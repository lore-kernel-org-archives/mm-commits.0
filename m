From: akpm@linux-foundation.org
Subject: [nacked] page_fault-retry-with-nopage_retry.patch removed from -mm tree
Date: Wed, 01 Apr 2009 08:56:52 -0700
Message-ID: <200904011556.n31FuqZu026713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762996AbZDAQFf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 12:05:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghan@google.com, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, edwintorok@gmail.com, hpa@zytor.com, hugh@veritas.com, lee.schermerhorn@hp.com, mikew@google.com, mingo@elte.hu


The patch titled
     page_fault retry with NOPAGE_RETRY
has been removed from the -mm tree.  Its filename was
     page_fault-retry-with-nopage_retry.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: page_fault retry with NOPAGE_RETRY
=46rom: Ying Han <yinghan@google.com>

Allow major faults to drop the mmap_sem read lock while waiting for
synchronous disk read.  This allows another thread which wishes to grab
down_write(mmap_sem) to proceed while the current is waiting the disk I=
O.

The patch extend the 'write' flag of handle_mm_fault() to FAULT_FLAG_RE=
TRY
as identify that the caller can tolerate the retry in the filemap_fault
call patch.

This patch helps a lot in cases we have writer which is waitting behind
all readers, so it could execute much faster.

I also made patches for all other arch. I am posting x86_64 here first =
and
I will post others by the time everyone feels comfortable with this pat=
ch.

