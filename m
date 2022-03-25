Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C3FC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352982AbiCYBek (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357357AbiCYBdj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403BEBD8AF
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA00FB82727
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA82C340EC;
        Fri, 25 Mar 2022 01:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171923;
        bh=BeFxiOij/w8SpxOd2aqpfQ70btBqbdwriOHltGk81J4=;
        h=Date:To:From:Subject:From;
        b=XNqxUmOrQMybNB9mWvtieoNNpbnC/tduOZuZ7oh+nNmBF/0GtAQQW8QvKQJF6qDeO
         471O6OEjXZsdD/Qed46t6Fp43mpZuMVCCHt3Ib99kwb0dS4HgjNutUwVWb6rHRHUGb
         u8r+UHADmJUEGOynYtac9I+QCVxrkCmRNP6drsKk=
Date:   Thu, 24 Mar 2022 18:32:02 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-hugetlb-use-helper-macro-__attr_rw.patch removed from -mm tree
Message-Id: <20220325013203.7EA82C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: use helper macro __ATTR_RW
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-helper-macro-__attr_rw.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

