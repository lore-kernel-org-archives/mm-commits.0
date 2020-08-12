Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4342C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7CAE2078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266244;
	bh=7C/ejomiz/hX7kl1e9HkqA7hk8Tz6208tM5FSnTdQ1I=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=oNxIEdZF3CalqGjWyemYJhoR0+1W+O+gY5ZkM0rY92mNBys3VUBRRMYML5wZGpDgP
	 RKpnvS10KoVPUE30/xOKnf+EJP8TQjbHcXa3v8HiqT9iXU9qsqMeKPmOQFvo9MRcFp
	 1V8rrxR/Tl4WZ+b+0W6QTnz6IQUW5VYB+g0G1YAI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgHLVEE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbgHLVEE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:04:04 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85F0520774;
        Wed, 12 Aug 2020 21:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266243;
        bh=7C/ejomiz/hX7kl1e9HkqA7hk8Tz6208tM5FSnTdQ1I=;
        h=Date:From:To:Subject:From;
        b=r96Tdrazhv9dYRox1ZBVz0nZkwWq5HHXFYHNPksmOErLx5fOYEqj5k7xC4etEXlDL
         3YD+HeAvQGZUHj/MC2H8XHcr67kPj8TaoUoECWoH75DJRTUSZioRAO4ZlRnJn8VPc6
         qaMr3Gf0VVD/d8JQ1rg9DJWYMZvjd8TUXdZdBrXU=
Date:   Wed, 12 Aug 2020 14:04:03 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, geert@linux-m68k.org,
        jesse.brandeburg@intel.com, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com
Subject:  [merged]
 lib-test_bitops-do-the-full-test-during-module-init.patch removed from -mm
 tree
Message-ID: <20200812210403.qb17VVi5O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_bitops: do the full test during module init
has been removed from the -mm tree.  Its filename was
     lib-test_bitops-do-the-full-test-during-module-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: lib/test_bitops: do the full test during module init

Currently, the bitops test consists of two parts: one part is executed
during module load, the second part during module unload.  This is
cumbersome for the user, as he has to perform two steps to execute all
tests, and is different from most (all?) other tests.

Merge the two parts, so both are executed during module load.

Link: http://lkml.kernel.org/r/20200706112900.7097-1-geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitops.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/lib/test_bitops.c~lib-test_bitops-do-the-full-test-during-module-init
+++ a/lib/test_bitops.c
@@ -52,9 +52,9 @@ static unsigned long order_comb_long[][2
 
 static int __init test_bitops_startup(void)
 {
-	int i;
+	int i, bit_set;
 
-	pr_warn("Loaded test module\n");
+	pr_info("Starting bitops test\n");
 	set_bit(BITOPS_4, g_bitmap);
 	set_bit(BITOPS_7, g_bitmap);
 	set_bit(BITOPS_11, g_bitmap);
@@ -81,12 +81,8 @@ static int __init test_bitops_startup(vo
 				       order_comb_long[i][0]);
 	}
 #endif
-	return 0;
-}
 
-static void __exit test_bitops_unstartup(void)
-{
-	int bit_set;
+	barrier();
 
 	clear_bit(BITOPS_4, g_bitmap);
 	clear_bit(BITOPS_7, g_bitmap);
@@ -98,7 +94,13 @@ static void __exit test_bitops_unstartup
 	if (bit_set != BITOPS_LAST)
 		pr_err("ERROR: FOUND SET BIT %d\n", bit_set);
 
-	pr_warn("Unloaded test module\n");
+	pr_info("Completed bitops test\n");
+
+	return 0;
+}
+
+static void __exit test_bitops_unstartup(void)
+{
 }
 
 module_init(test_bitops_startup);
_

Patches currently in -mm which might be from geert@linux-m68k.org are


