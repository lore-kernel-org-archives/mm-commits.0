Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D19C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 19:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbiDZTO0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 15:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354331AbiDZTOW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 15:14:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEFC25E97
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 12:11:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF04AB82249
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 19:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E54DC385A4;
        Tue, 26 Apr 2022 19:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651000270;
        bh=/+qlRoVlGZuztGD5ZO7NCxK+/yWvmj2QMurkhK7l60g=;
        h=Date:To:From:Subject:From;
        b=04dcOxXTdPeBMNbmm/bKas8FgTTEh0tLS9fq5awj5F8KB/MYgESDmzc04gY44X5Ec
         +71zSwiLkz8a3xh059TL2RXqQQObbWEy08k5shQfzMvNZfd/THYa9LdSytMw94odvb
         wlBYD75SY5dAGT2R6nMSooZ1VIZdi8reWH7o3pvo=
Date:   Tue, 26 Apr 2022 12:11:09 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, rf@opensource.cirrus.com, pmladek@suse.com,
        Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
        andriy.shevchenko@linux.intel.com, adobriyan@gmail.com,
        jvgediya@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-sysfs-input-to-bool-using-kstrtobool.patch added to -mm tree
Message-Id: <20220426191110.8E54DC385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert sysfs input to bool using kstrtobool()
has been added to the -mm tree.  Its filename is
     mm-convert-sysfs-input-to-bool-using-kstrtobool.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-convert-sysfs-input-to-bool-using-kstrtobool.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-convert-sysfs-input-to-bool-using-kstrtobool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jagdish Gediya <jvgediya@linux.ibm.com>
Subject: mm: convert sysfs input to bool using kstrtobool()

Sysfs input conversion to corrosponding bool value e.g.  "false" or "0" to
false, "true" or "1" to true are currently handled through strncmp at
multiple places.  Use kstrtobool() to convert sysfs input to bool value.

Link: https://lkml.kernel.org/r/20220426180203.70782-2-jvgediya@linux.ibm.com
Signed-off-by: Jagdish Gediya <jvgediya@linux.ibm.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c    |    6 +-----
 mm/swap_state.c |    6 +-----
 2 files changed, 2 insertions(+), 10 deletions(-)

--- a/mm/migrate.c~mm-convert-sysfs-input-to-bool-using-kstrtobool
+++ a/mm/migrate.c
@@ -2534,11 +2534,7 @@ static ssize_t numa_demotion_enabled_sto
 					   struct kobj_attribute *attr,
 					   const char *buf, size_t count)
 {
-	if (!strncmp(buf, "true", 4) || !strncmp(buf, "1", 1))
-		numa_demotion_enabled = true;
-	else if (!strncmp(buf, "false", 5) || !strncmp(buf, "0", 1))
-		numa_demotion_enabled = false;
-	else
+	if (kstrtobool(buf, &numa_demotion_enabled))
 		return -EINVAL;
 
 	return count;
--- a/mm/swap_state.c~mm-convert-sysfs-input-to-bool-using-kstrtobool
+++ a/mm/swap_state.c
@@ -874,11 +874,7 @@ static ssize_t vma_ra_enabled_store(stru
 				      struct kobj_attribute *attr,
 				      const char *buf, size_t count)
 {
-	if (!strncmp(buf, "true", 4) || !strncmp(buf, "1", 1))
-		enable_vma_readahead = true;
-	else if (!strncmp(buf, "false", 5) || !strncmp(buf, "0", 1))
-		enable_vma_readahead = false;
-	else
+	if (kstrtobool(buf, &enable_vma_readahead))
 		return -EINVAL;
 
 	return count;
_

Patches currently in -mm which might be from jvgediya@linux.ibm.com are

lib-kstrtoxc-add-false-true-support-to-kstrtobool.patch
mm-convert-sysfs-input-to-bool-using-kstrtobool.patch

