From: akpm@linux-foundation.org
Subject: + fs-romfs-correct-error-handling-code.patch added to -mm tree
Date: Mon, 03 Aug 2009 13:04:11 -0700
Message-ID: <200908032004.n73K4DOL010242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752152AbZHCUET (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2009 16:04:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk


The patch titled
     fs/romfs: correct error-handling code
has been added to the -mm tree.  Its filename is
     fs-romfs-correct-error-handling-code.patch

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
Subject: fs/romfs: correct error-handling code
From: Julia Lawall <julia@diku.dk>

romfs_iget returns an ERR_PTR value in an error case instead of NULL.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@match exists@
expression x, E;
statement S1, S2;
@@

x = romfs_iget(...)
... when != x = E
(
*  if (x == NULL || ...) S1 else S2
|
*  if (x == NULL && ...) S1 else S2
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/romfs/super.c~fs-romfs-correct-error-handling-code fs/romfs/super.c
--- a/fs/romfs/super.c~fs-romfs-correct-error-handling-code
+++ a/fs/romfs/super.c
@@ -528,7 +528,7 @@ static int romfs_fill_super(struct super
 	pos = (ROMFH_SIZE + len + 1 + ROMFH_PAD) & ROMFH_MASK;
 
 	root = romfs_iget(sb, pos);
-	if (!root)
+	if (IS_ERR(root))
 		goto error;
 
 	sb->s_root = d_alloc_root(root);
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-media-dvb-use-dst_type-field-instead-of-type_flags.patch
drivers-ata-use-resource_size.patch
drivers-video-imxfbc-fix-resource-size-off-by-1-error.patch
edac-fix-resource-size-calculation.patch
fs-romfs-correct-error-handling-code.patch
drivers-vlynq-vlynqc-fix-resource-size-off-by-1-error.patch

