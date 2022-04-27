Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4847DC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 17:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244345AbiD0RsZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 13:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbiD0RsW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 13:48:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A9ADFCC
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 10:45:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA8A6B828B4
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 17:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC7BC385A7;
        Wed, 27 Apr 2022 17:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651081506;
        bh=/SWTURBlPcaXYT1C2uiHCtTMRAaJMm9535yAmKygSVw=;
        h=Date:To:From:Subject:From;
        b=qRLzDm2Ol7qu+v4qpRYueV68D/bFXrg9+L+xdt+2m/dSU8FaJDhVvHXZ4pdR65kHi
         zJApPlQ5KqlvIXoZoC2zHD5YoOnUvu2ihmwdn3npn0dVgBhO2FgkUSGG9ZG73a32+U
         etjod2UaDEejB054WZzrEOTKdsyvTFM3LRDandGw=
Date:   Wed, 27 Apr 2022 10:45:05 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        peterx@redhat.com, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-use-maple-tree-iterator-to-iterate-vmas-fix.patch added to -mm tree
Message-Id: <20220427174506.6CC7BC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/userfaultfd: fix maple state in userfaultfd_register()
has been added to the -mm tree.  Its filename is
     userfaultfd-use-maple-tree-iterator-to-iterate-vmas-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-use-maple-tree-iterator-to-iterate-vmas-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-use-maple-tree-iterator-to-iterate-vmas-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: fs/userfaultfd: fix maple state in userfaultfd_register()

When VMAs are split/merged, the maple tree node may be replaced.  Re-walk
the tree in such cases by calling mas_pause().

Link: https://lkml.kernel.org/r/20220427154314.2o32gn46323hllnb@revolver
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/userfaultfd.c~userfaultfd-use-maple-tree-iterator-to-iterate-vmas-fix
+++ a/fs/userfaultfd.c
@@ -1437,6 +1437,8 @@ static int userfaultfd_register(struct u
 				 ((struct vm_userfaultfd_ctx){ ctx }),
 				 anon_vma_name(vma));
 		if (prev) {
+			/* vma_merge() invalidated the mas */
+			mas_pause(&mas);
 			vma = prev;
 			goto next;
 		}
@@ -1444,11 +1446,15 @@ static int userfaultfd_register(struct u
 			ret = split_vma(mm, vma, start, 1);
 			if (ret)
 				break;
+			/* split_vma() invalidated the mas */
+			mas_pause(&mas);
 		}
 		if (vma->vm_end > end) {
 			ret = split_vma(mm, vma, end, 0);
 			if (ret)
 				break;
+			/* split_vma() invalidated the mas */
+			mas_pause(&mas);
 		}
 	next:
 		/*
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch
userfaultfd-use-maple-tree-iterator-to-iterate-vmas-fix.patch

