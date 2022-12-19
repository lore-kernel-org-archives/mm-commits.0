Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2393AC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 19 Dec 2022 22:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbiLSWLp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Dec 2022 17:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbiLSWKr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2022 17:10:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE9DE54
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2022 14:10:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8C4C61152
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2022 22:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABAEC433D2;
        Mon, 19 Dec 2022 22:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671487845;
        bh=qoWflZLozNvk95ZiO5bo+soLE2gm9EB0no6ABzL7210=;
        h=Date:To:From:Subject:From;
        b=urCWimQU4WrEU8zVHR7ppMiTPd1t56T1zatltrgM/9rl65xdxZpiWcUShiZYRmL4F
         YZxJHHjySzbrerQl8LPsK2yMfF38W/BHNCpzCpVFWalg00lHQHlphHi79lUExmV2fe
         PTOVM5FOIsNj/KrnwaoHU3NugYP/u04QHef+il2Q=
Date:   Mon, 19 Dec 2022 14:10:44 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, geert+renesas@glider.be,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-add-dhrystone-benchmark-test-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20221219221045.0ABAEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Date: Sun, 18 Dec 2022 10:51:59 +0100
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-add-dhrystone-benchmark-test-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-add-dhrystone-benchmark-test-fix.patch

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
From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Sun, 18 Dec 2022 10:51:59 +0100
Subject: lib-add-dhrystone-benchmark-test-fix

fix uninitialized use of ret

Link: https://lkml.kernel.org/r/alpine.DEB.2.22.394.2212190857310.137329@ramsan.of.borg
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dhry_run.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/dhry_run.c~lib-add-dhrystone-benchmark-test-fix
+++ a/lib/dhry_run.c
@@ -69,7 +69,7 @@ static int dhry_run_set(const char *val,
 	if (dhry_run && system_state == SYSTEM_RUNNING)
 		dhry_benchmark();
 
-	return ret;
+	return 0;
 }
 
 static int __init dhry_init(void)
_

Patches currently in -mm which might be from geert+renesas@glider.be are

lib-add-dhrystone-benchmark-test.patch
lib-add-dhrystone-benchmark-test-fix.patch

