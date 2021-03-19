Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E52C433C1
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 23:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82C4F6197B
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 23:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhCSXK5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 19:10:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229725AbhCSXKw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 19:10:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E69D26197E;
        Fri, 19 Mar 2021 23:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616195452;
        bh=H4Df2vhc+ylX5YPlAaRoWs4W8k5+hfVjre4H9y454Vs=;
        h=Date:From:To:Subject:From;
        b=YByECqPmHt+K3wYCCIP9D2Ws8etlEadO11tfqys/I5/+mQi+fiX/hz7Av6mOMZUEM
         qXVqP7accZyuoRzF0TICKO3WX7JBtMnof7qOJZ51PQIfQVBwRWYDIRBS4sUEsBuwu3
         b8bYDeJvSXLG9eHzD5ef3sExWCJ+QNS5I2KiGFzA=
Date:   Fri, 19 Mar 2021 16:10:51 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org,
        npiggin@gmail.com, sfr@canb.auug.org.au
Subject:  + mm-vmalloc-hugepage-vmalloc-mappings-fix.patch added to
 -mm tree
Message-ID: <20210319231051.Zh1bITVQj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: [next] mm/vmalloc: fix read of uninitialized pointer area
has been added to the -mm tree.  Its filename is
     mm-vmalloc-hugepage-vmalloc-mappings-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-hugepage-vmalloc-mappings-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-hugepage-vmalloc-mappings-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: [next] mm/vmalloc: fix read of uninitialized pointer area

There is a corner case where the sanity check of variable size fails
and branches to label fail and shift can be less than PAGE_SHIFT
causing area to never be assigned. This was picked up by static
analysis as follows:

    1. var_decl: Declaring variable area without initializer.
       struct vm_struct *area;

   ...

    2. Condition !size, taking true branch.
       if (!size || (size >> PAGE_SHIFT) > totalram_pages())
    3. Jumping to label fail.
               goto fail;

    ...

    4. Condition shift > 12, taking false branch.
	fail:
		if (shift > PAGE_SHIFT) {
			shift = PAGE_SHIFT;
			align = real_align;
			size = real_size;
			goto again;
		}

     Uninitialized pointer read (UNINIT)
     5. uninit_use: Using uninitialized value area.
 		if (!area) {
			...
		}

Fix this by setting area to NULL to avoid the uninitialized read
of area.

Addresses-Coverity: ("Uninitialized pointer read")
Link: https://lkml.kernel.org/r/20210318155955.18220-1-colin.king@canonical.com
Fixes: 92db9fec381b ("mm/vmalloc: hugepage vmalloc mappings")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-hugepage-vmalloc-mappings-fix
+++ a/mm/vmalloc.c
@@ -2879,8 +2879,10 @@ void *__vmalloc_node_range(unsigned long
 	unsigned long real_align = align;
 	unsigned int shift = PAGE_SHIFT;
 
-	if (!size || (size >> PAGE_SHIFT) > totalram_pages())
+	if (!size || (size >> PAGE_SHIFT) > totalram_pages()) {
+		area = NULL;
 		goto fail;
+	}
 
 	if (vmap_allow_huge && !(vm_flags & VM_NO_HUGE_VMAP) &&
 			arch_vmap_pmd_supported(prot)) {
_

Patches currently in -mm which might be from colin.king@canonical.com are

mm-slab-fix-spelling-mistake-disired-desired.patch
mm-vmalloc-hugepage-vmalloc-mappings-fix.patch
mm-cma-support-sysfs-fix.patch

