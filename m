Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 342D3C47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiLAAB7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiLAAAx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD9A88B4E
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60F72614D0
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC6CC43470;
        Thu,  1 Dec 2022 00:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852846;
        bh=NZ8am+CnVEVu+LTNsYXXuleWkISvkoKbOBuYF4V3wj0=;
        h=Date:To:From:Subject:From;
        b=yKRoi4VifDChSo3qcH5pnfl5X47Zt7X0yrIQyxqdmU9hbQ1m1Ke5ibGH4DUWIo1D1
         hW0r+Efv1nxiROFoHVp5N2BPXeehgzEAlFDNiGpDafNMwDh6N39rrzhK6LLQqvmIP/
         PKK4mo56inN1xgtA9mAOld7UHL4VIQVUWqryJb4M=
Date:   Wed, 30 Nov 2022 16:00:45 -0800
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        christophe.jaillet@wanadoo.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-kstrtobool-instead-of-strtobool.patch removed from -mm tree
Message-Id: <20221201000046.8CC6CC43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use kstrtobool() instead of strtobool()
has been removed from the -mm tree.  Its filename was
     mm-use-kstrtobool-instead-of-strtobool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
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

io-mapping-move-some-code-within-the-include-guarded-section.patch

