Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E891C43334
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jul 2022 19:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235187AbiGSTD2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jul 2022 15:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbiGSTDO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2022 15:03:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C423751A0A
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 12:03:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B6DD617D0
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 19:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884B6C341C6;
        Tue, 19 Jul 2022 19:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658257392;
        bh=i7qDfPXR4s3ysrM4b9KVOF5yfULIWElDxUxHKyJ9e2A=;
        h=Date:To:From:Subject:From;
        b=YHdpCmpDoo6SanvdU8H7KFnRCz+uHXu1ysmEtg3bVYAcTO2Md0soAeglYqecArSu4
         zs7UVqlgmtgEev/+PKWEwyJ1f3NPBPUUCVHWCN2auKz886ffsbs4rr15fdIe/78aEw
         6O/NZqIn9aRnUqWC5/mG7SVIoRDsrzPzOuOfpPlg=
Date:   Tue, 19 Jul 2022 12:03:11 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix.patch added to mm-unstable branch
Message-Id: <20220719190312.884B6C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix bitwise for logical operator in mas_validate_limits()
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: fix bitwise for logical operator in mas_validate_limits()
Date: Tue, 19 Jul 2022 18:51:57 +0000

Use the correct operator.

Link: https://lkml.kernel.org/r/20220719185142.3360559-1-Liam.Howlett@oracle.com
Fixes: fb7297e8a66b (Maple Tree: add new data structure)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix
+++ a/lib/maple_tree.c
@@ -6966,7 +6966,7 @@ static void mas_validate_limits(struct m
 
 		piv = mas_safe_pivot(mas, pivots, i, type);
 
-		if (!piv & (i != 0))
+		if (!piv && (i != 0))
 			break;
 
 		if (!mte_is_leaf(mas->node)) {
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

