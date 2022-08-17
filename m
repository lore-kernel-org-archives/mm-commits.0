Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D6F5C25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 20:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242210AbiHQU6c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 16:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242165AbiHQU52 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 16:57:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC40AB413
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 13:57:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 251B7615A6
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 20:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77661C433D6;
        Wed, 17 Aug 2022 20:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660769838;
        bh=csP7XbM2rzGxbYC/SLLLPSa3M9SwQkdKVeL/dfGfLnc=;
        h=Date:To:From:Subject:From;
        b=oOvjhwKKOtgWg8QQQDqvZXqcfRLKdu42WTXNl+RcbEEkredmf/yTuT9/4ST6Z3bSK
         sKrTEoTDArFcvoBLlc+ZZ6o/IY60bvOc+VY/pzNrRhEnUvparN29M67Uf0xMsWbVcV
         ct9K/P+iVRQp8Hsht0J3Pk4l1D4ihsZbJ1QYamwY=
Date:   Wed, 17 Aug 2022 13:57:17 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        rburny@google.com, djwong@kernel.org, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-shmem_replace_page-remember-nr_shmem.patch removed from -mm tree
Message-Id: <20220817205718.77661C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: shmem_replace_page() remember NR_SHMEM
has been removed from the -mm tree.  Its filename was
     mm-shmem-shmem_replace_page-remember-nr_shmem.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/shmem: shmem_replace_page() remember NR_SHMEM
Date: Wed, 10 Aug 2022 22:06:33 -0700 (PDT)

Elsewhere, NR_SHMEM is updated at the same time as shmem NR_FILE_PAGES;
but shmem_replace_page() was forgetting to do that - so NR_SHMEM stats
could grow too big or too small, in those unusual cases when it's used.

Link: https://lkml.kernel.org/r/cec7c09d-5874-e160-ada6-6e10ee48784@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Radoslaw Burny <rburny@google.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/shmem.c~mm-shmem-shmem_replace_page-remember-nr_shmem
+++ a/mm/shmem.c
@@ -1659,7 +1659,9 @@ static int shmem_replace_page(struct pag
 		new = page_folio(newpage);
 		mem_cgroup_migrate(old, new);
 		__inc_lruvec_page_state(newpage, NR_FILE_PAGES);
+		__inc_lruvec_page_state(newpage, NR_SHMEM);
 		__dec_lruvec_page_state(oldpage, NR_FILE_PAGES);
+		__dec_lruvec_page_state(oldpage, NR_SHMEM);
 	}
 	xa_unlock_irq(&swap_mapping->i_pages);
 
_

Patches currently in -mm which might be from hughd@google.com are


