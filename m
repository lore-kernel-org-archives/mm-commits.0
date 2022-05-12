Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8393C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 23:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352409AbiELXaR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 19:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358070AbiELXaQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 19:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AA4285EFF
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 16:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEF23B80CD8
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 23:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD8AC385B8;
        Thu, 12 May 2022 23:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652398210;
        bh=Lc38ttl8opwG02iaAqS2wZgY2pFbve3qe9dPrsLywhQ=;
        h=Date:To:From:Subject:From;
        b=aeY7AdtTrrrFBTBzNW+rodH8xeoMverqLELdkiwsYRgNn6UTKuC6pRzooBtLP7JJN
         4PefgyAo3csz8AUHR3/bPR9ZjJgRX/PDnzMtmDKdbUM+V3qI7LDKCerwd7+NNAn7VH
         t6i0MabEVfm2Gmbe+6fssMvH6+MUtdtEgAvm8zao=
Date:   Thu, 12 May 2022 16:30:09 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com, osalvador@suse.de,
        mike.kravetz@oracle.com, mcgrof@kernel.org, masahiroy@kernel.org,
        keescook@chromium.org, duanxiongchun@bytedance.com,
        david@redhat.com, corbet@lwn.net, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-use-kstrtobool-for-hugetlb_vmemmap-param-parsing.patch added to mm-unstable branch
Message-Id: <20220512233010.6DD8AC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: use kstrtobool for hugetlb_vmemmap param parsing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-use-kstrtobool-for-hugetlb_vmemmap-param-parsing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-use-kstrtobool-for-hugetlb_vmemmap-param-parsing.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-hugetlb_vmemmap-disable-hugetlb_optimize_vmemmap-when-struct-page-crosses-page-boundaries.patch
mm-memory_hotplug-override-memmap_on_memory-when-hugetlb_free_vmemmap=on.patch
mm-hugetlb_vmemmap-use-kstrtobool-for-hugetlb_vmemmap-param-parsing.patch
mm-hugetlb_vmemmap-add-hugetlb_optimize_vmemmap-sysctl.patch

