Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93FCCC433FE
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 21:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7629261215
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 21:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbhJEVVH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 17:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235845AbhJEVVH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 17:21:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC1D4610FB;
        Tue,  5 Oct 2021 21:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633468756;
        bh=62N7++GcqDtJmNU7We4ViMYy+Eea/y+vB5O+IzDd/2I=;
        h=Date:From:To:Subject:From;
        b=McrEbQhVyO3XrA7q1psP5NTslQfDSvGPcBzhP2uD20HeG7tQlVyTLRcn1hqrOtfeg
         fiZWTlPuyXl7lCUEVaawx+nwimO4Jf6aT8+NXLxH1PXFo1WEGgzvrCpu3l/RlMAGib
         P+2hzOzdEqX1cTXZsfszP9IN8or9p29uj1Fo7n/g=
Date:   Tue, 05 Oct 2021 14:19:15 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, axboe@kernel.dk, cl@linux.com,
        iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz
Subject:  +
 mm-dont-call-should_failslab-for-config_failslab-fix.patch added to -mm
 tree
Message-ID: <20211005211915.fvkrqV4Sp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-dont-call-should_failslab-for-config_failslab-fix
has been added to the -mm tree.  Its filename is
     mm-dont-call-should_failslab-for-config_failslab-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-dont-call-should_failslab-for-config_failslab-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-call-should_failslab-for-config_failslab-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-dont-call-should_failslab-for-config_failslab-fix

avoid ifdefs

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fault-inject.h |    4 ++++
 mm/slab.h                    |    2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/fault-inject.h~mm-dont-call-should_failslab-for-config_failslab-fix
+++ a/include/linux/fault-inject.h
@@ -68,6 +68,10 @@ struct kmem_cache;
 int should_failslab(struct kmem_cache *s, gfp_t gfpflags);
 extern bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags);
 #else
+static inline int should_failslab(struct kmem_cache *s, gfp_t gfpflags)
+{
+	return 0;
+}
 static inline bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags)
 {
 	return false;
--- a/mm/slab.h~mm-dont-call-should_failslab-for-config_failslab-fix
+++ a/mm/slab.h
@@ -491,10 +491,8 @@ static inline struct kmem_cache *slab_pr
 
 	might_alloc(flags);
 
-#ifdef CONFIG_FAILSLAB
 	if (should_failslab(s, flags))
 		return NULL;
-#endif
 
 	if (!memcg_slab_pre_alloc_hook(s, objcgp, size, flags))
 		return NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-dont-call-should_failslab-for-config_failslab-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
hugetlbfs-extend-the-definition-of-hugepages-parameter-to-support-node-allocation-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

