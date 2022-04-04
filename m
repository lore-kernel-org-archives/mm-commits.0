Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0954CC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 23:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236757AbiDDXSc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 19:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233870AbiDDXSQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 19:18:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5216414023
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 16:09:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03214B81AD2
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 23:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E8CC2BBE4;
        Mon,  4 Apr 2022 23:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649113750;
        bh=zeNnEwjkBeMbUhA3CezaxI088J9ifGOJ6Q5OQha+gUg=;
        h=Date:To:From:Subject:From;
        b=RdVxpXF0xlX9ubUec/v2MuecOczpt8wmTFmWwUbx/xBRnKt7BFmF/F+die5lKUn4c
         zaxdUiwMEEbYpU0goXkUhk25j+TNvlX+7Rt9eOkpfUCD0oXYXhuIs1k6vlNVBQJKUy
         PzyY9rY39ywuYgL1ihn/BuvE+W9X6ha8LkfUPpAs=
Date:   Mon, 04 Apr 2022 16:09:09 -0700
To:     mm-commits@vger.kernel.org, caoyixuan2019@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-fix-a-comment.patch added to -mm tree
Message-Id: <20220404230910.A8E8CC2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: fix a comment
has been added to the -mm tree.  Its filename is
     mm-vmalloc-fix-a-comment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-fix-a-comment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-fix-a-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: mm/vmalloc: fix a comment

The sentence
"but the mempolcy want to alloc memory by interleaving"
should be rephrased with
"but the mempolicy wants to alloc memory by interleaving"
where "mempolicy" is a struct name.

This work is coauthored by
Yinan Zhang
Jiajian Ye
Shenghong Han
Chongxi Zhao
Yuhong Feng
Yongqiang Liu

Link: https://lkml.kernel.org/r/20220401064543.4447-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-a-comment
+++ a/mm/vmalloc.c
@@ -2903,7 +2903,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			/* memory allocation should consider mempolicy, we can't
 			 * wrongly use nearest node when nid == NUMA_NO_NODE,
 			 * otherwise memory may be allocated in only one node,
-			 * but mempolcy want to alloc memory by interleaving.
+			 * but mempolicy wants to alloc memory by interleaving.
 			 */
 			if (IS_ENABLED(CONFIG_NUMA) && nid == NUMA_NO_NODE)
 				nr = alloc_pages_bulk_array_mempolicy(bulk_gfp,
_

Patches currently in -mm which might be from caoyixuan2019@email.szu.edu.cn are

mm-vmalloc-fix-a-comment.patch

