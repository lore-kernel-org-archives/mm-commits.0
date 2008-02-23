From: akpm@linux-foundation.org
Subject: + hfsplus-handle-match_strdup-failure.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:33:33 -0800
Message-ID: <200802230734.m1N7YMBP018283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756544AbYBWHyx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jim@meyering.net, meyering@redhat.com, zippel@linux-m68k.org


The patch titled
     hfsplus: handle match_strdup failure
has been added to the -mm tree.  Its filename is
     hfsplus-handle-match_strdup-failure.patch

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

usbaudio-handle-kcalloc-failure.patch
9p-handle-kstrdup-and-match_strdup-failure.patch
alpha-handle-kcalloc-failure.patch
affs-handle-match_strdup-failure.patch
hfs-handle-match_strdup-failure.patch
hfsplus-handle-match_strdup-failure.patch
lib-inflatec-handle-failed-malloc.patch
