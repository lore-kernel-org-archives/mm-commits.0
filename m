Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE267C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiGRAc1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiGRAcZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:32:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3345A13CE1
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E83F8B80EE7
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A30C3411E;
        Mon, 18 Jul 2022 00:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104341;
        bh=AQz9KtKOY7irAAQAd3vsb/wWgpVFhW1i2dHSOC+2aFE=;
        h=Date:To:From:Subject:From;
        b=yTw4can3T7y84+xswXxR1WNNGE8r0c4px1f/viYfLeLnYRG78NJEtqkVs8NQJQGzF
         llZ0KgHlVpTN8hZePJR+Gk3K9K4twynP+dCNkiCbBZpMKiMFyA1+8nuaukHw3I5JVB
         x3nAe4pTHcYszD5FOBjCwOBVA4bbZWvSw/J5YrLE=
Date:   Sun, 17 Jul 2022 17:32:20 -0700
To:     mm-commits@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net, wuchi.zero@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] net-lib-once-remove-net_get_random_once_wait-macro.patch removed from -mm tree
Message-Id: <20220718003221.96A30C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: net, lib/once: remove {net_}get_random_once_wait macro
has been removed from the -mm tree.  Its filename was
     net-lib-once-remove-net_get_random_once_wait-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

