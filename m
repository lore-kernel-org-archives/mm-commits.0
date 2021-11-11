Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56FECC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3973E61872
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbhKKCmL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:42:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233120AbhKKCmJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:42:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8EC761354;
        Thu, 11 Nov 2021 02:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598360;
        bh=2pCIONfXm0bS/zrS6OJ+tPto5zE+LQR1LqVX19wpRtk=;
        h=Date:From:To:Subject:From;
        b=w96dYqdVR55c+tDzEFt+7GXooZ1aiFSHQmhw5iK37rKHvzJIUmz6mEtiUTLOeKj2R
         D9AUEsj1qpnrbkrKNqxJgNCM6BkcQcdrpvuWWMD6Inlvn0ex1PDUW11eqyBiTKQj8q
         yl5WuNEKONDFbodfIV2GKaBkgVDN0mGBhf4vEsrk=
Date:   Wed, 10 Nov 2021 18:39:20 -0800
From:   akpm@linux-foundation.org
To:     bp@suse.de, maz@misterjones.org, mm-commits@vger.kernel.org,
        rabin@rab.in, weidonghui@allwinnertech.com, will@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?scripts-decodecode-fix-faulting-instruction-no-print-when-?=
 =?US-ASCII?Q?oppsfile-is-dos-format.patch?= removed from -mm tree
Message-ID: <20211111023920.rlyy72j4-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/decodecode: fix faulting instruction no print when opps.file is DOS format
has been removed from the -mm tree.  Its filename was
     scripts-decodecode-fix-faulting-instruction-no-print-when-oppsfile-is-dos-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: weidonghui <weidonghui@allwinnertech.com>
Subject: scripts/decodecode: fix faulting instruction no print when opps.file is DOS format

If opps.file is in DOS format, faulting instruction cannot be printed:
/ # ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
/ # ./scripts/decodecode < oops.file
[ 0.734345] Code: d0002881 912f9c21 94067e68 d2800001 (b900003f)
aarch64-linux-gnu-strip: '/tmp/tmp.5Y9eybnnSi.o': No such file
aarch64-linux-gnu-objdump: '/tmp/tmp.5Y9eybnnSi.o': No such file
All code
========
   0:   d0002881        adrp    x1, 0x512000
   4:   912f9c21        add     x1, x1, #0xbe7
   8:   94067e68        bl      0x19f9a8
   c:   d2800001        mov     x1, #0x0                        // #0
  10:   b900003f        str     wzr, [x1]

Code starting with the faulting instruction
===========================================

Background: The compilation environment is Ubuntu, and the test
environment is Windows.  Most logs are generated in the Windows
environment.  In this way, CR (carriage return) will inevitably appear,
which will affect the use of decodecode in the Ubuntu environment.

The repaired effect is as follows:

/ # ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
/ # ./scripts/decodecode < oops.file
[ 0.734345] Code: d0002881 912f9c21 94067e68 d2800001 (b900003f)
All code
========
   0:   d0002881        adrp    x1, 0x512000
   4:   912f9c21        add     x1, x1, #0xbe7
   8:   94067e68        bl      0x19f9a8
   c:   d2800001        mov     x1, #0x0                        // #0
  10:*  b900003f        str     wzr, [x1]               <-- trapping instruction

Code starting with the faulting instruction
===========================================
   0:   b900003f        str     wzr, [x1]

Link: https://lkml.kernel.org/r/20211008064712.926-1-weidonghui@allwinnertech.com
Signed-off-by: weidonghui <weidonghui@allwinnertech.com>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Marc Zyngier <maz@misterjones.org>
Cc: Will Deacon <will@kernel.org>
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decodecode |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/decodecode~scripts-decodecode-fix-faulting-instruction-no-print-when-oppsfile-is-dos-format
+++ a/scripts/decodecode
@@ -126,7 +126,7 @@ if [ $marker -ne 0 ]; then
 fi
 echo Code starting with the faulting instruction  > $T.aa
 echo =========================================== >> $T.aa
-code=`echo $code | sed -e 's/ [<(]/ /;s/[>)] / /;s/ /,0x/g; s/[>)]$//'`
+code=`echo $code | sed -e 's/\r//;s/ [<(]/ /;s/[>)] / /;s/ /,0x/g; s/[>)]$//'`
 echo -n "	.$type 0x" > $T.s
 echo $code >> $T.s
 disas $T 0
_

Patches currently in -mm which might be from weidonghui@allwinnertech.com are


