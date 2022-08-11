Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AAADC19F2A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 21:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiHKVtq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 17:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234743AbiHKVtp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 17:49:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC98D9F76E
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 14:49:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C1BDB822C3
        for <mm-commits@vger.kernel.org>; Thu, 11 Aug 2022 21:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F72C433C1;
        Thu, 11 Aug 2022 21:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660254581;
        bh=MkTTixymR+M9HQ7MsNyPVwAGJP5goZIr7E6eBpOzw9A=;
        h=Date:To:From:Subject:From;
        b=IyWVn07X+RlWInNcB6plQqwwVu9xIanlp9qtBfI5oGrS5Zk2un2xxZhP8OIeU1jRo
         U+KS6OHdAQtVCn+gewV5n5vcUVzzgcbBVkW3h+tCAHtyMCNn1X0glnSiPh2MFQJrlA
         uBwTpQXHh1BNF5zVjQu6zCpaVbV0fpc26PDYqd1w=
Date:   Thu, 11 Aug 2022 14:49:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        rburny@google.com, djwong@kernel.org, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-shmem_replace_page-remember-nr_shmem.patch added to mm-hotfixes-unstable branch
Message-Id: <20220811214941.33F72C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: shmem_replace_page() remember NR_SHMEM
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-shmem_replace_page-remember-nr_shmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-shmem_replace_page-remember-nr_shmem.patch

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

mm-shmem-fix-chattr-fsflags-support-in-tmpfs.patch
mm-shmem-tmpfs-fallocate-use-file_modified.patch
mm-shmem-shmem_replace_page-remember-nr_shmem.patch

