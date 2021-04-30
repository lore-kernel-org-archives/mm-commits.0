Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D9AC43461
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03BE661482
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhD3F6A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230182AbhD3F56 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:57:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E3626147D;
        Fri, 30 Apr 2021 05:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762230;
        bh=5ivkx4l+rXBMpB8BdRtsgDXZfbRXURTM74mKSIyuMaQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SCbRtC1p+piucLTXLDWSmftixCUWcWt5bNvyT/PeSmId6YgYNaqg9DFmY2FN3sEqC
         IN9oshcMof3TLSdCJ3u32yNJj03fMKYB5Oc1Yl5MySHx9RTWWy5yIEZC9ZYvWAA/sM
         cDrusslT32AAXEywsg+v2c98V+9bmX49DbfIhWXo=
Date:   Thu, 29 Apr 2021 22:57:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, daizhiyuan@phytium.com.cn,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 078/178] mm/interval_tree: add comments to improve
 code readability
Message-ID: <20210430055709.Yo-SNkNcg%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Subject: mm/interval_tree: add comments to improve code readability

Add a comment explaining the value of the ISSTATIC parameter, Inform the
reader that this is not a coding style issue.

Link: https://lkml.kernel.org/r/1613964695-17614-1-git-send-email-daizhiyuan@phytium.com.cn
Signed-off-by: Zhiyuan Dai <daizhiyuan@phytium.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/interval_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/interval_tree.c~mm-interval_tree-add-comments-to-improve-code-reading
+++ a/mm/interval_tree.c
@@ -22,7 +22,7 @@ static inline unsigned long vma_last_pgo
 
 INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
 		     unsigned long, shared.rb_subtree_last,
-		     vma_start_pgoff, vma_last_pgoff,, vma_interval_tree)
+		     vma_start_pgoff, vma_last_pgoff, /* empty */, vma_interval_tree)
 
 /* Insert node immediately after prev in the interval tree */
 void vma_interval_tree_insert_after(struct vm_area_struct *node,
_
