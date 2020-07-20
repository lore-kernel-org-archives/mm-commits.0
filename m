Return-Path: <SRS0=eezP=A7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A03C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 20 Jul 2020 23:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B5C222BEF
	for <mm-commits@archiver.kernel.org>; Mon, 20 Jul 2020 23:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595286199;
	bh=i+gRqi+h31MRieG/Qqrku05KcFg8PV46tmC+CwRWjoA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ZsbqIiy1BJAsVHslVhhJeN8i6DqQz/1TMeVW0yP6Vb0Rij11Ip+1VHwltDTMIbwGA
	 kSM4/TJic8/vEVu2dHa4xcaFyQ36M6DlbbP6uN4oz8YxOUKjxkmTRwmyQhmd18CYnz
	 ZPVRzKT6zVB9JUPs2h4+u0ASXxrUk0KtsJ6E+CD8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgGTXDS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Jul 2020 19:03:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgGTXDS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Jul 2020 19:03:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D90D207FC;
        Mon, 20 Jul 2020 23:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595286197;
        bh=i+gRqi+h31MRieG/Qqrku05KcFg8PV46tmC+CwRWjoA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ONRsmTZWI1dIH+r0zewW0O9bOnh2u5kl/Jo3XOgEcPs8vG1bW8Rw2rb8kmihUrMcI
         N6W6vFzLgBFw9+4uskPIVlrEaBt6UCkyvLPQo23QCmyNTz0WTuW/4vvUECax4Hd920
         quyIxvjxvAgXqt1tiFkSfdgwvt6EIxpqfpYz4KCk=
Date:   Mon, 20 Jul 2020 16:03:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  +
 =?US-ASCII?Q?mm-vmstat-fix-proc-sys-vm-stat=5Frefresh-generating-false-?=
 =?US-ASCII?Q?warnings-fix-2.patch?= added to -mm tree
Message-ID: <20200720230317.dCinRyLtE%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2
has been added to the -mm tree.  Its filename is
     mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2

comment MAX_THRESHOLD, per Michal

Cc: Roman Gushchin <guro@fb.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmstat.c~mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2
+++ a/mm/vmstat.c
@@ -167,6 +167,7 @@ EXPORT_SYMBOL(vm_zone_stat);
 EXPORT_SYMBOL(vm_numa_stat);
 EXPORT_SYMBOL(vm_node_stat);
 
+/* Maximum sync threshold for per-cpu vmstat counters */
 #ifdef CONFIG_SMP
 #define MAX_THRESHOLD 125
 #else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch
mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mmhwpoison-rework-soft-offline-for-in-use-pages-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

