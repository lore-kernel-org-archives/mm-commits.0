Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3921EC388F7
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01B3B207EA
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408182;
	bh=kMiWqmIOxbLvuw55W4Pi+D/xtMiAcjplTDZJqSRaAMY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=htmWGweNLT6oPLSRi5DOwsA1HCsstFFKwncc08rVLj3k8uAERgqYz9xeDpvwBnU7s
	 7hi/DN1kHUwGbavELCk/nDmL87OY1nJI78RHkt9tTsF5oPgFxx9eKYYqCvilRuLrSx
	 a56ILb7l4RdkAaHUt5d5yHIKjRsqLhyFATvb/DU0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373247AbgJVXJl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:09:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373127AbgJVXJl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:09:41 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAF9D20756;
        Thu, 22 Oct 2020 23:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408180;
        bh=kMiWqmIOxbLvuw55W4Pi+D/xtMiAcjplTDZJqSRaAMY=;
        h=Date:From:To:Subject:From;
        b=w96a4AGoinT6sCCicx2MVmqtDOxfzJtWN7lFFgj8f1w11Yj9mHWk8lsEzCI7gRM25
         E8yFLD8rFFZikn0E61L2ixblMfDt+BCz5Eb+Evu909ecxSq2Lnax6poHJYfdH6eh2k
         XT7t4wqg6zgm9UdY4Jsjgtjs75ogjSvM80Egx09c=
Date:   Thu, 22 Oct 2020 16:09:39 -0700
From:   akpm@linux-foundation.org
To:     ebiederm@xmission.com, jannh@google.com, jgg@nvidia.com,
        jhubbard@nvidia.com, mchehab@kernel.org,
        mm-commits@vger.kernel.org, sakari.ailus@linux.intel.com,
        walken@google.com
Subject:  [merged]
 mm-gup_benchmark-take-the-mmap-lock-around-gup.patch removed from -mm tree
Message-ID: <20201022230939.33jamHgQb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup_benchmark: take the mmap lock around GUP
has been removed from the -mm tree.  Its filename was
     mm-gup_benchmark-take-the-mmap-lock-around-gup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Michel Lespinasse <walken@google.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
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

mm-gup-assert-that-the-mmap-lock-is-held-in-__get_user_pages.patch
mmap-locking-api-dont-check-locking-if-the-mm-isnt-live-yet.patch

