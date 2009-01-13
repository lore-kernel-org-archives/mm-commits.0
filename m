From: akpm@linux-foundation.org
Subject: - page_fault-retry-with-nopage_retry-fix.patch removed from -mm tree
Date: Mon, 12 Jan 2009 19:56:46 -0800
Message-ID: <200901130356.n0D3ukIt018285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754426AbZAMD5Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 22:57:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, edwintorok@gmail.com, hpa@zytor.com, hugh@veritas.com, lee.schermerhorn@hp.com, mikew@google.com, mingo@el


The patch titled
     page_fault-retry-with-nopage_retry-fix
has been removed from the -mm tree.  Its filename was
     page_fault-retry-with-nopage_retry-fix.patch

This patch was dropped because it was folded into page_fault-retry-with=
-nopage_retry.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: page_fault-retry-with-nopage_retry-fix
=46rom: Andrew Morton <akpm@linux-foundation.org>

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rohit Seth <rohitseth@google.com>
Cc: T=F6r=F6k Edwin <edwintorok@gmail.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    3 +++
 mm/filemap.c            |   38 ++++++++++++++++++++------------------
 2 files changed, 23 insertions(+), 18 deletions(-)

diff -puN include/linux/pagemap.h~page_fault-retry-with-nopage_retry-fi=
x include/linux/pagemap.h
--- a/include/linux/pagemap.h~page_fault-retry-with-nopage_retry-fix
+++ a/include/linux/pagemap.h
@@ -232,6 +232,9 @@ extern struct page * find_get_page(struc
 				pgoff_t index);
 extern struct page * find_lock_page(struct address_space *mapping,
 				pgoff_t index);
+extern unsigned find_lock_page_retry(struct address_space *mapping,
+			pgoff_t offset, struct vm_area_struct *vma,
+			struct page **ppage, int retry)
 extern struct page * find_or_create_page(struct address_space *mapping=
,
 				pgoff_t index, gfp_t gfp_mask);
 unsigned find_get_pages(struct address_space *mapping, pgoff_t start,
diff -puN mm/filemap.c~page_fault-retry-with-nopage_retry-fix mm/filema=
p.c
--- a/mm/filemap.c~page_fault-retry-with-nopage_retry-fix
+++ a/mm/filemap.c
@@ -714,51 +714,53 @@ repeat:
 EXPORT_SYMBOL(find_lock_page);
=20
 /**
- * find_lock_page_retry - locate, pin and lock a pagecache page, if re=
try
- * flag is on, and page is already locked by someone else, return a hi=
nt of
- * retry.
+ * find_lock_page_retry - locate, pin and lock a pagecache page
  * @mapping: the address_space to search
  * @offset: the page index
  * @vma: vma in which the fault was taken
- * @page: zero if page not present, otherwise point to the page in
- * pagecache.
+ * @ppage: zero if page not present, otherwise point to the page in pa=
gecache.
  * @retry: 1 indicate caller tolerate a retry.
  *
- * Return *page=3D=3DNULL if page is not in pagecache. Otherwise retur=
n *page
+ * If retry flag is on, and page is already locked by someone else, re=
turn a
+ * hint of retry.
+ *
+ * Return *ppage=3D=3DNULL if page is not in pagecache. Otherwise retu=
rn *ppage
  * points to the page in the pagecache with ret=3DVM_FAULT_RETRY indic=
ate a
- * hint to caller for retry, or ret=3D0 which means page is succefully
+ * hint to caller for retry, or ret=3D0 which means page is successful=
ly
  * locked.
  */
 unsigned find_lock_page_retry(struct address_space *mapping, pgoff_t o=
ffset,
-				struct vm_area_struct *vma, struct page **page,
+				struct vm_area_struct *vma, struct page **ppage,
 				int retry)
 {
 	unsigned int ret =3D 0;
+	struct page *page;
=20
 repeat:
-	*page =3D find_get_page(mapping, offset);
-	if (*page) {
+	page =3D find_get_page(mapping, offset);
+	if (page) {
 		if (!retry)
-			lock_page(*page);
+			lock_page(page);
 		else {
-			if (!trylock_page(*page)) {
+			if (!trylock_page(page)) {
 				struct mm_struct *mm =3D vma->vm_mm;
=20
 				up_read(&mm->mmap_sem);
-				wait_on_page_locked(*page);
+				wait_on_page_locked(page);
 				down_read(&mm->mmap_sem);
=20
-				page_cache_release(*page);
+				page_cache_release(page);
 				return VM_FAULT_RETRY;
 			}
 		}
-		if (unlikely((*page)->mapping !=3D mapping)) {
-			unlock_page(*page);
-			page_cache_release(*page);
+		if (unlikely(page->mapping !=3D mapping)) {
+			unlock_page(page);
+			page_cache_release(page);
 			goto repeat;
 		}
-		VM_BUG_ON((*page)->index !=3D offset);
+		VM_BUG_ON(page->index !=3D offset);
 	}
+	*ppage =3D page;
 	return ret;
 }
 EXPORT_SYMBOL(find_lock_page_retry);
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
clocksource-pass-clocksource-to-read-callback.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
smp_call_function_single-be-slightly-less-stupid.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
alpha-fix-vmalloc-breakage-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
rtc-cumulative-style-fixes-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkp=
atch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patc=
h
w1-build-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
