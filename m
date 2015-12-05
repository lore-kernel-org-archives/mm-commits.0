From: akpm@linux-foundation.org
Subject: + ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
 added to -mm tree
Date: Fri, 04 Dec 2015 16:40:36 -0800
Message-ID: <56623284.WgTAGD+D3btOI0TN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460AbbLEAkh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 19:40:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, lkp@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan-run-time-undefined-behavior-sanity-checker-fix
has been added to the -mm tree.  Its filename is
     ubsan-run-time-undefined-behavior-sanity-checker-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ubsan-run-time-undefined-behavior-sanity-checker-fix.patch

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
Subject: ubsan-run-time-undefined-behavior-sanity-checker-fix

fix unused local warning

Reported-by: kbuild test robot <lkp@intel.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/ubsan.c~ubsan-run-time-undefined-behavior-sanity-checker-fix lib/ubsan.c
--- a/lib/ubsan.c~ubsan-run-time-undefined-behavior-sanity-checker-fix
+++ a/lib/ubsan.c
@@ -118,11 +118,11 @@ static u_max get_unsigned_val(struct typ
 static void val_to_string(char *str, size_t size, struct type_descriptor *type,
 	unsigned long value)
 {
-	u_max val = get_unsigned_val(type, value);
-
 	if (type_is_int(type)) {
 		if (type_bit_width(type) == 128) {
 #ifdef CONFIG_ARCH_SUPPORTS_INT128
+			u_max val = get_unsigned_val(type, value);
+
 			scnprintf(str, size, "0x%08x%08x%08x%08x",
 				(u32)(val >> 96),
 				(u32)(val >> 64),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
oom-kill-init-lead-panic-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
linux-next-git-rejects.patch
fs-adfs-adfsh-tidy-up-comments.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

