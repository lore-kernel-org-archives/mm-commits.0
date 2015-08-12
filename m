From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-add-vmhugetlbrss-field-in-proc-pid-status-fix.patch removed from -mm tree
Date: Wed, 12 Aug 2015 16:54:06 -0700
Message-ID: <55cbdc9e./HuVt6JC1AKWT+kQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbbHLXyH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Aug 2015 19:54:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joern@logfs.org, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-add-vmhugetlbrss-field-in-proc-pid-status-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-vmhugetlbrss-field-in-proc-pid-status-fix.patch

This patch was dropped because it was folded into mm-hugetlb-add-vmhuge=
tlbrss-field-in-proc-pid-status.patch

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-add-vmhugetlbrss-field-in-proc-pid-status-fix

Cc: David Rientjes <rientjes@google.com>
Cc: J=F6rn Engel <joern@logfs.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-add-vmhugetlbrss-field-in-=
proc-pid-status-fix include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-add-vmhugetlbrss-field-in-proc=
-pid-status-fix
+++ a/include/linux/hugetlb.h
@@ -535,8 +535,15 @@ static inline spinlock_t *huge_pte_lockp
 	return &mm->page_table_lock;
 }
=20
-#define get_hugetlb_rss(mm)	0
-#define mod_hugetlb_rss(mm, value)	do {} while (0)
+static inline int get_hugetlb_rss(struct mm_struct *mm)
+{
+	return 0;
+}
+
+static inline void mod_hugetlb_rss(struct mm_struct *mm, long value)
+{
+}
+
 #endif	/* CONFIG_HUGETLB_PAGE */
=20
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

arch-alpha-kernel-systblss-remove-debug-check.patch
ipcsem-fix-use-after-free-on-ipc_rmid-after-a-task-using-same-semaphore=
-set-exits-fix.patch
mm-hwpoison-fix-panic-due-to-split-huge-zero-page-fix.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
ocfs2-sysfile-interfaces-for-online-file-check-fix.patch
fs-create-and-use-seq_show_option-for-escaping-fix.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patc=
h
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages-fix.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.p=
atch
pagemap-update-documentation-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patc=
h
mm-srcu-ify-shrinkers-fix-fix.patch
x86-use-generic-early-mem-copy-fix.patch
mm-hugetlb-add-vmhugetlbrss-field-in-proc-pid-status.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
proc-add-kpageidle-file-fix-6-fix.patch
proc-add-kpageidle-file-fix-6-fix-2-fix.patch
proc-export-idle-flag-via-kpageflags-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zswap-dynamic-pool-creation-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.pa=
tch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.pa=
tch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix=
=2Epatch
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.p=
atch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-f=
ix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixe=
s.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
