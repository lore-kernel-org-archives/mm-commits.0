From: akpm@linux-foundation.org
Subject: - uclinux-fix-gzip-header-parsing-in-binfmt_flatc.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:10:32 -0700
Message-ID: <200810182310.m9INAWEq027551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257AbYJRXMO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:12:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: volodymyrgl@gmail.com, dhowells@redhat.com, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     uclinux: fix gzip header parsing in binfmt_flat.c
has been removed from the -mm tree.  Its filename was
     uclinux-fix-gzip-header-parsing-in-binfmt_flatc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uclinux: fix gzip header parsing in binfmt_flat.c
From: "Volodymyr G. Lukiianyk" <volodymyrgl@gmail.com>

There are off-by-one errors in decompress_exec() when calculating the length of
optional "original file name" and "comment" fields: the "ret" index is not
incremented when terminating '\0' character is reached. The check of the buffer
overflow (after an "extra-field" length was taken into account) is also fixed.

I've encountered this off-by-one error when tried to reuse
gzip-header-parsing part of the decompress_exec() function.  There was an
"original file name" field in the payload (with miscalculated length) and
zlib_inflate() returned Z_DATA_ERROR.  But after the fix similar to this
one all worked fine.

Signed-off-by: Volodymyr G Lukiianyk <volodymyrgl@gmail.com>
Acked-by: Greg Ungerer <gerg@snapgear.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_flat.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/binfmt_flat.c~uclinux-fix-gzip-header-parsing-in-binfmt_flatc fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~uclinux-fix-gzip-header-parsing-in-binfmt_flatc
+++ a/fs/binfmt_flat.c
@@ -229,13 +229,13 @@ static int decompress_exec(
 	ret = 10;
 	if (buf[3] & EXTRA_FIELD) {
 		ret += 2 + buf[10] + (buf[11] << 8);
-		if (unlikely(LBUFSIZE == ret)) {
+		if (unlikely(LBUFSIZE <= ret)) {
 			DBG_FLT("binfmt_flat: buffer overflow (EXTRA)?\n");
 			goto out_free_buf;
 		}
 	}
 	if (buf[3] & ORIG_NAME) {
-		for (; ret < LBUFSIZE && (buf[ret] != 0); ret++)
+		while (ret < LBUFSIZE && buf[ret++] != 0)
 			;
 		if (unlikely(LBUFSIZE == ret)) {
 			DBG_FLT("binfmt_flat: buffer overflow (ORIG_NAME)?\n");
@@ -243,7 +243,7 @@ static int decompress_exec(
 		}
 	}
 	if (buf[3] & COMMENT) {
-		for (;  ret < LBUFSIZE && (buf[ret] != 0); ret++)
+		while (ret < LBUFSIZE && buf[ret++] != 0)
 			;
 		if (unlikely(LBUFSIZE == ret)) {
 			DBG_FLT("binfmt_flat: buffer overflow (COMMENT)?\n");
_

Patches currently in -mm which might be from volodymyrgl@gmail.com are

origin.patch

