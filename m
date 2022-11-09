Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB3CC4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiKIBip (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiKIBid (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38900BB2
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B08FB61811
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1285CC433B5;
        Wed,  9 Nov 2022 01:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957902;
        bh=Xsv9LxJNbp8HMQ2+IRNANOEmG8l/J9UwzYBajSr2mQM=;
        h=Date:To:From:Subject:From;
        b=dz/nwyWwX4m2VERh7oakVxXYHc949KZE2Jmy36yCEC/OR5WdPzI+CPcaOcjZwCG4p
         gygAPeZiCgGCIsspOdEd8Ht+yfWWn2LAado9vFfc7THnF5sy3OGooowXb+zH75TPzY
         gkB1TtC5GF3mWAl1HBnlI5zgrOcH3B/QjofnfkwA=
Date:   Tue, 08 Nov 2022 17:38:21 -0800
To:     mm-commits@vger.kernel.org, eb@emlix.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-typo-in-struct-vm_operations_struct-comments.patch removed from -mm tree
Message-Id: <20221109013822.1285CC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix typo in struct vm_operations_struct comments
has been removed from the -mm tree.  Its filename was
     mm-fix-typo-in-struct-vm_operations_struct-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rolf Eike Beer <eb@emlix.com>
Subject: mm: fix typo in struct vm_operations_struct comments
Date: Fri, 07 Oct 2022 13:37:41 +0200

There is no eprotect(), so I assume this is about mprotect().

Link: https://lkml.kernel.org/r/2385684.8vm7BOzihM@mobilepool36.emlix.com
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-fix-typo-in-struct-vm_operations_struct-comments
+++ a/include/linux/mm.h
@@ -549,7 +549,7 @@ struct vm_operations_struct {
 	/*
 	 * Called by mprotect() to make driver-specific permission
 	 * checks before mprotect() is finalised.   The VMA must not
-	 * be modified.  Returns 0 if eprotect() can proceed.
+	 * be modified.  Returns 0 if mprotect() can proceed.
 	 */
 	int (*mprotect)(struct vm_area_struct *vma, unsigned long start,
 			unsigned long end, unsigned long newflags);
_

Patches currently in -mm which might be from eb@emlix.com are


