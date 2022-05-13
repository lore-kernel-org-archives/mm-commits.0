Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E9AC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 02:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376601AbiEMC6M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 22:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376602AbiEMC6J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 22:58:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2F66CF41
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 19:58:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C489B8015B
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 02:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6D3C385B8;
        Fri, 13 May 2022 02:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652410685;
        bh=Fj3c2AgStnRQLX1bihSSbzggXaZgS+xZ1Ok4inkbMs0=;
        h=Date:To:From:Subject:From;
        b=H3X2msF2JzyqpunhjEy/fYbDMXDExYxjPBJezIgioziF4UTDtzRWtJ9rq+4/tOsV/
         l6ZnMVZNp0g7stKrk8U+277cLVZM4WJaeLfVKTwXehAyV2M0AOm7RJaNtcLTkirQpZ
         3BwgRCaDe52POGmvdqlljovON9nOWxf7xDo9Gvew=
Date:   Thu, 12 May 2022 19:58:04 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, rf@opensource.cirrus.com, pmladek@suse.com,
        jvgediya@linux.ibm.com, Jonathan.Cameron@huawei.com,
        dave.hansen@intel.com, andy.shevchenko@gmail.com,
        adobriyan@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-convert-sysfs-input-to-bool-using-kstrtobool-fix.patch removed from -mm tree
Message-Id: <20220513025804.EA6D3C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-convert-sysfs-input-to-bool-using-kstrtobool-fix
has been removed from the -mm tree.  Its filename was
     mm-convert-sysfs-input-to-bool-using-kstrtobool-fix.patch

This patch was dropped because it was folded into mm-convert-sysfs-input-to-bool-using-kstrtobool.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-convert-sysfs-input-to-bool-using-kstrtobool-fix

propagate kstrtobool() return value, per Andy

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jagdish Gediya <jvgediya@linux.ibm.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c    |    7 +++++--
 mm/swap_state.c |    7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/mm/migrate.c~mm-convert-sysfs-input-to-bool-using-kstrtobool-fix
+++ a/mm/migrate.c
@@ -2523,8 +2523,11 @@ static ssize_t numa_demotion_enabled_sto
 					   struct kobj_attribute *attr,
 					   const char *buf, size_t count)
 {
-	if (kstrtobool(buf, &numa_demotion_enabled))
-		return -EINVAL;
+	ssize_t ret;
+
+	ret = kstrtobool(buf, &numa_demotion_enabled);
+	if (ret)
+		return ret;
 
 	return count;
 }
--- a/mm/swap_state.c~mm-convert-sysfs-input-to-bool-using-kstrtobool-fix
+++ a/mm/swap_state.c
@@ -874,8 +874,11 @@ static ssize_t vma_ra_enabled_store(stru
 				      struct kobj_attribute *attr,
 				      const char *buf, size_t count)
 {
-	if (kstrtobool(buf, &enable_vma_readahead))
-		return -EINVAL;
+	ssize_t ret;
+
+	ret = kstrtobool(buf, &enable_vma_readahead);
+	if (ret)
+		return ret;
 
 	return count;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

assoc_array-fix-bug_on-during-garbage-collect-fix.patch
mm-convert-sysfs-input-to-bool-using-kstrtobool.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

