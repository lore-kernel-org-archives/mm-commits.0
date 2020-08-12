Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87624C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55C8620838
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266349;
	bh=CSyWuBUEKWIlOtuO4FPlmb7zU9+yZYX6F5qFBvacq1E=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=jDIFMmzIUdXFr6t7XM15yu5d6NPhy7Ma9IRJK2HoGqVd8e4y2KPfORIXO3LVTD4ds
	 S2CcmxU783A50w3CLwwUpoqBUddr6ovq9s4/B99gl6eM1vAFq7R8YiEEMgQIHtIctU
	 bPywtqV6CZcZz1Ss6R00qIgrydLaJPi6W+ABwKtc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgHLVFt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:05:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgHLVFs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:05:48 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 763CE20774;
        Wed, 12 Aug 2020 21:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266348;
        bh=CSyWuBUEKWIlOtuO4FPlmb7zU9+yZYX6F5qFBvacq1E=;
        h=Date:From:To:Subject:From;
        b=MV3/vF9xCI5YI+ht7W38ArK/fleiOtkIrWzH08dcv234fhc/GSUBJnRvtnRn2WUO1
         n5s5txeEtbKY2mdVMTxY4E+M6jg5B7lX6DUsBnvalZ/fBG2BnA46ojEEHtK+Fgy/ER
         cUPrsavU2G/SQoG9YSRDZ45cVRl24+VZxmntCzEY=
Date:   Wed, 12 Aug 2020 14:05:48 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, dave@stgolabs.net, manfred@colorfullife.com,
        mm-commits@vger.kernel.org
Subject:  [merged] ipc-uninline-functions.patch removed from -mm
 tree
Message-ID: <20200812210548.zJAiVqdTC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: uninline functions
has been removed from the -mm tree.  Its filename was
     ipc-uninline-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: ipc: uninline functions

Two functions are only called via function pointers, don't bother
inlining them.

Link: http://lkml.kernel.org/r/20200710200312.GA960353@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    3 +--
 ipc/shm.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/ipc/sem.c~ipc-uninline-functions
+++ a/ipc/sem.c
@@ -585,8 +585,7 @@ static int newary(struct ipc_namespace *
 /*
  * Called with sem_ids.rwsem and ipcp locked.
  */
-static inline int sem_more_checks(struct kern_ipc_perm *ipcp,
-				struct ipc_params *params)
+static int sem_more_checks(struct kern_ipc_perm *ipcp, struct ipc_params *params)
 {
 	struct sem_array *sma;
 
--- a/ipc/shm.c~ipc-uninline-functions
+++ a/ipc/shm.c
@@ -711,8 +711,7 @@ no_file:
 /*
  * Called with shm_ids.rwsem and ipcp locked.
  */
-static inline int shm_more_checks(struct kern_ipc_perm *ipcp,
-				struct ipc_params *params)
+static int shm_more_checks(struct kern_ipc_perm *ipcp, struct ipc_params *params)
 {
 	struct shmid_kernel *shp;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

ramfs-support-o_tmpfile.patch

