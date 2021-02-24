Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22715C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBA7B64F20
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235276AbhBXUGj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:06:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235274AbhBXUFz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3DC464F37;
        Wed, 24 Feb 2021 20:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197094;
        bh=k1hKdwrJHIO+A24G95yDbw/sYmpvr+nfWn01btySRwo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MwSpEj+WUQe55xi1uFZg0iBdxbBJ1ij+JM/q2AMWhhoa2/Aixeuz1itnlS2XjODHp
         UGBDf0Ng0UIdcKVkQkNyMaxDHonLdhoxWpWTnKl9t1cV1gSMMasmBNg16dHOR33Plt
         6J8lDKopmtQvvRely11yqFZgBOt1L7/06Ta173w0=
Date:   Wed, 24 Feb 2021 12:04:53 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, bgeffon@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        lixinhai.lxh@gmail.com, lokeshgidra@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 083/173] mm: mremap: unlink anon_vmas when mremap
 with MREMAP_DONTUNMAP success
Message-ID: <20210224200453.9k7nHP6Ig%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
