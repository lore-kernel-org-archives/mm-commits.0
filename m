Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9532C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 23:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8856A61423
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 23:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347660AbhI2Xri (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Sep 2021 19:47:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344487AbhI2Xri (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 29 Sep 2021 19:47:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 312EE6135E;
        Wed, 29 Sep 2021 23:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632959156;
        bh=MEgJ7KvYi8Av24//nGgzhoDXlUuU7nH5si1THKDNO+s=;
        h=Date:From:To:Subject:From;
        b=k2bQubxRylOj49IC+9Qz8yUrNEDkd747kysj0J4Ygu5B87aGn3VhyAjlqEO77kzz5
         kX74WWyCvFUq1wSnZYcemRMN4Pvjb/92uTu+u/yPKfbh1Dnmf8WVSSE6K3Y8Yh4TKu
         WpGKImp75O+htp4RWdpdA1Ue0gokVDkN/B8hIpY8=
Date:   Wed, 29 Sep 2021 16:45:55 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dvyukov@google.com, elver@google.com,
        glider@google.com, jannh@google.com, mm-commits@vger.kernel.org,
        nogikh@google.com, sfr@canb.auug.org.au, tarasmadan@google.com
Subject:  [to-be-updated]
 =?US-ASCII?Q?kfence-limit-currently-covered-allocations-when-pool-nearl?=
 =?US-ASCII?Q?y-full-fix-fix.patch?= removed from -mm tree
Message-ID: <20210929234555.TUua31Nmy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix-fix
has been removed from the -mm tree.  Its filename was
     kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix-fix

fix i386 build

In file included from ./include/linux/kernel.h:16,
                 from ./include/linux/list.h:9,
                 from ./include/linux/wait.h:7,
                 from ./include/linux/wait_bit.h:8,
                 from ./include/linux/fs.h:6,
                 from ./include/linux/debugfs.h:15,
                 from mm/kfence/core.c:12:
mm/kfence/core.c: In function 'get_alloc_stack_hash':
./include/linux/minmax.h:20:28: error: comparison of distinct pointer types lacks a cast [-Werror]
   20 |  (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
      |                            ^~
./include/linux/minmax.h:26:4: note: in expansion of macro '__typecheck'
   26 |   (__typecheck(x, y) && __no_side_effects(x, y))
      |    ^~~~~~~~~~~
./include/linux/minmax.h:36:24: note: in expansion of macro '__safe_cmp'
   36 |  __builtin_choose_expr(__safe_cmp(x, y), \
      |                        ^~~~~~~~~~
./include/linux/minmax.h:45:19: note: in expansion of macro '__careful_cmp'
   45 | #define min(x, y) __careful_cmp(x, y, <)
      |                   ^~~~~~~~~~~~~
mm/kfence/core.c:177:16: note: in expansion of macro 'min'
  177 |  num_entries = min(num_entries, UNIQUE_ALLOC_STACK_DEPTH);
      |                ^~~

Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Taras Madan <tarasmadan@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kfence/core.c~kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix-fix
+++ a/mm/kfence/core.c
@@ -172,7 +172,7 @@ static inline bool should_skip_covered(v
 	return atomic_long_read(&counters[KFENCE_COUNTER_ALLOCATED]) > thresh;
 }
 
-static u32 get_alloc_stack_hash(unsigned long *stack_entries, size_t num_entries)
+static u32 get_alloc_stack_hash(unsigned long *stack_entries, unsigned long num_entries)
 {
 	num_entries = min(num_entries, UNIQUE_ALLOC_STACK_DEPTH);
 	num_entries = filter_irq_stacks(stack_entries, num_entries);
@@ -839,7 +839,7 @@ void kfence_shutdown_cache(struct kmem_c
 void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
 {
 	unsigned long stack_entries[KFENCE_STACK_DEPTH];
-	size_t num_stack_entries;
+	unsigned long num_stack_entries;
 	u32 alloc_stack_hash;
 
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
hugetlbfs-extend-the-definition-of-hugepages-parameter-to-support-node-allocation-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

