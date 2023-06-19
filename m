Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EC9C001B3
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjFSX2V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjFSX2E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:28:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF5219AD
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:26:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC24561148
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD39C433C8;
        Mon, 19 Jun 2023 23:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217171;
        bh=EGkwDBChj/gG3SVDGLgSo4vKIdlG01LvgaU7IYx9XDM=;
        h=Date:To:From:Subject:From;
        b=MenJglYmeXz3yVZZiWsfiEw5bBnxoVUZ+id9U/bi3UrcP4zkQYyBzj0b1FZDsPNEN
         M3wHohivohNdTMQrjDewfOusoTw3IAUevazMipLAEQN3h5yNROv98kC8kuwl2LFWcd
         VxQU71XIdmI2DtTrTicrbjr68ZZvLBT2AfSlbGHA=
Date:   Mon, 19 Jun 2023 16:26:10 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, npiggin@gmail.com,
        mpe@ellerman.id.au, davem@davemloft.net,
        christophe.leroy@csgroup.eu, dianders@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-hardlockup-in-watchdog_hardlockup_check-use-cpumask_copy.patch removed from -mm tree
Message-Id: <20230619232611.4BD39C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/hardlockup: in watchdog_hardlockup_check() use cpumask_copy()
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-in-watchdog_hardlockup_check-use-cpumask_copy.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog/hardlockup: in watchdog_hardlockup_check() use cpumask_copy()
Date: Fri, 26 May 2023 18:41:34 -0700

In the patch ("watchdog/hardlockup: add a "cpu" param to
watchdog_hardlockup_check()") we started using a cpumask to keep track of
which CPUs to backtrace.  When setting up this cpumask, it's better to use
cpumask_copy() than to just copy the structure directly.  Fix this.

Link: https://lkml.kernel.org/r/20230526184139.4.Iccee2d1ea19114dafb6553a854ea4d8ab2a3f25b@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/watchdog.c~watchdog-hardlockup-in-watchdog_hardlockup_check-use-cpumask_copy
+++ a/kernel/watchdog.c
@@ -154,7 +154,9 @@ void watchdog_hardlockup_check(unsigned
 	 */
 	if (is_hardlockup(cpu)) {
 		unsigned int this_cpu = smp_processor_id();
-		struct cpumask backtrace_mask = *cpu_online_mask;
+		struct cpumask backtrace_mask;
+
+		cpumask_copy(&backtrace_mask, cpu_online_mask);
 
 		/* Only print hardlockups once. */
 		if (per_cpu(watchdog_hardlockup_warned, cpu))
_

Patches currently in -mm which might be from dianders@chromium.org are


