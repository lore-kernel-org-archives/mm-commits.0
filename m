From: akpm@linux-foundation.org
Subject: + page_fault-retry-with-nopage_retry.patch added to -mm tree
Date: Tue, 09 Dec 2008 11:31:25 -0800
Message-ID: <200812091931.mB9JVRID024521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754577AbYLITcA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Dec 2008 14:32:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, edwintorok@gmail.com, hpa@zytor.com, hugh@veritas.com, lee.schermerhorn@hp.com, mikew@google.com, mingo@elte.hu, npiggin@suse.de, rientjes@google.com, rohitseth@google.com


The patch titled
     page_fault retry with NOPAGE_RETRY
has been added to the -mm tree.  Its filename is
     page_fault-retry-with-nopage_retry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
i will post others by the time everyone feels comfortable of this patch=
=2E

todo:
- there is potential a starvation hole with the retry. By the time the
  retry returns, the pages might be released. we can make change by hol=
ding
  page reference as well as remembering what the page "was"(in case the
  file was truncated). any suggestion here are welcomed.

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

 arch/x86/mm/fault.c |   12 ++++++
 include/linux/mm.h  |    3 +
 mm/filemap.c        |   84 ++++++++++++++++++++++++++++++++++++++++--
 mm/memory.c         |    8 ++++
 4 files changed, 102 insertions(+), 5 deletions(-)

