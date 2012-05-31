From: akpm@linux-foundation.org
Subject: [folded] syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update.patch removed from -mm tree
Date: Thu, 31 May 2012 16:20:24 -0700
Message-ID: <20120531232024.C566EA009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:46850 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758622Ab2EaXU0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 19:20:26 -0400
Received: by eeit10 with SMTP id t10so83779eei.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 16:20:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: syscalls-x86-add-__nr_kcmp-syscall-v8 comment update
has been removed from the -mm tree.  Its filename was
     syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update.patch

This patch was dropped because it was folded into syscalls-x86-add-__nr_kcmp-syscall-v8.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: syscalls-x86-add-__nr_kcmp-syscall-v8 comment update

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcmp.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN kernel/kcmp.c~syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update kernel/kcmp.c
--- a/kernel/kcmp.c~syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update
+++ a/kernel/kcmp.c
@@ -18,6 +18,17 @@
  * reasons, still the comparison results should be suitable for
  * sorting. Thus, we obfuscate kernel pointers values and compare
  * the production instead.
+ *
+ * The obfuscation is done in two steps. First -- we use xor on
+ * kernel pointer with random value, which puts pointer into
+ * a new position in reordered space. Second -- we multiply
+ * the xor production with big odd random number to permute
+ * bits even more (the odd multiplier guarantees that the product
+ * is unique ever after the high bits are truncated, since any odd
+ * number is relative prime to 2^n).
+ *
+ * Note also the obfuscation itself is invisible to user-space
+ * and if needed it can be changed to any suitable scheme.
  */
 static unsigned long cookies[KCMP_TYPES][2] __read_mostly;
 
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
sethostname-setdomainname-notify-userspace-when-there-is-a-change-in-uts_kern_table.patch
pidns-use-task_active_pid_ns-in-do_notify_parent.patch
pidns-make-killed-children-autoreap.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch

