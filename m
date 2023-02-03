Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A7AC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbjBCGut (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbjBCGus (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:50:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC415B8A
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:50:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63149B82981
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06313C4339B;
        Fri,  3 Feb 2023 06:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407045;
        bh=dA4AB9HsLbPQUV56QdKSrXSUgNysWbpvbzuDZaGVHFw=;
        h=Date:To:From:Subject:From;
        b=A9WxDCnN7GLNjdPXM3WretiLWeQPPKq5TiloNFlHfIjr26r0VXVQnknNnE+TCpfUn
         FDERYDZ8oARlaIZiL78eLHKSATubSR/KJmxJ5JqTmEkpFM4LxkvRgZz3R1o+xSbFBl
         w9fdCpbMkZ7qE0YchG1IJyCUcSAD8xzYLeAjbNP8=
Date:   Thu, 02 Feb 2023 22:50:44 -0800
To:     mm-commits@vger.kernel.org, richard.henderson@linaro.org,
        mattst88@gmail.com, ink@jurassic.park.msu.ru,
        ebiederm@xmission.com, zeming@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-process-remove-unnecessary-void-conversions.patch removed from -mm tree
Message-Id: <20230203065045.06313C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arch/alpha/kernel/process.c: remove unnecessary (void*) conversions
has been removed from the -mm tree.  Its filename was
     kernel-process-remove-unnecessary-void-conversions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li zeming <zeming@nfschina.com>
Subject: arch/alpha/kernel/process.c: remove unnecessary (void*) conversions
Date: Tue, 13 Dec 2022 15:36:33 +0800

generic_ptr is a void * type and does not require a cast.

Link: https://lkml.kernel.org/r/20221213073633.3586-1-zeming@nfschina.com
Signed-off-by: Li zeming <zeming@nfschina.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/alpha/kernel/process.c~kernel-process-remove-unnecessary-void-conversions
+++ a/arch/alpha/kernel/process.c
@@ -74,7 +74,7 @@ struct halt_info {
 static void
 common_shutdown_1(void *generic_ptr)
 {
-	struct halt_info *how = (struct halt_info *)generic_ptr;
+	struct halt_info *how = generic_ptr;
 	struct percpu_struct *cpup;
 	unsigned long *pflags, flags;
 	int cpuid = smp_processor_id();
_

Patches currently in -mm which might be from zeming@nfschina.com are


