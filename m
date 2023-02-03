Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C930EC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbjBCGpr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbjBCGp1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:45:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0988D634
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:42:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0F19B8297E
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998C7C433D2;
        Fri,  3 Feb 2023 06:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406552;
        bh=e3oCMJUx9+mIOfwCIpClju2qEUm76QM9YV/sp/qBD3A=;
        h=Date:To:From:Subject:From;
        b=b4036LqUigtAIPCTfVI/FncSNUx5cp3T3Jn7bV2wKqmBaT1hWbLGSmi4NakszwnUA
         2Utk1cwL2FMEe3rF7nZkZx6AyM6CgtIMKwc51ZGyRkfvWHViYHUyyuQy/UDlU5oMNT
         mqsgY3ynf7Xx9vSd9NZMRFhqhanZM7wfSQEXZfYs=
Date:   Thu, 02 Feb 2023 22:42:32 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, geert+renesas@glider.be,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-add-dhrystone-benchmark-test-fix.patch removed from -mm tree
Message-Id: <20230203064232.998C7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib-add-dhrystone-benchmark-test-fix
has been removed from the -mm tree.  Its filename was
     lib-add-dhrystone-benchmark-test-fix.patch

This patch was dropped because it was folded into lib-add-dhrystone-benchmark-test.patch

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: lib-add-dhrystone-benchmark-test-fix
Date: Sun, 18 Dec 2022 10:51:59 +0100

fix uninitialized use of ret

Link: https://lkml.kernel.org/r/alpine.DEB.2.22.394.2212190857310.137329@ramsan.of.borg
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

