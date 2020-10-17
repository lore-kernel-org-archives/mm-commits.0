Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A99BC433DF
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ADEA208E4
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976454;
	bh=hOaqVUk6Ts2NldEbt7e5w6xi/BvKskyBfySCZv/4e50=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=1bqXaObHN3e8ZfKuign0XODgViMw28h1In/vY5dNYNImaIx014DyN6rVhrMx7NJaK
	 5lT2IPxo8TAqMOtu5rfVrzSiyDZsXt/N7c9I1hfGadp2VZAE4QSbMBOCtnVfEfH5gp
	 6bxyz0ppVPyZfYic4uNv3Tszl4L++Lm0pml2IeWo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439891AbgJQXON (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:14:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXON (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:14:13 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACF6C20878;
        Sat, 17 Oct 2020 23:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976453;
        bh=hOaqVUk6Ts2NldEbt7e5w6xi/BvKskyBfySCZv/4e50=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=f/1qtrASMSGmqI/A1treObMrUIMEjxPeFnS7b6/Zi5ujWA2up6uu6KaLTlBKfURq4
         /ieI7SKNKrouyjRgVnNhTWwVRxbJJTxQU+lKFPwlCQ1nzmU/IkVvC8tfSfNCT4Avw4
         CEku5ubewvt2A9NZTFBU6Hcn5hsIC3mjYTH7/JuI=
Date:   Sat, 17 Oct 2020 16:14:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ebiederm@xmission.com, jannh@google.com,
        jgg@nvidia.com, jhubbard@nvidia.com, linux-mm@kvack.org,
        mchehab@kernel.org, mm-commits@vger.kernel.org,
        sakari.ailus@linux.intel.com, torvalds@linux-foundation.org,
        walken@google.com
Subject:  [patch 12/40] mm/gup_benchmark: take the mmap lock around
 GUP
Message-ID: <20201017231412.94CmEnsAR%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
