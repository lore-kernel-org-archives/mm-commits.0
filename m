From: akpm@linux-foundation.org
Subject: + page_fault-retry-with-nopage_retry-fix.patch added to -mm tree
Date: Tue, 09 Dec 2008 11:31:30 -0800
Message-ID: <200812091931.mB9JVUWF024544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754623AbYLITcF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Dec 2008 14:32:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, edwintorok@gmail.com, hpa@zytor.com, hugh@veritas.com, lee.schermerhorn@hp.com, mikew@google.com, mingo@elte.hu, npiggin@suse.de, rientjes@google.com, rohitseth@google.com, yinghan@google.com


The patch titled
     page_fault-retry-with-nopage_retry-fix
has been added to the -mm tree.  Its filename is
     page_fault-retry-with-nopage_retry-fix.patch

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

origin.patch
mm-backing-devc-remove-recently-added-warn_on.patch
revert-percpu-counter-clean-up-percpu_counter_sum_and_set.patch
revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
ksym_symbol_len-fixes.patch
mm-remove-the-might_sleep-from-lock_page.patch
make-linx-next-apply.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
pci-uninline-pci_ioremap_bar.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fi=
xes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
fs-truncate-blocks-outside-i_size-after-o_direct-write-error-fix.patch
vmscan-shrink_active_list-reduce-lru_lock-hold-time.patch
page_fault-retry-with-nopage_retry-fix.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=3D0-checkpatch-fix=
es.patch
nfs-optimize-attribute-timeouts-for-noac-and-actimeo=3D0-checkpatch-fix=
es-checkpatch-fixes.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-chec=
kpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch=
-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
parport-ieee1284-use-del_timer_sync-in-parport_wait_event-checkpatch-fi=
xes.patch
romfs-romfs_iget-unsigned-ino-=3D-0-is-always-true-checkpatch-fixes.pat=
ch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
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
