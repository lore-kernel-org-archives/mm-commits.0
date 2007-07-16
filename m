From: akpm@linux-foundation.org
Subject: - replace-obscure-constructs-in-fs-block_devc.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:57:58 -0700
Message-ID: <200707162057.l6GKvwYp002242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36677 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758642AbXGPVPI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes-kernel@saeurebad.de, B.Steinbrink@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Replace obscure constructs in fs/block_dev.c
has been removed from the -mm tree.  Its filename was
     replace-obscure-constructs-in-fs-block_devc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Replace obscure constructs in fs/block_dev.c
From: Johannes Weiner <hannes-kernel@saeurebad.de>

Replace some funky codepaths in fs/block_dev.c with cleaner versions of the
affected places.

[akpm@linux-foundation.org: fix return value]
Signed-off-by: Johannes Weiner <hannes-kernel@saeurebad.de>
Cc: Bjorn Steinbrink <B.Steinbrink@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |   50 ++++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff -puN fs/block_dev.c~replace-obscure-constructs-in-fs-block_devc fs/block_dev.c
--- a/fs/block_dev.c~replace-obscure-constructs-in-fs-block_devc
+++ a/fs/block_dev.c
@@ -872,7 +872,7 @@ static struct bd_holder *find_bd_holder(
  */
 static int add_bd_holder(struct block_device *bdev, struct bd_holder *bo)
 {
-	int ret;
+	int err;
 
 	if (!bo)
 		return -EINVAL;
@@ -880,15 +880,18 @@ static int add_bd_holder(struct block_de
 	if (!bd_holder_grab_dirs(bdev, bo))
 		return -EBUSY;
 
-	ret = add_symlink(bo->sdir, bo->sdev);
-	if (ret == 0) {
-		ret = add_symlink(bo->hdir, bo->hdev);
-		if (ret)
-			del_symlink(bo->sdir, bo->sdev);
+	err = add_symlink(bo->sdir, bo->sdev);
+	if (err)
+		return err;
+
+	err = add_symlink(bo->hdir, bo->hdev);
+	if (err) {
+		del_symlink(bo->sdir, bo->sdev);
+		return err;
 	}
-	if (ret == 0)
-		list_add_tail(&bo->list, &bdev->bd_holder_list);
-	return ret;
+
+	list_add_tail(&bo->list, &bdev->bd_holder_list);
+	return 0;
 }
 
 /**
@@ -946,7 +949,7 @@ static struct bd_holder *del_bd_holder(s
 static int bd_claim_by_kobject(struct block_device *bdev, void *holder,
 				struct kobject *kobj)
 {
-	int res;
+	int err;
 	struct bd_holder *bo, *found;
 
 	if (!kobj)
@@ -957,21 +960,24 @@ static int bd_claim_by_kobject(struct bl
 		return -ENOMEM;
 
 	mutex_lock(&bdev->bd_mutex);
-	res = bd_claim(bdev, holder);
-	if (res == 0) {
-		found = find_bd_holder(bdev, bo);
-		if (found == NULL) {
-			res = add_bd_holder(bdev, bo);
-			if (res)
-				bd_release(bdev);
-		}
-	}
 
-	if (res || found)
+	err = bd_claim(bdev, holder);
+	if (err)
+		goto out;
+
+	found = find_bd_holder(bdev, bo);
+	if (found)
+		goto out;
+
+	err = add_bd_holder(bdev, bo);
+	if (err)
+		bd_release(bdev);
+
+out:
+	if (err || found)
 		free_bd_holder(bo);
 	mutex_unlock(&bdev->bd_mutex);
-
-	return res;
+	return err;
 }
 
 /**
_

Patches currently in -mm which might be from hannes-kernel@saeurebad.de are

origin.patch
