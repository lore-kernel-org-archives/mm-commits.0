Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB34CC433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B96D26103D
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343647AbhIHCUG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235450AbhIHCUG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:20:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D18A60187;
        Wed,  8 Sep 2021 02:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631067539;
        bh=p4uyAHGLApHjD6wFtZmhT/P+IDJDZ7c4EoSC8twvg84=;
        h=Date:From:To:Subject:From;
        b=c0R1DfiPzlFpscQzm6dEBiQhThfjpBFPxJjgvOohnOtfJpC8b8cfmWC07sF6/Pq5Z
         Dmrm4elVwlOPV6mhGnUxgzJEmoXGWmE4Xzmy40iS2cCDHn8+MbHoHjEGIr9OILcZnd
         PiOtfV+5P8fjo5hDlvh4mQoEUt/R2JqHyYNdl2qA=
Date:   Tue, 07 Sep 2021 19:18:58 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        sjpark@amazon.de
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-damon-implement-primitives-for-the-virtual-memory-addr?=
 =?US-ASCII?Q?ess-spaces-fix.patch?= removed from -mm tree
Message-ID: <20210908021858.xe_efhjMN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix
has been removed from the -mm tree.  Its filename was
     mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix.patch

This patch was dropped because it was folded into mm-damon-implement-primitives-for-the-virtual-memory-address-spaces.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix

mm/damon/vaddr.c needs highmem.h for kunmap_atomic()

Cc: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/vaddr.c~mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix
+++ a/mm/damon/vaddr.c
@@ -10,6 +10,7 @@
 #include <linux/damon.h>
 #include <linux/mm.h>
 #include <linux/mmu_notifier.h>
+#include <linux/highmem.h>
 #include <linux/page_idle.h>
 #include <linux/random.h>
 #include <linux/sched/mm.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-damon-implement-primitives-for-the-virtual-memory-address-spaces.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch
checkpatch-improve-git_commit_id-test-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

