Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C78C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 00:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEABD64DD3
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jan 2021 00:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhA1ANX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Jan 2021 19:13:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231706AbhA1ANQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Jan 2021 19:13:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1344B64D99;
        Thu, 28 Jan 2021 00:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611792752;
        bh=O1jv8VoP5wmY1V2iVrXNiLzUjUywudF6FiiMx4BOC4A=;
        h=Date:From:To:Subject:From;
        b=gGaQjGJRb5lpon51MqdqRCc0/rVbzNFo1E3tAT7meWGNMoaRaVAazBzg1z+FtMxMU
         l/MDjpnK42C+jYR0FiXeFURtWdNoW+xSeYnz6YoRpw7SrfxhcYtnW8tQEfSMmP2kiS
         RV3BEVx2LpGOFnx2PCxCF3VrBxtTZybyryrouCDk=
Date:   Wed, 27 Jan 2021 16:12:31 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, bgeffon@google.com,
        kirill.shutemov@linux.intel.com, lixinhai.lxh@gmail.com,
        lokeshgidra@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?mm-mremap-unlink-anon=5Fvmas-when-mremap-with-mremap=5Fdo?=
 =?US-ASCII?Q?ntunmap-success-v2.patch?= added to -mm tree
Message-ID: <20210128001231.8gqUun2Wu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success
has been added to the -mm tree.  Its filename is
     mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success

Need to consider the old vma just been partially moved, if so we must keep
the anon_vma links for remaining mapped pages in old vma.

Link: https://lkml.kernel.org/r/20210127083917.309264-2-lixinhai.lxh@gmail.com
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success-v2
+++ a/mm/mremap.c
@@ -599,7 +599,8 @@ static unsigned long move_vma(struct vm_
 		 * anon_vma links of the old vma is no longer needed after its page
 		 * table has been moved.
 		 */
-		if (new_vma != vma)
+		if (new_vma != vma && vma->vm_start == old_addr &&
+			vma->vm_end == (old_addr + old_len))
 			unlink_anon_vmas(vma);
 
 		/* Because we won't unmap we don't need to touch locked_vm */
_

Patches currently in -mm which might be from lixinhai.lxh@gmail.com are

mm-rmap-explicitly-reset-vma-anon_vma-in-unlink_anon_vmas.patch
mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success.patch
mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success-v2.patch
mm-hugetlbc-fix-unnecessary-address-expansion-of-pmd-sharing.patch

