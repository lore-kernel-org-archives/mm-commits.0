Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF11C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379811AbiFQCuM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379812AbiFQCtq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D3465406
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47046B826ED
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E459FC34114;
        Fri, 17 Jun 2022 02:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434183;
        bh=cNJd+4c73l5RFdEJJxPOgEh5gBmshxOQ7FQmpIzanv4=;
        h=Date:To:From:Subject:From;
        b=IhL+oFrzMH7qP2SwFnVFslAZgEndXPqZgR8RRQdKCMaBfM2CdW2EEY7SMeI0nEGOk
         qDvxvNFfw5WHOm/T7pFDT9eAps0FB4zo6L38VrBXq5ybrRGxp5OaMd9bA8zHkQnqSG
         +hvLZEA73dobiXSoV0Kx+QCIf2UqVdXHXSypLBdQ=
Date:   Thu, 16 Jun 2022 19:49:42 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        osalvador@suse.de, joao.m.martins@oracle.com, david@redhat.com,
        gautammenghani201@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unwanted-initialization-in-vmemmap_populate_compound_pages.patch removed from -mm tree
Message-Id: <20220617024942.E459FC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/sparse-vmemmap.c: remove unwanted initialization in vmemmap_populate_compound_pages()
has been removed from the -mm tree.  Its filename was
     mm-remove-unwanted-initialization-in-vmemmap_populate_compound_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gautam Menghani <gautammenghani201@gmail.com>
Subject: mm/sparse-vmemmap.c: remove unwanted initialization in vmemmap_populate_compound_pages()
Date: Sun, 12 Jun 2022 11:23:20 -0700

Remove unnecessary initialization for the variable 'next'.  This fixes
the clang scan warning: Value stored to 'next' during its
initialization is never read [deadcode.DeadStores]

Link: https://lkml.kernel.org/r/20220612182320.160651-1-gautammenghani201@gmail.com
Signed-off-by: Gautam Menghani <gautammenghani201@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse-vmemmap.c~mm-remove-unwanted-initialization-in-vmemmap_populate_compound_pages
+++ a/mm/sparse-vmemmap.c
@@ -737,7 +737,7 @@ static int __meminit vmemmap_populate_co
 
 	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
 	for (addr = start; addr < end; addr += size) {
-		unsigned long next = addr, last = addr + size;
+		unsigned long next, last = addr + size;
 
 		/* Populate the head page vmemmap page */
 		pte = vmemmap_populate_address(addr, node, NULL, NULL);
_

Patches currently in -mm which might be from gautammenghani201@gmail.com are


