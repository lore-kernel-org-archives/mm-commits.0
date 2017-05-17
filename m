From: akpm@linux-foundation.org
Subject: + powerpc-sequoia-fix-nand-partitions-not-to-overlap.patch added
 to -mm tree
Date: Wed, 17 May 2017 14:37:52 -0700
Message-ID: <591cc2b0.cvRhd23+SwEcqIXj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49884 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753810AbdEQViV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2017 17:38:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@denx.de, benh@kernel.crashing.org, jwboyer@linux.vnet.ibm.com, mark.rutland@arm.com, mpe@ellerman.id.au, paulus@samba.org, pavel@ucw.cz, robh+dt@kernel.org, sr@denx.de, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/sequoia: fix NAND partitions not to overlap
has been added to the -mm tree.  Its filename is
     powerpc-sequoia-fix-nand-partitions-not-to-overlap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-sequoia-fix-nand-partitions-not-to-overlap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-sequoia-fix-nand-partitions-not-to-overlap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Machek <pavel@denx.de>
Subject: powerpc/sequoia: fix NAND partitions not to overlap

Fix overlapping NAND partitions.  Two partitions at same place are bad
news...

Link: http://lkml.kernel.org/r/20170402100535.GA18340@amd
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Cc: Stefan Roese <sr@denx.de>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/boot/dts/sequoia.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/boot/dts/sequoia.dts~powerpc-sequoia-fix-nand-partitions-not-to-overlap arch/powerpc/boot/dts/sequoia.dts
--- a/arch/powerpc/boot/dts/sequoia.dts~powerpc-sequoia-fix-nand-partitions-not-to-overlap
+++ a/arch/powerpc/boot/dts/sequoia.dts
@@ -229,7 +229,7 @@
 						};
 						partition@84000 {
 							label = "user";
-							reg = <0x00000000 0x01f7c000>;
+							reg = <0x00084000 0x01f7c000>;
 						};
 					};
 				};
_

Patches currently in -mm which might be from pavel@denx.de are

powerpc-sequoia-fix-nand-partitions-not-to-overlap.patch

