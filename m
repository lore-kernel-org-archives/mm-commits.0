Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6A6C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99E772078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266143;
	bh=7hFNLTmCM53WidHXcPFFqgFpPbgPpER16aFpN2hM6DY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=xVJH5VWxOTjSmK+4MNz6iVTt0GloVngCc90na/mIgT97n+zfBLQWGOvq7OqldsYLS
	 fgWXYHg55I5Kju8i9GnPjoGCErNQ3A5xJf0SOdoF/stIuXLKk9HWet/33mwSs2fwOJ
	 q/zqkiyyeaE6HHw1fmMbjJlDq9ph8QC+cLynqVW0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgHLVCX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgHLVCX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:23 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 620EF2087C;
        Wed, 12 Aug 2020 21:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266141;
        bh=7hFNLTmCM53WidHXcPFFqgFpPbgPpER16aFpN2hM6DY=;
        h=Date:From:To:Subject:From;
        b=zqWFsfmnuZgLixMGV0TN2lh8e6DsfvQbxB8ccdtFJPcwWZVjiISJ7GcnUqjb+OkLc
         WbZAtF6T61lIM8ffr4vDXtrc8Su3ZI1qVd9RvUaU3RFBMGfAcNrPK+Ei1nE26BynD6
         gJSy0MdYqJCb1ckOp08n7l+lxNLjcONrp9XdVCUQ=
Date:   Wed, 12 Aug 2020 14:02:21 -0700
From:   akpm@linux-foundation.org
To:     longman@redhat.com, mathieu.desnoyers@efficios.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, peterz@infradead.org,
        walken@google.com
Subject:  [merged] sched-mm-optimize-current_gfp_context.patch
 removed from -mm tree
Message-ID: <20200812210221.bNuT5LOO9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/sched/mm.h: optimize current_gfp_context()
has been removed from the -mm tree.  Its filename was
     sched-mm-optimize-current_gfp_context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from longman@redhat.com are


