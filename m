Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53830C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F152B21775
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881538;
	bh=nDnf5y0QMkin8dm7BZGyqT55aSJeyfVzQ+jFwO/57+o=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=OI95x/U7LhghH/tfpE/Dg0SK787yiwUdNMOS4qe3sZgb1+RHHNiHVuWokIOqpejpN
	 oNHegnL3yNbQemBqg/E0pUVW3mJiKs60lm3P+ESXJXqy+/xs2J9aaM4jIGo6+qKNpg
	 ygjAanRm0bgALVvVNXBSv+D74fG+qukhfFrPtbxg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408657AbgJPUwR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:52:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408651AbgJPUwR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:52:17 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1D582145D;
        Fri, 16 Oct 2020 20:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881536;
        bh=nDnf5y0QMkin8dm7BZGyqT55aSJeyfVzQ+jFwO/57+o=;
        h=Date:From:To:Subject:From;
        b=cZL8fWVnOmR6cs2Zt9yjf3oglfywluf4ELGeZDTChAAPq8YI9TSplF1GQzJpyWPWq
         k0F+ZvZlde/SvuUJg8uCu2Mj6IA7YQO3kzAHE5D393u3eWH3GKckVLW5d2VUc4BYaa
         KHXvjZ2EPJQ1eNMEqddic6prdh2OfBoVCCkpbOpM=
Date:   Fri, 16 Oct 2020 13:52:16 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tanxiaofei@huawei.com
Subject:  [merged] mm-fix-some-doc-warnings-in-workingsetc.patch
 removed from -mm tree
Message-ID: <20201016205216.VDim7nqJi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/workingset.c: fix some doc warnings
has been removed from the -mm tree.  Its filename was
     mm-fix-some-doc-warnings-in-workingsetc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiaofei Tan <tanxiaofei@huawei.com>
Subject: mm/workingset.c: fix some doc warnings

Fix following warnings caused by mismatch bewteen function parameters and
comments.

mm/workingset.c:228: warning: Function parameter or member 'lruvec' not described in 'workingset_age_nonresident'
mm/workingset.c:228: warning: Excess function parameter 'memcg' description in 'workingset_age_nonresident'

Link: https://lkml.kernel.org/r/1600485913-11192-1-git-send-email-tanxiaofei@huawei.com
Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/workingset.c~mm-fix-some-doc-warnings-in-workingsetc
+++ a/mm/workingset.c
@@ -216,7 +216,7 @@ static void unpack_shadow(void *shadow,
 
 /**
  * workingset_age_nonresident - age non-resident entries as LRU ages
- * @memcg: the lruvec that was aged
+ * @lruvec: the lruvec that was aged
  * @nr_pages: the number of pages to count
  *
  * As in-memory pages are aged, non-resident pages need to be aged as
_

Patches currently in -mm which might be from tanxiaofei@huawei.com are


