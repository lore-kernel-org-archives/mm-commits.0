Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4A9C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiCVVtt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236671AbiCVVtU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:49:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76A65FF35
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:47:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FC56B81DAF
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9DCC340EC;
        Tue, 22 Mar 2022 21:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985670;
        bh=CBQauugBlttK82R1G0LQ5qfgK60FXc1ArnvAVJh/Nlo=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=wUnE7ZW4psb92RHZU7k9l7oXy0IGNqBDq3gX+PX37JhWmKqnrE6//obsRVWr6FMwf
         Rz2c4JWgewz86wC1cBaWxxlS9gXRUW64s1np/c1d22ooG3DLZNEC91JSu6oJKo9Pzn
         M8wwQDKyIOB+1ob/xiiAgA8HozEAWGslPYBPrG40=
Date:   Tue, 22 Mar 2022 14:47:49 -0700
To:     David.Laight@ACULAB.COM, anshuman.khandual@arm.com,
        christophe.leroy@csgroup.eu, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 183/227] mm: uninline copy_overflow()
Message-Id: <20220322214750.0C9DCC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm: uninline copy_overflow()

While building a small config with CONFIG_CC_OPTIMISE_FOR_SIZE, I ended up
with more than 50 times the following function in vmlinux because GCC
doesn't honor the 'inline' keyword:

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

With -Winline, GCC tells:

	/include/linux/thread_info.h:212:20: warning: inlining failed in call to 'copy_overflow': call is unlikely and code size would grow [-Winline]

copy_overflow() is a non conditional warning called by
check_copy_size() on an error path.

check_copy_size() have to remain inlined in order to benefit
from constant folding, but copy_overflow() is not worth inlining.

Uninline the warning when CONFIG_BUG is selected.

When CONFIG_BUG is not selected, WARN() does nothing so skip it.

This reduces the size of vmlinux by almost 4kbytes.

Link: https://lkml.kernel.org/r/e1723b9cfa924bcefcd41f69d0025b38e4c9364e.1644819985.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/thread_info.h |    5 ++++-
 mm/maccess.c                |    6 ++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/include/linux/thread_info.h~mm-uninline-copy_overflow
+++ a/include/linux/thread_info.h
@@ -209,9 +209,12 @@ __bad_copy_from(void);
 extern void __compiletime_error("copy destination size is too small")
 __bad_copy_to(void);
 
+void __copy_overflow(int size, unsigned long count);
+
 static inline void copy_overflow(int size, unsigned long count)
 {
-	WARN(1, "Buffer overflow detected (%d < %lu)!\n", size, count);
+	if (IS_ENABLED(CONFIG_BUG))
+		__copy_overflow(size, count);
 }
 
 static __always_inline __must_check bool
--- a/mm/maccess.c~mm-uninline-copy_overflow
+++ a/mm/maccess.c
@@ -335,3 +335,9 @@ long strnlen_user_nofault(const void __u
 
 	return ret;
 }
+
+void __copy_overflow(int size, unsigned long count)
+{
+	WARN(1, "Buffer overflow detected (%d < %lu)!\n", size, count);
+}
+EXPORT_SYMBOL(__copy_overflow);
_
