Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D54C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B19C1613BA
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhEEBBW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:01:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231592AbhEEBBW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:01:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B045361078;
        Wed,  5 May 2021 01:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620176425;
        bh=1M4vhf3IMxjy/996vIcdHP/ibFvWxBeySajgPX6nkqI=;
        h=Date:From:To:Subject:From;
        b=iX2Ei58zh+FhSDooENpOarhAVBiWeGPapRIG/MM9+8Hiww4ThGcDX1sIE48ZhQMuv
         kDuDuWh2aNnQ3wdoD+HIoVcsFcdL6FsDqCIyiKdGfLnNBWOHlJIurouDgFkujnvw3l
         NROrt+Bas4RMYwk4B09PU9KlSnHZQ3p/UKK8BZgw=
Date:   Tue, 04 May 2021 18:00:25 -0700
From:   akpm@linux-foundation.org
To:     daizhiyuan@phytium.com.cn, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-frontswap-minor-coding-style-tweaks.patch removed from -mm tree
Message-ID: <20210505010025.yLh_YvlUz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/frontswap: minor coding style tweaks
has been removed from the -mm tree.  Its filename was
     mm-frontswap-minor-coding-style-tweaks.patch

This patch was dropped because it was folded into mm-mempool-minor-coding-style-tweaks.patch

------------------------------------------------------
From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/frontswap: minor coding style tweaks

This patch move brace position to fix coding style issues,
improve code reading.

Link: https://lkml.kernel.org/r/1613962668-15045-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frontswap.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/frontswap.c~mm-frontswap-minor-coding-style-tweaks
+++ a/mm/frontswap.c
@@ -60,16 +60,20 @@ static u64 frontswap_succ_stores;
 static u64 frontswap_failed_stores;
 static u64 frontswap_invalidates;
 
-static inline void inc_frontswap_loads(void) {
+static inline void inc_frontswap_loads(void)
+{
 	data_race(frontswap_loads++);
 }
-static inline void inc_frontswap_succ_stores(void) {
+static inline void inc_frontswap_succ_stores(void)
+{
 	data_race(frontswap_succ_stores++);
 }
-static inline void inc_frontswap_failed_stores(void) {
+static inline void inc_frontswap_failed_stores(void)
+{
 	data_race(frontswap_failed_stores++);
 }
-static inline void inc_frontswap_invalidates(void) {
+static inline void inc_frontswap_invalidates(void)
+{
 	data_race(frontswap_invalidates++);
 }
 #else
_

Patches currently in -mm which might be from daizhiyuan@phytium.com.cn are

mm-memremap-fixes-improper-spdx-comment-style.patch
mm-interval_tree-add-comments-to-improve-code-reading.patch
mm-dmapool-switch-from-strlcpy-to-strscpy.patch
mm-kasan-switch-from-strlcpy-to-strscpy.patch
mm-zswap-switch-from-strlcpy-to-strscpy.patch
mm-mempool-minor-coding-style-tweaks.patch
mm-vmalloc-minor-coding-style-tweaks.patch
mm-memory_hotplug-minor-coding-style-tweaks.patch
mm-mempolicy-minor-coding-style-tweaks.patch

