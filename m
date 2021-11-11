Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06FB8C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E529D61884
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbhKKCmx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:42:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:48512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233571AbhKKCmx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:42:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 965E1610F7;
        Thu, 11 Nov 2021 02:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598404;
        bh=E3YFTwhDgZg/bCs5k3BUDP4zj7Bc5SA5F/zSMfm7X/8=;
        h=Date:From:To:Subject:From;
        b=xdUGKPt3i+hfHrKVwxtXn4XVAdgByAGiLC+2G7d0oYdMbSC9RgqXniPl7mmyz0o6I
         gnKLTqPIrJ5iGu/TEm2h17tMR6l/pHR0zvzrofABUbvgmNajDQppa5ZgO1bbEjZrrP
         RVRPPPWBGTRqsaiIT6GE/QyKzUZabbyRKoWOgIvg=
Date:   Wed, 10 Nov 2021 18:40:04 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, david@redhat.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 =?US-ASCII?Q?mm-disable-numa=5Fbalancing=5Fdefault=5Fenabled-and-transpar?=
 =?US-ASCII?Q?ent=5Fhugepage-on-preempt=5Frt.patch?= removed from -mm tree
Message-ID: <20211111024004.YElSC7TNe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: disable NUMA_BALANCING_DEFAULT_ENABLED and TRANSPARENT_HUGEPAGE on PREEMPT_RT
has been removed from the -mm tree.  Its filename was
     mm-disable-numa_balancing_default_enabled-and-transparent_hugepage-on-preempt_rt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from bigeasy@linutronix.de are


