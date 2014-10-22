From: akpm@linux-foundation.org
Subject: + decompress_bunzip2-off-by-one-in-get_next_block.patch added to
 -mm tree
Date: Wed, 22 Oct 2014 12:16:41 -0700
Message-ID: <54480299.eNu4TSJ2ID60atFh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56711 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242AbaJVTQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Oct 2014 15:16:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, alain@knaff.lu, hpa@zytor.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: decompress_bunzip2: off by one in get_next_block()
has been added to the -mm tree.  Its filename is
     decompress_bunzip2-off-by-one-in-get_next_block.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/decompress_bunzip2-off-by-one-in-get_next_block.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/decompress_bunzip2-off-by-one-in-get_next_block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rtc-pm8xxx-rework-to-support-pm8941-rtc-fix.patch
ocfs2-fix-an-off-by-one-bug_on-statement.patch
decompress_bunzip2-off-by-one-in-get_next_block.patch
linux-next.patch

