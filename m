Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7EEC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D0DC206F2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597194275;
	bh=yLtbW5r5zY/iIeWvJe3phWyuNnoarlTY94m4+f9rc6g=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=osTZN6a0H/20O0u26Ku1PQQe5Bc7/NVmX0kITriLkzfYu18TRg2byXrirFNjAS9F8
	 NySEZHml4Z7GP5yPNyWmGA3djE72D8kb32rgrAE7X6TQU/K4ltK/DgwQYsapVqbirO
	 uXlOHS/n6F8nUFQFtX/f8LJWaWnasBAvpg1JB/js=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgHLBEe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:04:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBEe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:04:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32915206B5;
        Wed, 12 Aug 2020 01:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597194274;
        bh=yLtbW5r5zY/iIeWvJe3phWyuNnoarlTY94m4+f9rc6g=;
        h=Date:From:To:Subject:From;
        b=HZvZb4ur5v2lCdfrwNeqcgloDHQbBznjOdrTxGFG7/sE8ClDaCNliMdBYHe2lxGLG
         pHCmN7Vm4YzrVD0l3qzxK8MH9qlToR2ran2Pyu97wHQR5LQqOIUzHPJQjEDknmQPFN
         1VQExFH/0UoOb0zK4uOja94GlDvvoaDgXD74KfLo=
Date:   Tue, 11 Aug 2020 18:04:33 -0700
From:   akpm@linux-foundation.org
To:     andy.shevchenko@gmail.com, mm-commits@vger.kernel.org,
        rd.dunlap@gmail.com, rikard.falkeborn@gmail.com
Subject:  [folded-merged] bits-add-tests-of-genmask-fix.patch
 removed from -mm tree
Message-ID: <20200812010433.TlZOyOtZI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_bits: add MODULE_LICENSE()
has been removed from the -mm tree.  Its filename was
     bits-add-tests-of-genmask-fix.patch

This patch was dropped because it was folded into bits-add-tests-of-genmask.patch

------------------------------------------------------
From: Randy Dunlap <rd.dunlap@gmail.com>
Subject: lib/test_bits: add MODULE_LICENSE()

Add MODULE_LICENSE() to prevent build warning:

WARNING: modpost: missing MODULE_LICENSE() in lib/test_bits.o

Link: http://lkml.kernel.org/r/dfc74524-0789-2827-4eff-476ddab65699@gmail.com
Signed-off-by: Randy Dunlap <rd.dunlap@gmail.com>
Cc: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bits.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/test_bits.c~bits-add-tests-of-genmask-fix
+++ a/lib/test_bits.c
@@ -71,3 +71,5 @@ static struct kunit_suite bits_test_suit
 	.test_cases = bits_test_cases,
 };
 kunit_test_suite(bits_test_suite);
+
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from rd.dunlap@gmail.com are

bits-add-tests-of-genmask.patch

