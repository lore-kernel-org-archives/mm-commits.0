Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F30C636D6
	for <mm-commits@archiver.kernel.org>; Mon, 20 Feb 2023 20:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbjBTUrA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Feb 2023 15:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbjBTUq7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Feb 2023 15:46:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0193A10D8
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 12:46:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FCFEB80DC7
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 20:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41113C433EF;
        Mon, 20 Feb 2023 20:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676926015;
        bh=ZOP5V6c6XHWdxfaAiU6XDNVG1PBmxKYoZGEHWGr2SqM=;
        h=Date:To:From:Subject:From;
        b=BhXmDU8esJ3R203SlLxWZcVFROST08RulL+AVk3kpUnY8gsMFm4d4Qu9DWxZpkrxe
         k3140mABX2ZYbR6qKTHYMG8fNV/BavvQ7WsJtbv9nX1Qrp317D+gU4bGo0LaEi/B9e
         R2H/K6ZCOkFoahuGqRO+UQ4W/Ttom1A51xypNyw0=
Date:   Mon, 20 Feb 2023 12:46:54 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        ryabinin.a.a@gmail.com, peterz@infradead.org,
        Kuan-Ying.Lee@mediatek.com, jpoimboe@kernel.org, glider@google.com,
        elver@google.com, dvyukov@google.com, andreyknvl@gmail.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-mark-addr_has_metadata-__always_inline.patch removed from -mm tree
Message-Id: <20230220204655.41113C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: mark addr_has_metadata __always_inline
has been removed from the -mm tree.  Its filename was
     kasan-mark-addr_has_metadata-__always_inline.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kasan: mark addr_has_metadata __always_inline
Date: Wed, 15 Feb 2023 14:00:56 +0100

Patch series "objtool warning fixes", v2.

These are three of the easier fixes for objtool warnings around
kasan/kmsan/kcsan.  I dropped one patch since Peter had come up with a
better fix, and adjusted the changelog text based on feedback.


This patch (of 3):

When the compiler decides not to inline this function, objtool complains
about incorrect UACCESS state:

mm/kasan/generic.o: warning: objtool: __asan_load2+0x11: call to addr_has_metadata() with UACCESS enabled

Link: https://lore.kernel.org/all/20230208164011.2287122-1-arnd@kernel.org/
Link: https://lkml.kernel.org/r/20230215130058.3836177-2-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/kasan/kasan.h~kasan-mark-addr_has_metadata-__always_inline
+++ a/mm/kasan/kasan.h
@@ -297,7 +297,7 @@ static inline const void *kasan_shadow_t
 		<< KASAN_SHADOW_SCALE_SHIFT);
 }
 
-static inline bool addr_has_metadata(const void *addr)
+static __always_inline bool addr_has_metadata(const void *addr)
 {
 	return (kasan_reset_tag(addr) >=
 		kasan_shadow_to_mem((void *)KASAN_SHADOW_START));
@@ -316,7 +316,7 @@ bool kasan_check_range(unsigned long add
 
 #else /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
 
-static inline bool addr_has_metadata(const void *addr)
+static __always_inline bool addr_has_metadata(const void *addr)
 {
 	return (is_vmalloc_addr(addr) || virt_addr_valid(addr));
 }
_

Patches currently in -mm which might be from arnd@arndb.de are


