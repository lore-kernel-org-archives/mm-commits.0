From: akpm@linux-foundation.org
Subject: + capabilities-add-bounding-set-to-proc-self-status.patch added to -mm tree
Date: Mon, 05 May 2008 12:57:13 -0700
Message-ID: <200805051957.m45JvDBw002143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753654AbYEEUDX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 16:03:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, morgan@kernel.org, mtk.manpages@gmail.com


The patch titled
     capabilities: add bounding set to /proc/self/status
has been added to the -mm tree.  Its filename is
     capabilities-add-bounding-set-to-proc-self-status.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-unionfs.patch
capabilities-add-bounding-set-to-proc-self-status.patch
reiser4.patch

