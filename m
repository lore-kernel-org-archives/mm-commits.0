From: akpm@linux-foundation.org
Subject: [merged] sysctl-remove-obsolete-comments.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:07 -0800
Message-ID: <201101132011.p0DKBm0W030204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933695Ab1AMUMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:12:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bookjovi@gmail.com, hidave.darkstar@gmail.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: remove obsolete comments
has been removed from the -mm tree.  Its filename was
     sysctl-remove-obsolete-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: remove obsolete comments
From: Jovi Zhang <bookjovi@gmail.com>

ctl_unnumbered.txt have been removed in Documentation directory so just
also remove this invalid comments

[akpm@linux-foundation.org: fix Documentation/sysctl/00-INDEX, per Dave]
Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Cc: Dave Young <hidave.darkstar@gmail.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/00-INDEX |    2 --
 kernel/sysctl.c               |   17 -----------------
 2 files changed, 19 deletions(-)

diff -puN Documentation/sysctl/00-INDEX~sysctl-remove-obsolete-comments Documentation/sysctl/00-INDEX
--- a/Documentation/sysctl/00-INDEX~sysctl-remove-obsolete-comments
+++ a/Documentation/sysctl/00-INDEX
@@ -4,8 +4,6 @@ README
 	- general information about /proc/sys/ sysctl files.
 abi.txt
 	- documentation for /proc/sys/abi/*.
-ctl_unnumbered.txt
-	- explanation of why one should not add new binary sysctl numbers.
 fs.txt
 	- documentation for /proc/sys/fs/*.
 kernel.txt
diff -puN kernel/sysctl.c~sysctl-remove-obsolete-comments kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-remove-obsolete-comments
+++ a/kernel/sysctl.c
@@ -246,10 +246,6 @@ static struct ctl_table root_table[] = {
 		.mode		= 0555,
 		.child		= dev_table,
 	},
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
@@ -972,10 +968,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
@@ -1336,11 +1328,6 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one,
 	},
 #endif
-
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
@@ -1496,10 +1483,6 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &pipe_proc_fn,
 		.extra1		= &pipe_min_size,
 	},
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
_

Patches currently in -mm which might be from bookjovi@gmail.com are

origin.patch
linux-next.patch

