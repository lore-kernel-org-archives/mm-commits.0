From: akpm@linux-foundation.org
Subject: - ia64-perfmon-remove-exit_pfm_fs.patch removed from -mm tree
Date: Mon, 15 Oct 2007 19:17:40 -0700
Message-ID: <200710160217.l9G2He7v004221@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36792 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757312AbXJPCSJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 22:18:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam.sharma@gmail.com, eranian@hpl.hp.com, satyam@infradead.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64 perfmon: Remove exit_pfm_fs()
has been removed from the -mm tree.  Its filename was
     ia64-perfmon-remove-exit_pfm_fs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 7 deletions(-)

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

origin.patch
kill-declare_mutex_locked.patch
