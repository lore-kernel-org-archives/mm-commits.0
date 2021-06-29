Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C70EC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 658ED611AE
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhF2CmV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231719AbhF2CmU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:42:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F5E761D0B;
        Tue, 29 Jun 2021 02:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934393;
        bh=/2IpH6hU5SmbCfx1oZ4BVWrZbh+GJR/oZWSw5LPceVU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dzcYUMh4e8u0yBVfRXgsO+FPeQk33MlV1gH1+mEi0jCcC3d3f9KDUn5hO4xl2dtgu
         AmuwqL6IGerpylAtgfffB8j74Q6xClKN/n83TTXHgnXmbn1aSTcUVYVjjXv+AcdF+7
         Ivc4v5pXxM8gnG1XbRiIhvCaueoC1xEDE2/Kl340=
Date:   Mon, 28 Jun 2021 19:39:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, dbueso@suse.de,
        geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 126/192] mm/mempolicy: use vma_lookup() in
 __access_remote_vm()
Message-ID: <20210629023953.KFc5yMQ5h%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mempolicy: use vma_lookup() in __access_remote_vm()

vma_lookup() finds the vma of a specific address with a cleaner interface
and is more readable.

Link: https://lkml.kernel.org/r/20210521174745.2219620-23-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-vma_lookup-in-__access_remote_vm
+++ a/mm/mempolicy.c
@@ -975,7 +975,7 @@ static long do_get_mempolicy(int *policy
 		 * want to return MPOL_DEFAULT in this case.
 		 */
 		mmap_read_lock(mm);
-		vma = find_vma_intersection(mm, addr, addr+1);
+		vma = vma_lookup(mm, addr);
 		if (!vma) {
 			mmap_read_unlock(mm);
 			return -EFAULT;
_
