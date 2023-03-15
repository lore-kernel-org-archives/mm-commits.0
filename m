Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F223C74A5B
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 19:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjCOT1p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 15:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjCOT1N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 15:27:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1551CF5D
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 12:27:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A52BDB81F0D
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 19:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C928C433D2;
        Wed, 15 Mar 2023 19:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678908428;
        bh=IlLcAbszshuV+XOwBPBs2i2Id0zaMGwSh5Jq/qjHmGg=;
        h=Date:To:From:Subject:From;
        b=EMcX08VIeHwFWzvS1e2HSE5uG7v3DUOVyyZz3aDU6vtn5asXM9Rl1MzmqN6/7P+ok
         iTnEGf9BTPLjEIH3+rhzTvXgSSwWF77j33EAnMT98CoFvj0yc3PZLZV6maMSSVcKgb
         Ry813/fXf7fJDV5KhxUMs+ncnk3KYZFDddMpv3Ek=
Date:   Wed, 15 Mar 2023 12:27:07 -0700
To:     mm-commits@vger.kernel.org, klausman@schwarzvogel.de,
        geert+renesas@glider.be, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-dhry-fix-unstable-smp_processor_id_-usage.patch added to mm-hotfixes-unstable branch
Message-Id: <20230315192708.4C928C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: dhry: fix unstable smp_processor_id(_) usage
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-dhry-fix-unstable-smp_processor_id_-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-dhry-fix-unstable-smp_processor_id_-usage.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: lib: dhry: fix unstable smp_processor_id(_) usage
Date: Wed, 15 Mar 2023 15:28:17 +0100

When running the in-kernel Dhrystone benchmark with
CONFIG_DEBUG_PREEMPT=y:

    BUG: using smp_processor_id() in preemptible [00000000] code: bash/938

Fix this by not using smp_processor_id() directly, but instead wrapping
the whole benchmark inside a get_cpu()/put_cpu() pair.  This makes sure
the whole benchmark is run on the same CPU core, and the reported values
are consistent.

Link: https://lkml.kernel.org/r/b0d29932bb24ad82cea7f821e295c898e9657be0.1678890070.git.geert+renesas@glider.be
Fixes: d5528cc16893f1f6 ("lib: add Dhrystone benchmark test")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reported-by: Tobias Klausmann <klausman@schwarzvogel.de>
  Link: https://bugzilla.kernel.org/show_bug.cgi?id=217179
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dhry_run.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/lib/dhry_run.c~lib-dhry-fix-unstable-smp_processor_id_-usage
+++ a/lib/dhry_run.c
@@ -31,6 +31,7 @@ MODULE_PARM_DESC(iterations,
 
 static void dhry_benchmark(void)
 {
+	unsigned int cpu = get_cpu();
 	int i, n;
 
 	if (iterations > 0) {
@@ -45,9 +46,10 @@ static void dhry_benchmark(void)
 	}
 
 report:
+	put_cpu();
 	if (n >= 0)
-		pr_info("CPU%u: Dhrystones per Second: %d (%d DMIPS)\n",
-			smp_processor_id(), n, n / DHRY_VAX);
+		pr_info("CPU%u: Dhrystones per Second: %d (%d DMIPS)\n", cpu,
+			n, n / DHRY_VAX);
 	else if (n == -EAGAIN)
 		pr_err("Please increase the number of iterations\n");
 	else
_

Patches currently in -mm which might be from geert+renesas@glider.be are

lib-dhry-fix-unstable-smp_processor_id_-usage.patch

