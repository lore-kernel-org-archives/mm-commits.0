Return-Path: <SRS0=ColI=A4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E59C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 20:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1092820704
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 20:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595017084;
	bh=G23gBfexYlwv6sRJWZw4RzYrfpYT0TOycmWALwjamZU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=P0GWnGrq7yPOEnLtBvl0QxCrFfdZELADzbbIsHdY6ASo7T1H2C+zYNCgPv396sEGz
	 Olb+Zph8xM1oWSDFZjYHKBbIObSIxmBnWzrL7tnQgJyLHdpoLIf5/l55tsESWTMyZv
	 +aatgZ1Ay+3L8DNsz0V6zdptDaKH/juRith6egvY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgGQUSD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jul 2020 16:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728183AbgGQUSD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Jul 2020 16:18:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA9122074B;
        Fri, 17 Jul 2020 20:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595017082;
        bh=G23gBfexYlwv6sRJWZw4RzYrfpYT0TOycmWALwjamZU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZQ1VIE3bPMO1zryltEd8mupylmlYjwoPPyemNxZcUeP1YYcK+SVjSzwvFNG4RPcnn
         qM+lyQCSgMEHhkcEyjyNbY/LPSFsj/NsWFbd5kKuV0XZgUAOANCDNuykYJyuWqOxez
         oGh31saLg7dYLsdcysfoU268l2zMAi1mKoRctjWc=
Date:   Fri, 17 Jul 2020 13:18:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 revert-squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch removed
 from -mm tree
Message-ID: <20200717201802.TxWt5AZDi%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: revert-squashfs-migrate-from-ll_rw_block-usage-to-bio-fix
has been removed from the -mm tree.  Its filename was
     revert-squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch

This patch was dropped because it was folded into revert-squashfs-migrate-from-ll_rw_block-usage-to-bio.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert-squashfs-migrate-from-ll_rw_block-usage-to-bio-fix

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/squashfs/super.c~revert-squashfs-migrate-from-ll_rw_block-usage-to-bio-fix
+++ a/fs/squashfs/super.c
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/magic.h>
 #include <linux/xattr.h>
+#include <linux/blk_types.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch
revert-squashfs-migrate-from-ll_rw_block-usage-to-bio.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

