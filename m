Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0CD2C07E9E
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F87761CA0
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhGFTXt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:23:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230505AbhGFTXt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:23:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F01F61C9D;
        Tue,  6 Jul 2021 19:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599270;
        bh=REj06D6c9FF8H/xS7Kyu0FqbxyUwXFhTF0yTRQtf70k=;
        h=Date:From:To:Subject:From;
        b=XscQdR7f0b6lVQfIpc9DQK2IRTEqD6x9loDJ3+gVvLXm/fdCLvVUBaE8rAYIOHOUy
         UCs/rj3wQnaGEQ8nzVi3EuDC6Su0lFb8vD1sZgocxwA2Mq3U1BeElL/3CWc+qLyXIl
         OfKxzKePGGR2O1hAj1ldMQyxditrcuB1fuSSd/rA=
Date:   Tue, 06 Jul 2021 12:21:10 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, ddstreet@ieee.org, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shy828301@gmail.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-swap-make-swap_address_space-an-inline-function.patch removed from -mm
 tree
Message-ID: <20210706192110.mVONixM51%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: make swap_address_space an inline function
has been removed from the -mm tree.  Its filename was
     mm-swap-make-swap_address_space-an-inline-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from mgorman@techsingularity.net are


