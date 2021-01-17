Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 881D3C433E0
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 02:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B81922D49
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 02:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbhAQCMG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Jan 2021 21:12:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbhAQCMF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 16 Jan 2021 21:12:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7764522D0A;
        Sun, 17 Jan 2021 02:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610849459;
        bh=W0gTPwznguCtBODXOr5gJqUg29fHBWTVuVNlLkfEkuc=;
        h=Date:From:To:Subject:From;
        b=0Or2PQYGfR9c9ws4iGt+or+0X2HIbAz0SQ+DoO9acwKkn1N7lxTfx6waoLmrLB9BP
         z1LSjXLa9X2b3cwvOu3OnbQm6dLH+ksXEC/RyXdyjq+6IlWSMCLtAPyx4JIKBYcuz7
         OXMRscOk2441RPybkWkD04DlBKyQFmVP2B7aBy0w=
Date:   Sat, 16 Jan 2021 18:10:59 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged]
 mm-hugetlb-fix-potential-missing-huge-page-size-info.patch removed from -mm
 tree
Message-ID: <20210117021059.aKDWs3amp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix potential missing huge page size info
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-potential-missing-huge-page-size-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: fix potential missing huge page size info

The huge page size is encoded for VM_FAULT_HWPOISON errors only.  So if we
return VM_FAULT_HWPOISON, huge page size would just be ignored.

Link: https://lkml.kernel.org/r/20210107123449.38481-1-linmiaohe@huawei.com
Fixes: aa50d3a7aa81 ("Encode huge page size for VM_FAULT_HWPOISON errors")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-potential-missing-huge-page-size-info
+++ a/mm/hugetlb.c
@@ -4371,7 +4371,7 @@ retry:
 		 * So we need to block hugepage fault by PG_hwpoison bit check.
 		 */
 		if (unlikely(PageHWPoison(page))) {
-			ret = VM_FAULT_HWPOISON |
+			ret = VM_FAULT_HWPOISON_LARGE |
 				VM_FAULT_SET_HINDEX(hstate_index(h));
 			goto backout_unlocked;
 		}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked.patch

