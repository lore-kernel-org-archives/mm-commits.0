Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1BDCC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 00:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbiKOAnU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Nov 2022 19:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiKOAnT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2022 19:43:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7141ADBD
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 16:43:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53B4DB810F7
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 00:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF874C433C1;
        Tue, 15 Nov 2022 00:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668472996;
        bh=90lR07NOD/Du8zOgDJ7iMu33NtP0UwtejBfmGffRt+I=;
        h=Date:To:From:Subject:From;
        b=t/n5epeZZdnYxnaSkXVuRTvuYdjNZMf1Oii1/Pp/iCWO8/tgzlf4XzClHWcLLO0f0
         wgHKv3A2u5rbn2nE5fzjwhhQ/VdcMFT+LghsAB6pcUslkVo1D+jev1aWAOCO55f2Kb
         h5Sep5qPAYp+O3BxIM53bRztZZ1J1n0qz9H5TQ/E=
Date:   Mon, 14 Nov 2022 16:43:15 -0800
To:     mm-commits@vger.kernel.org, liam.howlett@oracle.com,
        david@redhat.com, ian@linux.cowan.aero, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-fix-documentation-for-vma_mas_szero.patch added to mm-hotfixes-unstable branch
Message-Id: <20221115004315.DF874C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmap: fix documentation for vma_mas_szero
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mmap-fix-documentation-for-vma_mas_szero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-fix-documentation-for-vma_mas_szero.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ian Cowan <ian@linux.cowan.aero>
Subject: mm: mmap: fix documentation for vma_mas_szero
Date: Sun, 13 Nov 2022 19:33:49 -0500

When the struct_mm input, mm, was changed to a struct ma_state, mas, the
documentation for the function was never updated.  This updates that
documentation reference.

Link: https://lkml.kernel.org/r/20221114003349.41235-1-ian@linux.cowan.aero
Signed-off-by: Ian Cowan <ian@linux.cowan.aero>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-fix-documentation-for-vma_mas_szero
+++ a/mm/mmap.c
@@ -456,7 +456,7 @@ void vma_mas_remove(struct vm_area_struc
  * vma_mas_szero() - Set a given range to zero.  Used when modifying a
  * vm_area_struct start or end.
  *
- * @mm: The struct_mm
+ * @mas: The maple tree ma_state
  * @start: The start address to zero
  * @end: The end address to zero.
  */
_

Patches currently in -mm which might be from ian@linux.cowan.aero are

mm-mmap-fix-documentation-for-vma_mas_szero.patch