[akpm@linux-foundation.org: untangle the `write' boolean from the FAULT=
_FLAG_foo non-boolean field]
[akpm@linux-foundation.org: undo wrong spelling change]
Signed-off-by: Mike Waychison <mikew@google.com>
Signed-off-by: Ying Han <yinghan@google.com>
Tested-by: T=F6r=F6k Edwin <edwintorok@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>
Cc: Rohit Seth <rohitseth@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c |   16 +++++++
 include/linux/mm.h  |    2=20
 mm/filemap.c        |   85 ++++++++++++++++++++++++++++++++++++++++--
 mm/memory.c         |   11 ++++-
 4 files changed, 109 insertions(+), 5 deletions(-)

diff -puN arch/x86/mm/fault.c~page_fault-retry-with-nopage_retry arch/x=
86/mm/fault.c
--- a/arch/x86/mm/fault.c~page_fault-retry-with-nopage_retry
+++ a/arch/x86/mm/fault.c
@@ -977,6 +977,7 @@ do_page_fault(struct pt_regs *regs, unsi
 	struct mm_struct *mm;
 	int write;
 	int fault;
+	int retry_flag =3D 1;
=20
 	tsk =3D current;
 	mm =3D tsk->mm;
@@ -1085,6 +1086,7 @@ do_page_fault(struct pt_regs *regs, unsi
 		might_sleep();
 	}
=20
+retry:
 	vma =3D find_vma(mm, address);
 	if (unlikely(!vma)) {
 		bad_area(regs, error_code, address);
@@ -1137,6 +1139,20 @@ good_area:
 		return;
 	}
=20
+	/*
+	 * Here we retry fault once and switch to synchronous mode. The
+	 * main reason is to prevent us from the cases of starvation.
+	 * The retry logic open a starvation hole in which case pages might
+	 * be removed or changed after the retry.
+	 */
+	if (fault & VM_FAULT_RETRY) {
+		if (retry_flag) {
+			retry_flag =3D 0;
+			goto retry;
+		}
+		BUG();
+	}
+
 	if (fault & VM_FAULT_MAJOR)
 		tsk->maj_flt++;
 	else
diff -puN include/linux/mm.h~page_fault-retry-with-nopage_retry include=
/linux/mm.h
--- a/include/linux/mm.h~page_fault-retry-with-nopage_retry
+++ a/include/linux/mm.h
@@ -135,6 +135,7 @@ extern pgprot_t protection_map[16];
=20
 #define FAULT_FLAG_WRITE	0x01	/* Fault was a write access */
 #define FAULT_FLAG_NONLINEAR	0x02	/* Fault was via a nonlinear mapping=
 */
+#define FAULT_FLAG_RETRY	0x04	/* Retry major fault */
=20
 /*
  * This interface is used by x86 PAT code to identify a pfn mapping th=
at is
@@ -697,6 +698,7 @@ static inline int page_mapped(struct pag
=20
 #define VM_FAULT_MINOR	0 /* For backwards compat. Remove me quickly. *=
/
=20
+#define VM_FAULT_RETRY	0x0010
 #define VM_FAULT_OOM	0x0001
 #define VM_FAULT_SIGBUS	0x0002
 #define VM_FAULT_MAJOR	0x0004
diff -puN mm/filemap.c~page_fault-retry-with-nopage_retry mm/filemap.c
--- a/mm/filemap.c~page_fault-retry-with-nopage_retry
+++ a/mm/filemap.c
@@ -714,6 +714,57 @@ repeat:
 EXPORT_SYMBOL(find_lock_page);
=20
 /**
+ * find_lock_page_retry - locate, pin and lock a pagecache page
+ * @mapping: the address_space to search
+ * @offset: the page index
+ * @vma: vma in which the fault was taken
+ * @ppage: zero if page not present, otherwise point to the page in pa=
gecache
+ * @retry: 1 indicate caller tolerate a retry.
+ *
+ * If retry flag is on, and page is already locked by someone else, re=
turn
+ * a hint of retry.
+ *
+ * Return *ppage=3D=3DNULL if page is not in pagecache. Otherwise retu=
rn *ppage
+ * points to the page in the pagecache with ret=3DVM_FAULT_RETRY indic=
ate a
+ * hint to caller for retry, or ret=3D0 which means page is successful=
ly locked.
+ */
+unsigned find_lock_page_retry(struct address_space *mapping, pgoff_t o=
ffset,
+				struct vm_area_struct *vma, struct page **ppage,
+				int retry)
+{
+	unsigned int ret =3D 0;
+	struct page *page;
+
+repeat:
+	page =3D find_get_page(mapping, offset);
+	if (page) {
+		if (!retry)
+			lock_page(page);
+		else {
+			if (!trylock_page(page)) {
+				struct mm_struct *mm =3D vma->vm_mm;
+
+				up_read(&mm->mmap_sem);
+				wait_on_page_locked(page);
+				down_read(&mm->mmap_sem);
+
+				page_cache_release(page);
+				return VM_FAULT_RETRY;
+			}
+		}
+		if (unlikely(page->mapping !=3D mapping)) {
+			unlock_page(page);
+			page_cache_release(page);
+			goto repeat;
+		}
+		VM_BUG_ON(page->index !=3D offset);
+	}
+	*ppage =3D page;
+	return ret;
+}
+EXPORT_SYMBOL(find_lock_page_retry);
+
+/**
  * find_or_create_page - locate or add a pagecache page
  * @mapping: the page's address_space
  * @index: the page's index into the mapping
@@ -1459,6 +1510,8 @@ int filemap_fault(struct vm_area_struct=20
 	pgoff_t size;
 	int did_readaround =3D 0;
 	int ret =3D 0;
+	int retry_flag =3D vmf->flags & FAULT_FLAG_RETRY;
+	int retry_ret;
=20
 	size =3D (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHI=
=46T;
 	if (vmf->pgoff >=3D size)
@@ -1473,6 +1526,8 @@ int filemap_fault(struct vm_area_struct=20
 	 */
 retry_find:
 	page =3D find_lock_page(mapping, vmf->pgoff);
+
+retry_find_nopage:
 	/*
 	 * For sequential accesses, we use the generic readahead logic.
 	 */
@@ -1480,9 +1535,12 @@ retry_find:
 		if (!page) {
 			page_cache_sync_readahead(mapping, ra, file,
 							   vmf->pgoff, 1);
-			page =3D find_lock_page(mapping, vmf->pgoff);
+			retry_ret =3D find_lock_page_retry(mapping, vmf->pgoff,
+						vma, &page, retry_flag);
 			if (!page)
 				goto no_cached_page;
+			if (retry_ret =3D=3D VM_FAULT_RETRY)
+				return retry_ret;
 		}
 		if (PageReadahead(page)) {
 			page_cache_async_readahead(mapping, ra, file, page,
@@ -1519,14 +1577,18 @@ retry_find:
 				start =3D vmf->pgoff - ra_pages / 2;
 			do_page_cache_readahead(mapping, file, start, ra_pages);
 		}
-		page =3D find_lock_page(mapping, vmf->pgoff);
+		retry_ret =3D find_lock_page_retry(mapping, vmf->pgoff,
+				vma, &page, retry_flag);
 		if (!page)
 			goto no_cached_page;
+		if (retry_ret =3D=3D VM_FAULT_RETRY)
+			return retry_ret;
 	}
=20
 	if (!did_readaround)
 		ra->mmap_miss--;
=20
+retry_page_update:
 	/*
 	 * We have a locked page in the page cache, now we need to check
 	 * that it's up-to-date. If not, it is going to be due to an error.
@@ -1561,8 +1623,23 @@ no_cached_page:
 	 * In the unlikely event that someone removed it in the
 	 * meantime, we'll just come back here and read it again.
 	 */
-	if (error >=3D 0)
-		goto retry_find;
+	if (error >=3D 0) {
+		/*
+		 * If caller cannot tolerate a retry in the ->fault path
+		 * go back to check the page again.
+		 */
+		if (!retry_flag)
+			goto retry_find;
+
+		retry_ret =3D find_lock_page_retry(mapping, vmf->pgoff,
+					vma, &page, retry_flag);
+		if (!page)
+			goto retry_find_nopage;
+		else if (retry_ret =3D=3D VM_FAULT_RETRY)
+			return retry_ret;
+		else
+			goto retry_page_update;
+	}
=20
 	/*
 	 * An error return from page_cache_read can result if the
diff -puN mm/memory.c~page_fault-retry-with-nopage_retry mm/memory.c
--- a/mm/memory.c~page_fault-retry-with-nopage_retry
+++ a/mm/memory.c
@@ -2595,6 +2595,13 @@ static int __do_fault(struct mm_struct *
 	vmf.page =3D NULL;
=20
 	ret =3D vma->vm_ops->fault(vma, &vmf);
+
+	/* page may be available, but we have to restart the process
+	 * because mmap_sem was dropped during the ->fault
+	 */
+	if (ret & VM_FAULT_RETRY)
+		return ret;
+
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
 		return ret;
=20
@@ -2736,8 +2743,10 @@ static int do_linear_fault(struct mm_str
 {
 	pgoff_t pgoff =3D (((address & PAGE_MASK)
 			- vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-	unsigned int flags =3D (write_access ? FAULT_FLAG_WRITE : 0);
+	int write =3D write_access & ~FAULT_FLAG_RETRY;
+	unsigned int flags =3D (write ? FAULT_FLAG_WRITE : 0);
=20
+	flags |=3D (write_access & FAULT_FLAG_RETRY);
 	pte_unmap(page_table);
 	return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
_

Patches currently in -mm which might be from yinghan@google.com are

page_fault-retry-with-nopage_retry.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
