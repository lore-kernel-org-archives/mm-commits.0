Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89FCFC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 28 Nov 2022 21:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbiK1VRa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Nov 2022 16:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiK1VR3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2022 16:17:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95930BC1B
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 13:17:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3390261468
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 21:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6F6C433C1;
        Mon, 28 Nov 2022 21:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669670247;
        bh=e3PajOauPqDh/YjJVPLZ+JfclYpBU3LskFNnH/S8+e8=;
        h=Date:To:From:Subject:From;
        b=0vfiLFIcFGkZSmL+Xf4yUnHyzvomTi560f/9tf94dka6MQuOiKyMpDP2W/udw9nLj
         RaR4a8PJXKZAx4sc8hCtBnAjdXwsY4/15Zgv+iK/mg6EV6tkNwBbEWU7Q2KHKRzlWS
         XYswpVj2LcDyu/iLJGIGJjZv2+Uw4RrRy+5MCOks=
Date:   Mon, 28 Nov 2022 13:17:26 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] irqreturnh-fix-kernel-doc-warnings.patch removed from -mm tree
Message-Id: <20221128211727.7E6F6C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: irqreturn.h: fix kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     irqreturnh-fix-kernel-doc-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: irqreturn.h: fix kernel-doc warnings
Date: Wed, 23 Nov 2022 22:30:13 -0800

irqreturn.h:6: warning: missing initial short description on line:
 * enum irqreturn
irqreturn.h:15: warning: Enum value 'IRQ_NONE' not described in enum 'irqreturn'
irqreturn.h:15: warning: Enum value 'IRQ_HANDLED' not described in enum 'irqreturn'
irqreturn.h:15: warning: Enum value 'IRQ_WAKE_THREAD' not described in enum 'irqreturn'

Link: https://lkml.kernel.org/r/20221124063013.28479-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irqreturn.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/irqreturn.h~irqreturnh-fix-kernel-doc-warnings
+++ a/include/linux/irqreturn.h
@@ -3,10 +3,10 @@
 #define _LINUX_IRQRETURN_H
 
 /**
- * enum irqreturn
- * @IRQ_NONE		interrupt was not from this device or was not handled
- * @IRQ_HANDLED		interrupt was handled by this device
- * @IRQ_WAKE_THREAD	handler requests to wake the handler thread
+ * enum irqreturn - irqreturn type values
+ * @IRQ_NONE:		interrupt was not from this device or was not handled
+ * @IRQ_HANDLED:	interrupt was handled by this device
+ * @IRQ_WAKE_THREAD:	handler requests to wake the handler thread
  */
 enum irqreturn {
 	IRQ_NONE		= (0 << 0),
_

Patches currently in -mm which might be from rdunlap@infradead.org are

maple_tree-allow-test_maple_tree-only-when-debug_kernel-is-set.patch

