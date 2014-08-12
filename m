From: akpm@linux-foundation.org
Subject: [merged] sysctl-remove-now-unused-typedef-ctl_table.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:40:36 -0700
Message-ID: <53ea6db4.eQwCW/n9Vi6D9E2O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:52708 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbaHLTkg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:36 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so2668922pde.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: remove typedef ctl_table
has been removed from the -mm tree.  Its filename was
     sysctl-remove-now-unused-typedef-ctl_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: sysctl: remove typedef ctl_table

Remove the final user, and the typedef itself.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c  |    2 +-
 include/linux/sysctl.h |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/proc/proc_sysctl.c~sysctl-remove-now-unused-typedef-ctl_table fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~sysctl-remove-now-unused-typedef-ctl_table
+++ a/fs/proc/proc_sysctl.c
@@ -632,7 +632,7 @@ out:
 	return ret;
 }
 
-static int scan(struct ctl_table_header *head, ctl_table *table,
+static int scan(struct ctl_table_header *head, struct ctl_table *table,
 		unsigned long *pos, struct file *file,
 		struct dir_context *ctx)
 {
diff -puN include/linux/sysctl.h~sysctl-remove-now-unused-typedef-ctl_table include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-remove-now-unused-typedef-ctl_table
+++ a/include/linux/sysctl.h
@@ -34,8 +34,6 @@ struct ctl_table_root;
 struct ctl_table_header;
 struct ctl_dir;
 
-typedef struct ctl_table ctl_table;
