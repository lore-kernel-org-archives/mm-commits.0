Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0837CDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbjJRVoA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbjJRVnu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:43:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F184A111
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:43:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89710C433C9;
        Wed, 18 Oct 2023 21:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697665428;
        bh=s+lHI9rLfIEnxt1BdxynO93gkfBSeYrst2OpYc6Q8LI=;
        h=Date:To:From:Subject:From;
        b=rUt7oDtFr9vlViH8wOMow7taka1fAcfA8Fa7tgpuzR/0N+dxQ5Fiewgn9KwjVEIvV
         cBqa0tmDjGNTY2RtaPpm8ME0yGNSbngOHRlTUl2wqnSavH3aKHgd4hIygd2mk8zT1F
         4LTS+YHP+LdI5/HOXE8eCPNv7gi5Un/ShNAmnMu4=
Date:   Wed, 18 Oct 2023 14:43:48 -0700
To:     mm-commits@vger.kernel.org, oleg@redhat.com, kunyu@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-signal-remove-unnecessary-null-values-from-ucounts.patch removed from -mm tree
Message-Id: <20231018214348.89710C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel/signal: remove unnecessary NULL values from ucounts
has been removed from the -mm tree.  Its filename was
     kernel-signal-remove-unnecessary-null-values-from-ucounts.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li kunyu <kunyu@nfschina.com>
Subject: kernel/signal: remove unnecessary NULL values from ucounts
Date: Tue, 26 Sep 2023 10:24:10 +0800

ucounts is assigned first, so it does not need to initialize the
assignment.

Link: https://lkml.kernel.org/r/20230926022410.4280-1-kunyu@nfschina.com
Signed-off-by: Li kunyu <kunyu@nfschina.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/signal.c~kernel-signal-remove-unnecessary-null-values-from-ucounts
+++ a/kernel/signal.c
@@ -415,7 +415,7 @@ __sigqueue_alloc(int sig, struct task_st
 		 int override_rlimit, const unsigned int sigqueue_flags)
 {
 	struct sigqueue *q = NULL;
-	struct ucounts *ucounts = NULL;
+	struct ucounts *ucounts;
 	long sigpending;
 
 	/*
_

Patches currently in -mm which might be from kunyu@nfschina.com are


