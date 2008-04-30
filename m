From: akpm@linux-foundation.org
Subject: - hfsplus-handle-match_strdup-failure.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:58 -0700
Message-ID: <200804300539.m3U5dwUg028896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754492AbYD3FkU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:40:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jim@meyering.net, meyering@redhat.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hfsplus: handle match_strdup failure
has been removed from the -mm tree.  Its filename was
     hfsplus-handle-match_strdup-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfsplus: handle match_strdup failure
From: Jim Meyering <jim@meyering.net>

fs/hfsplus/options.c (hfsplus_parse_options): Handle match_strdup failure.

Signed-off-by: Jim Meyering <meyering@redhat.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/options.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/hfsplus/options.c~hfsplus-handle-match_strdup-failure fs/hfsplus/options.c
--- a/fs/hfsplus/options.c~hfsplus-handle-match_strdup-failure
+++ a/fs/hfsplus/options.c
@@ -132,7 +132,8 @@ int hfsplus_parse_options(char *input, s
 				return 0;
 			}
 			p = match_strdup(&args[0]);
-			sbi->nls = load_nls(p);
+			if (p)
+				sbi->nls = load_nls(p);
 			if (!sbi->nls) {
 				printk(KERN_ERR "hfs: unable to load nls mapping \"%s\"\n", p);
 				kfree(p);
_

Patches currently in -mm which might be from jim@meyering.net are

origin.patch
git-v9fs.patch

