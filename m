From: akpm@linux-foundation.org
Subject: + syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update.patch added to -mm tree
Date: Wed, 11 Apr 2012 16:32:26 -0700
Message-ID: <20120411233227.3A062A03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:43660 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934059Ab2DKXc3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Apr 2012 19:32:29 -0400
Received: by bkcjm19 with SMTP id jm19so61143bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Apr 2012 16:32:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, hpa@zytor.com


The patch titled
     Subject: syscalls-x86-add-__nr_kcmp-syscall-v8 comment update
has been added to the -mm tree.  Its filename is
     syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: syscalls-x86-add-__nr_kcmp-syscall-v8 comment update

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-ipc-message-queue-receive-cleanup.patch
c-r-ipc-message-queue-stealing-feature-introduced.patch

