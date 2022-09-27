Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957F6C6FA82
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiI0C4I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiI0Cyw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:54:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C876186DB
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:50:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40B16615B5
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98925C433D6;
        Tue, 27 Sep 2022 02:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664247005;
        bh=GwTADE+/vkFPgd2iwkpPO2I+9YKHoWYtZR/Wsc5nHiA=;
        h=Date:To:From:Subject:From;
        b=YtGLR0khkP83GI1CneGeCvtwgFzUvMcuGtYnrodXGBhA36WOrDdZiep9IQHecWtK3
         j/MQ/eTnGBTPHtJknltGp7METJdSc8wEcp+KIkEs4sGZRLootw9XHA9nK4othiFJnR
         hWNAWW0W0PB9/ALX29XYyT+rkbz8oZCu2TiIIns8=
Date:   Mon, 26 Sep 2022 19:50:04 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch removed from -mm tree
Message-Id: <20220927025005.98925C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mlock: drop dead code in count_mm_mlocked_page_nr()
has been removed from the -mm tree.  Its filename was
     mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/mlock: drop dead code in count_mm_mlocked_page_nr()
Date: Wed, 15 Jun 2022 17:40:58 +0000

The check for mm being null has never been needed since the only caller
has always passed in current->mm.  Remove the check from
count_mm_mlocked_page_nr().

Link: https://lkml.kernel.org/r/20220615174050.738523-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Suggested-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mlock.c~mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr
+++ a/mm/mlock.c
@@ -531,14 +531,12 @@ static unsigned long count_mm_mlocked_pa
 	unsigned long end;
 	VMA_ITERATOR(vmi, mm, start);
 
-	if (mm == NULL)
-		mm = current->mm;
-
 	/* Don't overflow past ULONG_MAX */
 	if (unlikely(ULONG_MAX - len < start))
 		end = ULONG_MAX;
 	else
 		end = start + len;
+
 	for_each_vma_range(vmi, vma, end) {
 		if (vma->vm_flags & VM_LOCKED) {
 			if (start > vma->vm_start)
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


