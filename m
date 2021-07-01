Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C40FC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC41B6147D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238563AbhGAB6u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:58:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238467AbhGAB6r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:58:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9127F61468;
        Thu,  1 Jul 2021 01:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104577;
        bh=9MBrLmQ5O2ytNTSuFSNr1kI2RbdC7XVerY793xPqLYY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hPc6QzyO2kJp8njE6kfHHvi8yWfyx5vD1LwLhkgh+zXUn9IL5IHQ3NpW7WCqmA6Mz
         uFDjI3Uh9cH+wvUof4Zv5SUKYd1UgVV9RpShnDZkZ7bZwNGVcQVM8oEqpSWD/ytBA6
         IAm4Yl/m4pb14oIov7auQgagbVixkjHO8QFFF1NM=
Date:   Wed, 30 Jun 2021 18:56:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     4sschmid@informatik.uni-hamburg.de, akpm@linux-foundation.org,
        bongkyu.kim@lge.com, dimitri.ledkov@canonical.com,
        hsiangkao@redhat.com, keescook@chromium.org, kyungsik.lee@lge.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, terrelln@fb.com,
        thisisrast7@gmail.com, torvalds@linux-foundation.org,
        yinghai@kernel.org
Subject:  [patch 172/192] lib/decompress_unlz4.c: correctly handle
 zero-padding around initrds.
Message-ID: <20210701015616.3oaIBGjeo%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Subject: lib/decompress_unlz4.c: correctly handle zero-padding around initrds.

lz4 compatible decompressor is simple.  The format is underspecified and
relies on EOF notification to determine when to stop.  Initramfs buffer
format[1] explicitly states that it can have arbitrary number of zero
padding.  Thus when operating without a fill function, be extra careful to
ensure that sizes less than 4, or apperantly empty chunksizes are treated
as EOF.

To test this I have created two cpio initrds, first a normal one,
main.cpio.  And second one with just a single /test-file with content
"second" second.cpio.  Then i compressed both of them with gzip, and with
lz4 -l.  Then I created a padding of 4 bytes (dd if=/dev/zero of=pad4 bs=1
count=4).  To create four testcase initrds:

 1) main.cpio.gzip + extra.cpio.gzip = pad0.gzip
 2) main.cpio.lz4  + extra.cpio.lz4 = pad0.lz4
 3) main.cpio.gzip + pad4 + extra.cpio.gzip = pad4.gzip
 4) main.cpio.lz4  + pad4 + extra.cpio.lz4 = pad4.lz4

The pad4 test-cases replicate the initrd load by grub, as it pads and
aligns every initrd it loads.

All of the above boot, however /test-file was not accessible in the initrd
for the testcase #4, as decoding in lz4 decompressor failed.  Also an
error message printed which usually is harmless.

Whith a patched kernel, all of the above testcases now pass, and
/test-file is accessible.

This fixes lz4 initrd decompress warning on every boot with grub.  And
more importantly this fixes inability to load multiple lz4 compressed
initrds with grub.  This patch has been shipping in Ubuntu kernels since
January 2021.

[1] ./Documentation/driver-api/early-userspace/buffer-format.rst

BugLink: https://bugs.launchpad.net/bugs/1835660
Link: https://lore.kernel.org/lkml/20210114200256.196589-1-xnox@ubuntu.com/ # v0
Link: https://lkml.kernel.org/r/20210513104831.432975-1-dimitri.ledkov@canonical.com
Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Bongkyu Kim <bongkyu.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Cc: Rajat Asthana <thisisrast7@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlz4.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/lib/decompress_unlz4.c~lib-decompress_unlz4c-correctly-handle-zero-padding-around-initrds
+++ a/lib/decompress_unlz4.c
@@ -112,6 +112,9 @@ STATIC inline int INIT unlz4(u8 *input,
 				error("data corrupted");
 				goto exit_2;
 			}
+		} else if (size < 4) {
+			/* empty or end-of-file */
+			goto exit_3;
 		}
 
 		chunksize = get_unaligned_le32(inp);
@@ -125,6 +128,10 @@ STATIC inline int INIT unlz4(u8 *input,
 			continue;
 		}
 
+		if (!fill && chunksize == 0) {
+			/* empty or end-of-file */
+			goto exit_3;
+		}
 
 		if (posp)
 			*posp += 4;
@@ -184,6 +191,7 @@ STATIC inline int INIT unlz4(u8 *input,
 		}
 	}
 
+exit_3:
 	ret = 0;
 exit_2:
 	if (!input)
_
