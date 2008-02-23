From: akpm@linux-foundation.org
Subject: + affs-handle-match_strdup-failure.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:33:29 -0800
Message-ID: <200802230734.m1N7YItR018277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238AbYBWHyx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jim@meyering.net, meyering@redhat.com, zippel@linux-m68k.org


The patch titled
     affs: handle match_strdup failure
has been added to the -mm tree.  Its filename is
     affs-handle-match_strdup-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

usbaudio-handle-kcalloc-failure.patch
9p-handle-kstrdup-and-match_strdup-failure.patch
alpha-handle-kcalloc-failure.patch
affs-handle-match_strdup-failure.patch
hfs-handle-match_strdup-failure.patch
hfsplus-handle-match_strdup-failure.patch
lib-inflatec-handle-failed-malloc.patch
