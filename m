From: akpm@linux-foundation.org
Subject: [patch 16/28] exec: avoid RLIMIT_STACK races with prlimit()
Date: Wed, 29 Nov 2017 16:10:51 -0800
Message-ID: <5a1f4c8b.l2x77wf4flCbY9y0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60682 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753487AbdK3AKw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:10:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, keescook@chromium.org, ben.hutchings@codethink.co.uk, james.l.morris@oracle.com, jslaby@suse.cz, luto@kernel.org, oleg@redhat.com, serge@hallyn.com, spender@grsecurity.net, stable@vger.kernel.org

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
Acked-by: Serge Hallyn <serge@hallyn.com>
Cc: James Morris <james.l.morris@oracle.com>
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
