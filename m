From: akpm@linux-foundation.org
Subject: + udf-fix-function-name-from-udf_crc16-to-udf_crc.patch added to -mm tree
Date: Tue, 03 Jul 2007 11:24:37 -0700
Message-ID: <200707031824.l63IOgWM007684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52572 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755093AbXGCSZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 14:25:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, jack@ucw.cz


The patch titled
     UDF: fix function name from udf_crc16 to udf_crc
has been added to the -mm tree.  Its filename is
     udf-fix-function-name-from-udf_crc16-to-udf_crc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: UDF: fix function name from udf_crc16 to udf_crc
From: Cyrill Gorcunov <gorcunov@gmail.com>

We have to change udf_crc16() name to udf_crc() to be able to play with CRC
test.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/crc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/udf/crc.c~udf-fix-function-name-from-udf_crc16-to-udf_crc fs/udf/crc.c
--- a/fs/udf/crc.c~udf-fix-function-name-from-udf_crc16-to-udf_crc
+++ a/fs/udf/crc.c
@@ -106,8 +106,8 @@ int main(void)
 {
 	unsigned short x;
 
-	x = udf_crc16(bytes, sizeof bytes);
-	printf("udf_crc16: calculated = %4.4x, correct = %4.4x\n", x, 0x3299U);
+	x = udf_crc(bytes, sizeof bytes);
+	printf("udf_crc: calculated = %4.4x, correct = %4.4x\n", x, 0x3299U);
 
 	return 0;
 }
_

Patches currently in -mm which might be from gorcunov@gmail.com are

udf-check-for-allocated-memory-for-data-of-new-inodes.patch
udf-check-for-allocated-memory-for-data-of-new-inodes-fix.patch
udf-check-for-allocated-memory-for-inode-data-v2.patch
udf-coding-style-conversion-lindent.patch
udf-coding-style-conversion-lindent-fixups.patch
udf-coding-style-conversion-lindent-fixups-2.patch
udf-fix-function-name-from-udf_crc16-to-udf_crc.patch
