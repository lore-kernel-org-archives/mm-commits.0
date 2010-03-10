From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-remove-references-to-ctl_unnumbered-which-has-been-removed.patch removed from -mm tree
Date: Wed, 10 Mar 2010 12:30:17 -0800
Message-ID: <201003102030.o2AKUHLP001974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757019Ab0CJUaV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 15:30:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: knikanth@suse.de, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: remove references to CTL_UNNUMBERED which has been removed
has been removed from the -mm tree.  Its filename was
     sysctl-remove-references-to-ctl_unnumbered-which-has-been-removed.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: remove references to CTL_UNNUMBERED which has been removed
From: Nikanth Karthikesan <knikanth@suse.de>

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
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
@@ -227,10 +227,6 @@ static struct ctl_table root_table[] = {
 		.mode		= 0555,
 		.child		= dev_table,
 	},
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
@@ -940,10 +936,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
@@ -1286,10 +1278,6 @@ static struct ctl_table vm_table[] = {
 	},
 #endif
 
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
@@ -1437,10 +1425,6 @@ static struct ctl_table fs_table[] = {
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
sysctl-remove-references-to-ctl_unnumbered-which-has-been-removed.patch

