Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22052C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236307AbiCVVoc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236139AbiCVVoZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:44:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630DE5F4C2
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:42:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C918B81D9E
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B221EC340EE;
        Tue, 22 Mar 2022 21:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985356;
        bh=Hn/AIoQdeTw5O5kZZ7f+AVx97B+TM9hDMs/OwKX3LVQ=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=IPou8L9ZNHBCjwbnuaBc6PtXf3MRj5bX/sFfSQtSXYTb/e5HLIdpkfmORt+epFi1l
         drMhOv/MJSKjZdY6llZvHGNDsApFnQ7rqSEJkyd8o+8ph5sGIPeXmbkUjn0V1VsPW2
         CBXrMcAGMsLXooMK0LWT4hlwD2oOFj0NBRQoMQYo=
Date:   Tue, 22 Mar 2022 14:42:36 -0700
To:     vbabka@suse.cz, hughd@google.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 080/227] mm: _install_special_mapping() apply VM_LOCKED_CLEAR_MASK
Message-Id: <20220322214236.B221EC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: mm: _install_special_mapping() apply VM_LOCKED_CLEAR_MASK

_install_special_mapping() adds the VM_SPECIAL bit VM_DONTEXPAND (and
never attempts to update locked_vm), so it ought to be consistent with
mmap_region() and mlock_fixup(), making sure not to add VM_LOCKED or
VM_LOCKONFAULT.  I doubt that this fixes any problem in practice: just do
it for consistency.

Link: https://lkml.kernel.org/r/a85315a9-21d1-6133-c5fc-c89863dfb25b@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mmap.c~mm-_install_special_mapping-apply-vm_locked_clear_mask
+++ a/mm/mmap.c
@@ -3448,6 +3448,7 @@ static struct vm_area_struct *__install_
 	vma->vm_end = addr + len;
 
 	vma->vm_flags = vm_flags | mm->def_flags | VM_DONTEXPAND | VM_SOFTDIRTY;
+	vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 
 	vma->vm_ops = ops;
_
