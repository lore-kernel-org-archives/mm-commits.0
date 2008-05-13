From: akpm@linux-foundation.org
Subject: - capabilities-add-bounding-set-to-proc-self-status.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:25 -0700
Message-ID: <200805132133.m4DLXPPd000823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762074AbYEMVds (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:33:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, morgan@kernel.org, mtk.manpages@gmail.com, mm-commits@vger.kernel.org


The patch titled
     capabilities: add bounding set to /proc/self/status
has been removed from the -mm tree.  Its filename was
     capabilities-add-bounding-set-to-proc-self-status.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: capabilities: add bounding set to /proc/self/status
From: "Serge E. Hallyn" <serue@us.ibm.com>

There is currently no way to query the bounding set of another task.  As there
appears to be no security reason not to, and as Michael Kerrisk points out the
following valid reasons to do so exist:

* consistency (I can see all of the other per-thread/process sets in
  /proc/.../status)

* debugging -- I could imagine that it would make the job of debugging an
  application that uses capabilities a little simpler.

this patch adds the bounding set to /proc/self/status right after the
effective set.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/array.c~capabilities-add-bounding-set-to-proc-self-status fs/proc/array.c
--- a/fs/proc/array.c~capabilities-add-bounding-set-to-proc-self-status
+++ a/fs/proc/array.c
@@ -298,6 +298,7 @@ static inline void task_cap(struct seq_f
 	render_cap_t(m, "CapInh:\t", &p->cap_inheritable);
 	render_cap_t(m, "CapPrm:\t", &p->cap_permitted);
 	render_cap_t(m, "CapEff:\t", &p->cap_effective);
+	render_cap_t(m, "CapBnd:\t", &p->cap_bset);
 }
 
 static inline void task_context_switch_counts(struct seq_file *m,
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
git-unionfs.patch
git-vfs-cleanups.patch
reiser4.patch

