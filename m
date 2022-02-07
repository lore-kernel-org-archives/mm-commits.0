Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FF6C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 21:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbiBGVAw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 16:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbiBGVAh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 16:00:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77CDC0401E5
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 13:00:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62F6E6156A
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 21:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF263C004E1;
        Mon,  7 Feb 2022 21:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644267629;
        bh=k65XN4+fP+16qXk6u+7QvZIVQeCS+9AI5GLuHC/Ge4w=;
        h=Date:To:From:Subject:From;
        b=nVy1X7dAIabxsHUQtrQoP89O6KX+NBXULnCy620v39q9un/ovBpEqmGfkc9iFcRUh
         yROKPdHjCErtp1mcRYgCwZWKYqKlt1+VTPFUJhup63hhd7jIvDd6Eco+2Yy5oW9MSp
         onX3b9NRVyTyvbvdhI/7hyg8o+FpVxf7Nhdz7V4A=
Date:   Mon, 07 Feb 2022 13:00:29 -0800
To:     mm-commits@vger.kernel.org, christophe.leroy@csgroup.eu,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-outline-copy_overflow.patch added to -mm tree
Message-Id: <20220207210029.AF263C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: uninline copy_overflow()
has been added to the -mm tree.  Its filename is
     mm-outline-copy_overflow.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-outline-copy_overflow.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-outline-copy_overflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-outline-copy_overflow.patch
ilog2-force-inlining-of-__ilog2_u32-and-__ilog2_u64.patch

