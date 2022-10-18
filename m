Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08800C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 00:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbiJRA2k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 20:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbiJRA2Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 20:28:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9C192CCA
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 17:26:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 218CE61330
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 00:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DD4C433C1;
        Tue, 18 Oct 2022 00:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666052713;
        bh=KY6/f89h4xO0JAcvvc5yvYdUqvaitr351Hx5Bty3Yis=;
        h=Date:To:From:Subject:From;
        b=TP/p46cmFF96kHfZZZl8q7Vhhgj61FPdhxRjTYXg/uZHkMdHLz/s8vfSYf6cIv7FS
         7BcsIWEC3MHzeDif4Rg7BgrxMwWl+e8XywiOuCvZWd8RAqhCpngtqrLrgnbxzgS1aM
         0VxjwywRpWkUbNHr+EFh4LuHHfMgEPnsixZpgij4=
Date:   Mon, 17 Oct 2022 17:25:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, hughd@google.com,
        lukas.bulwahn@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-remove-unneeded-assignments-in-shmem_get_folio_gfp.patch added to mm-unstable branch
Message-Id: <20221018002513.73DD4C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: remove unneeded assignments in shmem_get_folio_gfp()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-remove-unneeded-assignments-in-shmem_get_folio_gfp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-remove-unneeded-assignments-in-shmem_get_folio_gfp.patch

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
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: mm/shmem: remove unneeded assignments in shmem_get_folio_gfp()
Date: Fri, 7 Oct 2022 10:50:27 +0200

After the rework of shmem_get_folio_gfp() to use a folio, the local
variable hindex is only needed to be set once before passing it to
shmem_add_to_page_cache().

Remove the unneeded initialization and assignments of the variable hindex
before the actual effective assignment and first use.

No functional change. No change in object code.

Link: https://lkml.kernel.org/r/20221007085027.6309-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-remove-unneeded-assignments-in-shmem_get_folio_gfp
+++ a/mm/shmem.c
@@ -1826,7 +1826,7 @@ static int shmem_get_folio_gfp(struct in
 	struct shmem_sb_info *sbinfo;
 	struct mm_struct *charge_mm;
 	struct folio *folio;
-	pgoff_t hindex = index;
+	pgoff_t hindex;
 	gfp_t huge_gfp;
 	int error;
 	int once = 0;
@@ -1864,7 +1864,6 @@ repeat:
 	}
 
 	if (folio) {
-		hindex = folio->index;
 		if (sgp == SGP_WRITE)
 			folio_mark_accessed(folio);
 		if (folio_test_uptodate(folio))
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

mm-shmem-remove-unneeded-assignments-in-shmem_get_folio_gfp.patch

