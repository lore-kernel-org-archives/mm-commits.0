Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB9E8C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E95964F3F
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbhBYTXg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:23:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:60066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234663AbhBYTUF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:20:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98E6B64F5E;
        Thu, 25 Feb 2021 19:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280418;
        bh=kT9utayuDwZa27Oa4DR1T/lgFgUlUOkjmfS43agxV0w=;
        h=Date:From:To:Subject:From;
        b=nQGBt7f7laX9iERefzwVYfpkwy8vlhp0AJuUv3BuDh38JoWVgzZDSfdk42KNYVNPs
         SJeZzwjLkuQg4XVdH9XinYmMTQOawZe6ZfubZk78w3eVCjNhTC8SXVx6IsNRaJPjbn
         blFZiXFUONiCNh/4V68/zyaYBF4zw1/0qPCZUmU0=
Date:   Thu, 25 Feb 2021 11:13:38 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stephenzhangzsd@gmail.com
Subject:  [merged]
 mm-swapfilec-fix-debugging-information-problem.patch removed from -mm tree
Message-ID: <20210225191338.75qacvB3Q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: fix debugging information problem
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-fix-debugging-information-problem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Zhang <stephenzhangzsd@gmail.com>
Subject: mm/swapfile.c: fix debugging information problem

Once the function name is changed, it may be easy to forget to modify the
corresponding code here.

Link: https://lkml.kernel.org/r/1611369120-2276-1-git-send-email-stephenzhangzsd@gmail.com
Signed-off-by: Stephen Zhang <stephenzhangzsd@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-fix-debugging-information-problem
+++ a/mm/swapfile.c
@@ -1157,13 +1157,13 @@ static struct swap_info_struct *__swap_i
 	return p;
 
 bad_offset:
-	pr_err("swap_info_get: %s%08lx\n", Bad_offset, entry.val);
+	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
 	goto out;
 bad_device:
-	pr_err("swap_info_get: %s%08lx\n", Unused_file, entry.val);
+	pr_err("%s: %s%08lx\n", __func__, Unused_file, entry.val);
 	goto out;
 bad_nofile:
-	pr_err("swap_info_get: %s%08lx\n", Bad_file, entry.val);
+	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
 out:
 	return NULL;
 }
@@ -1180,7 +1180,7 @@ static struct swap_info_struct *_swap_in
 	return p;
 
 bad_free:
-	pr_err("swap_info_get: %s%08lx\n", Unused_offset, entry.val);
+	pr_err("%s: %s%08lx\n", __func__, Unused_offset, entry.val);
 out:
 	return NULL;
 }
_

Patches currently in -mm which might be from stephenzhangzsd@gmail.com are

mm-early_ioremapc-use-__func__-instead-of-function-name.patch

