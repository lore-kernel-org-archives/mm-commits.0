From: akpm@linux-foundation.org
Subject: + decompressors-fix-no-limit-output-buffer-length.patch added to
 -mm tree
Date: Wed, 24 Jul 2013 13:47:27 -0700
Message-ID: <51f03d5f.Jmsl/n3WCS5SoyJ/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3GXUr2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 16:47:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tixy@linaro.org, swarren@wwwdotorg.org, acourbot@nvidia.com

Subject: + decompressors-fix-no-limit-output-buffer-length.patch added to -mm tree
To: acourbot@nvidia.com,swarren@wwwdotorg.org,tixy@linaro.org
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 13:47:27 -0700


The patch titled
     Subject: lib/decompressors: fix "no limit" output buffer length
has been added to the -mm tree.  Its filename is
     decompressors-fix-no-limit-output-buffer-length.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/decompressors-fix-no-limit-output-buffer-length.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/decompressors-fix-no-limit-output-buffer-length.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Courbot <acourbot@nvidia.com>
Subject: lib/decompressors: fix "no limit" output buffer length

When decompressing into memory, the output buffer length is set to some
arbitrarily high value (0x7fffffff) to indicate the output is, virtually,
unlimited in size.

The problem with this is that some platforms have their physical memory at
high physical addresses (0x80000000 or more), and that the output buffer
address and its "unlimited" length cannot be added without overflowing. 
An example of this can be found in inflate_fast():

/* next_out is the output buffer address */
out = strm->next_out - OFF;
/* avail_out is the output buffer size. end will overflow if the output
 * address is >= 0x80000104 */
end = out + (strm->avail_out - 257);

This has huge consequences on the performance of kernel decompression,
since the following exit condition of inflate_fast() will be always true:

} while (in < last && out < end);

Indeed, "end" has overflowed and is now always lower than "out".  As a
result, inflate_fast() will return after processing one single byte of
input data, and will thus need to be called an unreasonably high number of
times.  This probably went unnoticed because kernel decompression is fast
enough even with this issue.

Nonetheless, adjusting the output buffer length in such a way that the
above pointer arithmetic never overflows results in a kernel decompression
that is about 3 times faster on affected machines.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Tested-by: Jon Medhurst <tixy@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_inflate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/decompress_inflate.c~decompressors-fix-no-limit-output-buffer-length lib/decompress_inflate.c
--- a/lib/decompress_inflate.c~decompressors-fix-no-limit-output-buffer-length
+++ a/lib/decompress_inflate.c
@@ -48,7 +48,7 @@ STATIC int INIT gunzip(unsigned char *bu
 		out_len = 0x8000; /* 32 K */
 		out_buf = malloc(out_len);
 	} else {
-		out_len = 0x7fffffff; /* no limit */
+		out_len = ((size_t)~0) - (size_t)out_buf; /* no limit */
 	}
 	if (!out_buf) {
 		error("Out of memory while allocating output buffer");
_

Patches currently in -mm which might be from acourbot@nvidia.com are

decompressors-fix-no-limit-output-buffer-length.patch

