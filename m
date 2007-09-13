From: akpm@linux-foundation.org
Subject: + ia64-perfmon-remove-exit_pfm_fs.patch added to -mm tree
Date: Thu, 13 Sep 2007 16:25:33 -0700
Message-ID: <200709132325.l8DNPXAQ010987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46212 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015AbXIMX0A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 19:26:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam.sharma@gmail.com, eranian@hpl.hp.com, satyam@infradead.org, tony.luck@intel.com


The patch titled
     ia64 perfmon: Remove exit_pfm_fs()
has been added to the -mm tree.  Its filename is
     ia64-perfmon-remove-exit_pfm_fs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64 perfmon: Remove exit_pfm_fs()
From: "Satyam Sharma" <satyam.sharma@gmail.com>

Because it is dead code and not referenced by anybody else (that file cannot
be built modular).

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Stephane Eranian <eranian@hpl.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/perfmon.c |    7 -------
 1 files changed, 7 deletions(-)

diff -puN arch/ia64/kernel/perfmon.c~ia64-perfmon-remove-exit_pfm_fs arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~ia64-perfmon-remove-exit_pfm_fs
+++ a/arch/ia64/kernel/perfmon.c
@@ -1538,13 +1538,6 @@ init_pfm_fs(void)
 	return err;
 }
 
-static void __exit
-exit_pfm_fs(void)
-{
-	unregister_filesystem(&pfm_fs_type);
-	mntput(pfmfs_mnt);
-}
-
 static ssize_t
 pfm_read(struct file *filp, char __user *buf, size_t size, loff_t *ppos)
 {
_

Patches currently in -mm which might be from satyam.sharma@gmail.com are

ia64-tree-wide-misc-__cpuinitdata-init-exit-fix.patch
ia64-perfmon-remove-exit_pfm_fs.patch
kill-declare_mutex_locked.patch
