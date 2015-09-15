From: akpm@linux-foundation.org
Subject: + zlib-fix-usage-example-of-zlib_adler32.patch added to -mm tree
Date: Tue, 15 Sep 2015 16:00:00 -0700
Message-ID: <55f8a2f0.cq8wouzu7Anpfnxh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbIOXAA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 19:00:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anish@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/zutil.h: fix usage example of zlib_adler32()
has been added to the -mm tree.  Its filename is
     zlib-fix-usage-example-of-zlib_adler32.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zlib-fix-usage-example-of-zlib_adler32.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zlib-fix-usage-example-of-zlib_adler32.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

zlib-fix-usage-example-of-zlib_adler32.patch

