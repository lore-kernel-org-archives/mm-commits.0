From: akpm@linux-foundation.org
Subject: + sysctl-remove-references-to-ctl_unnumbered-which-has-been-removed.patch added to -mm tree
Date: Tue, 09 Feb 2010 15:13:14 -0800
Message-ID: <201002092313.o19NDEiI007459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752259Ab0BIXNS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2010 18:13:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: knikanth@suse.de


The patch titled
     sysctl: remove references to CTL_UNNUMBERED which has been removed
has been added to the -mm tree.  Its filename is
     sysctl-remove-references-to-ctl_unnumbered-which-has-been-removed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: remove references to CTL_UNNUMBERED which has been removed
From: Nikanth Karthikesan <knikanth@suse.de>

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/00-INDEX |    2 --
 kernel/sysctl.c               |   16 ----------------
 2 files changed, 18 deletions(-)

diff -puN Documentation/sysctl/00-INDEX~sysctl-remove-references-to-ctl_unnumbered-which-has-been-removed Documentation/sysctl/00-INDEX
--- a/Documentation/sysctl/00-INDEX~sysctl-remove-references-to-ctl_unnumbered-which-has-been-removed
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
diff -puN kernel/sysctl.c~sysctl-remove-references-to-ctl_unnumbered-which-has-been-removed kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-remove-references-to-ctl_unnumbered-which-has-been-removed
+++ a/kernel/sysctl.c
@@ -222,10 +222,6 @@ static struct ctl_table root_table[] = {
 		.mode		= 0555,
 		.child		= dev_table,
 	},
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
@@ -926,10 +922,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
@@ -1272,10 +1264,6 @@ static struct ctl_table vm_table[] = {
 	},
 #endif
 
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
@@ -1423,10 +1411,6 @@ static struct ctl_table fs_table[] = {
 		.child		= binfmt_misc_table,
 	},
 #endif
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
_

Patches currently in -mm which might be from knikanth@suse.de are

linux-next.patch
remove-unused-macro-vm_min_readahead.patch
sysctl-remove-references-to-ctl_unnumbered-which-has-been-removed.patch

