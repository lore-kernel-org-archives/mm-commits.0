Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A06FEB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjFSX2X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjFSX2E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:28:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15441BF1
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:26:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F093610A2
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990F9C433C0;
        Mon, 19 Jun 2023 23:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217174;
        bh=kAAVwayPChwDLTNwTpohZlmJXPNCAC+eUrdZuVaSUPo=;
        h=Date:To:From:Subject:From;
        b=Rn48hMS3GoBEi4BjmHxXxDxVn5MtwpTDT1iNf6Vgi3b3Y9KalnTkzf2aTyK0iEAx4
         /7jS6Hcyv8b9/ggPO8JSYWTWBzMs3RroezBHvcFSjUd/t8uKohoqBkmv7GnFuk2pjX
         Sve+biXfgD2gRXXDhIbZsUbUdi6vf+lnA/JsyxXI=
Date:   Mon, 19 Jun 2023 16:26:14 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, npiggin@gmail.com,
        mpe@ellerman.id.au, davem@davemloft.net,
        christophe.leroy@csgroup.eu, dianders@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-buddy-dont-copy-the-cpumask-in-watchdog_next_cpu.patch removed from -mm tree
Message-Id: <20230619232614.990F9C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/buddy: don't copy the cpumask in watchdog_next_cpu()
has been removed from the -mm tree.  Its filename was
     watchdog-buddy-dont-copy-the-cpumask-in-watchdog_next_cpu.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog/buddy: don't copy the cpumask in watchdog_next_cpu()
Date: Fri, 26 May 2023 18:41:37 -0700

There's no reason to make a copy of the "watchdog_cpus" locally in
watchdog_next_cpu().  Making a copy wouldn't make things any more race
free and we're just reading the value so there's no need for a copy.

Link: https://lkml.kernel.org/r/20230526184139.7.If466f9a2b50884cbf6a1d8ad05525a2c17069407@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog_buddy.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/watchdog_buddy.c~watchdog-buddy-dont-copy-the-cpumask-in-watchdog_next_cpu
+++ a/kernel/watchdog_buddy.c
@@ -10,12 +10,11 @@ static cpumask_t __read_mostly watchdog_
 
 static unsigned int watchdog_next_cpu(unsigned int cpu)
 {
-	cpumask_t cpus = watchdog_cpus;
 	unsigned int next_cpu;
 
-	next_cpu = cpumask_next(cpu, &cpus);
+	next_cpu = cpumask_next(cpu, &watchdog_cpus);
 	if (next_cpu >= nr_cpu_ids)
-		next_cpu = cpumask_first(&cpus);
+		next_cpu = cpumask_first(&watchdog_cpus);
 
 	if (next_cpu == cpu)
 		return nr_cpu_ids;
_

Patches currently in -mm which might be from dianders@chromium.org are


