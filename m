Return-Path: <SRS0=YRC/=A3=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF07C433E3
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 00:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECA4D2075B
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 00:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594860635;
	bh=3SlDspYAOetZOWNY1j9DGZemKeeoPsyFfYBkGDBhWxk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=GxlTJI2TDMxeWXc04JoOhCZcSb457DXtFfqMoK7C8NLS2lzFHII+9yT7u32FTCK23
	 W7CufpZ0DqWA+kDktLUwzCup+O5N8Hn/FOuniPeQ8Ihj1Sr7U9svhUcH4J6hTcoyW/
	 AG316yJhrNhcQkmUs5rvtonDE4+77ss/t+TM0VlA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgGPAue (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Jul 2020 20:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727906AbgGPAue (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Jul 2020 20:50:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB83020658;
        Thu, 16 Jul 2020 00:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594860634;
        bh=3SlDspYAOetZOWNY1j9DGZemKeeoPsyFfYBkGDBhWxk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IYHaoLfwT9OHwhG7d8XG1/atRC2Z1HDID7dVXdKc0LLKv6ugStYq+EE3//KcGhHbI
         fsV9MrCh2cCYppBSTmPdM0K3BkuVB/1+09r9sdcXvTveEXD8KgLawwQTmk4wlCKafM
         Ohzc3xyV1/lHM8ydpPV/Zqy4q1SMXPBJzKbu2ncY=
Date:   Wed, 15 Jul 2020 17:50:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     daniel.m.jordan@oracle.com, dave.hansen@linux.intel.com,
        david@redhat.com, hpa@zytor.com, luto@kernel.org,
        mhocko@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com, peterz@infradead.org,
        steven.sistare@oracle.com, tglx@linutronix.de
Subject:  + x86-mm-use-max-memory-block-size-on-bare-metal-v3.patch
 added to -mm tree
Message-ID: <20200716005033.zEvNPV5Qi%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86-mm-use-max-memory-block-size-on-bare-metal-v3
has been added to the -mm tree.  Its filename is
     x86-mm-use-max-memory-block-size-on-bare-metal-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-use-max-memory-block-size-on-bare-metal-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-use-max-memory-block-size-on-bare-metal-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: x86-mm-use-max-memory-block-size-on-bare-metal-v3

Add more accurate hypervisor check.  Someone kindly pointed me to
517c3ba00916 ("x86/speculation/mds: Apply more accurate check on
hypervisor platform"), and v2 had the same issue.

Link: http://lkml.kernel.org/r/20200714205450.945834-1-daniel.m.jordan@oracle.com
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-mm-use-max-memory-block-size-on-bare-metal-v3
+++ a/arch/x86/mm/init_64.c
@@ -54,7 +54,6 @@
 #include <asm/uv/uv.h>
 #include <asm/setup.h>
 #include <asm/ftrace.h>
-#include <asm/hypervisor.h>
 
 #include "mm_internal.h"
 
@@ -1410,7 +1409,7 @@ static unsigned long probe_memory_block_
 	 * Use max block size to minimize overhead on bare metal, where
 	 * alignment for memory hotplug isn't a concern.
 	 */
-	if (hypervisor_is_type(X86_HYPER_NATIVE)) {
+	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
 		bz = MAX_BLOCK_SIZE;
 		goto done;
 	}
_

Patches currently in -mm which might be from daniel.m.jordan@oracle.com are

x86-mm-use-max-memory-block-size-on-bare-metal.patch
x86-mm-use-max-memory-block-size-on-bare-metal-v3.patch

