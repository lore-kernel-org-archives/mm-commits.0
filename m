Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F15BC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 01:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376276AbiEMBFx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 21:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiEMBFr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 21:05:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B16A197
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 18:05:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C421FB82C27
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 01:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707FEC34113;
        Fri, 13 May 2022 01:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652403943;
        bh=TKVs2z+e9VzmrqQLh+BUOFU1uuiZ1KN4Igro7/Gz4qo=;
        h=Date:To:From:Subject:From;
        b=vtIeI3moqsjWWQAP6/zb+woyHaJemxqinDkXf1lcQFHI2kCel05lpvu148XIDb/5Z
         QoI+BDdhY/pHbPL68Ug1eRf1FppWn9hfXJLUTRkmwlG9U7dNytfxHBq586U1uPteYs
         CoU3DfYtv8kFykh9a7O7q3YpmUM53o5pWvhLqVJ8=
Date:   Thu, 12 May 2022 18:05:42 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, rf@opensource.cirrus.com, pmladek@suse.com,
        jvgediya@linux.ibm.com, Jonathan.Cameron@huawei.com,
        dave.hansen@intel.com, andy.shevchenko@gmail.com,
        adobriyan@gmail.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-sysfs-input-to-bool-using-kstrtobool-fix.patch added to mm-unstable branch
Message-Id: <20220513010543.707FEC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-convert-sysfs-input-to-bool-using-kstrtobool-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-sysfs-input-to-bool-using-kstrtobool-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-sysfs-input-to-bool-using-kstrtobool-fix.patch

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

 mm/migrate.c    |    6 ++++--
 mm/swap_state.c |    7 +++++--
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/mm/migrate.c~mm-convert-sysfs-input-to-bool-using-kstrtobool-fix
+++ a/mm/migrate.c
@@ -2523,8 +2523,10 @@ static ssize_t numa_demotion_enabled_sto
 					   struct kobj_attribute *attr,
 					   const char *buf, size_t count)
 {
-	if (kstrtobool(buf, &numa_demotion_enabled))
-		return -EINVAL;
+	ssize_t ret;
+
+	ret = kstrtobool(buf, &numa_demotion_enabled);
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
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mm-convert-sysfs-input-to-bool-using-kstrtobool-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

