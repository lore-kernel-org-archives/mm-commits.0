Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 868CBC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355071AbiCYBgn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357392AbiCYBfP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F35BC12F4
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C864160A75
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E65C340EC;
        Fri, 25 Mar 2022 01:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171974;
        bh=007/FO7Mhn4jrriWKIGrBU9nf13KMMlj+AyAubajQ9U=;
        h=Date:To:From:Subject:From;
        b=z9bO00A3gA7BhYHxZ5jMqa9Ub9DsHcB/U1ZD1NKzMVgTitjW9Xye+qhxF1ZK3xwUp
         DXgWlUMSYQGH36OjiUmexrNb7zLoAXjI9ieOM58y5ICYXhIxY3RTTpyhQn0nkqiW9Y
         8dUFYd0BuhRS+JBhr3YSlkGttyzwBm6PcQztAvxw=
Date:   Thu, 24 Mar 2022 18:32:53 -0700
To:     mm-commits@vger.kernel.org, David.Laight@ACULAB.COM,
        anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-uninline-copy_overflow.patch removed from -mm tree
Message-Id: <20220325013254.26E65C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: uninline copy_overflow()
has been removed from the -mm tree.  Its filename was
     mm-uninline-copy_overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


