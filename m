From: akpm@linux-foundation.org
Subject: - fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:47:45 -0700
Message-ID: <200710212347.l9LNljP1000673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751297AbXJUXs1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:48:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, edward@namesys.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     fs/reiser4/init_super.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: fs/reiser4/init_super.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/reiser4/init_super.c | 19283 -> 19246 (-37 bytes)
 fs/reiser4/init_super.o | 155348 -> 155152 (-196 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Edward Shishkin <edward@namesys.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/init_super.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/reiser4/init_super.c~fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc fs/reiser4/init_super.c
--- a/fs/reiser4/init_super.c~fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc
+++ a/fs/reiser4/init_super.c
@@ -17,14 +17,13 @@ int reiser4_init_fs_info(struct super_bl
 {
 	reiser4_super_info_data *sbinfo;
 
-	sbinfo = kmalloc(sizeof(reiser4_super_info_data),
+	sbinfo = kzalloc(sizeof(reiser4_super_info_data),
 			 reiser4_ctx_gfp_mask_get());
 	if (!sbinfo)
 		return RETERR(-ENOMEM);
 
 	super->s_fs_info = sbinfo;
 	super->s_op = NULL;
-	memset(sbinfo, 0, sizeof(*sbinfo));
 
 	ON_DEBUG(INIT_LIST_HEAD(&sbinfo->all_jnodes));
 	ON_DEBUG(spin_lock_init(&sbinfo->all_guard));
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
reiser4.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
