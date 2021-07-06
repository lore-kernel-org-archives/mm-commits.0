Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63630C07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DE3761CA0
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhGFTX4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:23:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230408AbhGFTX4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:23:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C32261C9D;
        Tue,  6 Jul 2021 19:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599276;
        bh=WgMNnxOGsbxm7ryLl7FKQRUTqzda6uftAtC5dQ4Sb/4=;
        h=Date:From:To:Subject:From;
        b=cyeKyyg5U1RDrDY2yf240UB9VAsYe2yo3E06UPT6BQUZNbCvdTQWS+3xfCKNI/ChM
         h8XXJWA2n9L6w6JbJKFW3dDlTSxEKdetAWc3DQp7fHmtG+yWqa6IKJpVhfx/o8XESI
         EugHXswvGLcG52sAkGBBuVoovxei5CeOWV+FFyo8=
Date:   Tue, 06 Jul 2021 12:21:16 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, ddstreet@ieee.org, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shy828301@gmail.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-swap-make-node_data-an-inline-function-on-config_flatmem.patch removed
 from -mm tree
Message-ID: <20210706192116.3r7knHNOD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: make NODE_DATA an inline function on CONFIG_FLATMEM
has been removed from the -mm tree.  Its filename was
     mm-swap-make-node_data-an-inline-function-on-config_flatmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from mgorman@techsingularity.net are


