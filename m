From: akpm@linux-foundation.org
Subject: + isofs-fix-minor-filesystem-corruption-take-3.patch added to -mm tree
Date: Wed, 16 Jul 2008 02:13:36 -0700
Message-ID: <200807160913.m6G9DaRo016240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754AbYGPJOc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 05:14:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adam.greenblatt@gmail.com, penberg@cs.helsinki.fi, stable@kernel.org


The patch titled
     isofs: fix minor filesystem corruption
has been added to the -mm tree.  Its filename is
     isofs-fix-minor-filesystem-corruption-take-3.patch

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
Subject: isofs: fix minor filesystem corruption
From: Adam Greenblatt <adam.greenblatt@gmail.com>

Some iso9660 images contain files with rockridge data that is either
incorrect or incompletely parsed.  Prior to commit
f2966632a134e865db3c819346a1dc7d96e05309 ("[PATCH] rock: handle directory
overflows") (included with kernel 2.6.13) the kernel ignored the rockridge
data for these files, while still allowing the files to be accessed under
their non-rockridge names.  That commit inadvertently changed things so
that files with invalid rockridge data could not be accessed at all.  (I
ran across the problem when comparing some old CDs with hard disk copies I
had made long ago under kernel 2.4: a few of the files on the hard disk
copies were no longer visible on the CDs.)

This change reverts to the pre-2.6.13 behavior.

Signed-off-by: Adam Greenblatt <adam.greenblatt@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/rock.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff -puN fs/isofs/rock.c~isofs-fix-minor-filesystem-corruption-take-3 fs/isofs/rock.c
--- a/fs/isofs/rock.c~isofs-fix-minor-filesystem-corruption-take-3
+++ a/fs/isofs/rock.c
@@ -209,6 +209,11 @@ repeat:
 
 	while (rs.len > 2) { /* There may be one byte for padding somewhere */
 		rr = (struct rock_ridge *)rs.chr;
+		/*
+		 * Ignore rock ridge info if rr->len is out of range, but
+		 * don't return -EIO because that would make the file
+		 * invisible.
+		 */
 		if (rr->len < 3)
 			goto out;	/* Something got screwed up here */
 		sig = isonum_721(rs.chr);
@@ -216,8 +221,12 @@ repeat:
 			goto eio;
 		rs.chr += rr->len;
 		rs.len -= rr->len;
+		/*
+		 * As above, just ignore the rock ridge info if rr->len
+		 * is bogus.
+		 */
 		if (rs.len < 0)
-			goto eio;	/* corrupted isofs */
+			goto out;	/* Something got screwed up here */
 
 		switch (sig) {
 		case SIG('R', 'R'):
@@ -307,6 +316,11 @@ parse_rock_ridge_inode_internal(struct i
 repeat:
 	while (rs.len > 2) { /* There may be one byte for padding somewhere */
 		rr = (struct rock_ridge *)rs.chr;
+		/*
+		 * Ignore rock ridge info if rr->len is out of range, but
+		 * don't return -EIO because that would make the file
+		 * invisible.
+		 */
 		if (rr->len < 3)
 			goto out;	/* Something got screwed up here */
 		sig = isonum_721(rs.chr);
@@ -314,8 +328,12 @@ repeat:
 			goto eio;
 		rs.chr += rr->len;
 		rs.len -= rr->len;
+		/*
+		 * As above, just ignore the rock ridge info if rr->len
+		 * is bogus.
+		 */
 		if (rs.len < 0)
-			goto eio;	/* corrupted isofs */
+			goto out;	/* Something got screwed up here */
 
 		switch (sig) {
 #ifndef CONFIG_ZISOFS		/* No flag for SF or ZF */
_

Patches currently in -mm which might be from adam.greenblatt@gmail.com are

isofs-fix-minor-filesystem-corruption-take-3.patch

