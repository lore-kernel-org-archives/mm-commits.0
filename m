Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23638C71153
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 20:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjIJUv7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 16:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjIJUv7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 16:51:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D06E18B
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 13:51:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B3EC433C8;
        Sun, 10 Sep 2023 20:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694379115;
        bh=UGF79IH8BqDXJwCyMCE7AqUpXJ6RAfx2oxNFoHE5A10=;
        h=Date:To:From:Subject:From;
        b=sWrRReUIpSA70fLtsyFi+qfLexo690kqXqQg+NlwwX4IaciCFMTlFwjtzyrAMeOBN
         IpEJnMdSXNXcX0zK2Uu7zZlfSdkhJWMfXfLCcsOxKH/icGdnlizl7DjRa0b2uzjc9L
         mDhmBL58588ZB3e2LAdU/NNQSoHx+BQKlPq27Gfc=
Date:   Sun, 10 Sep 2023 13:51:54 -0700
To:     mm-commits@vger.kernel.org, mark.rutland@arm.com,
        ubizjak@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic-v2.patch added to mm-nonmm-unstable branch
Message-Id: <20230910205155.17B3EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic-v2
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic-v2.patch

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

mm-vmstat-use-this_cpu_try_cmpxchg-in-mod_zonenode_state.patch
panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic.patch
panic-use-atomic_try_cmpxchg-in-panic-and-nmi_panic-v2.patch

