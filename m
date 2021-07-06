Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518D2C07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FD8061CA9
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhGFTZf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229925AbhGFTZe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:25:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADC5E61C9D;
        Tue,  6 Jul 2021 19:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599374;
        bh=pgcABjuflopvkRqyFTCBqYmgUzyMGGHKPZDUn7etDi4=;
        h=Date:From:To:Subject:From;
        b=XGA+RYV5Im3VCOb/k5+5TH1U4NevOhyNVelqVz1WZUAscOgue+tNqJhP23l47GTOF
         37rPl90Sm9XeSB8zy44zgzR9I+7dMYcTzdGop30kWJy3M9HAOYxZrfKS5sGvOyLrvX
         42tvHQ/DYsXRWlS0daOwzL8daLQQ1pbAWirX8GnU=
Date:   Tue, 06 Jul 2021 12:22:53 -0700
From:   akpm@linux-foundation.org
To:     4sschmid@informatik.uni-hamburg.de, bongkyu.kim@lge.com,
        dimitri.ledkov@canonical.com, hsiangkao@redhat.com,
        keescook@chromium.org, kyungsik.lee@lge.com,
        mm-commits@vger.kernel.org, terrelln@fb.com, thisisrast7@gmail.com,
        yinghai@kernel.org
Subject:  [merged]
 lib-decompress_unlz4c-correctly-handle-zero-padding-around-initrds.patch
 removed from -mm tree
Message-ID: <20210706192253.W-zacjLat%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/decompress_unlz4.c: correctly handle zero-padding around initrds.
has been removed from the -mm tree.  Its filename was
     lib-decompress_unlz4c-correctly-handle-zero-padding-around-initrds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from dimitri.ledkov@canonical.com are


