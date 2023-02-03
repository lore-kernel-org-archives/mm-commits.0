Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 200E2C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbjBCGuq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjBCGup (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:50:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6D71709
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:50:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A478A61CC8
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0345DC433D2;
        Fri,  3 Feb 2023 06:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407044;
        bh=7FZqxIIVuHcqEhWizsFxz84T63zVGKnMRYTXxlzsAmk=;
        h=Date:To:From:Subject:From;
        b=Bjdq0hwWky2zvIYcyDeB4e9yM9+VnzsK0AM0J6NtSagZECj4dSNIeLdfEX4ogPJ3S
         g2IrwoJnzSYHPDOvgcMbut4pIZIiV7u0vG5P44/sFmcuZ/7fKITjjmyBNSYpq4TdTM
         QDt6eOeg+SIuTpTohVQHDNXalnMyXYQ0mt4mkv34=
Date:   Thu, 02 Feb 2023 22:50:43 -0800
To:     mm-commits@vger.kernel.org, richard.henderson@linaro.org,
        mattst88@gmail.com, ink@jurassic.park.msu.ru, zeming@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-smp-remove-unnecessary-void-conversions.patch removed from -mm tree
Message-Id: <20230203065044.0345DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arch/alpha/kernel/smp.c: remove unnecessary (void*) conversions
has been removed from the -mm tree.  Its filename was
     kernel-smp-remove-unnecessary-void-conversions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li zeming <zeming@nfschina.com>
Subject: arch/alpha/kernel/smp.c: remove unnecessary (void*) conversions
Date: Tue, 13 Dec 2022 15:45:22 +0800

The void * type pointer does not need to be cast and assigned to another
pointer.

Link: https://lkml.kernel.org/r/20221213074522.3738-1-zeming@nfschina.com
Signed-off-by: Li zeming <zeming@nfschina.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/alpha/kernel/smp.c~kernel-smp-remove-unnecessary-void-conversions
+++ a/arch/alpha/kernel/smp.c
@@ -628,7 +628,7 @@ flush_tlb_all(void)
 static void
 ipi_flush_tlb_mm(void *x)
 {
-	struct mm_struct *mm = (struct mm_struct *) x;
+	struct mm_struct *mm = x;
 	if (mm == current->active_mm && !asn_locked())
 		flush_tlb_current(mm);
 	else
@@ -670,7 +670,7 @@ struct flush_tlb_page_struct {
 static void
 ipi_flush_tlb_page(void *x)
 {
-	struct flush_tlb_page_struct *data = (struct flush_tlb_page_struct *)x;
+	struct flush_tlb_page_struct *data = x;
 	struct mm_struct * mm = data->mm;
 
 	if (mm == current->active_mm && !asn_locked())
_

Patches currently in -mm which might be from zeming@nfschina.com are


