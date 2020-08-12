Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A66BC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 623D8208A9
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195930;
	bh=S4eWXnieZaxpnJaxp000pVSgN/+QdvHB6PoW6lKw2WA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=kqhUYT5KMdHOn34xDZ9dbw6Qf7nrAqbx5pNMAAl1LXUIVwTeJVrybDx3dkk4eR4Xq
	 H46gFoTIQS8wYpvRQOMMtSVs8p1Mjk/Lq1XZ6g9VLEMQiqWkckLsatKm/pzeUNgSQZ
	 iPvvhK9WeJEP7K+ykV/ty2RpKlKiETgdEtnOuQxM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgHLBcJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:32:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgHLBcH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:32:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1831022BEA;
        Wed, 12 Aug 2020 01:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195927;
        bh=S4eWXnieZaxpnJaxp000pVSgN/+QdvHB6PoW6lKw2WA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=d0Jy6be081ifQtSm4HsFRgc40hwbOTh/hYBMgMykVS4k8KjiFZiyzTTGamJF5JJRl
         6vbRRAODJiAZvpJaa3ST+6H0kaLHbWtiRnLlSl8BGql6myfRNk8odN0XEs4mZrB/AT
         4bqKSBdNe/rLWKJjFbB21SiNmBO/TaP7XcigXDN8=
Date:   Tue, 11 Aug 2020 18:32:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, longman@redhat.com,
        mathieu.desnoyers@efficios.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        torvalds@linux-foundation.org, walken@google.com
Subject:  [patch 035/165] include/linux/sched/mm.h: optimize
 current_gfp_context()
Message-ID: <20200812013206.tt3v-eUQV%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Waiman Long <longman@redhat.com>
Subject: include/linux/sched/mm.h: optimize current_gfp_context()

The current_gfp_context() converts a number of PF_MEMALLOC_* per-process
flags into the corresponding GFP_* flags for memory allocation.  In that
function, current->flags is accessed 3 times.  That may lead to duplicated
access of the same memory location.

This is not usually a problem with minimal debug config options on as the
compiler can optimize away the duplicated memory accesses.  With most of
the debug config options on, however, that may not be the case.  For
example, the x86-64 object size of the __need_fs_reclaim() in a debug
kernel that calls current_gfp_context() was 309 bytes.  With this patch
applied, the object size is reduced to 202 bytes.  This is a saving of 107
bytes and will probably be slightly faster too.

Use READ_ONCE() to access current->flags to prevent the compiler from
possibly accessing current->flags multiple times.

Link: http://lkml.kernel.org/r/20200618212936.9776-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/include/linux/sched/mm.h~sched-mm-optimize-current_gfp_context
+++ a/include/linux/sched/mm.h
@@ -178,14 +178,16 @@ static inline bool in_vfork(struct task_
  */
 static inline gfp_t current_gfp_context(gfp_t flags)
 {
-	if (unlikely(current->flags & (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS))) {
+	unsigned int pflags = READ_ONCE(current->flags);
+
+	if (unlikely(pflags & (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS))) {
 		/*
 		 * NOIO implies both NOIO and NOFS and it is a weaker context
 		 * so always make sure it makes precedence
 		 */
-		if (current->flags & PF_MEMALLOC_NOIO)
+		if (pflags & PF_MEMALLOC_NOIO)
 			flags &= ~(__GFP_IO | __GFP_FS);
-		else if (current->flags & PF_MEMALLOC_NOFS)
+		else if (pflags & PF_MEMALLOC_NOFS)
 			flags &= ~__GFP_FS;
 	}
 	return flags;
_
