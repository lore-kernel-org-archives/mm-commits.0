Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3082CC77B60
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 01:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCWBdv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Mar 2023 21:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbjCWBdb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Mar 2023 21:33:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C6F423C
        for <mm-commits@vger.kernel.org>; Wed, 22 Mar 2023 18:33:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B0FEFCE1F88
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 01:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0E0C433EF;
        Thu, 23 Mar 2023 01:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679535144;
        bh=lbN7t9aWtefSOQtYqaVXOc18fOhlzUzARGdTI+6f5ZY=;
        h=Date:To:From:Subject:From;
        b=sm9spmzKU1DFXYlaxtgtGDMhG7xNDTZUhGSTE9EGuZdCMGwwhOVGreiygxUZIEOB+
         Ah74q/UxDtVHcOqj7Mk3SnqUiTOXlylo4QqCXWPbNUJ9AKRGClko4byZM0isJJWjl0
         zazYvkk2hZMXBGxtZJnRSR3DQxkjThhRxfxVdqWc=
Date:   Wed, 22 Mar 2023 18:32:23 -0700
To:     mm-commits@vger.kernel.org, klausman@schwarzvogel.de,
        geert+renesas@glider.be, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-dhry-fix-unstable-smp_processor_id_-usage.patch removed from -mm tree
Message-Id: <20230323013224.3B0E0C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib: dhry: fix unstable smp_processor_id(_) usage
has been removed from the -mm tree.  Its filename was
     lib-dhry-fix-unstable-smp_processor_id_-usage.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


