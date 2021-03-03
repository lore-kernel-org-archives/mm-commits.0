Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D027EC43142
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A48CE64EC3
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242010AbhCDA7C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:50978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1388020AbhCDAMF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:12:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC1E464F1B;
        Wed,  3 Mar 2021 23:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614814550;
        bh=YsJ1x8IYkuS4q2LCO4FZVJdI0X7djZNHsahA/diiVWc=;
        h=Date:From:To:Subject:From;
        b=XjzgMJ26cU6GZRrLGcpjvdHgIQUP6KAGbOdjUHm9Dx4ie/2plg6veXCzCV3G9bzvX
         +/mCJ5MEY0yDtSKCbxS5zU2Wn2NVR82CKnLq/a+hLTeJ2ivonR4jc13Qh6MhHMZ00p
         LR4Jt5StLp0JTVFEclk5+dHLILI5FBYUv/vUdVEs=
Date:   Wed, 03 Mar 2021 15:35:49 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, guro@fb.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-vmstat-fix-proc-sys-vm-stat=5Frefresh-generating-false-?=
 =?US-ASCII?Q?warnings-fix-2.patch?= removed from -mm tree
Message-ID: <20210303233549.fiQz_6qaA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2
has been removed from the -mm tree.  Its filename was
     mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch

This patch was dropped because it was folded into mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch

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

mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
kernel-forkc-export-kernel_thread-to-modules.patch

