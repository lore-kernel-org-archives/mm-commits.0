From: akpm@linux-foundation.org
Subject: + drivers-video-gbefbc-eliminate-memory-leak.patch added to -mm tree
Date: Fri, 24 Sep 2010 15:28:45 -0700
Message-ID: <201009242228.o8OMSj6u029078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758314Ab0IXW33 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Sep 2010 18:29:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, arnaud.patard@rtp-net.org, ralf@linux-mips.org


The patch titled
     drivers/video/gbefb.c: eliminate memory leak
has been added to the -mm tree.  Its filename is
     drivers-video-gbefbc-eliminate-memory-leak.patch

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
Subject: drivers/video/gbefb.c: eliminate memory leak
From: Julia Lawall <julia@diku.dk>


This code is preceded by a call to framebuffer_alloc, which allocates
memory, so this memory should be freed before leaving the function in an
error case.  out_release_framebuffer just frees the frame buffer and
returns.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression x;
expression E;
identifier f1;
iterator I;
@@

x = framebuffer_alloc(...);
<... when != x
     when != true (x == NULL || ...)
     when != if (...) { <+...x...+> }
     when != I (...) { <+...x...+> }
(
 x == NULL
|
 x == E
|
 x->f1
)
...>
* return ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/gbefb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/gbefb.c~drivers-video-gbefbc-eliminate-memory-leak drivers/video/gbefb.c
--- a/drivers/video/gbefb.c~drivers-video-gbefbc-eliminate-memory-leak
+++ a/drivers/video/gbefb.c
@@ -1143,8 +1143,10 @@ static int __devinit gbefb_probe(struct 
 		return -ENOMEM;
 
 #ifndef MODULE
-	if (fb_get_options("gbefb", &options))
-		return -ENODEV;
+	if (fb_get_options("gbefb", &options)) {
+		ret = -ENODEV;
+		goto out_release_framebuffer;
+	}
 	gbefb_setup(options);
 #endif
 
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-char-agp-parisc-agpc-eliminate-memory-leak.patch
fs-btrfs-use-memdup_user.patch
fs-btrfs-use-err_cast.patch
fs-btrfs-inodec-eliminate-memory-leak.patch
arch-x86-kernel-cpu-cpufreq-fix-unsigned-return-type.patch
drivers-i2c-busses-i2c-pasemic-fix-unsigned-return-type.patch
drivers-video-matrox-matroxfb_mavenc-fix-unsigned-return-type.patch
drivers-video-gbefbc-eliminate-memory-leak.patch

