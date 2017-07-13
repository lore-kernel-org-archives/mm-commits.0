From: akpm@linux-foundation.org
Subject: [merged]
 sysctl-check-name-array-length-in-deprecated_sysctl_warning.patch removed
 from -mm tree
Date: Thu, 13 Jul 2017 13:40:42 -0700
Message-ID: <20170713204042.KvIlAEKQN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58990 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753272AbdGMUkn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:40:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, ebiederm@xmission.com, glider@google.com, keescook@chromium.org, mjurczyk@google.com, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, tedheadster@gmail.com


The patch titled
     Subject: kernel/sysctl_binary.c: check name array length in deprecated_sysctl_warning()
has been removed from the -mm tree.  Its filename was
     sysctl-check-name-array-length-in-deprecated_sysctl_warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mateusz Jurczyk <mjurczyk@google.com>
Subject: kernel/sysctl_binary.c: check name array length in deprecated_sysctl_warning()

Prevent use of uninitialized memory (originating from the stack frame of
do_sysctl()) by verifying that the name array is filled with sufficient
input data before comparing its specific entries with integer constants.

Through timing measurement or analyzing the kernel debug logs, a user-mode
program could potentially infer the results of comparisons against the
uninitialized memory, and acquire some (very limited) information about
the state of the kernel stack.  The change also eliminates possible future
warnings by tools such as KMSAN and other code checkers /
instrumentations.

Link: http://lkml.kernel.org/r/20170524122139.21333-1-mjurczyk@google.com
Signed-off-by: Mateusz Jurczyk <mjurczyk@google.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Matthew Whitehead <tedheadster@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_binary.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl_binary.c~sysctl-check-name-array-length-in-deprecated_sysctl_warning kernel/sysctl_binary.c
--- a/kernel/sysctl_binary.c~sysctl-check-name-array-length-in-deprecated_sysctl_warning
+++ a/kernel/sysctl_binary.c
@@ -1346,7 +1346,7 @@ static void deprecated_sysctl_warning(co
 	 * CTL_KERN/KERN_VERSION is used by older glibc and cannot
 	 * ever go away.
 	 */
-	if (name[0] == CTL_KERN && name[1] == KERN_VERSION)
+	if (nlen >= 2 && name[0] == CTL_KERN && name[1] == KERN_VERSION)
 		return;
 
 	if (printk_ratelimit()) {
_

Patches currently in -mm which might be from mjurczyk@google.com are


