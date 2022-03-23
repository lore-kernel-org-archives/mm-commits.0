Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28608C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345374AbiCWXHW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345385AbiCWXHV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:07:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C1D90275
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:05:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDB87617E8
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:05:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35626C340E9;
        Wed, 23 Mar 2022 23:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076745;
        bh=x8DTzlZqJ/qnPd9Aa+qhWoS0zfg5ybRrlCUTZMhNqqo=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=LAV6SbYpBFgABEAneOHWe05mh2iC66LEPyN8rA+RPLXXOdVJv6GilyjoK+GDmUC6g
         TEs7Nk2BKjsndITYHab+aYf9HHGRPH+i5ejtr/q7cLDWv/YZdHvFutdvW1ZA+S7l69
         SSnGlBdiHnItHWXsqDmcC4I7bBskBVdjVmhin3Jw=
Date:   Wed, 23 Mar 2022 16:05:44 -0700
To:     christophe.leroy@csgroup.eu, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 09/41] ilog2: force inlining of __ilog2_u32() and __ilog2_u64()
Message-Id: <20220323230545.35626C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: ilog2: force inlining of __ilog2_u32() and __ilog2_u64()

Building a kernel with CONFIG_CC_OPTIMISE_FOR_SIZE leads to __ilog2_u32()
being duplicated 50 times and __ilog2_u64() 3 times in vmlinux on a tiny
powerpc32 config.

__ilog2_u32() being 2 instructions it is not worth being kept out of line,
so force inlining.  Allthough the u64 version is a bit bigger, there is
still a small benefit in keeping it inlined.  On a 64 bits config there's
a real benefit.

With this change the size of vmlinux text is reduced by 1 kbytes, which is
approx 50% more than the size of the removed functions.

Before the patch there is for instance:

	c00d2a94 <__ilog2_u32>:
	c00d2a94:	7c 63 00 34 	cntlzw  r3,r3
	c00d2a98:	20 63 00 1f 	subfic  r3,r3,31
	c00d2a9c:	4e 80 00 20 	blr

	c00d36d8 <__order_base_2>:
	c00d36d8:	28 03 00 01 	cmplwi  r3,1
	c00d36dc:	40 81 00 2c 	ble     c00d3708 <__order_base_2+0x30>
	c00d36e0:	94 21 ff f0 	stwu    r1,-16(r1)
	c00d36e4:	7c 08 02 a6 	mflr    r0
	c00d36e8:	38 63 ff ff 	addi    r3,r3,-1
	c00d36ec:	90 01 00 14 	stw     r0,20(r1)
	c00d36f0:	4b ff f3 a5 	bl      c00d2a94 <__ilog2_u32>
	c00d36f4:	80 01 00 14 	lwz     r0,20(r1)
	c00d36f8:	38 63 00 01 	addi    r3,r3,1
	c00d36fc:	7c 08 03 a6 	mtlr    r0
	c00d3700:	38 21 00 10 	addi    r1,r1,16
	c00d3704:	4e 80 00 20 	blr
	c00d3708:	38 60 00 00 	li      r3,0
	c00d370c:	4e 80 00 20 	blr

With the patch it has become:

	c00d356c <__order_base_2>:
	c00d356c:	28 03 00 01 	cmplwi  r3,1
	c00d3570:	40 81 00 14 	ble     c00d3584 <__order_base_2+0x18>
	c00d3574:	38 63 ff ff 	addi    r3,r3,-1
	c00d3578:	7c 63 00 34 	cntlzw  r3,r3
	c00d357c:	20 63 00 20 	subfic  r3,r3,32
	c00d3580:	4e 80 00 20 	blr
	c00d3584:	38 60 00 00 	li      r3,0
	c00d3588:	4e 80 00 20 	blr

No more need for __order_base_2() to setup a stack frame and
save/restore caller address. And the following 'add 1' is
merged in the subtract.

Another typical use of it:

	c080ff28 <hugepagesz_setup>:
	...
	c080fff8:	7f c3 f3 78 	mr      r3,r30
	c080fffc:	4b 8f 81 f1 	bl      c01081ec <__ilog2_u32>
	c0810000:	38 63 ff f2 	addi    r3,r3,-14
	...

Becomes

	c080ff1c <hugepagesz_setup>:
	...
	c080ffec:	7f c3 00 34 	cntlzw  r3,r30
	c080fff0:	20 63 00 11 	subfic  r3,r3,17
	...

Here no need to move r30 argument to r3 then substract 14 to result.  Just
work on r30 and merge the 'sub 14' with the 'sub from 31'.

Link: https://lkml.kernel.org/r/803a2ac3d923ebcfd0dd40f5886b05cae7bb0aba.1644243860.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/log2.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/log2.h~ilog2-force-inlining-of-__ilog2_u32-and-__ilog2_u64
+++ a/include/linux/log2.h
@@ -18,7 +18,7 @@
  * - the arch is not required to handle n==0 if implementing the fallback
  */
 #ifndef CONFIG_ARCH_HAS_ILOG2_U32
-static inline __attribute__((const))
+static __always_inline __attribute__((const))
 int __ilog2_u32(u32 n)
 {
 	return fls(n) - 1;
@@ -26,7 +26,7 @@ int __ilog2_u32(u32 n)
 #endif
 
 #ifndef CONFIG_ARCH_HAS_ILOG2_U64
-static inline __attribute__((const))
+static __always_inline __attribute__((const))
 int __ilog2_u64(u64 n)
 {
 	return fls64(n) - 1;
_
