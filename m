From: akpm@linux-foundation.org
Subject: + lib-consistency-of-compress-formats-for-kernel-image.patch
 added to -mm tree
Date: Tue, 04 Nov 2014 13:59:55 -0800
Message-ID: <54594c5b.wsnJKuFF9xJ9Fs71%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaKDV7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 16:59:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matia.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/decompress.c: consistency of compress formats for kernel image
has been added to the -mm tree.  Its filename is
     lib-consistency-of-compress-formats-for-kernel-image.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-consistency-of-compress-formats-for-kernel-image.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/lib-consistency-of-compress-formats-for-kernel-image.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Haesung Kim <matia.kim@lge.com>
Subject: lib/decompress.c: consistency of compress formats for kernel image

Magic number of compress formats for kernel image is defined by two bytes.
 These numbers are written in hexadecimal number, nevertheless magic
number for only gunzip is written in octal number.  The formats should be
consistent for readability.  Therefore, magic numbers for gunzip are also
defined by hexadecimal number.

Signed-off-by: Haesung Kim <matia.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/decompress.c~lib-consistency-of-compress-formats-for-kernel-image lib/decompress.c
--- a/lib/decompress.c~lib-consistency-of-compress-formats-for-kernel-image
+++ a/lib/decompress.c
@@ -44,8 +44,8 @@ struct compress_format {
 };
 
 static const struct compress_format compressed_formats[] __initconst = {
-	{ {037, 0213}, "gzip", gunzip },
-	{ {037, 0236}, "gzip", gunzip },
+       { {0x1f, 0x8b}, "gzip", gunzip },
+       { {0x1f, 0x9e}, "gzip", gunzip },
 	{ {0x42, 0x5a}, "bzip2", bunzip2 },
 	{ {0x5d, 0x00}, "lzma", unlzma },
 	{ {0xfd, 0x37}, "xz", unxz },
_

Patches currently in -mm which might be from matia.kim@lge.com are

lib-consistency-of-compress-formats-for-kernel-image.patch

