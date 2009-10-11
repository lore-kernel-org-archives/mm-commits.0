From: akpm@linux-foundation.org
Subject: + hfsplus-refuse-to-mount-volumes-larger-than-2tb.patch added to -mm tree
Date: Sun, 11 Oct 2009 00:52:18 -0700
Message-ID: <200910110752.n9B7qIPF019767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460AbZJKHyh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Oct 2009 03:54:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@decadent.org.uk, snakebyte@gmx.de, stable@kernel.org, zippel@linux-m68k.org


The patch titled
     hfsplus: refuse to mount volumes larger than 2TB
has been added to the -mm tree.  Its filename is
     hfsplus-refuse-to-mount-volumes-larger-than-2tb.patch

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

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/wrapper.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/hfsplus/wrapper.c~hfsplus-refuse-to-mount-volumes-larger-than-2tb fs/hfsplus/wrapper.c
--- a/fs/hfsplus/wrapper.c~hfsplus-refuse-to-mount-volumes-larger-than-2tb
+++ a/fs/hfsplus/wrapper.c
@@ -99,6 +99,10 @@ int hfsplus_read_wrapper(struct super_bl
 
 	if (hfsplus_get_last_session(sb, &part_start, &part_size))
 		return -EINVAL;
+	if (part_start + part_size > 0x100000000) {
+		pr_err("hfs: volumes larger than 2TB are not supported yet\n");
+		return -EINVAL;
+	}
 	while (1) {
 		bh = sb_bread512(sb, part_start + HFSPLUS_VOLHEAD_SECTOR, vhdr);
 		if (!bh)
_

Patches currently in -mm which might be from ben@decadent.org.uk are

origin.patch
hfsplus-refuse-to-mount-volumes-larger-than-2tb.patch
hfsplus-refuse-to-mount-volumes-larger-than-2tb-fix.patch

