Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0CE6C5479D
	for <mm-commits@archiver.kernel.org>; Mon,  9 Jan 2023 22:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237371AbjAIWSD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 17:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbjAIWSC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 17:18:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FF91117A;
        Mon,  9 Jan 2023 14:18:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99AB86145F;
        Mon,  9 Jan 2023 22:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC65FC433D2;
        Mon,  9 Jan 2023 22:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673302680;
        bh=NLXtRZJSpY1d+h7PrbytlbZnTOekHgqdiWZ3M5BBds8=;
        h=Date:To:From:Subject:From;
        b=nyjdejR7/oLKwxd8Z0l3UYBJPFScYszGpwAQXpiaWfLz6LmgNjrB8e65YIglnD3/g
         p7JeqbBXYryr2Dtf1GeMLYtwMTrS3BDA1HqSc2Y3HHzvgtTbWP+QgBBU+AsT5EtQX6
         r1LCo67eNrK4A+doGO7iWbpEy/eDpDEmdFOKNuPA=
Date:   Mon, 09 Jan 2023 14:18:00 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, stable@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nommu-fix-memory-leak-in-do_mmap-error-path.patch added to mm-hotfixes-unstable branch
Message-Id: <20230109221800.DC65FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nommu: fix memory leak in do_mmap() error path
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nommu-fix-memory-leak-in-do_mmap-error-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nommu-fix-memory-leak-in-do_mmap-error-path.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: nommu: fix memory leak in do_mmap() error path
Date: Mon, 9 Jan 2023 20:55:21 +0000

The preallocation of the maple tree nodes may leak if the error path to
"error_just_free" is taken.  Fix this by moving the freeing of the maple
tree nodes to a shared location for all error paths.

Link: https://lkml.kernel.org/r/20230109205507.955577-1-Liam.Howlett@oracle.com
Fixes: 8220543df148 ("nommu: remove uses of VMA linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/nommu.c~nommu-fix-memory-leak-in-do_mmap-error-path
+++ a/mm/nommu.c
@@ -1240,6 +1240,7 @@ share:
 error_just_free:
 	up_write(&nommu_region_sem);
 error:
+	mas_destroy(&mas);
 	if (region->vm_file)
 		fput(region->vm_file);
 	kmem_cache_free(vm_region_jar, region);
@@ -1250,7 +1251,6 @@ error:
 
 sharing_violation:
 	up_write(&nommu_region_sem);
-	mas_destroy(&mas);
 	pr_warn("Attempt to share mismatched mappings\n");
 	ret = -EINVAL;
 	goto error;
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

nommu-fix-memory-leak-in-do_mmap-error-path.patch
nommu-fix-do_munmap-error-path.patch
nommu-fix-split_vma-map_count-error.patch
maple_tree-remove-gfp_zero-from-kmem_cache_alloc-and-kmem_cache_alloc_bulk.patch

