From: akpm@linux-foundation.org
Subject: + hfs-handle-match_strdup-failure.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:33:31 -0800
Message-ID: <200802230734.m1N7YKXp018280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755091AbYBWHyx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jim@meyering.net, meyering@redhat.com, zippel@linux-m68k.org


The patch titled
     hfs: handle match_strdup failure
has been added to the -mm tree.  Its filename is
     hfs-handle-match_strdup-failure.patch

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

usbaudio-handle-kcalloc-failure.patch
9p-handle-kstrdup-and-match_strdup-failure.patch
alpha-handle-kcalloc-failure.patch
affs-handle-match_strdup-failure.patch
hfs-handle-match_strdup-failure.patch
hfsplus-handle-match_strdup-failure.patch
lib-inflatec-handle-failed-malloc.patch
