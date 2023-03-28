Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE22C77B6C
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:23:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjC1XXd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjC1XWM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:22:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA1230EB
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:22:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52854B81EEC
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036E2C433D2;
        Tue, 28 Mar 2023 23:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045728;
        bh=28ff74T65Vrc8bO350aiNu/scj9lCU7jBG1m1+6bFBw=;
        h=Date:To:From:Subject:From;
        b=srFyAANte+Hob26tGU5XZg5i8QQQp3x6rbKpsGwji39KyLx+H6VeOnZcajriTKDdr
         DyjML2hmIOWR/mBHJvzmI27eGYrqj3T/NcwjMEsYpBFH+oHb5GviICe0sbcB9l+5s9
         M18V/iONKLLyshhFQMQCyXwGeZQA6DfxHe07Tkx0=
Date:   Tue, 28 Mar 2023 16:22:07 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        richard.weinberger@gmail.com, bigeasy@linutronix.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] io-mapping-dont-disable-preempt-on-rt-in-io_mapping_map_atomic_wc.patch removed from -mm tree
Message-Id: <20230328232208.036E2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: io-mapping: don't disable preempt on RT in io_mapping_map_atomic_wc()
has been removed from the -mm tree.  Its filename was
     io-mapping-dont-disable-preempt-on-rt-in-io_mapping_map_atomic_wc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: io-mapping: don't disable preempt on RT in io_mapping_map_atomic_wc().
Date: Fri, 10 Mar 2023 17:29:05 +0100

io_mapping_map_atomic_wc() disables preemption and pagefaults for
historical reasons.  The conversion to io_mapping_map_local_wc(), which
only disables migration, cannot be done wholesale because quite some call
sites need to be updated to accommodate with the changed semantics.

On PREEMPT_RT enabled kernels the io_mapping_map_atomic_wc() semantics are
problematic due to the implicit disabling of preemption which makes it
impossible to acquire 'sleeping' spinlocks within the mapped atomic
sections.

PREEMPT_RT replaces the preempt_disable() with a migrate_disable() for
more than a decade.  It could be argued that this is a justification to do
this unconditionally, but PREEMPT_RT covers only a limited number of
architectures and it disables some functionality which limits the coverage
further.

Limit the replacement to PREEMPT_RT for now.  This is also done
kmap_atomic().

Link: https://lkml.kernel.org/r/20230310162905.O57Pj7hh@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reported-by: Richard Weinberger <richard.weinberger@gmail.com>
  Link: https://lore.kernel.org/CAFLxGvw0WMxaMqYqJ5WgvVSbKHq2D2xcXTOgMCpgq9nDC-MWTQ@mail.gmail.com
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/io-mapping.h |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/include/linux/io-mapping.h~io-mapping-dont-disable-preempt-on-rt-in-io_mapping_map_atomic_wc
+++ a/include/linux/io-mapping.h
@@ -69,7 +69,10 @@ io_mapping_map_atomic_wc(struct io_mappi
 
 	BUG_ON(offset >= mapping->size);
 	phys_addr = mapping->base + offset;
-	preempt_disable();
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
+	else
+		migrate_disable();
 	pagefault_disable();
 	return __iomap_local_pfn_prot(PHYS_PFN(phys_addr), mapping->prot);
 }
@@ -79,7 +82,10 @@ io_mapping_unmap_atomic(void __iomem *va
 {
 	kunmap_local_indexed((void __force *)vaddr);
 	pagefault_enable();
-	preempt_enable();
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
+	else
+		migrate_enable();
 }
 
 static inline void __iomem *
@@ -162,7 +168,10 @@ static inline void __iomem *
 io_mapping_map_atomic_wc(struct io_mapping *mapping,
 			 unsigned long offset)
 {
-	preempt_disable();
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
+	else
+		migrate_disable();
 	pagefault_disable();
 	return io_mapping_map_wc(mapping, offset, PAGE_SIZE);
 }
@@ -172,7 +181,10 @@ io_mapping_unmap_atomic(void __iomem *va
 {
 	io_mapping_unmap(vaddr);
 	pagefault_enable();
-	preempt_enable();
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
+	else
+		migrate_enable();
 }
 
 static inline void __iomem *
_

Patches currently in -mm which might be from bigeasy@linutronix.de are


