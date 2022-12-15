Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A18C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 22:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiLOW0y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 17:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLOW0x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 17:26:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61FA49B53
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 14:26:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 716DC61F5A
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 22:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6910C433D2;
        Thu, 15 Dec 2022 22:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671143211;
        bh=B73W1SIKTzuxoSjQGFQyk4MwVs79otoN/U59qF4aYYM=;
        h=Date:To:From:Subject:From;
        b=o7lDIAZ6aXwnAVMprZjvr54y5b5bA3MDkLERcJX0Iqf4NrWr6cNDKfi2MwLs44avE
         oaydKJKmHokVlIIhhyAeWx72KlzFYOCEvemvwZloXgBmvUCBeqz+kBzR1iny9qh2tT
         L7BYXYRrQIks/ST0iQ6g3x/yhKWILDfkjdNctwPk=
Date:   Thu, 15 Dec 2022 14:26:51 -0800
To:     mm-commits@vger.kernel.org, richard.henderson@linaro.org,
        mattst88@gmail.com, ink@jurassic.park.msu.ru,
        ebiederm@xmission.com, zeming@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-process-remove-unnecessary-void-conversions.patch added to mm-nonmm-unstable branch
Message-Id: <20221215222651.C6910C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/alpha/kernel/process.c: remove unnecessary (void*) conversions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-process-remove-unnecessary-void-conversions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-process-remove-unnecessary-void-conversions.patch

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

 arch/alpha/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

kernel-smp-remove-unnecessary-void-conversions.patch
kernel-process-remove-unnecessary-void-conversions.patch

