Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF64C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 22:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiLOW0M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 17:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLOW0L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 17:26:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D494730D
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 14:26:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6837ECE1CF6
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 22:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742A9C433EF;
        Thu, 15 Dec 2022 22:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671143166;
        bh=hTZ6MR1oQcj5ILaCgJtWk9QANTzw9bck3Uj9lifqaNo=;
        h=Date:To:From:Subject:From;
        b=Et8pUpjjwNcyq/60uzL7kuVn8giX6HloobeqsTF333+lmwVaDxcsrQkWHguabE39s
         Wuf5i+a57ALHkMBE4nqTtsE6kpgY8l2AP6uT2nhCdbXXEZch21cB4ntsQxfubpnKm7
         f8jjlen8BKnk+35IqEGA2wTaShjD+XdTau4HzauQ=
Date:   Thu, 15 Dec 2022 14:26:05 -0800
To:     mm-commits@vger.kernel.org, richard.henderson@linaro.org,
        mattst88@gmail.com, ink@jurassic.park.msu.ru, zeming@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-smp-remove-unnecessary-void-conversions.patch added to mm-nonmm-unstable branch
Message-Id: <20221215222606.742A9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/alpha/kernel/smp.c: remove unnecessary (void*) conversions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-smp-remove-unnecessary-void-conversions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-smp-remove-unnecessary-void-conversions.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

 arch/alpha/kernel/smp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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

kernel-smp-remove-unnecessary-void-conversions.patch

