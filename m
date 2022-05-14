Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB595C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 14 May 2022 19:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbiENT4V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 May 2022 15:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbiENTza (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 May 2022 15:55:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870B2377E9
        for <mm-commits@vger.kernel.org>; Sat, 14 May 2022 12:55:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D25FCCE098A
        for <mm-commits@vger.kernel.org>; Sat, 14 May 2022 19:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A41EC340EE;
        Sat, 14 May 2022 19:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652558124;
        bh=4T1nG9jINQ4d0CYPKFRd5cT7UEz0M4TYpawpBe8UC/E=;
        h=Date:To:From:Subject:From;
        b=xnU5xDjR6OfmNXOun67vgf9NZkqZE5nq9MJjPP51WCQxY7dVFA48djEbFQU0y7DN6
         6jCWZZjQKj88FIpX/dCz/kqS2ZNhIeKUrwvpkEyMCmeEjIqX9MbjNxJEYTH5YOXMVc
         1GIP9DC5SK2oS4JWERuakSkYgl6rYaeNyCOUSTjU=
Date:   Sat, 14 May 2022 12:55:23 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com, osalvador@suse.de,
        mike.kravetz@oracle.com, mcgrof@kernel.org, masahiroy@kernel.org,
        keescook@chromium.org, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-use-kstrtobool-for-hugetlb_vmemmap-param-parsing.patch removed from -mm tree
Message-Id: <20220514195524.0A41EC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: use kstrtobool for hugetlb_vmemmap param parsing
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-use-kstrtobool-for-hugetlb_vmemmap-param-parsing.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: use kstrtobool for hugetlb_vmemmap param parsing

Use kstrtobool rather than open coding "on" and "off" parsing in
mm/hugetlb_vmemmap.c, which is more powerful to handle all kinds of
parameters like 'Yy1Nn0' or [oO][NnFf] for "on" and "off".

Link: https://lkml.kernel.org/r/20220512041142.39501-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    6 +++---
 mm/hugetlb_vmemmap.c                            |   10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-hugetlb_vmemmap-use-kstrtobool-for-hugetlb_vmemmap-param-parsing
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1664,10 +1664,10 @@
 			enabled.
 			Allows heavy hugetlb users to free up some more
 			memory (7 * PAGE_SIZE for each 2MB hugetlb page).
-			Format: { on | off (default) }
+			Format: { [oO][Nn]/Y/y/1 | [oO][Ff]/N/n/0 (default) }
 
-			on:  enable the feature
-			off: disable the feature
+			[oO][Nn]/Y/y/1: enable the feature
+			[oO][Ff]/N/n/0: disable the feature
 
 			Built with CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON=y,
 			the default is on.
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-use-kstrtobool-for-hugetlb_vmemmap-param-parsing
+++ a/mm/hugetlb_vmemmap.c
@@ -28,15 +28,15 @@ EXPORT_SYMBOL(hugetlb_optimize_vmemmap_k
 
 static int __init hugetlb_vmemmap_early_param(char *buf)
 {
-	if (!buf)
+	bool enable;
+
+	if (kstrtobool(buf, &enable))
 		return -EINVAL;
 
-	if (!strcmp(buf, "on"))
+	if (enable)
 		static_branch_enable(&hugetlb_optimize_vmemmap_key);
-	else if (!strcmp(buf, "off"))
-		static_branch_disable(&hugetlb_optimize_vmemmap_key);
 	else
-		return -EINVAL;
+		static_branch_disable(&hugetlb_optimize_vmemmap_key);
 
 	return 0;
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


