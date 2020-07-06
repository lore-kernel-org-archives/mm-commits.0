Return-Path: <SRS0=vc0r=AR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49306C433E0
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jul 2020 23:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11C9B2075B
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jul 2020 23:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594078382;
	bh=6sNU6tdIGsTZFgDr5G62kNT3eVKam1EwKeCk4pjPvII=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=VY08NjlCSkCrzHXVTgCiMlUp63soB0de82IVneVywJIalYmSfv+ok2k9J9SFDGLqr
	 HsBiffPCTnTDwnqdfzhGUy4rQlSblxW8aZ+/xpwVif8RLRxWuBNREuZIhkTYw5U2UH
	 U9rnQf9nrvmgWn2aqpYpfGVNi19aWPCLvxRwFk0g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgGFXdB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jul 2020 19:33:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbgGFXdB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Jul 2020 19:33:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1CA0206DF;
        Mon,  6 Jul 2020 23:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594078381;
        bh=6sNU6tdIGsTZFgDr5G62kNT3eVKam1EwKeCk4pjPvII=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LmMRDMkERL2G+0+F1sf/XfXIhSx4wBR3I4fj1vn5hHkL5o1erSOW6eLuON/vKyA+v
         6NYBcnaalq22rlteao/DB1H4SwNUZp6j95zOeBZNlUm61+j66uVpNyYU8t1z3jdyEt
         p4L1RjGUCMbSmuIvwdmPOMUwuTMKQGs9H4gdaHyk=
Date:   Mon, 06 Jul 2020 16:33:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bigeasy@linutronix.de, cl@linux.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, tglx@linutronix.de, yuzhao@google.com
Subject:  [merged] slub-drop-lockdep_assert_held-from-put_map.patch
 removed from -mm tree
Message-ID: <20200706233300.2QiUxmw6Q%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
Message-ID: <20200706233300.egYrR3TsMsRKOD2ZcP2PWXDPScpw2hIeiI9YpPH27aI@z>


The patch titled
     Subject: mm/slub.c: drop lockdep_assert_held() from put_map()
has been removed from the -mm tree.  Its filename was
     slub-drop-lockdep_assert_held-from-put_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/slub.c: drop lockdep_assert_held() from put_map()

There is no point in using lockdep_assert_held() unlock that is about to
be unlocked.  It works only with lockdep and lockdep will complain if
spin_unlock() is used on a lock that has not been locked.

Remove superfluous lockdep_assert_held().

Link: http://lkml.kernel.org/r/20200618201234.795692-2-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/slub.c~slub-drop-lockdep_assert_held-from-put_map
+++ a/mm/slub.c
@@ -473,8 +473,6 @@ static unsigned long *get_map(struct kme
 static void put_map(unsigned long *map) __releases(&object_map_lock)
 {
 	VM_BUG_ON(map != object_map);
-	lockdep_assert_held(&object_map_lock);
-
 	spin_unlock(&object_map_lock);
 }
 
_

Patches currently in -mm which might be from bigeasy@linutronix.de are


