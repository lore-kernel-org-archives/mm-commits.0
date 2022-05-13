Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E1EC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383767AbiEMTWd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383706AbiEMTWM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A044C38DA7
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53CF5B83159
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D063C34113;
        Fri, 13 May 2022 19:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469691;
        bh=3WsAdQD2LnHq5PKcKr+LMx9zXZ9JuGAjwr8qRzZxub0=;
        h=Date:To:From:Subject:From;
        b=00F7KFrQr0uVnQAn7d2mirWPw1JDQJCFTH9sFWIhhxS4TxMOYSJcfqGw6JkKP8O57
         m1V+sgGugvH0QiHrEj+JKQXrvvhaLM0V3qQnEfzFery2el/APQX77HXfvZvF06C+UL
         iUnJzMoCjQB0PkdOWIRVlfYkhIA+0ao2J4TDjSQE=
Date:   Fri, 13 May 2022 12:21:30 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, rf@opensource.cirrus.com, pmladek@suse.com,
        Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
        andy.shevchenko@gmail.com, adobriyan@gmail.com,
        jvgediya@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-sysfs-input-to-bool-using-kstrtobool.patch removed from -mm tree
Message-Id: <20220513192131.0D063C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert sysfs input to bool using kstrtobool()
has been removed from the -mm tree.  Its filename was
     mm-convert-sysfs-input-to-bool-using-kstrtobool.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jagdish Gediya <jvgediya@linux.ibm.com>
Subject: mm: convert sysfs input to bool using kstrtobool()

Sysfs input conversion to corrosponding bool value e.g.  "false" or "0" to
false, "true" or "1" to true are currently handled through strncmp at
multiple places.  Use kstrtobool() to convert sysfs input to bool value.

[akpm@linux-foundation.org: propagate kstrtobool() return value, per Andy]
Link: https://lkml.kernel.org/r/20220426180203.70782-2-jvgediya@linux.ibm.com
Signed-off-by: Jagdish Gediya <jvgediya@linux.ibm.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c    |   11 +++++------
 mm/swap_state.c |   11 +++++------
 2 files changed, 10 insertions(+), 12 deletions(-)

--- a/mm/migrate.c~mm-convert-sysfs-input-to-bool-using-kstrtobool
+++ a/mm/migrate.c
@@ -2523,12 +2523,11 @@ static ssize_t numa_demotion_enabled_sto
 					   struct kobj_attribute *attr,
 					   const char *buf, size_t count)
 {
-	if (!strncmp(buf, "true", 4) || !strncmp(buf, "1", 1))
-		numa_demotion_enabled = true;
-	else if (!strncmp(buf, "false", 5) || !strncmp(buf, "0", 1))
-		numa_demotion_enabled = false;
-	else
-		return -EINVAL;
+	ssize_t ret;
+
+	ret = kstrtobool(buf, &numa_demotion_enabled);
+	if (ret)
+		return ret;
 
 	return count;
 }
--- a/mm/swap_state.c~mm-convert-sysfs-input-to-bool-using-kstrtobool
+++ a/mm/swap_state.c
@@ -874,12 +874,11 @@ static ssize_t vma_ra_enabled_store(stru
 				      struct kobj_attribute *attr,
 				      const char *buf, size_t count)
 {
-	if (!strncmp(buf, "true", 4) || !strncmp(buf, "1", 1))
-		enable_vma_readahead = true;
-	else if (!strncmp(buf, "false", 5) || !strncmp(buf, "0", 1))
-		enable_vma_readahead = false;
-	else
-		return -EINVAL;
+	ssize_t ret;
+
+	ret = kstrtobool(buf, &enable_vma_readahead);
+	if (ret)
+		return ret;
 
 	return count;
 }
_

Patches currently in -mm which might be from jvgediya@linux.ibm.com are


