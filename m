From: akpm@linux-foundation.org
Subject: + fs-ubifs-use-err_cast.patch added to -mm tree
Date: Tue, 25 May 2010 15:56:28 -0700
Message-ID: <201005252256.o4PMuSP0019922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752272Ab0EYW4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 18:56:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, dedekind1@gmail.com


The patch titled
     fs/ubifs: use ERR_CAST
has been added to the -mm tree.  Its filename is
     fs-ubifs-use-err_cast.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/ubifs: use ERR_CAST
From: Julia Lawall <julia@diku.dk>

Use ERR_CAST(x) rather than ERR_PTR(PTR_ERR(x)).  The former makes more
clear what is the purpose of the operation, which otherwise looks like a
no-op.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T x;
identifier f;
@@

T f (...) { <+...
- ERR_PTR(PTR_ERR(x))
+ x
 ...+> }

@@
expression x;
@@

- ERR_PTR(PTR_ERR(x))
+ ERR_CAST(x)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ubifs/lpt.c        |   14 +++++++-------
 fs/ubifs/lpt_commit.c |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/ubifs/lpt.c~fs-ubifs-use-err_cast fs/ubifs/lpt.c
--- a/fs/ubifs/lpt.c~fs-ubifs-use-err_cast
+++ a/fs/ubifs/lpt.c
@@ -1457,13 +1457,13 @@ struct ubifs_lprops *ubifs_lpt_lookup(st
 		shft -= UBIFS_LPT_FANOUT_SHIFT;
 		nnode = ubifs_get_nnode(c, nnode, iip);
 		if (IS_ERR(nnode))
-			return ERR_PTR(PTR_ERR(nnode));
+			return ERR_CAST(nnode);
 	}
 	iip = ((i >> shft) & (UBIFS_LPT_FANOUT - 1));
 	shft -= UBIFS_LPT_FANOUT_SHIFT;
 	pnode = ubifs_get_pnode(c, nnode, iip);
 	if (IS_ERR(pnode))
-		return ERR_PTR(PTR_ERR(pnode));
+		return ERR_CAST(pnode);
 	iip = (i & (UBIFS_LPT_FANOUT - 1));
 	dbg_lp("LEB %d, free %d, dirty %d, flags %d", lnum,
 	       pnode->lprops[iip].free, pnode->lprops[iip].dirty,
@@ -1586,7 +1586,7 @@ struct ubifs_lprops *ubifs_lpt_lookup_di
 	nnode = c->nroot;
 	nnode = dirty_cow_nnode(c, nnode);
 	if (IS_ERR(nnode))
-		return ERR_PTR(PTR_ERR(nnode));
+		return ERR_CAST(nnode);
 	i = lnum - c->main_first;
 	shft = c->lpt_hght * UBIFS_LPT_FANOUT_SHIFT;
 	for (h = 1; h < c->lpt_hght; h++) {
@@ -1594,19 +1594,19 @@ struct ubifs_lprops *ubifs_lpt_lookup_di
 		shft -= UBIFS_LPT_FANOUT_SHIFT;
 		nnode = ubifs_get_nnode(c, nnode, iip);
 		if (IS_ERR(nnode))
-			return ERR_PTR(PTR_ERR(nnode));
+			return ERR_CAST(nnode);
 		nnode = dirty_cow_nnode(c, nnode);
 		if (IS_ERR(nnode))
-			return ERR_PTR(PTR_ERR(nnode));
+			return ERR_CAST(nnode);
 	}
 	iip = ((i >> shft) & (UBIFS_LPT_FANOUT - 1));
 	shft -= UBIFS_LPT_FANOUT_SHIFT;
 	pnode = ubifs_get_pnode(c, nnode, iip);
 	if (IS_ERR(pnode))
-		return ERR_PTR(PTR_ERR(pnode));
+		return ERR_CAST(pnode);
 	pnode = dirty_cow_pnode(c, pnode);
 	if (IS_ERR(pnode))
-		return ERR_PTR(PTR_ERR(pnode));
+		return ERR_CAST(pnode);
 	iip = (i & (UBIFS_LPT_FANOUT - 1));
 	dbg_lp("LEB %d, free %d, dirty %d, flags %d", lnum,
 	       pnode->lprops[iip].free, pnode->lprops[iip].dirty,
diff -puN fs/ubifs/lpt_commit.c~fs-ubifs-use-err_cast fs/ubifs/lpt_commit.c
--- a/fs/ubifs/lpt_commit.c~fs-ubifs-use-err_cast
+++ a/fs/ubifs/lpt_commit.c
@@ -646,7 +646,7 @@ static struct ubifs_pnode *pnode_lookup(
 		shft -= UBIFS_LPT_FANOUT_SHIFT;
 		nnode = ubifs_get_nnode(c, nnode, iip);
 		if (IS_ERR(nnode))
-			return ERR_PTR(PTR_ERR(nnode));
+			return ERR_CAST(nnode);
 	}
 	iip = ((i >> shft) & (UBIFS_LPT_FANOUT - 1));
 	return ubifs_get_pnode(c, nnode, iip);
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-scsi-aacraid-eliminate-use-after-free.patch
arch-x86-pci-use-kasprintf.patch
fs-btrfs-use-memdup_user.patch
drivers-media-use-memdup_user.patch
drivers-i2c-use-memdup_user.patch
drivers-ieee1394-use-memdup_user.patch
drivers-infiniband-core-use-memdup_user.patch
drivers-ide-use-memdup_user.patch
drivers-isdn-use-memdup_user.patch
net-can-use-memdup_user.patch
net-dccp-use-memdup_user.patch
drivers-net-use-memdup_user.patch
drivers-net-cxgb3-use-memdup_user.patch
drivers-net-wan-use-memdup_user.patch
drivers-net-wireless-prism54-use-memdup_user.patch
drivers-s390-net-use-memdup_user.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-use-memdup_user.patch
drivers-block-use-memdup_user.patch
drivers-staging-dream-camera-use-memdup_user.patch
drivers-usb-gadget-use-memdup_user.patch
mm-use-memdup_user.patch
drivers-char-vtc-use-memdup_user.patch
drivers-message-i2o-i2o_configc-use-memdup_user.patch
fs-autofs4-use-memdup_user.patch
drivers-video-via-use-memdup_user.patch
drivers-telephony-ixjc-use-memdup_user.patch
drivers-char-ppdevc-use-kasprintf.patch
drivers-char-applicomc-use-memdup_user.patch
ipc-semc-use-err_cast.patch
crypto-use-err_cast.patch
drivers-mmc-host-use-err_cast.patch
fs-ubifs-use-err_cast.patch
fs-btrfs-use-err_cast.patch
mm-use-err_cast.patch
fs-ceph-use-err_cast.patch
fs-affs-use-err_cast.patch

