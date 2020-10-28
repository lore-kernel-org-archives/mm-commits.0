Return-Path: <SRS0=6wtZ=ED=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 707F4C56201
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 21:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23A8F24759
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 21:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603922047;
	bh=7JicAPfx7DgvOGQYpWPGT8/Km3jeSPbO+jA/9wM3uxI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=EF2KHLWb82GV8f8737L2HgHG+WRkMGlBGlLB/yQiEROupmGB+kaHWZyVHhhv6pHT1
	 Ps+tz62m8ag0QH9emx0wlYc+gxBSIpRlD7xr6ux2y1+8HCKp0GuQxBxTPd3qFoCrJI
	 SF/ja+PyZ5igtNbrgV9IurTAQQjLU3FtuvGvciNk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgJ1VyG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:54:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728625AbgJ1VyF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Oct 2020 17:54:05 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D70F7246CD;
        Wed, 28 Oct 2020 21:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603922045;
        bh=7JicAPfx7DgvOGQYpWPGT8/Km3jeSPbO+jA/9wM3uxI=;
        h=Date:From:To:Subject:From;
        b=x/NyzeJatYXu7uMEb6SdKatvQpEvCXKZfXGOdNYMEaUJkHJwdhT53l4G4VPBNeqXm
         oh6q+IPZdr9WTmirVRMYcpI804gj2fNdbp33/8jIL9oVkxCQBrB+MqhI+Z7l/DsLJX
         /e7Ra3JhMi8atatMiwsgTa5vY+OLuzc7YYkhD7iU=
Date:   Wed, 28 Oct 2020 14:54:04 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, sh_def@163.com
Subject:  [folded-merged]
 mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs-fix.patch removed
 from -mm tree
Message-ID: <20201028215404.pnjPdYQXV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs-fix
has been removed from the -mm tree.  Its filename was
     mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs-fix.patch

This patch was dropped because it was folded into mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs-fix

remove incorrect kerneldoc token

Cc: Hui Su <sh_def@163.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/oom_kill.c~mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs-fix
+++ a/mm/oom_kill.c
@@ -170,7 +170,7 @@ static bool oom_unkillable_task(struct t
 	return false;
 }
 
-/**
+/*
  * Check whether unreclaimable slabs amount is greater than
  * all user memory(LRU pages).
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix.patch
mm.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters-fix.patch
mmoom_kill-fix-the-comment-of-is_dump_unreclaim_slabs.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch

