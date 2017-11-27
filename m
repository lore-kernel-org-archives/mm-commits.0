From: akpm@linux-foundation.org
Subject: + exec-avoid-rlimit_stack-races-with-prlimit.patch added to -mm
 tree
Date: Mon, 27 Nov 2017 15:13:28 -0800
Message-ID: <5a1c9c18.ro3IJpANbRrON8Ny%akpm__29304.0602854036$1511824411$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44624 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751921AbdK0XN3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2017 18:13:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, ben.hutchings@codethink.co.uk, james.l.morris@oracle.com, jslaby@suse.cz, luto@kernel.org, oleg@redhat.com, serge@hallyn.com, spender@grsecurity.net, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: exec: avoid RLIMIT_STACK races with prlimit()
has been added to the -mm tree.  Its filename is
     exec-avoid-rlimit_stack-races-with-prlimit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exec-avoid-rlimit_stack-races-with-prlimit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exec-avoid-rlimit_stack-races-with-prlimit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: exec: avoid RLIMIT_STACK races with prlimit()

While the defense-in-depth RLIMIT_STACK limit on setuid processes was
protected against races from other threads calling setrlimit(), I missed
protecting it against races from external processes calling prlimit(). 
This adds locking around the change and makes sure that rlim_max is set
too.

Link: http://lkml.kernel.org/r/20171127193457.GA11348@beast
Fixes: 64701dee4178e ("exec: Use sane stack rlimit under secureexec")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Reported-by: Brad Spengler <spender@grsecurity.net>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/exec.c~exec-avoid-rlimit_stack-races-with-prlimit fs/exec.c
--- a/fs/exec.c~exec-avoid-rlimit_stack-races-with-prlimit
+++ a/fs/exec.c
@@ -1340,10 +1340,15 @@ void setup_new_exec(struct linux_binprm
 		 * avoid bad behavior from the prior rlimits. This has to
 		 * happen before arch_pick_mmap_layout(), which examines
 		 * RLIMIT_STACK, but after the point of no return to avoid
-		 * needing to clean up the change on failure.
+		 * races from other threads changing the limits. This also
+		 * must be protected from races with prlimit() calls.
 		 */
+		task_lock(current->group_leader);
 		if (current->signal->rlim[RLIMIT_STACK].rlim_cur > _STK_LIM)
 			current->signal->rlim[RLIMIT_STACK].rlim_cur = _STK_LIM;
+		if (current->signal->rlim[RLIMIT_STACK].rlim_max > _STK_LIM)
+			current->signal->rlim[RLIMIT_STACK].rlim_max = _STK_LIM;
+		task_unlock(current->group_leader);
 	}
 
 	arch_pick_mmap_layout(current->mm);
_

Patches currently in -mm which might be from keescook@chromium.org are

exec-avoid-rlimit_stack-races-with-prlimit.patch
makefile-move-stack-protector-compiler-breakage-test-earlier.patch
makefile-move-stack-protector-availability-out-of-kconfig.patch
makefile-introduce-config_cc_stackprotector_auto.patch

