Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F1CFC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26F0E6100C
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhEHWs1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229699AbhEHWsW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CC02613C5;
        Sat,  8 May 2021 22:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514040;
        bh=GoY6qkgbPnYz1McuvqyLVhkY0hdiJ8ri//at7Ajrmu0=;
        h=Date:From:To:Subject:From;
        b=O5NzEH5Kc8iWze5Ke7UzObV2fIE7yN7orEwRpj/DlAmNdpQAZgPWQcLVsiaDujt02
         X/hpzt1h5U1kNOKOUNnXeJM37n6zZ19PWQQlgISWdyF/8okIH7go2BLmFVOsBW7Stn
         W6XJCOZn1yVIwoEoSGgef0hei5V67j6VYT9nHccc=
Date:   Sat, 08 May 2021 15:47:20 -0700
From:   akpm@linux-foundation.org
To:     linfeilong@huawei.com, linmiaohe@huawei.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-hugeltb-remove-redundant-vm_bug_on-in-region_add.patch removed from -mm
 tree
Message-ID: <20210508224720.x6RVQQOLz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugeltb: remove redundant VM_BUG_ON() in region_add()
has been removed from the -mm tree.  Its filename was
     mm-hugeltb-remove-redundant-vm_bug_on-in-region_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugeltb: remove redundant VM_BUG_ON() in region_add()

Patch series "Cleanup and fixup for hugetlb", v2.

This series contains cleanups to remove redundant VM_BUG_ON() and simplify
the return code.  Also this handles the error case in
hugetlb_fix_reserve_counts() correctly.  More details can be found in the
respective changelogs.


This patch (of 5):

The same VM_BUG_ON() check is already done in the callee.  Remove this
extra one to simplify the code slightly.

Link: https://lkml.kernel.org/r/20210410072348.20437-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210410072348.20437-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Feilong Lin <linfeilong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugeltb-remove-redundant-vm_bug_on-in-region_add
+++ a/mm/hugetlb.c
@@ -553,7 +553,6 @@ retry:
 	resv->adds_in_progress -= in_regions_needed;
 
 	spin_unlock(&resv->lock);
-	VM_BUG_ON(add < 0);
 	return add;
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


