From: akpm@linux-foundation.org
Subject: [merged] hfsplus-refuse-to-mount-volumes-larger-than-2tb.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:50:06 -0700
Message-ID: <200910302050.n9UKo61c009839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757525AbZJ3Uvn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:51:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@decadent.org.uk, snakebyte@gmx.de, stable@kernel.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hfsplus: refuse to mount volumes larger than 2TB
has been removed from the -mm tree.  Its filename was
     hfsplus-refuse-to-mount-volumes-larger-than-2tb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfsplus: refuse to mount volumes larger than 2TB
From: Ben Hutchings <ben@decadent.org.uk>

As found in <http://bugs.debian.org/550010>, hfsplus is using type u32
rather than sector_t for some sector number calculations.

In particular, hfsplus_get_block() does:

        u32 ablock, dblock, mask;
...
        map_bh(bh_result, sb, (dblock << HFSPLUS_SB(sb).fs_shift) + HFSPLUS_SB(sb).blockoffset + (iblock & mask));

I am not confident that I can find and fix all cases where a sector number
may be truncated.  For now, avoid data loss by refusing to mount HFS+
volumes with more than 2^32 sectors (2TB).

[akpm@linux-foundation.org: fix 32 and 64-bit issues]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/hfsplus/wrapper.c~hfsplus-refuse-to-mount-volumes-larger-than-2tb fs/hfsplus/wrapper.c
--- a/fs/hfsplus/wrapper.c~hfsplus-refuse-to-mount-volumes-larger-than-2tb
+++ a/fs/hfsplus/wrapper.c
@@ -99,6 +99,10 @@ int hfsplus_read_wrapper(struct super_bl
 
 	if (hfsplus_get_last_session(sb, &part_start, &part_size))
 		return -EINVAL;
+	if ((u64)part_start + part_size > 0x100000000ULL) {
+		pr_err("hfs: volumes larger than 2TB are not supported yet\n");
+		return -EINVAL;
+	}
 	while (1) {
 		bh = sb_bread512(sb, part_start + HFSPLUS_VOLHEAD_SECTOR, vhdr);
 		if (!bh)
_

Patches currently in -mm which might be from ben@decadent.org.uk are

origin.patch
linux-next.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch

