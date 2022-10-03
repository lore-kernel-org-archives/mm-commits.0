Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93139C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiJCVJn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJCVIG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:08:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984954F190
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28380611D2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C53BC433C1;
        Mon,  3 Oct 2022 21:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831172;
        bh=ryvsZx1PpYh3FlNYDZGfL9n4nlfT/VYLf9EE5IaESYs=;
        h=Date:To:From:Subject:From;
        b=Zzk0b9ALx+CBjCO+ZJD8Zc5RcZZjFy8PwAabiGSRH6G515Xt1aAbbOq3au4WFH8Uu
         WMXrNAoU0NcFWAAqnt81Y03tVxK68J44aOfXdrVqhOfW2TUFuSSkY5OheUTGnNx/Ga
         zkYRbadFGcXSwPUOQoL/hqheDjxRQIT6BnHDKoOE=
Date:   Mon, 03 Oct 2022 14:06:11 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, pcc@google.com,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-use-virt_addr_valid-in-kasan_addr_to_page-slab.patch removed from -mm tree
Message-Id: <20221003210612.7C53BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: use virt_addr_valid in kasan_addr_to_page/slab
has been removed from the -mm tree.  Its filename was
     kasan-use-virt_addr_valid-in-kasan_addr_to_page-slab.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: use virt_addr_valid in kasan_addr_to_page/slab
Date: Mon, 5 Sep 2022 23:05:37 +0200

Instead of open-coding the validity checks for addr in
kasan_addr_to_page/slab(), use the virt_addr_valid() helper.

Link: https://lkml.kernel.org/r/c22a4850d74d7430f8a6c08216fd55c2860a2b9e.1662411799.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kasan/report.c~kasan-use-virt_addr_valid-in-kasan_addr_to_page-slab
+++ a/mm/kasan/report.c
@@ -208,14 +208,14 @@ static void print_track(struct kasan_tra
 
 struct page *kasan_addr_to_page(const void *addr)
 {
-	if ((addr >= (void *)PAGE_OFFSET) && (addr < high_memory))
+	if (virt_addr_valid(addr))
 		return virt_to_head_page(addr);
 	return NULL;
 }
 
 struct slab *kasan_addr_to_slab(const void *addr)
 {
-	if ((addr >= (void *)PAGE_OFFSET) && (addr < high_memory))
+	if (virt_addr_valid(addr))
 		return virt_to_slab(addr);
 	return NULL;
 }
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-array-bounds-warnings-in-tests.patch

