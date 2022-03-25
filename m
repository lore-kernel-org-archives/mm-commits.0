Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7567DC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357380AbiCYBds (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357431AbiCYBdL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EE7BF023
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 237D8B826FE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB07C340ED;
        Fri, 25 Mar 2022 01:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171865;
        bh=ZfQTy3yJZ1y6qzvrHfOtBufvqftWsYmtd3wqnTEiavc=;
        h=Date:To:From:Subject:From;
        b=JHYWy1bsRKOM57W4SBckQXnKig0yvhj5d2FQ2do5x0RnAci2nZhC9yV+LzTkFHgtl
         haOFFhV0yyd30moQgvRSWkZbzW5fWCkSNLhuFq8gKh1G1qu6JTUS/fzXCHaGsbaXqY
         vnFseaEgTFYm9gS++pDbUZiDsL3EwxUxgafI6GQk=
Date:   Thu, 24 Mar 2022 18:31:05 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-_install_special_mapping-apply-vm_locked_clear_mask.patch removed from -mm tree
Message-Id: <20220325013105.AEB07C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: _install_special_mapping() apply VM_LOCKED_CLEAR_MASK
has been removed from the -mm tree.  Its filename was
     mm-_install_special_mapping-apply-vm_locked_clear_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from hughd@google.com are

mm-delete-__clearpagewaiters.patch
mm-filemap_unaccount_folio-large-skip-mapcount-fixup.patch
mm-thp-fix-nr_file_mapped-accounting-in-page__file_rmap.patch
mm-warn-on-deleting-redirtied-only-if-accounted.patch
mm-unmap_mapping_range_tree-with-i_mmap_rwsem-shared.patch

