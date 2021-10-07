Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A6BC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 19:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59BB260FC4
	for <mm-commits@archiver.kernel.org>; Thu,  7 Oct 2021 19:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbhJGTm0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Oct 2021 15:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231495AbhJGTmY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 Oct 2021 15:42:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C44461038;
        Thu,  7 Oct 2021 19:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633635630;
        bh=+9ralLQeB24wRXxj+MiYrO01Wx7pl3hvOvJ2fQY3qxM=;
        h=Date:From:To:Subject:From;
        b=FKVZtcZKLNUQ5nje571ela85Ehz540ltEGG2wNZ7m1CCarrGT3TxN4G/HJVHr+opk
         g2kYi7Sx3FTzr8rIYlf4lH+j6bamYOOJ9TnwZ+tPTRbnHK/LDlXVYpFNbcRGuMeB80
         9Y22R5M+DxET8qp3/KDwDLcaDryEl4KzdqLcaDDE=
Date:   Thu, 07 Oct 2021 12:40:30 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, axboe@kernel.dk, cl@linux.com,
        iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz
Subject:  [to-be-updated]
 mm-dont-call-should_failslab-for-config_failslab-fix.patch removed from -mm
 tree
Message-ID: <20211007194030.2MaXvMlZp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-dont-call-should_failslab-for-config_failslab-fix
has been removed from the -mm tree.  Its filename was
     mm-dont-call-should_failslab-for-config_failslab-fix.patch

This patch was dropped because an updated version will be merged

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
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

