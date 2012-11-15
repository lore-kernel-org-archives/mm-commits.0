From: akpm@linux-foundation.org
Subject: + proc-pid-status-show-all-supplementary-groups.patch added to -mm tree
Date: Thu, 15 Nov 2012 12:31:08 -0800
Message-ID: <20121115203109.1E174200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:47246 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768924Ab2KOUbL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 15:31:11 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so137418wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 12:31:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: artem.bityutskiy@linux.intel.com, keescook@chromium.org, serge.hallyn@ubuntu.com, stable@vger.kernel.org


The patch titled
     Subject: proc: pid/status: show all supplementary groups
has been added to the -mm tree.  Its filename is
     proc-pid-status-show-all-supplementary-groups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: proc: pid/status: show all supplementary groups

We display a list of supplementary group for each process in
/proc/<pid>/status.  However, we show only the first 32 groups, not all of
them.

Although this is rare, but sometimes processes do have more than 32
supplementary groups, and this kernel limitation breaks user-space apps
that rely on the group list in /proc/<pid>/status.

Number 32 comes from the internal NGROUPS_SMALL macro which defines the
length for the internal kernel "small" groups buffer.  There is no
apparent reason to limit to this value.

This patch removes the 32 groups printing limit.

The Linux kernel limits the amount of supplementary groups by NGROUPS_MAX,
which is currently set to 65536.  And this is the maximum count of groups
we may possibly print.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/array.c~proc-pid-status-show-all-supplementary-groups fs/proc/array.c
--- a/fs/proc/array.c~proc-pid-status-show-all-supplementary-groups
+++ a/fs/proc/array.c
@@ -212,7 +212,7 @@ static inline void task_state(struct seq
 	group_info = cred->group_info;
 	task_unlock(p);
 
-	for (g = 0; g < min(group_info->ngroups, NGROUPS_SMALL); g++)
+	for (g = 0; g < group_info->ngroups; g++)
 		seq_printf(m, "%d ",
 			   from_kgid_munged(user_ns, GROUP_AT(group_info, g)));
 	put_cred(cred);
_

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch
proc-pid-status-show-all-supplementary-groups.patch

