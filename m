Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92459C43217
	for <mm-commits@archiver.kernel.org>; Thu, 24 Nov 2022 22:24:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiKXWYV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Nov 2022 17:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiKXWYU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Nov 2022 17:24:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47277F5A7
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 14:24:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C225B82932
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 22:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30988C433D7;
        Thu, 24 Nov 2022 22:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669328657;
        bh=jpuFkhe+hjGBSkvmqmaFrAUFS1XYhOEmUwPV42mbisI=;
        h=Date:To:From:Subject:From;
        b=Yec3eRqQBC5Apd/SWdbZOLTpRP7PBK+GG6XMj31WiloHUggZXQT+a6QftJRGL5oGU
         K+XTXqcLSn6O5by6cFhj2YDkvTxtYpVsohWOYJQZVB/GIbijyqrzw3Sl/wG98y0MSX
         tLrH3oFJsQhFY5JaN3tOYuhwPrZELkM9Iojn+LAM=
Date:   Thu, 24 Nov 2022 14:24:16 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + irqreturnh-fix-kernel-doc-warnings.patch added to mm-nonmm-unstable branch
Message-Id: <20221124222417.30988C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: irqreturn.h: fix kernel-doc warnings
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     irqreturnh-fix-kernel-doc-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/irqreturnh-fix-kernel-doc-warnings.patch

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
irqreturnh-fix-kernel-doc-warnings.patch

