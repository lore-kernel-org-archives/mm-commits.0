Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560646;
	b=HLJEi/eNM2DClxVNR63RXkiBuObFzcPccCCai4JeoGwM5uYrerlrbp10uzpUhbjUdQyf
	 t8nnG3H8LF937NkM2kPVkyrX8cvDDC5/FvoP4YMKJX0grojppz0txr4A6W465Fl9PzhTr
	 rcMrX7XhytNZFYh7Ik2W9vSHp/gGpllgBwD2pBRPEr4slC4M/J3+GbHid8uhunpi/B7Lv
	 N74OG96qHHi+EQMQmytMFaqetLCoa03rj6oxJhzRkHP15unKN8Eq/+86bSZC4iasHAFNc
	 3OlgEWoVm3Nm2GRzianFjgupwJSvBomml/09xqZ9D1tNTVC1PGILoraWP4fF6lC2jIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560646;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=3xBVr1FOE5hKeHyUHrZ08RwKD3jyKef5n/j0WpDDFM0=;
	b=V5JhsdKgcp4AYx38kSFbL48hTf2POLnVITTVf1cUk8TarrINQ9S3KQBk8bw+ncjhuIbJ
	 auTuzFD9Glx2ZP5vWerRoLdwqvGeq/ueK6kcbWfkDB3ZXAAbHTRksYP4snSQ3phlh/WFt
	 arzs+D55hIvvIoKO/qe31t1rs5rikgey0yy7rpx77eDSEgwJ1Hdlg2NqUnAtsP5PB3DJ/
	 ZX7rT2v7bPkM03fErhqQPUDf1qZLBrdwmDRWMD7V6InexdK4VkpSzwvVgbUls2TlXIP96
	 hpm7YpmwOhx8CkP7efHQijlI8su/0lAgZuPS8hRWMgCICXW2Ll8g9t7qopKMWs8vGpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GEiAETPF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D4D606A31C
	for <mm-commits@vger.kernel.org>; Wed, 21 Oct 2026 05:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GEiAETPF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195201F000C9;
	Wed, 21 Oct 2026 05:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560646;
	bh=3xBVr1FOE5hKeHyUHrZ08RwKD3jyKef5n/j0WpDDFM0=;
	h=Date:To:From:Subject;
	b=GEiAETPFw7biMJMDj9WCVtElAiRvn64hdOsjFyuvTJgsv6begX0pRAfsrL+vaj6sI
	 DLx5LqLy93IBfkoCKov82ghcPCkMD9kkw5sVyVCBZO2UhnyVLDoITmRPm5cEZXpkhT
	 9fxizQ3R4blzrWmRNY/2ZOQcLRkkdoUehesDWBrk=
Date: Tue, 20 Oct 2026 22:30:45 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,matheus.aalmeida@inf.ufrgs.br,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-remove-cluster-allocation-size-limit.patch removed from -mm tree
Message-Id: <20261021053046.195201F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: fat: remove cluster allocation size limit
has been removed from the -mm tree.  Its filename was
     fat-remove-cluster-allocation-size-limit.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Subject: fat: remove cluster allocation size limit
Date: Mon, 12 Oct 2026 14:11:04 -0300

Patch series "fat: allocate multiple clusters in fallocate", v2.

This series adds support for allocating multiple clusters in a single
fat_add_clusters() call in fat_fallocate().

The multi-cluster TODO in inode.c is not implemented, as doing so would
require speculative preallocation or an iomap conversion.


This patch (of 3):

fat_alloc_clusters() currently BUG()s when asked to allocate more than
MAX_BUF_PER_PAGE / 2 clusters. This limit comes from the buffer_head
array used to defer syncing and mirroring.

Remove the allocation size limit by doing buffer_head batching like
fat_free_clusters() does.

Link: https://lore.kernel.org/20261012171106.146243-1-matheus.aalmeida@inf.ufrgs.br
Link: https://lore.kernel.org/20261012171106.146243-2-matheus.aalmeida@inf.ufrgs.br
Signed-off-by: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/fatent.c |   44 +++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

--- a/fs/fat/fatent.c~fat-remove-cluster-allocation-size-limit
+++ a/fs/fat/fatent.c
@@ -483,6 +483,26 @@ static void fat_collect_bhs(struct buffe
 	}
 }
 
+static int fat_flush_bhs(struct super_block *sb, struct buffer_head **bhs,
+			 int *nr_bhs, bool sync)
+{
+	int err, i;
+
+	if (sync) {
+		err = fat_sync_bhs(bhs, *nr_bhs);
+		if (err)
+			return err;
+	}
+	err = fat_mirror_bhs(sb, bhs, *nr_bhs);
+	if (err)
+		return err;
+	for (i = 0; i < *nr_bhs; i++)
+		brelse(bhs[i]);
+	*nr_bhs = 0;
+
+	return 0;
+}
+
 int fat_alloc_clusters(struct inode *inode, int *cluster, int nr_cluster)
 {
 	struct super_block *sb = inode->i_sb;
@@ -492,8 +512,6 @@ int fat_alloc_clusters(struct inode *ino
 	struct buffer_head *bhs[MAX_BUF_PER_PAGE];
 	int i, count, err, nr_bhs, idx_clus;
 
-	BUG_ON(nr_cluster > (MAX_BUF_PER_PAGE / 2));	/* fixed limit */
-
 	lock_fat(sbi);
 	if (sbi->free_clusters != -1 && sbi->free_clus_valid &&
 	    sbi->free_clusters < nr_cluster) {
@@ -524,14 +542,21 @@ int fat_alloc_clusters(struct inode *ino
 				if (prev_ent.nr_bhs)
 					ops->ent_put(&prev_ent, entry);
 
-				fat_collect_bhs(bhs, &nr_bhs, &fatent);
-
 				sbi->prev_free = entry;
 				if (sbi->free_clusters != -1)
 					sbi->free_clusters--;
 
 				cluster[idx_clus] = entry;
 				idx_clus++;
+
+				if (nr_bhs + fatent.nr_bhs > MAX_BUF_PER_PAGE) {
+					err = fat_flush_bhs(sb, bhs, &nr_bhs,
+							    inode_needs_sync(inode));
+					if (err)
+						goto out;
+				}
+				fat_collect_bhs(bhs, &nr_bhs, &fatent);
+
 				if (idx_clus == nr_cluster)
 					goto out;
 
@@ -621,17 +646,10 @@ int fat_free_clusters(struct inode *inod
 		}
 
 		if (nr_bhs + fatent.nr_bhs > MAX_BUF_PER_PAGE) {
-			if (sb->s_flags & SB_SYNCHRONOUS) {
-				err = fat_sync_bhs(bhs, nr_bhs);
-				if (err)
-					goto error;
-			}
-			err = fat_mirror_bhs(sb, bhs, nr_bhs);
+			err = fat_flush_bhs(sb, bhs, &nr_bhs,
+					    sb->s_flags & SB_SYNCHRONOUS);
 			if (err)
 				goto error;
-			for (i = 0; i < nr_bhs; i++)
-				brelse(bhs[i]);
-			nr_bhs = 0;
 		}
 		fat_collect_bhs(bhs, &nr_bhs, &fatent);
 	} while (cluster != FAT_ENT_EOF);
_

Patches currently in -mm which might be from matheus.aalmeida@inf.ufrgs.br are


