Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE91C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 14 Feb 2022 22:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbiBNWy6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Feb 2022 17:54:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiBNWy5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Feb 2022 17:54:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A3C177E75
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 14:54:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 292B96151D
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 22:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69165C340E9;
        Mon, 14 Feb 2022 22:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644879288;
        bh=z3y+DP7eIPRKCBmRWdjAhn50hvfiKP6pgOqjBFAo7MU=;
        h=Date:To:From:Subject:From;
        b=xwRdVL9VUxcHVlf2eAX2SYlo/07eZ8nuDtG59q6pTEr4YEhHDT0uv676K9e0IDsLo
         PUtTysJZJ60MRmhcSLVRoNHMDInNTBXNDt1XrZu1MNHh1VXSMztcjQX3tLlFI95EaS
         EZR+hH1vxsUUb6kSt2Dde3Fr4P6GBHoIIVPCkZzc=
Date:   Mon, 14 Feb 2022 14:54:47 -0800
To:     mm-commits@vger.kernel.org, christophe.leroy@csgroup.eu,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-outline-copy_overflow.patch removed from -mm tree
Message-Id: <20220214225448.69165C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: uninline copy_overflow()
has been removed from the -mm tree.  Its filename was
     mm-outline-copy_overflow.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm: uninline copy_overflow()

While building a small config with CONFIG_CC_OPTIMISE_FOR_SIZE, I ended up
with more than 50 times the following function in vmlinux:

	c00243bc <copy_overflow>:
	c00243bc:	94 21 ff f0 	stwu    r1,-16(r1)
	c00243c0:	7c 85 23 78 	mr      r5,r4
	c00243c4:	7c 64 1b 78 	mr      r4,r3
	c00243c8:	3c 60 c0 62 	lis     r3,-16286
	c00243cc:	7c 08 02 a6 	mflr    r0
	c00243d0:	38 63 5e e5 	addi    r3,r3,24293
	c00243d4:	90 01 00 14 	stw     r0,20(r1)
	c00243d8:	4b ff 82 45 	bl      c001c61c <__warn_printk>
	c00243dc:	0f e0 00 00 	twui    r0,0
	c00243e0:	80 01 00 14 	lwz     r0,20(r1)
	c00243e4:	38 21 00 10 	addi    r1,r1,16
	c00243e8:	7c 08 03 a6 	mtlr    r0
	c00243ec:	4e 80 00 20 	blr

That function being a non conditional warning on an error path,
it is not worth inlining.

Outline it.

This reduces the size of vmlinux by almost 4kbytes.

Link: https://lkml.kernel.org/r/ece7b29b480e8dca06544687d186a56ec67b72a7.1644575495.git.christophe.leroy@csgroup.eu
Link: https://lkml.kernel.org/r/b9a31b025e729394e7081257870f0a0e73355a04.1644229010.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/thread_info.h |    5 +----
 mm/maccess.c                |    5 +++++
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/include/linux/thread_info.h~mm-outline-copy_overflow
+++ a/include/linux/thread_info.h
@@ -209,10 +209,7 @@ __bad_copy_from(void);
 extern void __compiletime_error("copy destination size is too small")
 __bad_copy_to(void);
 
-static inline void copy_overflow(int size, unsigned long count)
-{
-	WARN(1, "Buffer overflow detected (%d < %lu)!\n", size, count);
-}
+void copy_overflow(int size, unsigned long count);
 
 static __always_inline __must_check bool
 check_copy_size(const void *addr, size_t bytes, bool is_source)
--- a/mm/maccess.c~mm-outline-copy_overflow
+++ a/mm/maccess.c
@@ -335,3 +335,8 @@ long strnlen_user_nofault(const void __u
 
 	return ret;
 }
+
+void copy_overflow(int size, unsigned long count)
+{
+	WARN(1, "Buffer overflow detected (%d < %lu)!\n", size, count);
+}
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-remove-usercopy_warn.patch
ilog2-force-inlining-of-__ilog2_u32-and-__ilog2_u64.patch

