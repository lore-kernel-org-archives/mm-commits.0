Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D006C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 30 Dec 2021 00:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhL3Akg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Dec 2021 19:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233673AbhL3Akg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Dec 2021 19:40:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DDCC061574
        for <mm-commits@vger.kernel.org>; Wed, 29 Dec 2021 16:40:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 126F0615B8
        for <mm-commits@vger.kernel.org>; Thu, 30 Dec 2021 00:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18035C36AEA;
        Thu, 30 Dec 2021 00:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640824833;
        bh=5JeM8Da+eOkkn7Ovvy9HTi2cx+pNlhQ90Kk+iN+yhLc=;
        h=Date:From:To:Subject:From;
        b=sp7QrulmSdawkR0j2cm0lMVgmXt2kZWvJKA1r5E6djKqFCJh5nSXdWtA6Azxc9mVj
         OnGTU2OEAI/lmWxm1lNrfGlY0PlyvRWDcc4DiWZwnecrTX83pQ1nIcAAYs/17i8Wx1
         VKhHYL16BMg8+goK/cxMH8GDxCEEIB1qzWCzNcLI=
Date:   Wed, 29 Dec 2021 16:40:32 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn, vvs@virtuozzo.com,
        unixbhaskar@gmail.com, shakeelb@google.com, rdunlap@infradead.org,
        dbueso@suse.de, cgel.zte@gmail.com, arnd@arndb.de,
        chi.minghao@zte.com.cn
Subject:  + ipc-sem-do-not-sleep-with-a-spin-lock-held.patch added to
 -mm tree
Message-ID: <20211230004032.kv0wS%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: do not sleep with a spin lock held
has been added to the -mm tree.  Its filename is
     ipc-sem-do-not-sleep-with-a-spin-lock-held.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-do-not-sleep-with-a-spin-lock-held.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-do-not-sleep-with-a-spin-lock-held.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minghao Chi <chi.minghao@zte.com.cn>
Subject: ipc/sem: do not sleep with a spin lock held

We can't call kvfree() with a spin lock held, so defer it.

Link: https://lkml.kernel.org/r/20211223031207.556189-1-chi.minghao@zte.com.cn
Fixes: fc37a3b8b438 ("[PATCH] ipc sem: use kvmalloc for sem_undo allocation")
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Yang Guang <cgel.zte@gmail.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/ipc/sem.c~ipc-sem-do-not-sleep-with-a-spin-lock-held
+++ a/ipc/sem.c
@@ -1964,6 +1964,7 @@ static struct sem_undo *find_alloc_undo(
 	 */
 	un = lookup_undo(ulp, semid);
 	if (un) {
+		spin_unlock(&ulp->lock);
 		kvfree(new);
 		goto success;
 	}
@@ -1976,9 +1977,8 @@ static struct sem_undo *find_alloc_undo(
 	ipc_assert_locked_object(&sma->sem_perm);
 	list_add(&new->list_id, &sma->list_id);
 	un = new;
-
-success:
 	spin_unlock(&ulp->lock);
+success:
 	sem_unlock(sma, -1);
 out:
 	return un;
_

Patches currently in -mm which might be from chi.minghao@zte.com.cn are

mm-remove-unneeded-variable.patch
selftests-vm-use-swap-to-make-code-cleaner.patch
fs-adfs-remove-unneeded-variable-make-code-cleaner.patch
ipc-sem-do-not-sleep-with-a-spin-lock-held.patch

