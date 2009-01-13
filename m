From: akpm@linux-foundation.org
Subject: + page_fault-retry-with-nopage_retry-fix-3.patch added to -mm tree
Date: Mon, 12 Jan 2009 19:59:46 -0800
Message-ID: <200901130359.n0D3xksB020843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753772AbZAMEAp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 23:00:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, edwintorok@gmail.com, hpa@zytor.com, hugh@veritas.com, lee.schermerhorn@hp.com, mikew@google.com, mingo@elte.hu, npiggin@suse.de, rientjes@google.com, rohitseth@google.com


The patch titled
     page_fault-retry-with-nopage_retry-fix 3
has been added to the -mm tree.  Its filename is
     page_fault-retry-with-nopage_retry-fix-3.patch

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
Subject: page_fault-retry-with-nopage_retry-fix 3
=46rom: Ying Han <yinghan@google.com>

I found out that the flags was set as FAULT_FLAG_WRITE no matter
what(write/read) whence FAULT_FLAG_RETRY is set.  the new patch changed
the logic which only set the flag in the "write" case.

Cc: Mike Waychison <mikew@google.com>
Cc: Ying Han <yinghan@google.com>
Cc: T=F6r=F6k Edwin <edwintorok@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>
Cc: Rohit Seth <rohitseth@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Tested-by: Valdis.Kletnieks@vt.edu
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c     |    6 ++++++
 include/linux/mm.h      |    4 ++--
 include/linux/pagemap.h |    3 ---
 mm/filemap.c            |    8 ++++----
 mm/memory.c             |    5 +++--
 5 files changed, 15 insertions(+), 11 deletions(-)

diff -puN arch/x86/mm/fault.c~page_fault-retry-with-nopage_retry-fix-3 =
arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~page_fault-retry-with-nopage_retry-fix-3
+++ a/arch/x86/mm/fault.c
@@ -763,6 +763,12 @@ good_area:
 		BUG();
 	}
=20
+	/*
+	 * Here we retry fault once and switch to synchronous mode. The
+	 * main reason is to prevent us from the cases of starvation.
+	 * The retry logic open a starvation hole in which case pages might
+	 * be removed or changed after the retry.
+	 */
 	if (fault & VM_FAULT_RETRY) {
 		if (write & FAULT_FLAG_RETRY) {
 			retry_flag &=3D ~FAULT_FLAG_RETRY;
diff -puN include/linux/mm.h~page_fault-retry-with-nopage_retry-fix-3 i=
nclude/linux/mm.h
--- a/include/linux/mm.h~page_fault-retry-with-nopage_retry-fix-3
+++ a/include/linux/mm.h
@@ -134,7 +134,7 @@ extern pgprot_t protection_map[16];
=20
 #define FAULT_FLAG_WRITE	0x01	/* Fault was a write access */
 #define FAULT_FLAG_NONLINEAR	0x02	/* Fault was via a nonlinear mapping=
 */
-#define FAULT_FLAG_RETRY	0x04	/* Retry majoy fault */
+#define FAULT_FLAG_RETRY	0x04	/* Retry major fault */
=20
 /*
  * This interface is used by x86 PAT code to identify a pfn mapping th=
at is
@@ -698,11 +698,11 @@ static inline int page_mapped(struct pag
=20
 #define VM_FAULT_MINOR	0 /* For backwards compat. Remove me quickly. *=
/
=20
+#define VM_FAULT_RETRY	0x0010
 #define VM_FAULT_OOM	0x0001
 #define VM_FAULT_SIGBUS	0x0002
 #define VM_FAULT_MAJOR	0x0004
 #define VM_FAULT_WRITE	0x0008	/* Special case for get_user_pages */
-#define VM_FAULT_RETRY	0x0010
=20
 #define VM_FAULT_NOPAGE	0x0100	/* ->fault installed the pte, not retur=
n page */
 #define VM_FAULT_LOCKED	0x0200	/* ->fault locked the returned page */
diff -puN include/linux/pagemap.h~page_fault-retry-with-nopage_retry-fi=
x-3 include/linux/pagemap.h
--- a/include/linux/pagemap.h~page_fault-retry-with-nopage_retry-fix-3
+++ a/include/linux/pagemap.h
@@ -232,9 +232,6 @@ extern struct page * find_get_page(struc
 				pgoff_t index);
 extern struct page * find_lock_page(struct address_space *mapping,
 				pgoff_t index);
-extern unsigned find_lock_page_retry(struct address_space *mapping,
-			pgoff_t offset, struct vm_area_struct *vma,
-			struct page **ppage, int retry);
 extern struct page * find_or_create_page(struct address_space *mapping=
,
 				pgoff_t index, gfp_t gfp_mask);
 unsigned find_get_pages(struct address_space *mapping, pgoff_t start,
diff -puN mm/filemap.c~page_fault-retry-with-nopage_retry-fix-3 mm/file=
map.c
--- a/mm/filemap.c~page_fault-retry-with-nopage_retry-fix-3
+++ a/mm/filemap.c
@@ -753,15 +753,15 @@ EXPORT_SYMBOL(find_lock_page);
  * @mapping: the address_space to search
  * @offset: the page index
  * @vma: vma in which the fault was taken
- * @ppage: zero if page not present, otherwise point to the page in pa=
gecache.
+ * @ppage: zero if page not present, otherwise point to the page in pa=
gecache
  * @retry: 1 indicate caller tolerate a retry.
  *
- * If retry flag is on, and page is already locked by someone else, re=
turn a
- * hint of retry.
+ * If retry flag is on, and page is already locked by someone else, re=
turn
+ * a hint of retry.
  *
  * Return *ppage=3D=3DNULL if page is not in pagecache. Otherwise retu=
rn *ppage
  * points to the page in the pagecache with ret=3DVM_FAULT_RETRY indic=
ate a
- * hint to caller for retry, or ret=3D0 which means page is successful=
ly
+ * hint to caller for retry, or ret=3D0 which means page is succefully
  * locked.
  */
 unsigned find_lock_page_retry(struct address_space *mapping, pgoff_t o=
ffset,
diff -puN mm/memory.c~page_fault-retry-with-nopage_retry-fix-3 mm/memor=
y.c
--- a/mm/memory.c~page_fault-retry-with-nopage_retry-fix-3
+++ a/mm/memory.c
@@ -2590,7 +2590,7 @@ static int __do_fault(struct mm_struct *
 	/* page may be available, but we have to restart the process
 	 * because mmap_sem was dropped during the ->fault
 	 */
-	if (ret =3D=3D VM_FAULT_RETRY)
+	if (ret & VM_FAULT_RETRY)
 		return ret;
=20
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
@@ -2734,7 +2734,8 @@ static int do_linear_fault(struct mm_str
 {
 	pgoff_t pgoff =3D (((address & PAGE_MASK)
 			- vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-	unsigned int flags =3D (write_access ? FAULT_FLAG_WRITE : 0);
+	int write =3D write_access & ~FAULT_FLAG_RETRY;
+	unsigned int flags =3D (write ? FAULT_FLAG_WRITE : 0);
=20
 	flags |=3D (write_access & FAULT_FLAG_RETRY);
 	pte_unmap(page_table);
_

Patches currently in -mm which might be from yinghan@google.com are

fs-execc-fix-value-of-vma-vm_pgoff-for-the-stack-vma-of-32-bit-processe=
s.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
