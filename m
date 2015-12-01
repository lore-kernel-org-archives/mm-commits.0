From: akpm@linux-foundation.org
Subject: + include-linux-sysctlh-make-ctl_tableextra1-2-const.patch added
 to -mm tree
Date: Mon, 30 Nov 2015 16:18:22 -0800
Message-ID: <565ce74e.jl1LvBLzII9Prawr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36365 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbbLAASX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2015 19:18:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dcashman@android.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/sysctl.h: make ctl_table.extra1/2 const
has been added to the -mm tree.  Its filename is
     include-linux-sysctlh-make-ctl_tableextra1-2-const.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-sysctlh-make-ctl_tableextra1-2-const.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-sysctlh-make-ctl_tableextra1-2-const.patch

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
Subject: include/linux/sysctl.h: make ctl_table.extra1/2 const

Nothing should be altering these values.  Declare the pointed-to values to
be const so we can actually use const values.

Cc: Kees Cook <keescook@chromium.org>
Cc: Daniel Cashman <dcashman@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/sysctl.h~include-linux-sysctlh-make-ctl_tableextra1-2-const include/linux/sysctl.h
--- a/include/linux/sysctl.h~include-linux-sysctlh-make-ctl_tableextra1-2-const
+++ a/include/linux/sysctl.h
@@ -111,8 +111,8 @@ struct ctl_table
 	struct ctl_table *child;	/* Deprecated */
 	proc_handler *proc_handler;	/* Callback for text formatting */
 	struct ctl_table_poll *poll;
-	void *extra1;
-	void *extra2;
+	const void *extra1;
+	const void *extra2;
 };
 
 struct ctl_node {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
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
include-linux-sysctlh-make-ctl_tableextra1-2-const.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
fs-adfs-adfsh-tidy-up-comments.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

