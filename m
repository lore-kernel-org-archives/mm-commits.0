From: akpm@linux-foundation.org
Subject: [merged] zlib-fix-usage-example-of-zlib_adler32.patch removed
 from -mm tree
Date: Mon, 09 Nov 2015 12:13:55 -0800
Message-ID: <5640fe83.KP7u7Xk7w4nLgTYJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbbKIUNz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anish@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/zutil.h: fix usage example of zlib_adler32()
has been removed from the -mm tree.  Its filename was
     zlib-fix-usage-example-of-zlib_adler32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anish Bhatt <anish@chelsio.com>
Subject: include/linux/zutil.h: fix usage example of zlib_adler32()

alder32 was renamed to zlib_adler32 since before 2.6.11.

Signed-off-by: Anish Bhatt <anish@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zutil.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/zutil.h~zlib-fix-usage-example-of-zlib_adler32 include/linux/zutil.h
--- a/include/linux/zutil.h~zlib-fix-usage-example-of-zlib_adler32
+++ a/include/linux/zutil.h
@@ -68,10 +68,10 @@ typedef uLong (*check_func) (uLong check
    An Adler-32 checksum is almost as reliable as a CRC32 but can be computed
    much faster. Usage example:
 
-     uLong adler = adler32(0L, NULL, 0);
+     uLong adler = zlib_adler32(0L, NULL, 0);
 
      while (read_buffer(buffer, length) != EOF) {
-       adler = adler32(adler, buffer, length);
+       adler = zlib_adler32(adler, buffer, length);
      }
      if (adler != original_adler) error();
 */
_

Patches currently in -mm which might be from anish@chelsio.com are


