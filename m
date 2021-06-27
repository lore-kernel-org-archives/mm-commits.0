Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF461C48BC2
	for <mm-commits@archiver.kernel.org>; Sun, 27 Jun 2021 21:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8F57619BF
	for <mm-commits@archiver.kernel.org>; Sun, 27 Jun 2021 21:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbhF0Vmo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Jun 2021 17:42:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231676AbhF0Vmo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 27 Jun 2021 17:42:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D80361AC0;
        Sun, 27 Jun 2021 21:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624830018;
        bh=VGkygYznnqrQuU/nSurlYCE7e0bFDH3TLaBibkgX3wY=;
        h=Date:From:To:Subject:From;
        b=o0HeoWrHJcQ2tD57wAFGa++WJlJO2sQRw6LihfwGwbNgw27e43mNVYG/ysaQ5CP8E
         5l9zygPl/CCl2Sni0cVlqWMw44/mbjltGUjGSm1yicNFv0WrBTsd8kh0y/zdRHVz6U
         gxUJZkrhJJgJkCFP2p2SmMGdcjbAsCF6urTO5ATA=
Date:   Sun, 27 Jun 2021 14:40:18 -0700
From:   akpm@linux-foundation.org
To:     1vier1@web.de, dbueso@suse.de, manfred@colorfullife.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org
Subject:  +
 ipc-semc-use-read_once-write_once-for-use_global_lock-update.patch added to
 -mm tree
Message-ID: <20210627214018.GPPzN12Az%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: use READ_ONCE()/WRITE_ONCE() for use_global_lock
has been added to the -mm tree.  Its filename is
     ipc-semc-use-read_once-write_once-for-use_global_lock-update.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-use-read_once-write_once-for-use_global_lock-update.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-use-read_once-write_once-for-use_global_lock-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: use READ_ONCE()/WRITE_ONCE() for use_global_lock

Link: https://lkml.kernel.org/r/20210627161919.3196-3-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: <1vier1@web.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/ipc/sem.c~ipc-semc-use-read_once-write_once-for-use_global_lock-update
+++ a/ipc/sem.c
@@ -2439,7 +2439,8 @@ static int sysvipc_sem_proc_show(struct
 
 	/*
 	 * The proc interface isn't aware of sem_lock(), it calls
-	 * ipc_lock_object() directly (in sysvipc_find_ipc).
+	 * ipc_lock_object(), i.e. spin_lock(&sma->sem_perm.lock).
+	 * (in sysvipc_find_ipc)
 	 * In order to stay compatible with sem_lock(), we must
 	 * enter / leave complex_mode.
 	 */
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-use-read_once-write_once-for-use_global_lock.patch
ipc-semc-use-read_once-write_once-for-use_global_lock-update.patch
ipc-utilc-use-binary-search-for-max_idx.patch

