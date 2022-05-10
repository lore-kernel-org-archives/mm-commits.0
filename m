Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B83C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbiEJEWt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236141AbiEJEUs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C398636E0C
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FC4C61772
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB47C385C2;
        Tue, 10 May 2022 04:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156151;
        bh=8t6nrPoFoUymOl8eQKvN0w4a8PUtsx+UogurQa7IRPg=;
        h=Date:To:From:Subject:From;
        b=VoCNL3G4Xd7KI2WwPwNWN2Y+nZcT/oY5lBAxRJqOggFr04Q0SzeWJUMc3eUox2eq9
         YPsIgC1iwqf276+1/SIUhkFmi5EkoZqKGjSOVOlFFj8WdUplnhQFugYEwRxbi2suZj
         4Ei++8PHcJBExlgxU1VJ5eChQx5g/uSqMCfeKBDU=
Date:   Mon, 09 May 2022 21:15:51 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-prohibit-multiple-physical-address-space-monitoring-targets.patch removed from -mm tree
Message-Id: <20220510041551.BAB47C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: prohibit multiple physical address space monitoring targets
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-prohibit-multiple-physical-address-space-monitoring-targets.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: prohibit multiple physical address space monitoring targets

Having multiple targets for physical address space monitoring makes no
sense.  This commit prohibits such a ridiculous DAMON context setup my
making the DAMON context build function to check and return an error for
the case.

Link: https://lkml.kernel.org/r/20220429160606.127307-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-prohibit-multiple-physical-address-space-monitoring-targets
+++ a/mm/damon/sysfs.c
@@ -2125,6 +2125,10 @@ static int damon_sysfs_set_targets(struc
 {
 	int i, err;
 
+	/* Multiple physical address space monitoring targets makes no sense */
+	if (ctx->ops.id == DAMON_OPS_PADDR && sysfs_targets->nr > 1)
+		return -EINVAL;
+
 	for (i = 0; i < sysfs_targets->nr; i++) {
 		struct damon_sysfs_target *sys_target =
 			sysfs_targets->targets_arr[i];
_

Patches currently in -mm which might be from sj@kernel.org are


