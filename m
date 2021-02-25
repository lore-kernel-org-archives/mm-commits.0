Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD2A8C433E6
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7623964F1A
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbhBYT1G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:27:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233805AbhBYTZT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:25:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB04964F7E;
        Thu, 25 Feb 2021 19:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280515;
        bh=+N5sRb2ZpyeV3XshnmSyMjucElXw5jQOJLXPGQuC+7c=;
        h=Date:From:To:Subject:From;
        b=eXieuxXDIeRiPE8ux1b8Cltn4CfP62TwF+PhZYYtgmjm9O4pZebsz5/OsACglqCfR
         4ZqRbcS73N9YGZhiKJFF288Uf/P+okh72tHFZRR8YkkYfs9eRjf45TMuCIauomNKLX
         WxNm7vZOVxrhFSl5NrIiK1E9mDR/SZnrqjzmG6mg=
Date:   Thu, 25 Feb 2021 11:15:14 -0800
From:   akpm@linux-foundation.org
To:     abaci-bugfix@linux.alibaba.com, abaci@linux.alibaba.com,
        adobriyan@gmail.com, bhe@redhat.com, dyoung@redhat.com,
        mm-commits@vger.kernel.org, urezki@gmail.com, vgoyal@redhat.com
Subject:  [merged] vmalloc-remove-redundant-null-check.patch
 removed from -mm tree
Message-ID: <20210225191514.RRaaQB0NU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmalloc: remove redundant NULL check
has been removed from the -mm tree.  Its filename was
     vmalloc-remove-redundant-null-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Li <abaci-bugfix@linux.alibaba.com>
Subject: vmalloc: remove redundant NULL check

Fix below warnings reported by coccicheck:
./fs/proc/vmcore.c:1503:2-7: WARNING: NULL check before some freeing
functions is not needed.

Link: https://lkml.kernel.org/r/1611216753-44598-1-git-send-email-abaci-bugfix@linux.alibaba.com
Signed-off-by: Yang Li <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/fs/proc/vmcore.c~vmalloc-remove-redundant-null-check
+++ a/fs/proc/vmcore.c
@@ -1503,11 +1503,8 @@ int vmcore_add_device_dump(struct vmcore
 	return 0;
 
 out_err:
-	if (buf)
-		vfree(buf);
-
-	if (dump)
-		vfree(dump);
+	vfree(buf);
+	vfree(dump);
 
 	return ret;
 }
_

Patches currently in -mm which might be from abaci-bugfix@linux.alibaba.com are


