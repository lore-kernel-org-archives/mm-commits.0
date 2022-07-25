Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA9FC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 19:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiGYTWd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 15:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiGYTWd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 15:22:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C936B849
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 12:22:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD30A60F13
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 19:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390D2C341C6;
        Mon, 25 Jul 2022 19:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658776951;
        bh=2j6xG2r4jNVzAc9lDkbrfeTenm4jHua6bLWDbULW78Y=;
        h=Date:To:From:Subject:From;
        b=m+4xXcxbI2JMM4AHr/VJ7Sn4AKLHf5luQpHG7rMDkFRTzK0G9o/oYRzfFe/Qj6SiC
         IhisOuvZEyED6RVNEW7wtqLChQSvta/xW9R3qX6oBvK73zoGxLx07x/FNiuGmflYmk
         PXuT7oHMWTsmJcrfUHzEan502ooDXASBVZuDJ/i8=
Date:   Mon, 25 Jul 2022 12:22:30 -0700
To:     mm-commits@vger.kernel.org, herberthbli@tencent.com,
        herbert@gondor.apana.org.au, slark_xiao@163.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-mpi-fix-typo-the-the-in-comment.patch added to mm-nonmm-unstable branch
Message-Id: <20220725192231.390D2C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/mpi: fix typo 'the the' in comment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-mpi-fix-typo-the-the-in-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-mpi-fix-typo-the-the-in-comment.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Slark Xiao <slark_xiao@163.com>
Subject: lib/mpi: fix typo 'the the' in comment
Date: Fri, 22 Jul 2022 18:19:22 +0800

Replace 'the the' with 'the' in the comment.

Link: https://lkml.kernel.org/r/20220722101922.81126-1-slark_xiao@163.com
Signed-off-by: Slark Xiao <slark_xiao@163.com>
Cc: Hongbo Li <herberthbli@tencent.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/mpi/mpiutil.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/mpi/mpiutil.c~lib-mpi-fix-typo-the-the-in-comment
+++ a/lib/mpi/mpiutil.c
@@ -272,7 +272,7 @@ MPI mpi_set_ui(MPI w, unsigned long u)
 	if (!w)
 		w = mpi_alloc(1);
 	/* FIXME: If U is 0 we have no need to resize and thus possible
-	 * allocating the the limbs.
+	 * allocating the limbs.
 	 */
 	RESIZE_IF_NEEDED(w, 1);
 	w->d[0] = u;
_

Patches currently in -mm which might be from slark_xiao@163.com are

lib-mpi-fix-typo-the-the-in-comment.patch

