From: akpm@linux-foundation.org
Subject: + hpfs-convert-to-use-lexx_add_cpu.patch added to -mm tree
Date: Mon, 01 Oct 2012 12:47:45 -0700
Message-ID: <20121001194746.101E5200061@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:37364 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2JATrs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 15:47:48 -0400
Received: by weyx43 with SMTP id x43so336210wey.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 12:47:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyj.lk@gmail.com, mikulas@artax.karlin.mff.cuni.cz, yongjun_wei@trendmicro.com.cn


The patch titled
     From: Wei Yongjun <weiyj.lk@gmail.com>
has been added to the -mm tree.  Its filename is
     hpfs-convert-to-use-lexx_add_cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yongjun <weiyj.lk@gmail.com>
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

Patches currently in -mm which might be from weiyj.lk@gmail.com are

hpfs-convert-to-use-lexx_add_cpu.patch

