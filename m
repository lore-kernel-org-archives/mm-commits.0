Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 867F7C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbiKOWdA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbiKOWcW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:32:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303835FDB
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D612DB81B87
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F125C433D7;
        Tue, 15 Nov 2022 22:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551539;
        bh=u5IMUaMM33N1B4usrkv/vMaySXDY+f3XZxfQLaTIcPM=;
        h=Date:To:From:Subject:From;
        b=MMGtIGtM1Th9ROeB9wnMP+PbGcpbWDReyTwuZs4acHBJ7vNHDIQNH8nyTzsxHcqLn
         CE4qOEXjXsFX14Uct+BppjO3o2N2FC75kFaKNMNvPCk1vrl+Fi7/QLKuwiYYwmx9b+
         QeuWmL/aDmev/6ak4MgTFjPyuRMwAGLd30RS/VXU=
Date:   Tue, 15 Nov 2022 14:32:19 -0800
To:     mm-commits@vger.kernel.org, bhelgaas@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ia64-remove-unused-__slow_down_io-and-slow_down_io-definitions.patch removed from -mm tree
Message-Id: <20221115223219.7F125C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ia64: remove unused __SLOW_DOWN_IO and SLOW_DOWN_IO definitions
has been removed from the -mm tree.  Its filename was
     ia64-remove-unused-__slow_down_io-and-slow_down_io-definitions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bjorn Helgaas <bhelgaas@google.com>
Subject: ia64: remove unused __SLOW_DOWN_IO and SLOW_DOWN_IO definitions
Date: Thu, 13 Oct 2022 19:19:10 -0500

Remove unused __SLOW_DOWN_IO and SLOW_DOWN_IO definitions.

Link: https://lkml.kernel.org/r/20221014001911.3342485-3-helgaas@kernel.org
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/io.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/ia64/include/asm/io.h~ia64-remove-unused-__slow_down_io-and-slow_down_io-definitions
+++ a/arch/ia64/include/asm/io.h
@@ -23,10 +23,6 @@
 #include <asm/unaligned.h>
 #include <asm/early_ioremap.h>
 
-/* We don't use IO slowdowns on the ia64, but.. */
-#define __SLOW_DOWN_IO	do { } while (0)
-#define SLOW_DOWN_IO	do { } while (0)
-
 #define __IA64_UNCACHED_OFFSET	RGN_BASE(RGN_UNCACHED)
 
 /*
_

Patches currently in -mm which might be from bhelgaas@google.com are


