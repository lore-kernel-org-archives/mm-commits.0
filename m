Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28FF8C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B30161468
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238462AbhGAB4K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:56:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhGAB4J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:56:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8324761468;
        Thu,  1 Jul 2021 01:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104418;
        bh=nHpuFln55P7Tu52NwndGlGtNQfEQEfrO2nZ0woL7Hew=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cuPfYgdzjpfbwz7Hqceor22TabrAhdIY4bex/8QLA9uVGsw9vNpFMeV4aBKZs00EB
         roTuPiMuzYdzJTNgfGXUrSb90z0z/Fl6XaVXmj4wBt28odE1XvLt+MnVdPfx0PYk7p
         pUEnfo/lUx7IMugGW1UrTepHj/brhfBNv/dbJoDA=
Date:   Wed, 30 Jun 2021 18:53:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, ddstreet@ieee.org,
        linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 121/192] mm/memory_hotplug: fix kerneldoc comment
 for __remove_memory
Message-ID: <20210701015338.pSbMy1HM9%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/memory_hotplug: fix kerneldoc comment for __remove_memory

make W=1 generates the following warning for __remove_memory

  mm/memory_hotplug.c:2044: warning: expecting prototype for remove_memory(). Prototype was for __remove_memory() instead

Commit eca499ab3749 ("mm/hotplug: make remove_memory() interface usable")
introduced the kerneldoc comment and function but the kerneldoc name and
function name did not match.

Link: https://lkml.kernel.org/r/20210520084809.8576-9-mgorman@techsingularity.net
Fixes: eca499ab3749 ("mm/hotplug: make remove_memory() interface usable")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-kerneldoc-comment-for-__remove_memory
+++ a/mm/memory_hotplug.c
@@ -1908,7 +1908,7 @@ static int __ref try_remove_memory(int n
 }
 
 /**
- * remove_memory
+ * __remove_memory - Remove memory if every memory block is offline
  * @nid: the node ID
  * @start: physical address of the region to remove
  * @size: size of the region to remove
_
