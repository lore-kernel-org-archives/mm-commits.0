Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8240AC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B44D61005
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbhGABHp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:07:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238272AbhGABHo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:07:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 279E961424;
        Thu,  1 Jul 2021 01:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625101514;
        bh=4pCJ2wesVDTntKDakjXF9rDj56pGeo8q1qLqlLsH4SM=;
        h=Date:From:To:Subject:From;
        b=krYbZLlIy/dqe9fpMBu6k7E1c3Vk3xRKhBgtdNSmOkmEV0nqlAdxh6/NOnMn6CH9y
         0GkeyvFPpmMPgAFwM8B/POgY6YfGibzkv/kms1vANV+dGeEEpE23N7qwlKIkyQtJsF
         Odj0NhqRRJNlDS8UN7EWvh9C+zAiweHt93iKI/ZQ=
Date:   Wed, 30 Jun 2021 18:05:13 -0700
From:   akpm@linux-foundation.org
To:     1vier1@web.de, dbueso@suse.de, manfred@colorfullife.com,
        mm-commits@vger.kernel.org, paulmck@kernel.org
Subject:  [folded-merged]
 ipc-semc-use-read_once-write_once-for-use_global_lock-update.patch removed
 from -mm tree
Message-ID: <20210701010513.TztST_-y5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: use READ_ONCE()/WRITE_ONCE() for use_global_lock
has been removed from the -mm tree.  Its filename was
     ipc-semc-use-read_once-write_once-for-use_global_lock-update.patch

This patch was dropped because it was folded into ipc-semc-use-read_once-write_once-for-use_global_lock.patch

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
ipc-utilc-use-binary-search-for-max_idx.patch

