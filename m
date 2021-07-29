Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4850C4338F
	for <mm-commits@archiver.kernel.org>; Thu, 29 Jul 2021 20:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC94860F48
	for <mm-commits@archiver.kernel.org>; Thu, 29 Jul 2021 20:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhG2UB1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Jul 2021 16:01:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230141AbhG2UB1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 29 Jul 2021 16:01:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B3F560720;
        Thu, 29 Jul 2021 20:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627588883;
        bh=RK1wIMw4NIAt3tzK45e29YHZiTkd6eCizFtOwksJTLs=;
        h=Date:From:To:Subject:From;
        b=FXCHINvg8kWtw1IOw6GJ1ITJ7ELXpG2Q6aNFYVMyCFThZRwKqU3GeoIsuZMO7nfga
         k3H5ItCtBJvQA1oZZ4+DuihMvg1pXv5dXp4S3M+wKXF6IWSixY4uQ5W4w6D5vqGCZE
         y1agjXaNMizzbxtDPOoHaYKsOFgOxlqQkpHgZMAY=
Date:   Thu, 29 Jul 2021 13:01:23 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ptikhomirov@virtuozzo.com,
        miltonm@bga.com, millerjo@us.ibm.com, manfred@colorfullife.com,
        ebiederm@xmission.com, dave@stgolabs.net, alexander@mihalicyn.com,
        alexander.mikhalitsyn@virtuozzo.com
Subject:  [to-be-updated]
 ipc-warn-if-trying-to-remove-ipc-object-which-is-absent.patch removed from
 -mm tree
Message-ID: <20210729200123.sZ8zg%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: WARN if trying to remove ipc object which is absent
has been removed from the -mm tree.  Its filename was
     ipc-warn-if-trying-to-remove-ipc-object-which-is-absent.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Subject: ipc: WARN if trying to remove ipc object which is absent

Let's produce a warning if we trying to remove non-existing IPC object
from IPC namespace kht/idr structures.

This allows to catch possible bugs when ipc_rmid() function was called
with inconsistent struct ipc_ids*, struct kern_ipc_perm* arguments.

Link: https://lkml.kernel.org/r/20210706132259.71740-3-alexander.mikhalitsyn@virtuozzo.com
Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc: Milton Miller <miltonm@bga.com>
Cc: Jack Miller <millerjo@us.ibm.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/ipc/util.c~ipc-warn-if-trying-to-remove-ipc-object-which-is-absent
+++ a/ipc/util.c
@@ -447,8 +447,8 @@ static int ipcget_public(struct ipc_name
 static void ipc_kht_remove(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
 {
 	if (ipcp->key != IPC_PRIVATE)
-		rhashtable_remove_fast(&ids->key_ht, &ipcp->khtnode,
-				       ipc_kht_params);
+		WARN_ON(rhashtable_remove_fast(&ids->key_ht, &ipcp->khtnode,
+				       ipc_kht_params));
 }
 
 /**
@@ -498,7 +498,7 @@ void ipc_rmid(struct ipc_ids *ids, struc
 {
 	int idx = ipcid_to_idx(ipcp->id);
 
-	idr_remove(&ids->ipcs_idr, idx);
+	WARN_ON(idr_remove(&ids->ipcs_idr, idx) != ipcp);
 	ipc_kht_remove(ids, ipcp);
 	ids->in_use--;
 	ipcp->deleted = true;
_

Patches currently in -mm which might be from alexander.mikhalitsyn@virtuozzo.com are


