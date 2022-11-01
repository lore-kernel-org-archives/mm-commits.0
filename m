Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0985C4332F
	for <mm-commits@archiver.kernel.org>; Tue,  1 Nov 2022 23:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiKAXBT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Nov 2022 19:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiKAXBS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2022 19:01:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E8D2C2
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 16:01:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB8BEB81FFA
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 23:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42821C433C1;
        Tue,  1 Nov 2022 23:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667343675;
        bh=iR75aDfgRKyTx7KnhURv9JfKHQgQhODV3rp+wk4XjHM=;
        h=Date:To:From:Subject:From;
        b=Ly1GFb03y5p+WpHpS3RJ2tw8iPGslj3BlcUIwvH0oFS5IVGBmU/9mKAyTsOZ2Ei0r
         TXrUQlG6jvlTLvPB2Pme/TM7Oyf0O3Q+GR7WlYww+09L7PrXgGJxR+6CBhX1B8XP3C
         bWo6Wu3HMT2WSWp+Njt3Sh9pPJHmMGJmKKPPCAJQ=
Date:   Tue, 01 Nov 2022 16:01:14 -0700
To:     mm-commits@vger.kernel.org, christophe.jaillet@wanadoo.fr,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-kstrtobool-instead-of-strtobool.patch added to mm-unstable branch
Message-Id: <20221101230115.42821C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use kstrtobool() instead of strtobool()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-kstrtobool-instead-of-strtobool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-kstrtobool-instead-of-strtobool.patch

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
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: mm: use kstrtobool() instead of strtobool()
Date: Tue, 1 Nov 2022 22:14:09 +0100

strtobool() is the same as kstrtobool().  However, the latter is more used
within the kernel.

In order to remove strtobool() and slightly simplify kstrtox.h, switch to
the other function name.

While at it, include the corresponding header file (<linux/kstrtox.h>)

Link: https://lkml.kernel.org/r/03f9401a6c8b87a1c786a2138d16b048f8d0eb53.1667336095.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |    3 ++-
 mm/usercopy.c         |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/mm/page_table_check.c~mm-use-kstrtobool-instead-of-strtobool
+++ a/mm/page_table_check.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2021, Google LLC.
  * Pasha Tatashin <pasha.tatashin@soleen.com>
  */
+#include <linux/kstrtox.h>
 #include <linux/mm.h>
 #include <linux/page_table_check.h>
 
@@ -23,7 +24,7 @@ EXPORT_SYMBOL(page_table_check_disabled)
 
 static int __init early_page_table_check_param(char *buf)
 {
-	return strtobool(buf, &__page_table_check_enabled);
+	return kstrtobool(buf, &__page_table_check_enabled);
 }
 
 early_param("page_table_check", early_page_table_check_param);
--- a/mm/usercopy.c~mm-use-kstrtobool-instead-of-strtobool
+++ a/mm/usercopy.c
@@ -12,6 +12,7 @@
 
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/kstrtox.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/sched/task.h>
@@ -258,7 +259,7 @@ static bool enable_checks __initdata = t
 
 static int __init parse_hardened_usercopy(char *str)
 {
-	if (strtobool(str, &enable_checks))
+	if (kstrtobool(str, &enable_checks))
 		pr_warn("Invalid option string for hardened_usercopy: '%s'\n",
 			str);
 	return 1;
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

mm-damon-use-kstrtobool-instead-of-strtobool.patch
mm-use-kstrtobool-instead-of-strtobool.patch

