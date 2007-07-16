From: akpm@linux-foundation.org
Subject: - hfsplus-change-kmalloc-memset-to-kzalloc.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:56:11 -0700
Message-ID: <200707162056.l6GKuB5l002074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50614 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881AbXGPVMK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:12:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wyatt@banksresearch.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     HFSPlus: change kmalloc/memset to kzalloc
has been removed from the -mm tree.  Its filename was
     hfsplus-change-kmalloc-memset-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: HFSPlus: change kmalloc/memset to kzalloc
From: Wyatt Banks <wyatt@banksresearch.com>

Removed kmalloc and memset in favor of kzalloc.

To explain the HFSPLUS_SB() macro in the removed memset call:

hfsplus_fs.h:#define HFSPLUS_SB(super)  (*(struct hfsplus_sb_info *)(super)->s_fs_info)

Signed-off-by: Wyatt Banks <wyatt@banksresearch.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/hfsplus/super.c~hfsplus-change-kmalloc-memset-to-kzalloc fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-change-kmalloc-memset-to-kzalloc
+++ a/fs/hfsplus/super.c
@@ -283,11 +283,10 @@ static int hfsplus_fill_super(struct sup
 	struct nls_table *nls = NULL;
 	int err = -EINVAL;
 
-	sbi = kmalloc(sizeof(struct hfsplus_sb_info), GFP_KERNEL);
+	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;
 
-	memset(sbi, 0, sizeof(HFSPLUS_SB(sb)));
 	sb->s_fs_info = sbi;
 	INIT_HLIST_HEAD(&sbi->rsrc_inodes);
 	hfsplus_fill_defaults(sbi);
_

Patches currently in -mm which might be from wyatt@banksresearch.com are

origin.patch
