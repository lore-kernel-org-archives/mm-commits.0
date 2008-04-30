From: akpm@linux-foundation.org
Subject: - hfs-handle-match_strdup-failure.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:56 -0700
Message-ID: <200804300539.m3U5duOw028890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754764AbYD3Fkm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:40:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jim@meyering.net, meyering@redhat.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hfs: handle match_strdup failure
has been removed from the -mm tree.  Its filename was
     hfs-handle-match_strdup-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfs: handle match_strdup failure
From: Jim Meyering <jim@meyering.net>

fs/hfs/super.c (parse_options): Handle match_strdup failure, twice.

Signed-off-by: Jim Meyering <meyering@redhat.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/super.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/hfs/super.c~hfs-handle-match_strdup-failure fs/hfs/super.c
--- a/fs/hfs/super.c~hfs-handle-match_strdup-failure
+++ a/fs/hfs/super.c
@@ -297,7 +297,8 @@ static int parse_options(char *options, 
 				return 0;
 			}
 			p = match_strdup(&args[0]);
-			hsb->nls_disk = load_nls(p);
+			if (p)
+				hsb->nls_disk = load_nls(p);
 			if (!hsb->nls_disk) {
 				printk(KERN_ERR "hfs: unable to load codepage \"%s\"\n", p);
 				kfree(p);
@@ -311,7 +312,8 @@ static int parse_options(char *options, 
 				return 0;
 			}
 			p = match_strdup(&args[0]);
-			hsb->nls_io = load_nls(p);
+			if (p)
+				hsb->nls_io = load_nls(p);
 			if (!hsb->nls_io) {
 				printk(KERN_ERR "hfs: unable to load iocharset \"%s\"\n", p);
 				kfree(p);
_

Patches currently in -mm which might be from jim@meyering.net are

origin.patch
git-v9fs.patch

