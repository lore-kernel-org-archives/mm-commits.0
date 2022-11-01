Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D66FDECAAA1
	for <mm-commits@archiver.kernel.org>; Tue,  1 Nov 2022 00:13:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiKAANa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Oct 2022 20:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiKAAN3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2022 20:13:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222AD12620
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 17:13:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 00B9FCE1898
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 00:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005CDC433D6;
        Tue,  1 Nov 2022 00:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667261602;
        bh=Sbq85KcDt7srxZarh8xf/ITikC71ivDWovECjy7AGp8=;
        h=Date:To:From:Subject:From;
        b=XkBLFkhLSJKoKoPCmx9OkENn3/xhxo1OnM4gticE0FD8UXc448ACTG1P/Cd8PZP57
         fD72JepXYgeuIqtqIdqc9lPHKejjaLP8yWdw1wtThpDRDDxexD5FcFG0HjLp4PKsUR
         V3R95nJaFimecOmAmINwyZ5x0x4dYJqxQJvLEk94=
Date:   Mon, 31 Oct 2022 17:13:21 -0700
To:     mm-commits@vger.kernel.org, Chao.Xu9@zeekrlife.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-correct-some-wrong-comments-based-on-fls.patch added to mm-unstable branch
Message-Id: <20221101001322.005CDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: correct some wrong comments based-on fls()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmstat-correct-some-wrong-comments-based-on-fls.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-correct-some-wrong-comments-based-on-fls.patch

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
From: Chao Xu <Chao.Xu9@zeekrlife.com>
Subject: mm/vmstat: correct some wrong comments based-on fls()
Date: Sat, 29 Oct 2022 12:44:36 +0800

The threshold should grow logarithmically, using fls() as an easy
approximation.  But there are some errors in fls(mem) and fls(Processors).
It is misleading so let's correct it.

Link: https://lkml.kernel.org/r/20221029044436.198169-1-xuchao066@163.com
Signed-off-by: Chao Xu <Chao.Xu9@zeekrlife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/vmstat.c~mm-vmstat-correct-some-wrong-comments-based-on-fls
+++ a/mm/vmstat.c
@@ -241,17 +241,17 @@ int calculate_normal_threshold(struct zo
 	 * 28		2		2	4-8 GB		7
 	 * 32		2		2	8-16 GB		8
 	 * 4		2		2	<128M		1
-	 * 30		4		3	2-4 GB		5
+	 * 30		4		3	2-4 GB		6
 	 * 48		4		3	8-16 GB		8
-	 * 32		8		4	1-2 GB		4
+	 * 32		8		4	1-2 GB		5
 	 * 32		8		4	0.9-1GB		4
 	 * 10		16		5	<128M		1
 	 * 40		16		5	900M		4
-	 * 70		64		7	2-4 GB		5
-	 * 84		64		7	4-8 GB		6
-	 * 108		512		9	4-8 GB		6
-	 * 125		1024		10	8-16 GB		8
-	 * 125		1024		10	16-32 GB	9
+	 * 70		64		7	2-4 GB		6
+	 * 84		64		7	4-8 GB		7
+	 * 108		512		10	4-8 GB		7
+	 * 125		1024		11	8-16 GB		8
+	 * 125		1024		11	16-32 GB	9
 	 */
 
 	mem = zone_managed_pages(zone) >> (27 - PAGE_SHIFT);
_

Patches currently in -mm which might be from Chao.Xu9@zeekrlife.com are

mm-vmstat-correct-some-wrong-comments-based-on-fls.patch

