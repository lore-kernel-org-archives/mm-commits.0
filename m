Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF5CBC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Feb 2022 04:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiBXEhZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Feb 2022 23:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiBXEhO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Feb 2022 23:37:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0C33F32F
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 20:36:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BF6EB823FC
        for <mm-commits@vger.kernel.org>; Thu, 24 Feb 2022 04:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3024C340E9;
        Thu, 24 Feb 2022 04:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645677402;
        bh=M5qHjIcLhM8Y2Cel3sxaWNS/YK+X0WQjuYcT/W4GDcY=;
        h=Date:To:From:Subject:From;
        b=x3P96CS9nDERxUQbkfu2TS8AXaanTXt3CWpcrb6J3bi8SBYFyhHN6RCraPN5cu3vT
         C3VvrsD6BRqxcl2llsGvhXw2I7bTtYClDfZjxVl92ZoU+fflwSWly3olSsGurfzizh
         bn+DFrZlUFA0JOk8Uw/5PJUqNVT7zp3mlZxNqo0o=
Date:   Wed, 23 Feb 2022 20:36:41 -0800
To:     mm-commits@vger.kernel.org, tony.luck@intel.com,
        tglx@linutronix.de, naoya.horiguchi@nec.com, mingo@redhat.com,
        linmiaohe@huawei.com, hpa@zytor.com, dave.hansen@linux.intel.com,
        bp@alien8.de, luofei@unicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hwpoison-add-in-use-hugepage-hwpoison-filter-judgement.patch removed from -mm tree
Message-Id: <20220224043641.E3024C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: add in-use hugepage hwpoison filter judgement
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-add-in-use-hugepage-hwpoison-filter-judgement.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: luofei <luofei@unicloud.com>
Subject: mm/hwpoison: add in-use hugepage hwpoison filter judgement

After successfully obtaining the reference count of the huge page, it is
still necessary to call hwpoison_filter() to make a filter judgement,
otherwise the filter hugepage will be unmaped and the related process may
be killed.

Link: https://lkml.kernel.org/r/20220221021521.2329075-1-luofei@unicloud.com
Signed-off-by: luofei <luofei@unicloud.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/memory-failure.c~mm-hwpoison-add-in-use-hugepage-hwpoison-filter-judgement
+++ a/mm/memory-failure.c
@@ -1537,6 +1537,17 @@ static int memory_failure_hugetlb(unsign
 	lock_page(head);
 	page_flags = head->flags;
 
+	if (hwpoison_filter(p)) {
+		if (TestClearPageHWPoison(head))
+			num_poisoned_pages_dec();
+		put_page(p);
+		if (flags & MF_MCE_HANDLE)
+			res = -EHWPOISON;
+		else
+			res = 0;
+		goto out;
+	}
+
 	/*
 	 * TODO: hwpoison for pud-sized hugetlb doesn't work right now, so
 	 * simply disable it. In order to make it work properly, we need
_

Patches currently in -mm which might be from luofei@unicloud.com are


