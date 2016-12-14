From: akpm@linux-foundation.org
Subject: [merged]
 prctl-remove-one-shot-limitation-for-changing-exe-link.patch removed from
 -mm tree
Date: Wed, 14 Dec 2016 11:22:45 -0800
Message-ID: <58519c05.pIGKHmBxHzvlXWce%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43790 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753538AbcLNTWq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:22:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: skinsbursky@virtuozzo.com, ebiederm@xmission.com, gorcunov@openvz.org, john.stultz@linaro.org, keescook@chromium.org, luto@amacapital.net, matthltc@us.ibm.com, mhocko@suse.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, vbabka@suse.cz, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prctl: remove one-shot limitation for changing exe link
has been removed from the -mm tree.  Its filename was
     prctl-remove-one-shot-limitation-for-changing-exe-link.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>
Subject: prctl: remove one-shot limitation for changing exe link

This limitation came with the reason to remove "another way for malicious
code to obscure a compromised program and masquerade as a benign process"
by allowing "security-concious program can use this prctl once during its
early initialization to ensure the prctl cannot later be abused for this
purpose":

http://marc.info/?l=linux-kernel&m=133160684517468&w=2

This explanation doesn't look sufficient.  The only thing "exe" link is
indicating is the file, used to execve, which is basically nothing and not
reliable immediately after process has returned from execve system call.

Moreover, to use this feture, all the mappings to previous exe file have
to be unmapped and all the new exe file permissions must be satisfied.

Which means, that changing exe link is very similar to calling execve on
the binary.

The need to remove this limitations comes from migration of NFS mount
point, which is not accessible during restore and replaced by other file
system.  Because of this exe link has to be changed twice.

[akpm@linux-foundation.org: fix up comment]
Link: http://lkml.kernel.org/r/20160927153755.9337.69650.stgit@localhost.localdomain
Signed-off-by: Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    6 +++++-
 kernel/sys.c          |   10 ----------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff -puN include/linux/sched.h~prctl-remove-one-shot-limitation-for-changing-exe-link include/linux/sched.h
--- a/include/linux/sched.h~prctl-remove-one-shot-limitation-for-changing-exe-link
+++ a/include/linux/sched.h
@@ -540,7 +540,11 @@ static inline int get_dumpable(struct mm
 					/* leave room for more dump flags */
 #define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
 #define MMF_VM_HUGEPAGE		17	/* set when VM_HUGEPAGE is set on vma */
-#define MMF_EXE_FILE_CHANGED	18	/* see prctl_set_mm_exe_file() */
+/*
+ * This one-shot flag is dropped due to necessity of changing exe once again
+ * on NFS restore
+ */
+//#define MMF_EXE_FILE_CHANGED	18	/* see prctl_set_mm_exe_file() */
 
 #define MMF_HAS_UPROBES		19	/* has uprobes */
 #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
diff -puN kernel/sys.c~prctl-remove-one-shot-limitation-for-changing-exe-link kernel/sys.c
--- a/kernel/sys.c~prctl-remove-one-shot-limitation-for-changing-exe-link
+++ a/kernel/sys.c
@@ -1696,16 +1696,6 @@ static int prctl_set_mm_exe_file(struct
 		fput(exe_file);
 	}
 
-	/*
-	 * The symlink can be changed only once, just to disallow arbitrary
-	 * transitions malicious software might bring in. This means one
-	 * could make a snapshot over all processes running and monitor
-	 * /proc/pid/exe changes to notice unusual activity if needed.
-	 */
-	err = -EPERM;
-	if (test_and_set_bit(MMF_EXE_FILE_CHANGED, &mm->flags))
-		goto exit;
