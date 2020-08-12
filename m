Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D15C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 819FF2054F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196226;
	bh=imZqtRs2Zm6d+Q8CnwkNMxVZRym6ZJZHY5VLNNkVgbg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=HK8Hn7KCVM0UyG3/tqaE6rkz1u9QzIk9nKrMwNScr74UtbLV9wDjk+LbJ8aDygDn6
	 VkTKVk9RRyP3hTqCaYTl7o19vvYC9iO8DviZknIQOaW6+kO/WxGqlygEq0scyzEEPi
	 dGPxI7CYMDPr5N2UDQ4qhZBCjgVmRacfcUiPMnI0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgHLBhG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:37:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBhG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:37:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B4A42087C;
        Wed, 12 Aug 2020 01:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196225;
        bh=imZqtRs2Zm6d+Q8CnwkNMxVZRym6ZJZHY5VLNNkVgbg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UkKydZ23RX0Da8JgYaArgBEEoUYr3+b08/TiVHYuUIdMTvVVXvFxPwukmsjEtYt8A
         9oq82k/Faws1A5rxaPJBptapPqtVwy+2BGZjLScP1oCRLBa/13FyEBmmK8Lkr1A/Wb
         LHJ+aN3/xHcxtsVQJDwJNT5B9VwDu1QY9eKpZlI4=
Date:   Tue, 11 Aug 2020 18:37:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, dave@stgolabs.net,
        linux-mm@kvack.org, manfred@colorfullife.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 129/165] ipc: uninline functions
Message-ID: <20200812013705.KtWRJHwph%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
