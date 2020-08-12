Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE8E8C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1EAC206F2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597194134;
	bh=rrOfMQ0OjU5lExFZJX4UoWVaNEjxT89XRQ6ynQ6eHb8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=uT7Ru+Hz/WPjkXhwOm1K6SVLirOVVslCRNU4jV88CrEFMe01S6OHprcJPOKd41gF1
	 98qG0SBu4TA6lfX+EubKmswMXlQxK0ZwQKWIDm8GJdEL7wIsl4PIzs0QVDJTNujqCE
	 HQrBZz5Nx5whDh89be18BoDQLUloiM7RO9mcoY0o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgHLBCO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgHLBCO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:02:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D64A206B5;
        Wed, 12 Aug 2020 01:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597194133;
        bh=rrOfMQ0OjU5lExFZJX4UoWVaNEjxT89XRQ6ynQ6eHb8=;
        h=Date:From:To:Subject:From;
        b=IFnpqk7PCByQoBjSiPYjlszyCp6SekBtX9CjZhhP3fPrruRU3KYTa9ul96rhZO/ES
         wfZPlqgRBXT/9SzBS7G+IsY3mQ65eXXxxIyDbe/DrR+rBfNAT6GelGaYVfP7cDOYnt
         3I4CJTrn5ZQDoOPkyNR6n0lVLwZOm//DRgUcC8sM=
Date:   Tue, 11 Aug 2020 18:02:12 -0700
From:   akpm@linux-foundation.org
To:     daniel.m.jordan@oracle.com, dave.hansen@linux.intel.com,
        david@redhat.com, hpa@zytor.com, luto@kernel.org,
        mhocko@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com, peterz@infradead.org,
        steven.sistare@oracle.com, tglx@linutronix.de
Subject:  [folded-merged]
 x86-mm-use-max-memory-block-size-on-bare-metal-v3.patch removed from -mm
 tree
Message-ID: <20200812010212.jX2LWoewO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86-mm-use-max-memory-block-size-on-bare-metal-v3
has been removed from the -mm tree.  Its filename was
     x86-mm-use-max-memory-block-size-on-bare-metal-v3.patch

This patch was dropped because it was folded into x86-mm-use-max-memory-block-size-on-bare-metal.patch

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

