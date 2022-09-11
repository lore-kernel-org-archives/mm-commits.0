Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F5BC6FA8A
	for <mm-commits@archiver.kernel.org>; Sun, 11 Sep 2022 23:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiIKXX2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 19:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiIKXXU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 19:23:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5352528B;
        Sun, 11 Sep 2022 16:23:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B759B80B96;
        Sun, 11 Sep 2022 23:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A85C43470;
        Sun, 11 Sep 2022 23:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662938596;
        bh=EpQAE4qVnM95xD4YziYr6osNBWrlPubrBcAM4ZGxPjI=;
        h=Date:To:From:Subject:From;
        b=J0dNg/2ZeqOEaH5QPMehEJlnlg86UYOCwCosHW0V7sRyxsc6CLYxIuFO1x3GvdiRe
         9KMOW26wN/0ukfOX9zqhpkEAsNYCYoCCMn+OSQmECegJTdPeBtZyH9U4/DTT1A5za3
         KlwkofRNO6nCgrhctZse895ArYujeIfHgj54Gzvo=
Date:   Sun, 11 Sep 2022 16:23:15 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@kernel.org, James.Bottomley@HansenPartnership.com,
        hagen@jauu.net, ammarfaizi2@gnuweeb.org, akpm@linux-foudation.org,
        dantengknight@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-dereferencing-possible-err_ptr.patch removed from -mm tree
Message-Id: <20220911232316.30A85C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix dereferencing possible ERR_PTR
has been removed from the -mm tree.  Its filename was
     mm-fix-dereferencing-possible-err_ptr.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Binyi Han <dantengknight@gmail.com>
Subject: mm: fix dereferencing possible ERR_PTR
Date: Sun, 4 Sep 2022 00:46:47 -0700

Smatch checker complains that 'secretmem_mnt' dereferencing possible
ERR_PTR().  Let the function return if 'secretmem_mnt' is ERR_PTR, to
avoid deferencing it.

Link: https://lkml.kernel.org/r/20220904074647.GA64291@cloud-MacBookPro
Fixes: 1507f51255c9f ("mm: introduce memfd_secret system call to create "secret" memory areas")
Signed-off-by: Binyi Han <dantengknight@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/secretmem.c~mm-fix-dereferencing-possible-err_ptr
+++ a/mm/secretmem.c
@@ -285,7 +285,7 @@ static int secretmem_init(void)
 
 	secretmem_mnt = kern_mount(&secretmem_fs);
 	if (IS_ERR(secretmem_mnt))
-		ret = PTR_ERR(secretmem_mnt);
+		return PTR_ERR(secretmem_mnt);
 
 	/* prevent secretmem mappings from ever getting PROT_EXEC */
 	secretmem_mnt->mnt_flags |= MNT_NOEXEC;
_

Patches currently in -mm which might be from dantengknight@gmail.com are


