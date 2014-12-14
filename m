From: akpm@linux-foundation.org
Subject: [merged] decompress_bunzip2-off-by-one-in-get_next_block.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:09:59 -0800
Message-ID: <548d0d97.tFc+Qj8VYjHZeNkv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbaLNEJw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:09:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, alain@knaff.lu, hpa@zytor.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: decompress_bunzip2: off by one in get_next_block()
has been removed from the -mm tree.  Its filename was
     decompress_bunzip2-off-by-one-in-get_next_block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: decompress_bunzip2: off by one in get_next_block()

"origPtr" is used as an offset into the bd->dbuf[] array.  That array is
allocated in start_bunzip() and has "bd->dbufSize" number of elements so
the test here should be >= instead of >.

Later we check "origPtr" again before using it as an offset so I don't
know if this bug can be triggered in real life.

Fixes: bc22c17e12c1 ('bzip2/lzma: library support for gzip, bzip2 and lzma decompression')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_bunzip2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/decompress_bunzip2.c~decompress_bunzip2-off-by-one-in-get_next_block lib/decompress_bunzip2.c
--- a/lib/decompress_bunzip2.c~decompress_bunzip2-off-by-one-in-get_next_block
+++ a/lib/decompress_bunzip2.c
@@ -184,7 +184,7 @@ static int INIT get_next_block(struct bu
 	if (get_bits(bd, 1))
 		return RETVAL_OBSOLETE_INPUT;
 	origPtr = get_bits(bd, 24);
-	if (origPtr > dbufSize)
+	if (origPtr >= dbufSize)
 		return RETVAL_DATA_ERROR;
 	/* mapping table: if some byte values are never used (encoding things
 	   like ascii text), the compression code removes the gaps to have fewer
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch

