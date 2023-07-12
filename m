Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8EF0EB64DD
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jul 2023 19:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbjGLTYo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jul 2023 15:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232359AbjGLTYl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2023 15:24:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B451FC3;
        Wed, 12 Jul 2023 12:24:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66A5A618F5;
        Wed, 12 Jul 2023 19:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B746EC433C9;
        Wed, 12 Jul 2023 19:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689189879;
        bh=0tWo1zEKeSSpkRHrgAJVRHpHi/qIQoimw+RHhIfcwj8=;
        h=Date:To:From:Subject:From;
        b=Iw6E8eYrZYEa77eExrycf5f69K1LtN+tNFDrMD+dh9IvfDvy47FHnOxHQvcOap28l
         JaykuLtfj9WQnPo42uuGwEXCzaWJTqu5aycBfVfq4/ZVa7z0AuG3+PIyyva8ssJoTE
         8svefSsXv2hBevMC7U3GnYEwnrcVYpt/kZgV09oM=
Date:   Wed, 12 Jul 2023 12:24:38 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-node-allocation-testing-on-32-bit.patch added to mm-hotfixes-unstable branch
Message-Id: <20230712192439.B746EC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix node allocation testing on 32 bit
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-fix-node-allocation-testing-on-32-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-node-allocation-testing-on-32-bit.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: fix node allocation testing on 32 bit
Date: Wed, 12 Jul 2023 13:39:16 -0400

Internal node counting was altered and the 64 bit test was updated,
however the 32bit test was missed.

Restore the 32bit test to a functional state.

Link: https://lore.kernel.org/linux-mm/CAMuHMdV4T53fOw7VPoBgPR7fP6RYqf=CBhD_y_vOg53zZX_DnA@mail.gmail.com/
Link: https://lkml.kernel.org/r/20230712173916.168805-2-Liam.Howlett@oracle.com
Fixes: 541e06b772c1 ("maple_tree: remove GFP_ZERO from kmem_cache_alloc() and kmem_cache_alloc_bulk()")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/radix-tree/maple.c~maple_tree-fix-node-allocation-testing-on-32-bit
+++ a/tools/testing/radix-tree/maple.c
@@ -206,9 +206,9 @@ static noinline void __init check_new_no
 				e = i - 1;
 		} else {
 			if (i >= 4)
-				e = i - 4;
-			else if (i == 3)
-				e = i - 2;
+				e = i - 3;
+			else if (i >= 1)
+				e = i - 1;
 			else
 				e = 0;
 		}
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mlock-fix-vma-iterator-conversion-of-apply_vma_lock_flags.patch
maple_tree-fix-32-bit-mas_next-testing.patch
maple_tree-fix-node-allocation-testing-on-32-bit.patch

