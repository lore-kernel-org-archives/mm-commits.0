Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74641C433E0
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 23:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3941723435
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jan 2021 23:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbhAGXOn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jan 2021 18:14:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:52690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbhAGXOn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Jan 2021 18:14:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE3EE235FF;
        Thu,  7 Jan 2021 23:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610061243;
        bh=CHdWgVgd/SSQEJkDLJQEZTef7usX1cfvXGlZrZtxpoY=;
        h=Date:From:To:Subject:From;
        b=DDkxm9z9V9HI4H70HMnLPYia/5RXARwWVKIurjpxbr9bWiZYh1tj2rS8J+edGEXmI
         L0a6+9O+bEnnHwr4HkCZ2krX5Z4gL3+2JsZOMaaLaw1YfDqOA5FtVNSk5JZWgkMsPs
         sXloVYFcBWv56pL6baX+ZOq70Dezwaam1qTYj+yA=
Date:   Thu, 07 Jan 2021 15:14:02 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-hugetlb-fix-potential-double-free-in-hugetlb=5Fregist?=
 =?US-ASCII?Q?er=5Fnode-error-path.patch?= added to -mm tree
Message-ID: <20210107231402.xbHgYN8eR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix potential double free in hugetlb_register_node() error path
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: fix potential double free in hugetlb_register_node() error path

In hugetlb_sysfs_add_hstate(), we would do kobject_put() on hstate_kobjs
when failed to create sysfs group but forget to set hstate_kobjs to NULL. 
Then in hugetlb_register_node() error path, we may free it again via
hugetlb_unregister_node().

Link: https://lkml.kernel.org/r/20210107123249.36964-1-linmiaohe@huawei.com
Fixes: a3437870160c ("hugetlb: new sysfs interface")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path
+++ a/mm/hugetlb.c
@@ -2947,8 +2947,10 @@ static int hugetlb_sysfs_add_hstate(stru
 		return -ENOMEM;
 
 	retval = sysfs_create_group(hstate_kobjs[hi], hstate_attr_group);
-	if (retval)
+	if (retval) {
 		kobject_put(hstate_kobjs[hi]);
+		hstate_kobjs[hi] = NULL;
+	}
 
 	return retval;
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmallocc-fix-potential-memory-leak.patch
mm-hugetlb-fix-potential-missing-huge-page-size-info.patch
mm-hugetlb-fix-potential-double-free-in-hugetlb_register_node-error-path.patch

