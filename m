Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31701C001B1
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjFXAAV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbjFXAAN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3C62693
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D7A4614A8
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6247AC433C0;
        Sat, 24 Jun 2023 00:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564811;
        bh=9i+ucsMRSrnWLC6rWe66c72e2wxXfvS/qW4taGFmvwY=;
        h=Date:To:From:Subject:From;
        b=o4L3BN5dxQ36ZC1Kmr979tORL8ix+E1Kwf/VNI70xk+QhsTfihPwITg9iUwEOensA
         KMc8F3QLfIzJprYXSn1AMpW+O86yURGLPrNGyfCZDQhrP5thAhCfi8nhlKve3p/4Y1
         +g6KqRptf/pZf3re95AD/3/nHJInUh0tW0bh5re4=
Date:   Fri, 23 Jun 2023 17:00:10 -0700
To:     mm-commits@vger.kernel.org, lstoakes@gmail.com,
        jhubbard@nvidia.com, david@redhat.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-do-not-return-0-from-pin_user_pages_fast-for-bad-args.patch removed from -mm tree
Message-Id: <20230624000011.6247AC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: do not return 0 from pin_user_pages_fast() for bad args
has been removed from the -mm tree.  Its filename was
     mm-gup-do-not-return-0-from-pin_user_pages_fast-for-bad-args.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: do not return 0 from pin_user_pages_fast() for bad args
Date: Mon, 19 Jun 2023 15:27:25 -0300

These routines are not intended to return zero, the callers cannot do
anything sane with a 0 return.  They should return an error which means
future calls to GUP will not succeed, or they should return some non-zero
number of pinned pages which means GUP should be called again.

If start + nr_pages overflows it should return -EOVERFLOW to signal the
arguments are invalid.

Syzkaller keeps tripping on this when fuzzing GUP arguments.

Link: https://lkml.kernel.org/r/0-v1-3d5ed1f20d50+104-gup_overflow_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reported-by: syzbot+353c7be4964c6253f24a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000094fdd05faa4d3a4@google.com
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-do-not-return-0-from-pin_user_pages_fast-for-bad-args
+++ a/mm/gup.c
@@ -3080,7 +3080,7 @@ static int internal_get_user_pages_fast(
 	start = untagged_addr(start) & PAGE_MASK;
 	len = nr_pages << PAGE_SHIFT;
 	if (check_add_overflow(start, len, &end))
-		return 0;
+		return -EOVERFLOW;
 	if (end > TASK_SIZE_MAX)
 		return -EFAULT;
 	if (unlikely(!access_ok((void __user *)start, len)))
_

Patches currently in -mm which might be from jgg@nvidia.com are


