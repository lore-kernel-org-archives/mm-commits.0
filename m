From: akpm@linux-foundation.org
Subject: +
 sysctl-check-name-array-length-in-deprecated_sysctl_warning.patch added to
 -mm tree
Date: Wed, 24 May 2017 14:49:52 -0700
Message-ID: <59260000.FZe9VAN427rx+rv9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46038 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033549AbdEXVtx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 May 2017 17:49:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjurczyk@google.com, davem@davemloft.net, ebiederm@xmission.com, keescook@chromium.org, penguin-kernel@I-love.SAKURA.ne.jp, tedheadster@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sysctl_binary.c: check name array length in deprecated_sysctl_warning()
has been added to the -mm tree.  Its filename is
     sysctl-check-name-array-length-in-deprecated_sysctl_warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysctl-check-name-array-length-in-deprecated_sysctl_warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysctl-check-name-array-length-in-deprecated_sysctl_warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

sysctl-check-name-array-length-in-deprecated_sysctl_warning.patch

