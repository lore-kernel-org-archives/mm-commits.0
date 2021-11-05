Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16DCCC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02EBA61252
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbhKEUiK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:38:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:32918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232269AbhKEUiI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:38:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83F3D611C0;
        Fri,  5 Nov 2021 20:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144527;
        bh=rwqbZ7Jw7ad1fBjerU310bTskbYP0lg49TmFynugLVI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=19F2cLj/MDo6vNgdKRTKiZNN48aR/yBIFv2kS54SM4699UdAtaj96qDN/czScBGT5
         gfrhKVMBiqR0nI9KJ87wRba8y8PNDu2J/5qHk6vROgi4LEuIiwwrsAbUj5DgkXzdOJ
         61eZ54V71snpFH2fDg3EKSP3z5rUWyiA6IgI/2wk=
Date:   Fri, 05 Nov 2021 13:35:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de, david@redhat.com,
        linux-mm@kvack.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 017/262] mm: disable
 NUMA_BALANCING_DEFAULT_ENABLED and TRANSPARENT_HUGEPAGE on PREEMPT_RT
Message-ID: <20211105203527.xgYSnEg-G%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm: disable NUMA_BALANCING_DEFAULT_ENABLED and TRANSPARENT_HUGEPAGE on PREEMPT_RT

TRANSPARENT_HUGEPAGE:
There are potential non-deterministic delays to an RT thread if a critical
memory region is not THP-aligned and a non-RT buffer is located in the same
hugepage-aligned region. It's also possible for an unrelated thread to migrate
pages belonging to an RT task incurring unexpected page faults due to memory
defragmentation even if khugepaged is disabled.

Regular HUGEPAGEs are not affected by this can be used.

NUMA_BALANCING:
There is a non-deterministic delay to mark PTEs PROT_NONE to gather NUMA fault
samples, increased page faults of regions even if mlocked and non-deterministic
delays when migrating pages.

[Mel Gorman worded 99% of the commit description].

Link: https://lore.kernel.org/all/20200304091159.GN3818@techsingularity.net/
Link: https://lore.kernel.org/all/20211026165100.ahz5bkx44lrrw5pt@linutronix.de/
Link: https://lkml.kernel.org/r/20211028143327.hfbxjze7palrpfgp@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 mm/Kconfig   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/init/Kconfig~mm-disable-numa_balancing_default_enabled-and-transparent_hugepage-on-preempt_rt
+++ a/init/Kconfig
@@ -901,7 +901,7 @@ config NUMA_BALANCING
 	bool "Memory placement aware NUMA scheduler"
 	depends on ARCH_SUPPORTS_NUMA_BALANCING
 	depends on !ARCH_WANT_NUMA_VARIABLE_LOCALITY
-	depends on SMP && NUMA && MIGRATION
+	depends on SMP && NUMA && MIGRATION && !PREEMPT_RT
 	help
 	  This option adds support for automatic NUMA aware memory/task placement.
 	  The mechanism is quite primitive and is based on migrating memory when
--- a/mm/Kconfig~mm-disable-numa_balancing_default_enabled-and-transparent_hugepage-on-preempt_rt
+++ a/mm/Kconfig
@@ -371,7 +371,7 @@ config NOMMU_INITIAL_TRIM_EXCESS
 
 config TRANSPARENT_HUGEPAGE
 	bool "Transparent Hugepage Support"
-	depends on HAVE_ARCH_TRANSPARENT_HUGEPAGE
+	depends on HAVE_ARCH_TRANSPARENT_HUGEPAGE && !PREEMPT_RT
 	select COMPACTION
 	select XARRAY_MULTI
 	help
_
