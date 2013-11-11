From: akpm@linux-foundation.org
Subject: [merged] pktcdvd-debugfs-functions-return-null-on-error.patch
 removed from -mm tree
Date: Mon, 11 Nov 2013 10:44:04 -0800
Message-ID: <52812574.G7uU57/0DqlZXv1W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab3KKSoF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Nov 2013 13:44:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, petero2@telia.com, jkosina@suse.cz, dan.carpenter@oracle.com

Subject: [merged] pktcdvd-debugfs-functions-return-null-on-error.patch removed from -mm tree
To: dan.carpenter@oracle.com,jkosina@suse.cz,petero2@telia.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 11 Nov 2013 10:44:04 -0800


The patch titled
     Subject: pktcdvd: debugfs functions return NULL on error
has been removed from the -mm tree.  Its filename was
     pktcdvd-debugfs-functions-return-null-on-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: pktcdvd: debugfs functions return NULL on error

My static checker complains correctly that this is potential NULL
dereference because debugfs functions return NULL on error.  They return
an ERR_PTR if they are configured out.

We don't need to check for ERR_PTR because if debugfs is stubbed out the
dummy functions won't complain about that.  We don't need to check the
values before calling debugfs_remove() because that accepts ERR_PTRs and
NULL pointers.

We don't need to set pkt->dfs_f_info to NULL in pkt_debugfs_dev_new()
because it was initialized with kzalloc() so I have removed that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Peter Osterlund <petero2@telia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/pktcdvd.c |   22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff -puN drivers/block/pktcdvd.c~pktcdvd-debugfs-functions-return-null-on-error drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~pktcdvd-debugfs-functions-return-null-on-error
+++ a/drivers/block/pktcdvd.c
@@ -473,45 +473,31 @@ static void pkt_debugfs_dev_new(struct p
 {
 	if (!pkt_debugfs_root)
 		return;
-	pd->dfs_f_info = NULL;
 	pd->dfs_d_root = debugfs_create_dir(pd->name, pkt_debugfs_root);
-	if (IS_ERR(pd->dfs_d_root)) {
-		pd->dfs_d_root = NULL;
+	if (!pd->dfs_d_root)
 		return;
-	}
+
 	pd->dfs_f_info = debugfs_create_file("info", S_IRUGO,
 				pd->dfs_d_root, pd, &debug_fops);
-	if (IS_ERR(pd->dfs_f_info)) {
-		pd->dfs_f_info = NULL;
-		return;
-	}
 }
 
 static void pkt_debugfs_dev_remove(struct pktcdvd_device *pd)
 {
 	if (!pkt_debugfs_root)
 		return;
-	if (pd->dfs_f_info)
-		debugfs_remove(pd->dfs_f_info);
+	debugfs_remove(pd->dfs_f_info);
+	debugfs_remove(pd->dfs_d_root);
 	pd->dfs_f_info = NULL;
-	if (pd->dfs_d_root)
-		debugfs_remove(pd->dfs_d_root);
 	pd->dfs_d_root = NULL;
 }
 
 static void pkt_debugfs_init(void)
 {
 	pkt_debugfs_root = debugfs_create_dir(DRIVER_NAME, NULL);
-	if (IS_ERR(pkt_debugfs_root)) {
-		pkt_debugfs_root = NULL;
-		return;
-	}
 }
 
 static void pkt_debugfs_cleanup(void)
 {
-	if (!pkt_debugfs_root)
-		return;
 	debugfs_remove(pkt_debugfs_root);
 	pkt_debugfs_root = NULL;
 }
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
ocfs2-add-missing-errno-in-ocfs2_ioctl_move_extents.patch
framework-for-version-lvb-remove-some-impossible-checks.patch
drivers-block-paride-pgc-underflow-bug-in-pg_write.patch
xfs-underflow-bug-in-xfs_attrlist_by_handle.patch
backlight-lm3630-signedness-bug-in-lm3630a_chip_init.patch
backlight-lm3630-potential-null-deref-in-probe.patch
linux-next.patch

