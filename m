From: akpm@linux-foundation.org
Subject: [merged] hpfs-convert-to-use-lexx_add_cpu.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:18:06 -0700
Message-ID: <20121005201806.AA1DF100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:49795 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277Ab2JEUSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:18:07 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so236299ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:18:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, mikulas@artax.karlin.mff.cuni.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: hpfs: convert to use leXX_add_cpu()
has been removed from the -mm tree.  Its filename was
     hpfs-convert-to-use-lexx_add_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: hpfs: convert to use leXX_add_cpu()

Convert cpu_to_leXX(leXX_to_cpu(E1) + E2) to use leXX_add_cpu().

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/anode.c |    6 +++---
 fs/hpfs/dnode.c |   28 ++++++++++++++--------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff -puN fs/hpfs/anode.c~hpfs-convert-to-use-lexx_add_cpu fs/hpfs/anode.c
--- a/fs/hpfs/anode.c~hpfs-convert-to-use-lexx_add_cpu
+++ a/fs/hpfs/anode.c
@@ -102,7 +102,7 @@ secno hpfs_add_sector_to_btree(struct su
 			return -1;
 		}
 		if (hpfs_alloc_if_possible(s, se = le32_to_cpu(btree->u.external[n].disk_secno) + le32_to_cpu(btree->u.external[n].length))) {
-			btree->u.external[n].length = cpu_to_le32(le32_to_cpu(btree->u.external[n].length) + 1);
+			le32_add_cpu(&btree->u.external[n].length, 1);
 			mark_buffer_dirty(bh);
 			brelse(bh);
 			return se;
@@ -153,7 +153,7 @@ secno hpfs_add_sector_to_btree(struct su
 		btree = &anode->btree;
 	}
 	btree->n_free_nodes--; n = btree->n_used_nodes++;
-	btree->first_free = cpu_to_le16(le16_to_cpu(btree->first_free) + 12);
+	le16_add_cpu(&btree->first_free, 12);
 	btree->u.external[n].disk_secno = cpu_to_le32(se);
 	btree->u.external[n].file_secno = cpu_to_le32(fs);
 	btree->u.external[n].length = cpu_to_le32(1);
@@ -174,7 +174,7 @@ secno hpfs_add_sector_to_btree(struct su
 		}
 		if (btree->n_free_nodes) {
 			btree->n_free_nodes--; n = btree->n_used_nodes++;
-			btree->first_free = cpu_to_le16(le16_to_cpu(btree->first_free) + 8);
+			le16_add_cpu(&btree->first_free, 8);
 			btree->u.internal[n].file_secno = cpu_to_le32(-1);
 			btree->u.internal[n].down = cpu_to_le32(na);
 			btree->u.internal[n-1].file_secno = cpu_to_le32(fs);
diff -puN fs/hpfs/dnode.c~hpfs-convert-to-use-lexx_add_cpu fs/hpfs/dnode.c
--- a/fs/hpfs/dnode.c~hpfs-convert-to-use-lexx_add_cpu
+++ a/fs/hpfs/dnode.c
@@ -145,10 +145,10 @@ static void set_last_pointer(struct supe
 		}
 	}
 	if (ptr) {
-		d->first_free = cpu_to_le32(le32_to_cpu(d->first_free) + 4);
+		le32_add_cpu(&d->first_free, 4);
 		if (le32_to_cpu(d->first_free) > 2048) {
 			hpfs_error(s, "set_last_pointer: too long dnode %08x", le32_to_cpu(d->self));
-			d->first_free = cpu_to_le32(le32_to_cpu(d->first_free) - 4);
+			le32_add_cpu(&d->first_free, -4);
 			return;
 		}
 		de->length = cpu_to_le16(36);
@@ -184,7 +184,7 @@ struct hpfs_dirent *hpfs_add_de(struct s
 	de->not_8x3 = hpfs_is_name_long(name, namelen);
 	de->namelen = namelen;
 	memcpy(de->name, name, namelen);
-	d->first_free = cpu_to_le32(le32_to_cpu(d->first_free) + d_size);
+	le32_add_cpu(&d->first_free, d_size);
 	return de;
 }
 
@@ -314,7 +314,7 @@ static int hpfs_add_to_dnode(struct inod
 	set_last_pointer(i->i_sb, ad, de->down ? de_down_pointer(de) : 0);
 	de = de_next_de(de);
 	memmove((char *)nd + 20, de, le32_to_cpu(nd->first_free) + (char *)nd - (char *)de);
-	nd->first_free = cpu_to_le32(le32_to_cpu(nd->first_free) - ((char *)de - (char *)nd - 20));
+	le32_add_cpu(&nd->first_free, -((char *)de - (char *)nd - 20));
 	memcpy(d, nd, le32_to_cpu(nd->first_free));
 	for_all_poss(i, hpfs_pos_del, (loff_t)dno << 4, pos);
 	fix_up_ptrs(i->i_sb, ad);
@@ -474,8 +474,8 @@ static secno move_to_top(struct inode *i
 			hpfs_brelse4(&qbh);
 			return 0;
 		}
-		dnode->first_free = cpu_to_le32(le32_to_cpu(dnode->first_free) - 4);
-		de->length = cpu_to_le16(le16_to_cpu(de->length) - 4);
+		le32_add_cpu(&dnode->first_free, -4);
+		le16_add_cpu(&de->length, -4);
 		de->down = 0;
 		hpfs_mark_4buffers_dirty(&qbh);
 		dno = up;
@@ -570,8 +570,8 @@ static void delete_empty_dnode(struct in
 		for_all_poss(i, hpfs_pos_subst, ((loff_t)dno << 4) | 1, ((loff_t)up << 4) | p);
 		if (!down) {
 			de->down = 0;
-			de->length = cpu_to_le16(le16_to_cpu(de->length) - 4);
-			dnode->first_free = cpu_to_le32(le32_to_cpu(dnode->first_free) - 4);
+			le16_add_cpu(&de->length, -4);
+			le32_add_cpu(&dnode->first_free, -4);
 			memmove(de_next_de(de), (char *)de_next_de(de) + 4,
 				(char *)dnode + le32_to_cpu(dnode->first_free) - (char *)de_next_de(de));
 		} else {
@@ -647,14 +647,14 @@ static void delete_empty_dnode(struct in
 					printk("HPFS: warning: unbalanced dnode tree, see hpfs.txt 4 more info\n");
 					printk("HPFS: warning: goin'on\n");
 				}
-				del->length = cpu_to_le16(le16_to_cpu(del->length) + 4);
+				le16_add_cpu(&del->length, 4);
 				del->down = 1;
-				d1->first_free = cpu_to_le32(le32_to_cpu(d1->first_free) + 4);
+				le32_add_cpu(&d1->first_free, 4);
 			}
 			if (dlp && !down) {
-				del->length = cpu_to_le16(le16_to_cpu(del->length) - 4);
+				le16_add_cpu(&del->length, -4);
 				del->down = 0;
-				d1->first_free = cpu_to_le32(le32_to_cpu(d1->first_free) - 4);
+				le32_add_cpu(&d1->first_free, -4);
 			} else if (down)
 				*(__le32 *) ((void *) del + le16_to_cpu(del->length) - 4) = cpu_to_le32(down);
 		} else goto endm;
@@ -668,9 +668,9 @@ static void delete_empty_dnode(struct in
 		memcpy(de_cp, de_prev, le16_to_cpu(de_prev->length));
 		hpfs_delete_de(i->i_sb, dnode, de_prev);
 		if (!de_prev->down) {
-			de_prev->length = cpu_to_le16(le16_to_cpu(de_prev->length) + 4);
+			le16_add_cpu(&de_prev->length, 4);
 			de_prev->down = 1;
-			dnode->first_free = cpu_to_le32(le32_to_cpu(dnode->first_free) + 4);
+			le32_add_cpu(&dnode->first_free, 4);
 		}
 		*(__le32 *) ((void *) de_prev + le16_to_cpu(de_prev->length) - 4) = cpu_to_le32(ndown);
 		hpfs_mark_4buffers_dirty(&qbh);
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
linux-next.patch

