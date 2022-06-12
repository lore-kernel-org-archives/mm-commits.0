Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A185C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 12 Jun 2022 18:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbiFLS2z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 12 Jun 2022 14:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbiFLS20 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 12 Jun 2022 14:28:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9BFE08B
        for <mm-commits@vger.kernel.org>; Sun, 12 Jun 2022 11:28:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC66AB80B7E
        for <mm-commits@vger.kernel.org>; Sun, 12 Jun 2022 18:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEF8C34115;
        Sun, 12 Jun 2022 18:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655058501;
        bh=ORocKMob4r+cr77X5RcJJhd9pwLRL+lsrEeTn+2LI9w=;
        h=Date:To:From:Subject:From;
        b=KfQ9Zlo7KwE9utKbkBFJHGhlXkN48vyKX1EUhHetr0VTNVRxNXIyIdsr6v2X78WKp
         qPbLNdtYzknDlkfCyiGXf1jxgkRR8/Je18jFPA1Xox4lLAOxAmrwNCfTyxOuteL/QC
         GctilUfCF6s1Mu/ItMygGLl5ObOZ80Vkzupgs18Y=
Date:   Sun, 12 Jun 2022 11:28:20 -0700
To:     mm-commits@vger.kernel.org, gautammenghani201@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unwanted-initialization-in-vmemmap_populate_compound_pages.patch added to mm-unstable branch
Message-Id: <20220612182821.9AEF8C34115@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse-vmemmap.c: remove unwanted initialization in vmemmap_populate_compound_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-unwanted-initialization-in-vmemmap_populate_compound_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unwanted-initialization-in-vmemmap_populate_compound_pages.patch

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
From: Gautam Menghani <gautammenghani201@gmail.com>
Subject: mm/sparse-vmemmap.c: remove unwanted initialization in vmemmap_populate_compound_pages()
Date: Sun, 12 Jun 2022 11:23:20 -0700

Remove unwanted initialization for the variable 'next'.  This fixes the
clang scan warning: Value stored to 'next' during its initialization is
never read [deadcode.DeadStores]

Link: https://lkml.kernel.org/r/20220612182320.160651-1-gautammenghani201@gmail.com
Signed-off-by: Gautam Menghani <gautammenghani201@gmail.com>
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

mm-remove-unwanted-initialization-in-vmemmap_populate_compound_pages.patch

