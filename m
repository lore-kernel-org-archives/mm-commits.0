Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EDB5E936F0
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244924AbjJDUXY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244943AbjJDUXI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435AFAD
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BA1C433CC;
        Wed,  4 Oct 2023 20:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450984;
        bh=ZTJkMcZ+LVTEwOneYeqm16pRRrt+6tXvO8En5c74Psw=;
        h=Date:To:From:Subject:From;
        b=0p4nFwwHi+VusDSmpgZfpo5re5JgPpRLxjQPW0Af9mdhYgfpYCl2zw8Ahg85jp4oF
         rD56tgDASSWSaBVRltWPl8x+lwiBM8hrH6VArCpkyAuFj/WbyLP6+oXhtW28xUF4+W
         3CmL24nCibIqLwA/YJTbpEle2kXo3LGhECiEVg48=
Date:   Wed, 04 Oct 2023 13:23:03 -0700
To:     mm-commits@vger.kernel.org, mark.rutland@arm.com,
        ubizjak@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic-v2.patch removed from -mm tree
Message-Id: <20231004202304.A5BA1C433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic-v2
has been removed from the -mm tree.  Its filename was
     panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic-v2.patch

This patch was dropped because it was folded into panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic.patch

------------------------------------------------------
From: Uros Bizjak <ubizjak@gmail.com>
Subject: panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic-v2
Date: Wed, 6 Sep 2023 21:11:28 +0200

clean up if/else block

Link: https://lkml.kernel.org/r/20230906191200.68707-1-ubizjak@gmail.com
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/panic.c~panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic-v2
+++ a/kernel/panic.c
@@ -321,9 +321,9 @@ void panic(const char *fmt, ...)
 	this_cpu = raw_smp_processor_id();
 
 	/* atomic_try_cmpxchg updates old_cpu on failure */
-	if (atomic_try_cmpxchg(&panic_cpu, &old_cpu, this_cpu))
-		;
-	else if (old_cpu != this_cpu)
+	if (atomic_try_cmpxchg(&panic_cpu, &old_cpu, this_cpu)) {
+		/* go ahead */
+	} else if (old_cpu != this_cpu)
 		panic_smp_self_stop();
 
 	console_verbose();
_

Patches currently in -mm which might be from ubizjak@gmail.com are

panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic.patch

