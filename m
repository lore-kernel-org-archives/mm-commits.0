Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5FEC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1840D64F1B
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbhBXUGj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:06:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235316AbhBXUFz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E34164F36;
        Wed, 24 Feb 2021 20:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197090;
        bh=o5B2UwUoJBuubQ9hFq7S1qGARKUxOP/DrAwHAuIUB9s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oCvZTMNtDzZZMa6A+QSEMsvYKBuAbdcR1ITA0W++v4hXJfLUtlxY67kEX9CQJ29xd
         LKR3CgnGwgnAuNU5Y/R1kOoUaoojpydwZXr/Fearnp4OlAPuEAIPQiTKvxDgJLExFQ
         pNngKXLa4/hBrIJxzsKHa2T/1vkfJ+VBzBo4EsqQ=
Date:   Wed, 24 Feb 2021 12:04:49 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, bgeffon@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        lixinhai.lxh@gmail.com, lokeshgidra@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 082/173] mm: rmap: explicitly reset vma->anon_vma
 in unlink_anon_vmas()
Message-ID: <20210224200449.hkU5GTEiH%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: mm: rmap: explicitly reset vma->anon_vma in unlink_anon_vmas()

In case the vma will continue to be used after unlink its relevant
anon_vma, we need to reset the vma->anon_vma pointer to NULL.  So, later
when fault happen within this vma again, a new anon_vma will be prepared.

By this way, the vma will only be checked for reverse mapping of pages
which been fault in after the unlink_anon_vmas call.

Currently, the mremap with MREMAP_DONTUNMAP scenario will continue use the
vma after moved its page table entries to a new vma.  For other scenarios,
the vma itself will be freed after call unlink_anon_vmas.

Link: https://lkml.kernel.org/r/20210119075126.3513154-1-lixinhai.lxh@gmail.com
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-explicitly-reset-vma-anon_vma-in-unlink_anon_vmas
+++ a/mm/rmap.c
@@ -413,8 +413,15 @@ void unlink_anon_vmas(struct vm_area_str
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
-	if (vma->anon_vma)
+	if (vma->anon_vma) {
 		vma->anon_vma->degree--;
+
+		/*
+		 * vma would still be needed after unlink, and anon_vma will be prepared
+		 * when handle fault.
+		 */
+		vma->anon_vma = NULL;
+	}
 	unlock_anon_vma_root(root);
 
 	/*
_
