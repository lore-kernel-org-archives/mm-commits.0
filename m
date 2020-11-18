Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C46EC63697
	for <mm-commits@archiver.kernel.org>; Wed, 18 Nov 2020 23:59:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0CE2246EB
	for <mm-commits@archiver.kernel.org>; Wed, 18 Nov 2020 23:59:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UzQHbuXJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgKRX6v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Nov 2020 18:58:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726340AbgKRX6v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Nov 2020 18:58:51 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27A3A246BB;
        Wed, 18 Nov 2020 23:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605743930;
        bh=gh0Z289yMQHgj2d4gwPDZzPBuC/miMoGntD4aOPyxvI=;
        h=Date:From:To:Subject:From;
        b=UzQHbuXJBbfHwnauYETQHWBSJN/SRK2wATENmu1pViSJPALDoiAgzZJ4CENhmMph5
         k9ZL+rvb3hw2dlP4D5Ur/PDnGxdGgXLwnJ4/3ZYlmH2MddoYUE5xkYTt3vmzHib88q
         vtuKaS3rr2kgB83ifAkUpNUOWpFCCbbVRJUQEXkk=
Date:   Wed, 18 Nov 2020 15:58:49 -0800
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, jrdr.linux@gmail.com, kaixuxia@tencent.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        tencent_os_robot@tencent.com, vdavydov.dev@gmail.com
Subject:  +
 mm-memcontrol-assign-boolean-values-to-a-bool-variable.patch added to -mm
 tree
Message-ID: <20201118235849.rXtPdcqe_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: Assign boolean values to a bool variable
has been added to the -mm tree.  Its filename is
     mm-memcontrol-assign-boolean-values-to-a-bool-variable.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-assign-boolean-values-to-a-bool-variable.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-assign-boolean-values-to-a-bool-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm: memcontrol: Assign boolean values to a bool variable

Fix the following coccinelle warnings:

./mm/memcontrol.c:7341:2-22: WARNING: Assignment of 0/1 to bool variable
./mm/memcontrol.c:7343:2-22: WARNING: Assignment of 0/1 to bool variable

Link: https://lkml.kernel.org/r/1604737495-6418-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Acked-by: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-assign-boolean-values-to-a-bool-variable
+++ a/mm/memcontrol.c
@@ -7340,9 +7340,9 @@ bool mem_cgroup_swap_full(struct page *p
 static int __init setup_swap_account(char *s)
 {
 	if (!strcmp(s, "1"))
-		cgroup_memory_noswap = 0;
+		cgroup_memory_noswap = false;
 	else if (!strcmp(s, "0"))
-		cgroup_memory_noswap = 1;
+		cgroup_memory_noswap = true;
 	return 1;
 }
 __setup("swapaccount=", setup_swap_account);
_

Patches currently in -mm which might be from kaixuxia@tencent.com are

mm-memcontrol-assign-boolean-values-to-a-bool-variable.patch

