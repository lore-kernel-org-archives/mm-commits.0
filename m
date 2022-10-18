Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B8EC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 00:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiJRAig (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 20:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbiJRAiV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 20:38:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D4B8C46F
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 17:37:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E2FBB81BF4
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 00:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEFAC433B5;
        Tue, 18 Oct 2022 00:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666052958;
        bh=ZOX6O4HPsOomTfV1gTNLXHYo1GsSS0/o9ugLxHOaFso=;
        h=Date:To:From:Subject:From;
        b=gjHq28cNNi3bcbz6NUSnXqzXe7116seA2BAxunqPKy+DMDdNlMFQwbNQaUSSNAqOV
         GzUmat/E++pB2CLSUfMUI+oX4ybdRgQBQTtYteY8MydpKnRtj62yZnm/zzvKeKMc3J
         wKGSOTFl112VbUoGie8hD5SFJ0jYYNJI4IL2VU+I=
Date:   Mon, 17 Oct 2022 17:29:18 -0700
To:     mm-commits@vger.kernel.org, wangdeming@inspur.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-vma_lookup-instead-of-find_vma.patch added to mm-unstable branch
Message-Id: <20221018002918.CEEFAC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mincore.c: use vma_lookup() instead of find_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-vma_lookup-instead-of-find_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-vma_lookup-instead-of-find_vma.patch

This patch will later appear in the mm-unstable branch at
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
From: Deming Wang <wangdeming@inspur.com>
Subject: mm/mincore.c: use vma_lookup() instead of find_vma()
Date: Thu, 6 Oct 2022 23:03:45 -0400

Using vma_lookup() verifies the start address is contained in the found
vma.  This results in easier to read the code.

Link: https://lkml.kernel.org/r/20221007030345.5029-1-wangdeming@inspur.com
Signed-off-by: Deming Wang <wangdeming@inspur.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mincore.c~mm-use-vma_lookup-instead-of-find_vma
+++ a/mm/mincore.c
@@ -190,8 +190,8 @@ static long do_mincore(unsigned long add
 	unsigned long end;
 	int err;
 
-	vma = find_vma(current->mm, addr);
-	if (!vma || addr < vma->vm_start)
+	vma = vma_lookup(current->mm, addr);
+	if (!vma)
 		return -ENOMEM;
 	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
 	if (!can_do_mincore(vma)) {
_

Patches currently in -mm which might be from wangdeming@inspur.com are

mm-use-vma_lookup-instead-of-find_vma.patch

