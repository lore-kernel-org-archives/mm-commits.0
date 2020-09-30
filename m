Return-Path: <SRS0=jIyd=DH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD20C4741F
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 22:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0176D2072E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 22:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601505688;
	bh=Wz7YXBqDl3UC1nLvz+i0i72sg9yClgqkMl2qZrmPC2g=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=za/QeCmeljmeJIyDMYFijoqhpcHo+iHJzWcI/cEAhMhPzL+YUQcgAFRzDrgOVarMu
	 qEw1uJgO3jBWQOi0E7Vyn+xu49u+IsoD2dT4xvmgwTMJRzKp4OOqSUqcmV5LPXfIRc
	 zVy/YZI0zrN/rAi9FIKgH3Lrw3ymgOyfpgg5LpG0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730548AbgI3WlZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Sep 2020 18:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgI3WlH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Sep 2020 18:41:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F5472072E;
        Wed, 30 Sep 2020 22:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601505666;
        bh=Wz7YXBqDl3UC1nLvz+i0i72sg9yClgqkMl2qZrmPC2g=;
        h=Date:From:To:Subject:From;
        b=0J95AeIHJGgIvGezDHHalE43BiQDmm/hn4b7hAbgV1oB6eB8M6ISaW9q7iBBAS39B
         MoSbUvuT06hCqZtZt6XJH3kIpbs3a2mxhFGloLupTfJqxFFnRtUWkJIZ9ZPUhjvwUl
         bh6X0ZfJ3gc7+s5yoSkakX9dQ0pKZtiHld8SMwEw=
Date:   Wed, 30 Sep 2020 15:41:05 -0700
From:   akpm@linux-foundation.org
To:     ebiederm@xmission.com, jannh@google.com, jgg@nvidia.com,
        jhubbard@nvidia.com, mchehab@kernel.org,
        mm-commits@vger.kernel.org, sakari.ailus@linux.intel.com,
        walken@google.com
Subject:  + mm-gup_benchmark-take-the-mmap-lock-around-gup.patch
 added to -mm tree
Message-ID: <20200930224105.-u-lp6tzJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup_benchmark: take the mmap lock around GUP
has been added to the -mm tree.  Its filename is
     mm-gup_benchmark-take-the-mmap-lock-around-gup.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup_benchmark-take-the-mmap-lock-around-gup.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup_benchmark-take-the-mmap-lock-around-gup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm/gup_benchmark: take the mmap lock around GUP

To be safe against concurrent changes to the VMA tree, we must take the
mmap lock around GUP operations (excluding the GUP-fast family of
operations, which will take the mmap lock by themselves if necessary).

This code is only for testing, and it's only reachable by root through
debugfs, so this doesn't really have any impact; however, if we want to
add lockdep asserts into the GUP path, we need to have clean locking here.

Link: https://lkml.kernel.org/r/CAG48ez3SG6ngZLtasxJ6LABpOnqCz5-QHqb0B4k44TQ8F9n6+w@mail.gmail.com
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_benchmark.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/mm/gup_benchmark.c~mm-gup_benchmark-take-the-mmap-lock-around-gup
+++ a/mm/gup_benchmark.c
@@ -72,6 +72,8 @@ static int __gup_benchmark_ioctl(unsigne
 	int nr;
 	struct page **pages;
 	int ret = 0;
+	bool needs_mmap_lock =
+		cmd != GUP_FAST_BENCHMARK && cmd != PIN_FAST_BENCHMARK;
 
 	if (gup->size > ULONG_MAX)
 		return -EINVAL;
@@ -81,6 +83,11 @@ static int __gup_benchmark_ioctl(unsigne
 	if (!pages)
 		return -ENOMEM;
 
+	if (needs_mmap_lock && mmap_read_lock_killable(current->mm)) {
+		ret = -EINTR;
+		goto free_pages;
+	}
+
 	i = 0;
 	nr = gup->nr_pages_per_call;
 	start_time = ktime_get();
@@ -120,9 +127,8 @@ static int __gup_benchmark_ioctl(unsigne
 					    pages + i, NULL);
 			break;
 		default:
-			kvfree(pages);
 			ret = -EINVAL;
-			goto out;
+			goto unlock;
 		}
 
 		if (nr <= 0)
@@ -150,8 +156,11 @@ static int __gup_benchmark_ioctl(unsigne
 	end_time = ktime_get();
 	gup->put_delta_usec = ktime_us_delta(end_time, start_time);
 
+unlock:
+	if (needs_mmap_lock)
+		mmap_read_unlock(current->mm);
+free_pages:
 	kvfree(pages);
-out:
 	return ret;
 }
 
_

Patches currently in -mm which might be from jannh@google.com are

mm-mmu_notifier-fix-mmget-assert-in-__mmu_interval_notifier_insert.patch
binfmt_elf_fdpic-stop-using-dump_emit-on-user-pointers-on-mmu.patch
coredump-let-dump_emit-bail-out-on-short-writes.patch
coredump-refactor-page-range-dumping-into-common-helper.patch
coredump-rework-elf-elf_fdpic-vma_dump_size-into-common-helper.patch
binfmt_elf-binfmt_elf_fdpic-use-a-vma-list-snapshot.patch
mm-gup-take-mmap_lock-in-get_dump_page.patch
mm-remove-the-now-unnecessary-mmget_still_valid-hack.patch
mm-gup_benchmark-take-the-mmap-lock-around-gup.patch
binfmt_elf-take-the-mmap-lock-around-find_extend_vma.patch
mmap-locking-api-dont-check-locking-if-the-mm-isnt-live-yet.patch
mm-gup-assert-that-the-mmap-lock-is-held-in-__get_user_pages.patch

