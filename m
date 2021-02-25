Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25BF1C433E9
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D27F764F42
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234680AbhBYT2V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:28:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233659AbhBYTZk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:25:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B050264F7B;
        Thu, 25 Feb 2021 19:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280509;
        bh=0jlM2J7V+FxKHwwCTXBsGmJc1Yu6SRz+dYlfWCHFnuo=;
        h=Date:From:To:Subject:From;
        b=Pjx2sYuCXT6fTVkNjcC6MIGDTDfYxPiUuWW7fh6fa+/LAIo0ex1IKVTu17ICt7SkF
         C1oL+b9puapdBzLf12BNOacy8iX+QEJuV4/p2arKYKYuptLPJexBRF7Q/ZbRu9DPrT
         DQ8UlS+vZojjqV1+Rlh+avaj8b4MUozDJbhQeW2Q=
Date:   Thu, 25 Feb 2021 11:15:08 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, bgeffon@google.com,
        kirill.shutemov@linux.intel.com, lixinhai.lxh@gmail.com,
        lokeshgidra@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success.patch
 removed from -mm tree
Message-ID: <20210225191508.BaaMSqd31%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success
has been removed from the -mm tree.  Its filename was
     mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success

mremap with MREMAP_DONTUNMAP can move all page table entries to new vma,
which means all pages allocated for the old vma are not relevant to it
anymore, and the relevant anon_vma links needs to be unlinked, in nature
the old vma is much like been freshly created and have no pages been fault
in.

But we should not do unlink, if the new vma has effectively merged with
the old one.

[lixinhai.lxh@gmail.com: v2]
  Link: https://lkml.kernel.org/r/20210127083917.309264-2-lixinhai.lxh@gmail.com
Link: https://lkml.kernel.org/r/20210119075126.3513154-2-lixinhai.lxh@gmail.com
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/mremap.c~mm-mremap-unlink-anon_vmas-when-mremap-with-mremap_dontunmap-success
+++ a/mm/mremap.c
@@ -593,6 +593,14 @@ static unsigned long move_vma(struct vm_
 		/* We always clear VM_LOCKED[ONFAULT] on the old vma */
 		vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
 
+		/*
+		 * anon_vma links of the old vma is no longer needed after its page
+		 * table has been moved.
+		 */
+		if (new_vma != vma && vma->vm_start == old_addr &&
+			vma->vm_end == (old_addr + old_len))
+			unlink_anon_vmas(vma);
+
 		/* Because we won't unmap we don't need to touch locked_vm */
 		return new_addr;
 	}
_

Patches currently in -mm which might be from lixinhai.lxh@gmail.com are


