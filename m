Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFB3EB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbjFSX2U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjFSX2E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:28:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D86919AB
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:26:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7D8461142
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6ACC433C8;
        Mon, 19 Jun 2023 23:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217170;
        bh=FmZzswpDwbIVd08HKXAurpz5wItdHoc7L/LPDyAmbzs=;
        h=Date:To:From:Subject:From;
        b=JIIbN2MKn4h6lQ/fZIpSPABUWpGh6Ju4HCTeG8bfsnm3j0ruwlwuTEcQ75hkjd6AC
         g8CnZutdAObzQ5kB2QY9ULaWnCsWH98mxlsHLkahpkD1TeZM274p88PRn3SV4bL58a
         9C9we3VyRmVupZqUt/i4oB1XNDnVqvvUcoZ0mkF4=
Date:   Mon, 19 Jun 2023 16:26:09 -0700
To:     mm-commits@vger.kernel.org, pmladek@suse.com, npiggin@gmail.com,
        mpe@ellerman.id.au, davem@davemloft.net,
        christophe.leroy@csgroup.eu, dianders@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-hardlockup-dont-use-raw_cpu_ptr-in-watchdog_hardlockup_kick.patch removed from -mm tree
Message-Id: <20230619232610.3E6ACC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: watchdog/hardlockup: don't use raw_cpu_ptr() in watchdog_hardlockup_kick()
has been removed from the -mm tree.  Its filename was
     watchdog-hardlockup-dont-use-raw_cpu_ptr-in-watchdog_hardlockup_kick.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: watchdog/hardlockup: don't use raw_cpu_ptr() in watchdog_hardlockup_kick()
Date: Fri, 26 May 2023 18:41:33 -0700

In the patch ("watchdog/hardlockup: add a "cpu" param to
watchdog_hardlockup_check()") there was no reason to use raw_cpu_ptr(). 
Using this_cpu_ptr() works fine.

Link: https://lkml.kernel.org/r/20230526184139.3.I660e103077dcc23bb29aaf2be09cb234e0495b2d@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/watchdog.c~watchdog-hardlockup-dont-use-raw_cpu_ptr-in-watchdog_hardlockup_kick
+++ a/kernel/watchdog.c
@@ -133,7 +133,7 @@ static bool is_hardlockup(unsigned int c
 
 static unsigned long watchdog_hardlockup_kick(void)
 {
-	return atomic_inc_return(raw_cpu_ptr(&hrtimer_interrupts));
+	return atomic_inc_return(this_cpu_ptr(&hrtimer_interrupts));
 }
 
 void watchdog_hardlockup_check(unsigned int cpu, struct pt_regs *regs)
_

Patches currently in -mm which might be from dianders@chromium.org are


