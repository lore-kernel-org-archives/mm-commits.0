From: akpm@linux-foundation.org
Subject: [merged] proc-pid-status-show-all-supplementary-groups.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:09:18 -0800
Message-ID: <20121218200919.0FF0020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:64685 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab2LRUJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:09:21 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so63362wib.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:09:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, keescook@chromium.org, serge.hallyn@ubuntu.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: pid/status: show all supplementary groups
has been removed from the -mm tree.  Its filename was
     proc-pid-status-show-all-supplementary-groups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

