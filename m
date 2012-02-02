From: akpm@linux-foundation.org
Subject: [merged] sysctl-remove-an-unused-variable.patch removed from -mm tree
Date: Thu, 02 Feb 2012 12:11:24 -0800
Message-ID: <20120202201124.567F7A016E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:50316 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab2BBUL0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2012 15:11:26 -0500
Received: by eekb15 with SMTP id b15so87774eek.1
        for <mm-commits@vger.kernel.org>; Thu, 02 Feb 2012 12:11:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: remove an unused variable
has been removed from the -mm tree.  Its filename was
     sysctl-remove-an-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: sysctl: remove an unused variable

"links" is never used, so we can remove it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/proc/proc_sysctl.c~sysctl-remove-an-unused-variable fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~sysctl-remove-an-unused-variable
+++ a/fs/proc/proc_sysctl.c
@@ -1165,7 +1165,6 @@ struct ctl_table_header *__register_sysc
 	const char *path, struct ctl_table *table)
 {
 	struct ctl_table_root *root = set->dir.header.root;
-	struct ctl_table_header *links = NULL;
 	struct ctl_table_header *header;
 	const char *name, *nextname;
 	struct ctl_dir *dir;
@@ -1222,7 +1221,6 @@ fail_put_dir_locked:
 	drop_sysctl_table(&dir->header);
 	spin_unlock(&sysctl_lock);
 fail:
-	kfree(links);
 	kfree(header);
 	dump_stack();
 	return NULL;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
mm-compaction-make-compact_control-order-signed.patch
mm-compaction-make-compact_control-order-signed-fix.patch
drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe.patch

