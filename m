From: akpm@linux-foundation.org
Subject: + drivers-block-nvme-corec-fix-build-with-gcc-444.patch added to
 -mm tree
Date: Thu, 28 May 2015 14:47:32 -0700
Message-ID: <55678cf4.mrnTsWa3GBN1JW4+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbbE1Vrd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 May 2015 17:47:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@fb.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/block/nvme-core.c: fix build with gcc-4.4.4
has been added to the -mm tree.  Its filename is
     drivers-block-nvme-corec-fix-build-with-gcc-444.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-block-nvme-corec-fix-build-with-gcc-444.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-block-nvme-corec-fix-build-with-gcc-444.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/block/nvme-core.c: fix build with gcc-4.4.4

gcc-4.4.4 (and possibly other versions) fail the compile when initializers
are used with anonymous unions.  Work around this.

drivers/block/nvme-core.c: In function 'nvme_identify_ctrl':
drivers/block/nvme-core.c:1163: error: unknown field 'identify' specified in initializer
drivers/block/nvme-core.c:1163: warning: missing braces around initializer
drivers/block/nvme-core.c:1163: warning: (near initialization for 'c.<anonymous>')
drivers/block/nvme-core.c:1164: error: unknown field 'identify' specified in initializer
drivers/block/nvme-core.c:1164: warning: excess elements in struct initializer
drivers/block/nvme-core.c:1164: warning: (near initialization for 'c')
...

This patch has no effect on text size with gcc-4.8.2.

Fixes: d29ec8241c10eac ("nvme: submit internal commands through the block layer")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nvme-core.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff -puN drivers/block/nvme-core.c~drivers-block-nvme-corec-fix-build-with-gcc-444 drivers/block/nvme-core.c
--- a/drivers/block/nvme-core.c~drivers-block-nvme-corec-fix-build-with-gcc-444
+++ a/drivers/block/nvme-core.c
@@ -1159,12 +1159,13 @@ static int adapter_delete_sq(struct nvme
 
 int nvme_identify_ctrl(struct nvme_dev *dev, struct nvme_id_ctrl **id)
 {
-	struct nvme_command c = {
-		.identify.opcode = nvme_admin_identify,
-		.identify.cns = cpu_to_le32(1),
-	};
+	struct nvme_command c = { };
 	int error;
 
+	/* gcc-4.4.4 (at least) has issues with initializers and anon unions */
+	c.identify.opcode = nvme_admin_identify;
+	c.identify.cns = cpu_to_le32(1);
+
 	*id = kmalloc(sizeof(struct nvme_id_ctrl), GFP_KERNEL);
 	if (!*id)
 		return -ENOMEM;
@@ -1179,12 +1180,13 @@ int nvme_identify_ctrl(struct nvme_dev *
 int nvme_identify_ns(struct nvme_dev *dev, unsigned nsid,
 		struct nvme_id_ns **id)
 {
-	struct nvme_command c = {
-		.identify.opcode = nvme_admin_identify,
-		.identify.nsid = cpu_to_le32(nsid),
-	};
+	struct nvme_command c = { };
 	int error;
 
+	/* gcc-4.4.4 (at least) has issues with initializers and anon unions */
+	c.identify.opcode = nvme_admin_identify,
+	c.identify.nsid = cpu_to_le32(nsid),
+
 	*id = kmalloc(sizeof(struct nvme_id_ns), GFP_KERNEL);
 	if (!*id)
 		return -ENOMEM;
@@ -1228,14 +1230,14 @@ int nvme_set_features(struct nvme_dev *d
 
 int nvme_get_log_page(struct nvme_dev *dev, struct nvme_smart_log **log)
 {
-	struct nvme_command c = {
-		.common.opcode = nvme_admin_get_log_page,
-		.common.nsid = cpu_to_le32(0xFFFFFFFF),
-		.common.cdw10[0] = cpu_to_le32(
+	struct nvme_command c = { };
+	int error;
+
+	c.common.opcode = nvme_admin_get_log_page,
+	c.common.nsid = cpu_to_le32(0xFFFFFFFF),
+	c.common.cdw10[0] = cpu_to_le32(
 			(((sizeof(struct nvme_smart_log) / 4) - 1) << 16) |
 			 NVME_LOG_SMART),
-	};
-	int error;
 
 	*log = kmalloc(sizeof(struct nvme_smart_log), GFP_KERNEL);
 	if (!*log)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fs-binfmt_elfc-load_elf_binary-return-einval-on-zero-length-mappings.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
fs-userfaultfdc-work-around-i386-build-error.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
prctl-more-prctlpr_set_mm_-checks-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
init-do_mounts-add-create_dev-failure-log-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-block-nvme-corec-fix-build-with-gcc-444.patch
arch-x86-kvm-mmuc-work-around-gcc-444-bug.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
drivers-gpu-drm-i915-i915_gem_gttc-hack-around-build-error-on-i386.patch
drivers-gpu-drm-i915-i915_gem_gttc-hack-around-build-error-on-i386.patch

