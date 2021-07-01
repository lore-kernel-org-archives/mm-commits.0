Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D416EC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE82C61241
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238520AbhGAB4S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhGAB4S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:56:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0D396105A;
        Thu,  1 Jul 2021 01:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104427;
        bh=/3fOwR+y7gNIuC95wBosbKEfM6/BZOtJo/SRA+Distg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MADWIe6EXIEsLt+lq2w53ABYRlu2L8mP0DSTcAmndwe65dBqxMLCWpMt7d0+wFrwD
         DnuvJyprZlSTyR3OlHsanlr6h7VD7Q26wjPU7mLVHgjbxxQR6EuG+GosomB/GaQlet
         7eDcAcciAjNRif5LUFBgtd3IbtLssaYtmBQHmr1E=
Date:   Wed, 30 Jun 2021 18:53:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, ddstreet@ieee.org,
        linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 124/192] mm/swap: make swap_address_space an
 inline function
Message-ID: <20210701015347.bJuHZiNgP%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/swap: make swap_address_space an inline function

make W=1 generates the following warning in page_mapping() for allnoconfig

  mm/util.c:700:15: warning: variable `entry' set but not used [-Wunused-but-set-variable]
     swp_entry_t entry;
                 ^~~~~

swap_address is a #define on !CONFIG_SWAP configurations.  Make the helper
an inline function to suppress the warning, add type checking and to apply
any side-effects in the parameter list.

Link: https://lkml.kernel.org/r/20210520084809.8576-12-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/swap.h~mm-swap-make-swap_address_space-an-inline-function
+++ a/include/linux/swap.h
@@ -537,7 +537,11 @@ static inline void put_swap_device(struc
 {
 }
 
-#define swap_address_space(entry)		(NULL)
+static inline struct address_space *swap_address_space(swp_entry_t entry)
+{
+	return NULL;
+}
+
 #define get_nr_swap_pages()			0L
 #define total_swap_pages			0L
 #define total_swapcache_pages()			0UL
_
