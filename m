Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 514A3C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3008161476
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238524AbhGAB41 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:56:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhGAB40 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:56:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0FEF61469;
        Thu,  1 Jul 2021 01:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104437;
        bh=Pbko7oyjPaPRNbxQeB+l3Mi8dtWEQl4zEHPaJst9M70=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0H3C1x8URxWWPjeLbiYwn5GzOP+tD743k0zCLuWS7eELMduHv9FAQ7a0FY5fjtRnY
         GOwO1w51HfxoA3yqrzaLpDeB7gINk2pcXcxkAKCr6JsSKeuodnQC2utKeR0KlB0yPu
         +71hR5A8UuMOxXdZVyafIxidMpD+9m09xP8JYnNg=
Date:   Wed, 30 Jun 2021 18:53:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, ddstreet@ieee.org,
        linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 127/192] mm/swap: make NODE_DATA an inline
 function on CONFIG_FLATMEM
Message-ID: <20210701015356.i3nr-saLs%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/swap: make NODE_DATA an inline function on CONFIG_FLATMEM

make W=1 generates the following warning in mm/workingset.c for allnoconfig

  mm/workingset.c: In function `unpack_shadow':
  mm/workingset.c:201:15: warning: variable `nid' set but not used [-Wunused-but-set-variable]
    int memcgid, nid;
                 ^~~

On FLATMEM, NODE_DATA returns a global pglist_data without dereferencing
nid.  Make the helper an inline function to suppress the warning, add type
checking and to apply any side-effects in the parameter list.

Link: https://lkml.kernel.org/r/20210520084809.8576-15-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/mmzone.h~mm-swap-make-node_data-an-inline-function-on-config_flatmem
+++ a/include/linux/mmzone.h
@@ -1064,7 +1064,10 @@ extern char numa_zonelist_order[];
 #ifndef CONFIG_NUMA
 
 extern struct pglist_data contig_page_data;
-#define NODE_DATA(nid)		(&contig_page_data)
+static inline struct pglist_data *NODE_DATA(int nid)
+{
+	return &contig_page_data;
+}
 #define NODE_MEM_MAP(nid)	mem_map
 
 #else /* CONFIG_NUMA */
_
