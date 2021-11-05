Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56908C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EAAC611EE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhKEUh3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:37:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbhKEUh1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:37:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 225636120D;
        Fri,  5 Nov 2021 20:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144483;
        bh=ZDnk8aUALmlN+b8RX2OiAAKavfx1qgWqQH9RlcuqhZw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ad+hjpy6NBGqaPr7it7DbnokfdqnNPCOrnpXn+Mp44M26BpF6Ut9iZZM0m9MngtJ9
         qWIBBGJelbr9Nh81lZNY4RYPbbdUrei6IgVqMiHP+K5n3c+/aRY2K1ee7BsQRoAenf
         156FPbnN/A+N6bvx7KPBo+5L8yNxvCXYX1LYgv74=
Date:   Fri, 05 Nov 2021 13:34:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bp@suse.de, linux-mm@kvack.org,
        maz@misterjones.org, mm-commits@vger.kernel.org, rabin@rab.in,
        torvalds@linux-foundation.org, weidonghui@allwinnertech.com,
        will@kernel.org
Subject:  [patch 003/262] scripts/decodecode: fix faulting
 instruction no print when opps.file is DOS format
Message-ID: <20211105203442.uBhwndE3D%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
