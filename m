Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E29C43334
	for <mm-commits@archiver.kernel.org>; Sun, 19 Jun 2022 23:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbiFSXZB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Jun 2022 19:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbiFSXZA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 19 Jun 2022 19:25:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B1564DB
        for <mm-commits@vger.kernel.org>; Sun, 19 Jun 2022 16:24:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86260612D0
        for <mm-commits@vger.kernel.org>; Sun, 19 Jun 2022 23:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A40C34114;
        Sun, 19 Jun 2022 23:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655681098;
        bh=R20VeKbsL0pNyjWtk/Yiek0Ka4QLfGPqDHpaPu5z0tQ=;
        h=Date:To:From:Subject:From;
        b=z/4m2cVtLa7/H88CZk2suLHEN8FUKmlPNMUO/8XzE+Qap/FFWm6ckt82cbiOo4Rsc
         tlFZXmnNrOy4w43+k2FbHrXTfXCqtVyuMYI2tCWYhcLfrWTYJJ5Sh1kbpMrhT5/pk/
         WMpEoaqdclk/+k3KaIfczC+vYctsnGa33Uo8g18k=
Date:   Sun, 19 Jun 2022 16:24:58 -0700
To:     mm-commits@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net, wuchi.zero@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + net-lib-once-remove-net_get_random_once_wait-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20220619232458.C5A40C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: net, lib/once: remove {net_}get_random_once_wait macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     net-lib-once-remove-net_get_random_once_wait-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/net-lib-once-remove-net_get_random_once_wait-macro.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: wuchi <wuchi.zero@gmail.com>
Subject: net, lib/once: remove {net_}get_random_once_wait macro
Date: Sun, 19 Jun 2022 15:46:41 +0800

DO_ONCE(func, ...) will call func with spinlock which acquired by
spin_lock_irqsave in __do_once_start.  But the get_random_once_wait will
sleep in get_random_bytes_wait -> wait_for_random_bytes.

Fortunately, there is no place to use {net_}get_random_once_wait, so we
could remove them simply.

Link: https://lkml.kernel.org/r/20220619074641.40916-1-wuchi.zero@gmail.com
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/net.h  |    2 --
 include/linux/once.h |    2 --
 2 files changed, 4 deletions(-)

--- a/include/linux/net.h~net-lib-once-remove-net_get_random_once_wait-macro
+++ a/include/linux/net.h
@@ -303,8 +303,6 @@ do {									\
 
 #define net_get_random_once(buf, nbytes)			\
 	get_random_once((buf), (nbytes))
-#define net_get_random_once_wait(buf, nbytes)			\
-	get_random_once_wait((buf), (nbytes))
 
 /*
  * E.g. XFS meta- & log-data is in slab pages, or bcache meta
--- a/include/linux/once.h~net-lib-once-remove-net_get_random_once_wait-macro
+++ a/include/linux/once.h
@@ -54,7 +54,5 @@ void __do_once_done(bool *done, struct s
 
 #define get_random_once(buf, nbytes)					     \
 	DO_ONCE(get_random_bytes, (buf), (nbytes))
-#define get_random_once_wait(buf, nbytes)                                    \
-	DO_ONCE(get_random_bytes_wait, (buf), (nbytes))                      \
 
 #endif /* _LINUX_ONCE_H */
_

Patches currently in -mm which might be from wuchi.zero@gmail.com are

lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch
lib-lru_cache-fix-error-free-handing-in-lc_create.patch
net-lib-once-remove-net_get_random_once_wait-macro.patch

