From: akpm@linux-foundation.org
Subject: - memstick-fix-attribute-structure-casting-in-mspro_block_resume.patch removed from -mm tree
Date: Sat, 09 Feb 2008 10:19:15 -0800
Message-ID: <200802091820.m19IK8s0025562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38621 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897AbYBISsW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 9 Feb 2008 13:48:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     memstick: fix attribute structure casting in mspro_block_resume
has been removed from the -mm tree.  Its filename was
     memstick-fix-attribute-structure-casting-in-mspro_block_resume.patch

This patch was dropped because it was folded into memstick-initial-commit-for-sony-memorystick-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: fix attribute structure casting in mspro_block_resume
From: Alex Dubov <oakad@yahoo.com>

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/memstick/core/mspro_block.c~memstick-fix-attribute-structure-casting-in-mspro_block_resume drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-fix-attribute-structure-casting-in-mspro_block_resume
+++ a/drivers/memstick/core/mspro_block.c
@@ -1237,7 +1237,7 @@ static int mspro_block_resume(struct mem
 
 	struct mspro_block_data *new_msb;
 	struct memstick_host *host = card->host;
-	struct mspro_sys_attr s_attr, r_attr;
+	struct mspro_sys_attr *s_attr, *r_attr;
 	unsigned char cnt;
 
 	mutex_lock(&host->lock);
@@ -1254,12 +1254,8 @@ static int mspro_block_resume(struct mem
 
 	for (cnt = 0; new_msb->attr_group.attrs[cnt]
 		      && msb->attr_group.attrs[cnt]; ++cnt) {
-		s_attr = container_of(new_msb->attr_group.attrs[cnt],
-				      struct mspro_sys_attr,
-				      dev_attr);
-		r_attr = container_of(msb->attr_group.attrs[cnt],
-				      struct mspro_sys_attr,
-				      dev_attr);
+		s_attr = mspro_from_sysfs_attr(new_msb->attr_group.attrs[cnt]);
+		r_attr = mspro_from_sysfs_attr(msb->attr_group.attrs[cnt]);
 
 		if (s_attr->id == MSPRO_BLOCK_ID_SYSINFO
 		    && r_attr->id == s_attr->id) {
_

Patches currently in -mm which might be from oakad@yahoo.com are

origin.patch
memstick-initial-commit-for-sony-memorystick-support.patch
memstick-fix-attribute-structure-casting-in-mspro_block_resume.patch
memstick-disable-busted-code.patch
