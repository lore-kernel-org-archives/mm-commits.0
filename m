From: akpm@linux-foundation.org
Subject: +
 list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
 added to -mm tree
Date: Thu, 30 Nov 2017 12:47:42 -0800
Message-ID: <5a206e6e.0YpNZhxi7s8yfUmR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54198 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751057AbdK3Urn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:47:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@fromorbit.com, hannes@cmpxchg.org, longman@redhat.com, sfr@canb.auug.org.au, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix
has been added to the -mm tree.  Its filename is
     list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix

include prefetch.h, remove unlocked list_empty() test, per Dave

Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/list_lru.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/list_lru.c~list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix mm/list_lru.c
--- a/mm/list_lru.c~list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix
+++ a/mm/list_lru.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/list_lru.h>
+#include <linux/prefetch.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/memcontrol.h>
@@ -135,13 +136,11 @@ bool list_lru_del(struct list_lru *lru,
 	/*
 	 * Prefetch the neighboring list entries to reduce lock hold time.
 	 */
-	if (unlikely(list_empty(item)))
-		return false;
 	prefetchw(item->prev);
 	prefetchw(item->next);
 
 	spin_lock(&nlru->lock);
-	if (likely(!list_empty(item))) {
+	if (!list_empty(item)) {
 		l = list_lru_from_kmem(nlru, item);
 		list_del_init(item);
 		l->nr_items--;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

