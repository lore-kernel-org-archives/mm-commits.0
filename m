Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B56ADC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  4 Mar 2022 04:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235684AbiCDEIj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Mar 2022 23:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiCDEIj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Mar 2022 23:08:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB32522E1
        for <mm-commits@vger.kernel.org>; Thu,  3 Mar 2022 20:07:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC142B826EC
        for <mm-commits@vger.kernel.org>; Fri,  4 Mar 2022 04:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1AAC340E9;
        Fri,  4 Mar 2022 04:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646366869;
        bh=7uVEgT3F1qRjkrU0ds4f6eIJWFPrSa8k4KZ1BIPkE64=;
        h=Date:To:From:Subject:From;
        b=1kLbw+rqaeGcbwc0eSIWUHL/dmFlJxkHB2KPi9oNO575Inf8dMl936nthBrKgtkRB
         iB2c2fQnVt50wCStaCJq85/SUQxiJcssD2uSe6NXnbjOVS6w7xDQ7bZu3QZ+Y5KMBR
         /B8PGicTrMwm90p2L6JTXozV8hcBT3I2rAT++BT8=
Date:   Thu, 03 Mar 2022 20:07:48 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-_install_special_mapping-apply-vm_locked_clear_mask.patch added to -mm tree
Message-Id: <20220304040749.8B1AAC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: _install_special_mapping() apply VM_LOCKED_CLEAR_MASK
has been added to the -mm tree.  Its filename is
     mm-_install_special_mapping-apply-vm_locked_clear_mask.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-_install_special_mapping-apply-vm_locked_clear_mask.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-_install_special_mapping-apply-vm_locked_clear_mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memfd-fix-f_seal_write-after-shmem-huge-page-allocated.patch
tmpfs-support-for-file-creation-time-fix.patch
mm-_install_special_mapping-apply-vm_locked_clear_mask.patch
mm-thp-refix-__split_huge_pmd_locked-for-migration-pmd.patch
mm-thp-clearpagedoublemap-in-first-page_add_file_rmap.patch
mm-thp-fix-nr_file_mapped-accounting-in-page__file_rmap.patch

