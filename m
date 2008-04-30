From: akpm@linux-foundation.org
Subject: - affs-handle-match_strdup-failure.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:53 -0700
Message-ID: <200804300539.m3U5draJ028887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901AbYD3FkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:40:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jim@meyering.net, meyering@redhat.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     affs: handle match_strdup failure
has been removed from the -mm tree.  Its filename was
     affs-handle-match_strdup-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: affs: handle match_strdup failure
From: Jim Meyering <jim@meyering.net>

fs/affs/super.c (parse_options): Remove useless initialization.  Handle
match_strdup failure.

Signed-off-by: Jim Meyering <meyering@redhat.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/affs/super.c~affs-handle-match_strdup-failure fs/affs/super.c
--- a/fs/affs/super.c~affs-handle-match_strdup-failure
+++ a/fs/affs/super.c
@@ -199,7 +199,6 @@ parse_options(char *options, uid_t *uid,
 		case Opt_prefix:
 			/* Free any previous prefix */
 			kfree(*prefix);
-			*prefix = NULL;
 			*prefix = match_strdup(&args[0]);
 			if (!*prefix)
 				return 0;
@@ -233,6 +232,8 @@ parse_options(char *options, uid_t *uid,
 			break;
 		case Opt_volume: {
 			char *vol = match_strdup(&args[0]);
+			if (!vol)
+				return 0;
 			strlcpy(volume, vol, 32);
 			kfree(vol);
 			break;
_

Patches currently in -mm which might be from jim@meyering.net are

origin.patch
git-v9fs.patch

