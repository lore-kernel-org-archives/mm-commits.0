Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 841B6C64ED6
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 03:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjBZD5k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Feb 2023 22:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjBZD5j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 25 Feb 2023 22:57:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E66EB69
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 19:57:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68519B80946
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 03:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E1DC433EF;
        Sun, 26 Feb 2023 03:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677383779;
        bh=p2uotpqt4GKrYqjdlV/iHtJN7gavEHWAkgsaqTq5MtE=;
        h=Date:To:From:Subject:From;
        b=NBtoFyqq+boKpOOP6tmasfOPKfzR1h2jtBtctfoB60MpAvDzUQ7RlZ9kNcY5XdKNL
         zLqKK4IMU9j0oAIj9+ulbeNZ3QUAYaLI0sMgwTE6nL2PsUEWfRC4QcigcBf7prBNOr
         Cmb9eE4nYeUEZ3CmB+09WrrsxM3D0Ztrx5632SVs=
Date:   Sat, 25 Feb 2023 19:56:18 -0800
To:     mm-commits@vger.kernel.org, spasswolf@web.de,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-fix-successful-vma_merge-of-next-in-do_mprotect_pkey.patch added to mm-unstable branch
Message-Id: <20230226035619.27E1DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect: Fix successful vma_merge() of next in do_mprotect_pkey()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mprotect-fix-successful-vma_merge-of-next-in-do_mprotect_pkey.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-fix-successful-vma_merge-of-next-in-do_mprotect_pkey.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mprotect: Fix successful vma_merge() of next in do_mprotect_pkey()
Date: Fri, 24 Feb 2023 16:20:55 -0500

If mprotect_fixup() successfully calls vma_merge() and replaces vma and
the next vma, then the tmp variable in the do_mprotect_pkey() is not
updated to point to the new vma end.  This results in the loop detecting a
gap between VMAs that does not exist.  Fix the faulty value of tmp by
setting it to the end location of the vma iterator at the end of the loop.

Link: https://lkml.kernel.org/r/20230224212055.1786100-1-Liam.Howlett@oracle.com
Fixes: 2286a6914c77 ("mm: change mprotect_fixup to vma iterator")
Link: https://lore.kernel.org/linux-mm/20230223120407.729110a6ecd1416ac59d9cb0@linux-foundation.org/
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Bert Karwatzki <spasswolf@web.de>
  Link: https://bugzilla.kernel.org/show_bug.cgi?id=217061
Tested-by: Bert Karwatzki <spasswolf@web.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mprotect.c~mm-mprotect-fix-successful-vma_merge-of-next-in-do_mprotect_pkey
+++ b/mm/mprotect.c
@@ -832,6 +832,7 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
 		if (error)
 			break;
 
+		tmp = vma_iter_end(&vmi);
 		nstart = tmp;
 		prot = reqprot;
 	}
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mprotect-fix-successful-vma_merge-of-next-in-do_mprotect_pkey.patch

