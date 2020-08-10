Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0281C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBA7C2065D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027176;
	bh=5Lku47CeWNOicxLTSGbpV4a7XPYf01+IujXOE2jBWyc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KB45GUWArafaTAkz1RvZx9laGTJ61jt5f5X3cWBIWkmZHexjkCBfGCT4DHZnE0McV
	 neD6sIYTn4LHJkBetWN3zXSmSomav8liN9UARt7rSwF53valxpTstN73ms96Q2kczo
	 ii6fONOJOgHcyBxCEIL3mX2gNKMnjuixD+0kr3h4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgHJCjg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:39:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCjg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:39:36 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97290206C3;
        Mon, 10 Aug 2020 02:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027176;
        bh=5Lku47CeWNOicxLTSGbpV4a7XPYf01+IujXOE2jBWyc=;
        h=Date:From:To:Subject:From;
        b=rY9kvO1vOzexL4Nbk6dXoNOwEZ2uJ7CyqQ0pbzra5oqwAFZuA2ErRsMv2NkNoo46j
         eUy80RZTkX4Ay5G+hTlzth1MdcE1VHy6yOCrRm/0hMDdftPOqia+7ovX/eETOoClr2
         owWBNk7yk5BNqd7mGAGs4iq5VAhW9v6ugNBLfgTQ=
Date:   Sun, 09 Aug 2020 19:39:35 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, ardb@kernel.org, aryabinin@virtuozzo.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        glider@google.com, lenaptr@google.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com, walter-zh.wu@mediatek.com
Subject:  [merged]
 kasan-allow-enabling-stack-tagging-for-tag-based-mode.patch removed from
 -mm tree
Message-ID: <20200810023935.6q1K-cuKV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: allow enabling stack tagging for tag-based mode
has been removed from the -mm tree.  Its filename was
     kasan-allow-enabling-stack-tagging-for-tag-based-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: allow enabling stack tagging for tag-based mode

Use CONFIG_KASAN_STACK to enable stack tagging.

Note, that HWASAN short granules [1] are disabled. Supporting those will
require more kernel changes.

[1] https://clang.llvm.org/docs/HardwareAssistedAddressSanitizerDesign.html

Link: http://lkml.kernel.org/r/e7febb907b539c3730780df587ce0b38dc558c3d.1596199677.git.andreyknvl@google.com
Link: http://lkml.kernel.org/r/99f7d90a4237431bf5988599fb41358e92876eb0.1596544734.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Elena Petrova <lenaptr@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.kasan |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/Makefile.kasan~kasan-allow-enabling-stack-tagging-for-tag-based-mode
+++ a/scripts/Makefile.kasan
@@ -44,7 +44,8 @@ else
 endif
 
 CFLAGS_KASAN := -fsanitize=kernel-hwaddress \
-		-mllvm -hwasan-instrument-stack=0 \
+		-mllvm -hwasan-instrument-stack=$(CONFIG_KASAN_STACK) \
+		-mllvm -hwasan-use-short-granules=0 \
 		$(instrumentation_flags)
 
 endif # CONFIG_KASAN_SW_TAGS
_

Patches currently in -mm which might be from andreyknvl@google.com are