diff -puN arch/x86/mm/fault.c~page_fault-retry-with-nopage_retry arch/x=
86/mm/fault.c
--- a/arch/x86/mm/fault.c~page_fault-retry-with-nopage_retry
+++ a/arch/x86/mm/fault.c
@@ -597,6 +597,7 @@ void __kprobes do_page_fault(struct pt_r
 	unsigned long flags;
 	int sig;
 #endif
+	unsigned int retry_flag =3D FAULT_FLAG_RETRY;
=20
 	tsk =3D current;
 	mm =3D tsk->mm;
@@ -705,6 +706,7 @@ void __kprobes do_page_fault(struct pt_r
 		down_read(&mm->mmap_sem);
 	}
=20
+retry:
 	vma =3D find_vma(mm, address);
 	if (!vma)
 		goto bad_area;
@@ -731,6 +733,7 @@ void __kprobes do_page_fault(struct pt_r
 good_area:
 	si_code =3D SEGV_ACCERR;
 	write =3D 0;
+	write |=3D retry_flag;
 	switch (error_code & (PF_PROT|PF_WRITE)) {
 	default:	/* 3: write, present */
 		/* fall through */
@@ -759,6 +762,15 @@ good_area:
 			goto do_sigbus;
 		BUG();
 	}
+
+	if (fault & VM_FAULT_RETRY) {
+		if (write & FAULT_FLAG_RETRY) {
+			retry_flag &=3D ~FAULT_FLAG_RETRY;
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
@@ -144,7 +144,7 @@ extern pgprot_t protection_map[16];
=20
 #define FAULT_FLAG_WRITE	0x01	/* Fault was a write access */
 #define FAULT_FLAG_NONLINEAR	0x02	/* Fault was via a nonlinear mapping=
 */
-
+#define FAULT_FLAG_RETRY	0x04	/* Retry majoy fault */
=20
 /*
  * vm_fault is filled by the the pagefault handler and passed to the v=
ma's
@@ -694,6 +694,7 @@ static inline int page_mapped(struct pag
 #define VM_FAULT_SIGBUS	0x0002
 #define VM_FAULT_MAJOR	0x0004
 #define VM_FAULT_WRITE	0x0008	/* Special case for get_user_pages */
+#define VM_FAULT_RETRY	0x0010
=20
 #define VM_FAULT_NOPAGE	0x0100	/* ->fault installed the pte, not retur=
n page */
 #define VM_FAULT_LOCKED	0x0200	/* ->fault locked the returned page */
diff -puN mm/filemap.c~page_fault-retry-with-nopage_retry mm/filemap.c
--- a/mm/filemap.c~page_fault-retry-with-nopage_retry
+++ a/mm/filemap.c
@@ -714,6 +714,56 @@ repeat:
 EXPORT_SYMBOL(find_lock_page);
=20
 /**
+ * find_lock_page_retry - locate, pin and lock a pagecache page, if re=
try
+ * flag is on, and page is already locked by someone else, return a hi=
nt of
+ * retry.
+ * @mapping: the address_space to search
+ * @offset: the page index
+ * @vma: vma in which the fault was taken
+ * @page: zero if page not present, otherwise point to the page in
+ * pagecache.
+ * @retry: 1 indicate caller tolerate a retry.
+ *
+ * Return *page=3D=3DNULL if page is not in pagecache. Otherwise retur=
n *page
+ * points to the page in the pagecache with ret=3DVM_FAULT_RETRY indic=
ate a
+ * hint to caller for retry, or ret=3D0 which means page is succefully
+ * locked.
+ */
+unsigned find_lock_page_retry(struct address_space *mapping, pgoff_t o=
ffset,
+				struct vm_area_struct *vma, struct page **page,
+				int retry)
+{
+	unsigned int ret =3D 0;
+
+repeat:
+	*page =3D find_get_page(mapping, offset);
+	if (*page) {
+		if (!retry)
+			lock_page(*page);
+		else {
+			if (!trylock_page(*page)) {
+				struct mm_struct *mm =3D vma->vm_mm;
+
+				up_read(&mm->mmap_sem);
+				wait_on_page_locked(*page);
+				down_read(&mm->mmap_sem);
+
+				page_cache_release(*page);
+				return VM_FAULT_RETRY;
+			}
+		}
+		if (unlikely((*page)->mapping !=3D mapping)) {
+			unlock_page(*page);
+			page_cache_release(*page);
+			goto repeat;
+		}
+		VM_BUG_ON((*page)->index !=3D offset);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(find_lock_page_retry);
+
+/**
  * find_or_create_page - locate or add a pagecache page
  * @mapping: the page's address_space
  * @index: the page's index into the mapping
@@ -1444,6 +1494,8 @@ int filemap_fault(struct vm_area_struct=20
 	pgoff_t size;
 	int did_readaround =3D 0;
 	int ret =3D 0;
+	int retry_flag =3D vmf->flags & FAULT_FLAG_RETRY;
+	int retry_ret;
=20
 	size =3D (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHI=
=46T;
 	if (vmf->pgoff >=3D size)
@@ -1458,6 +1510,8 @@ int filemap_fault(struct vm_area_struct=20
 	 */
 retry_find:
 	page =3D find_lock_page(mapping, vmf->pgoff);
+
+retry_find_nopage:
 	/*
 	 * For sequential accesses, we use the generic readahead logic.
 	 */
@@ -1465,9 +1519,12 @@ retry_find:
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
@@ -1504,14 +1561,18 @@ retry_find:
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
@@ -1546,8 +1607,23 @@ no_cached_page:
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
@@ -2543,6 +2543,13 @@ static int __do_fault(struct mm_struct *
 	vmf.page =3D NULL;
=20
 	ret =3D vma->vm_ops->fault(vma, &vmf);
+
+	/* page may be available, but we have to restart the process
+	 * because mmap_sem was dropped during the ->fault
+	 */
+	if (ret =3D=3D VM_FAULT_RETRY)
+		return ret;
+
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
 		return ret;
=20
@@ -2686,6 +2693,7 @@ static int do_linear_fault(struct mm_str
 			- vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 	unsigned int flags =3D (write_access ? FAULT_FLAG_WRITE : 0);
=20
+	flags |=3D (write_access & FAULT_FLAG_RETRY);
 	pte_unmap(page_table);
 	return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
_

Patches currently in -mm which might be from yinghan@google.com are

mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_p=
ages-during-munlock.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
