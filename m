Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44DE5C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236434AbiCVVrF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236566AbiCVVrB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:47:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8CA5F8E3
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:45:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A07BA6149F
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1983C340EC;
        Tue, 22 Mar 2022 21:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985524;
        bh=6w9+CxZXSPgJv6PDHksGM+bIyjBwyBPpEv+CDSlrXOw=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=rfVIue0METJk/Xq0XBuXCGRC1J5UqPwuNboPwgrH1I718HqnYRlvxWoJaUZAOdVJZ
         scwdb57/6JNvykH5vQAkqdimy284yXdDPSjIB3P4VgfBj7vzxMGOzocz/8csP4vnTb
         0YaKkJ5WqWi3qhC3t2NBXqjRUc9zJHBgkCal67Q8=
Date:   Tue, 22 Mar 2022 14:45:23 -0700
To:     songmuchun@bytedance.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 135/227] mm/hugetlb: use helper macro __ATTR_RW
Message-Id: <20220322214523.F1983C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: use helper macro __ATTR_RW

Use helper macro __ATTR_RW to define HSTATE_ATTR to make code more clear. 
Minor readability improvement.

Link: https://lkml.kernel.org/r/20220222112731.33479-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-helper-macro-__attr_rw
+++ a/mm/hugetlb.c
@@ -3499,8 +3499,7 @@ static int demote_pool_huge_page(struct
 	static struct kobj_attribute _name##_attr = __ATTR_WO(_name)
 
 #define HSTATE_ATTR(_name) \
-	static struct kobj_attribute _name##_attr = \
-		__ATTR(_name, 0644, _name##_show, _name##_store)
+	static struct kobj_attribute _name##_attr = __ATTR_RW(_name)
 
 static struct kobject *hugepages_kobj;
 static struct kobject *hstate_kobjs[HUGE_MAX_HSTATE];
_
