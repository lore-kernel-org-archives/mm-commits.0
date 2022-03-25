Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7DE1C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357394AbiCYBfS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357364AbiCYBet (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CFDBF536
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D34D60AD1
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA038C340ED;
        Fri, 25 Mar 2022 01:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171948;
        bh=OllI4KFKqGMxUQLxThnR4oH3hMzXYNhZSI+7LgxZre4=;
        h=Date:To:From:Subject:From;
        b=TFO38+VsHPJRlWyr+5zH6O071F/oef/jtfWSliktyW+ZhVIweRgTuKHvs8gI8ivXQ
         ra6CPFWQ7L1o8+5fPpdYECR1g0qbRkWbZszXZOlyyqSSJy5wdBb7093jmWxKEJnEPt
         z4e8sqHDmrKlxWZ6aF41TcrWA41F+Q/ql/4NeRtM=
Date:   Thu, 24 Mar 2022 18:32:28 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-ksm-use-helper-macro-__attr_rw.patch removed from -mm tree
Message-Id: <20220325013228.AA038C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm: use helper macro __ATTR_RW
has been removed from the -mm tree.  Its filename was
     mm-ksm-use-helper-macro-__attr_rw.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/ksm: use helper macro __ATTR_RW

Use helper macro __ATTR_RW to define KSM_ATTR to make code more clear. 
Minor readability improvement.

Link: https://lkml.kernel.org/r/20220221115809.26381-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/ksm.c~mm-ksm-use-helper-macro-__attr_rw
+++ a/mm/ksm.c
@@ -2829,8 +2829,7 @@ static void wait_while_offlining(void)
 #define KSM_ATTR_RO(_name) \
 	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 #define KSM_ATTR(_name) \
-	static struct kobj_attribute _name##_attr = \
-		__ATTR(_name, 0644, _name##_show, _name##_store)
+	static struct kobj_attribute _name##_attr = __ATTR_RW(_name)
 
 static ssize_t sleep_millisecs_show(struct kobject *kobj,
 				    struct kobj_attribute *attr, char *buf)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

