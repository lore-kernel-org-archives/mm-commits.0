Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49BA7C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22B3A22D07
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781151;
	bh=t5PucQZuKToNKwVENT0iXxoiOqnhQXXF6xvuCDnnKj4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=BNliMvAu1z7JFgB5dMqi/f5ADlCQ1kmqOmL9Bw9vHWnwzbilePcRLwfTC1v54LboJ
	 6knjMKezpX7wJcHdYVepHNMPq247LVUqn6dl/o82CSshcOmJMUpLVXvLYOdp8q0TK6
	 zmapCwcDMgn00Qa+DpT0IfEpX8EFHE6v9XIL3N+c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgHGGTK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGTK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:19:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E26932177B;
        Fri,  7 Aug 2020 06:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781150;
        bh=t5PucQZuKToNKwVENT0iXxoiOqnhQXXF6xvuCDnnKj4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=k8WeoTUVc4zSsbLPRavwgmy7nAG3F0u2TnPjKmiphcQazY5jfvPQtArkezWLsR09U
         wQ1ITzXzSDOyNwp2XUYGukaGVs2nAA22Sk9JP78K4B6LiUYAplDA15cCGmT86gi4A+
         7fN6M3xsuHL5iPyskU7dsM0Kdn03SpG+lCcpn8EU=
Date:   Thu, 06 Aug 2020 23:19:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de, cl@linux.com,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, yuzhao@google.com
Subject:  [patch 038/163] mm/slub.c: drop lockdep_assert_held()
 from put_map()
Message-ID: <20200807061909.ouNDTlYfw%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
