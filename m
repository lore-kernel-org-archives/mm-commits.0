Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E8F4C636CC
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 20:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbjAaUxC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 15:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbjAaUwt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 15:52:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0811659E60
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 12:52:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 816CD61532
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 20:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4EEC433EF;
        Tue, 31 Jan 2023 20:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675198365;
        bh=CM9ki9iCfuAh4cQxdjjLA1s+f3Sd5XBPVIKwbsZXqSc=;
        h=Date:To:From:Subject:From;
        b=NwpjwDVDxNVXjoB8q46TklaEukcGIGQzRrBprCIeZO1KAXTgnnXlpq6FMfz7s4IYn
         4sNhhdVHAj41MQTnkSXhQaCYpSTmkqhahik3aOMBfBxaBds37ybIKQmfMF5DznuGQV
         g3j4qGVLWFbBDiT4BGndfoDmhB9LF21qReL4jDDc=
Date:   Tue, 31 Jan 2023 12:52:44 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com, 42.hyeyoo@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch added to mm-unstable branch
Message-Id: <20230131205244.DE4EEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix
Date: Tue Jan 31 12:50:59 PM PST 2023

fix drivers/misc/open-dice.c, per Hyeonggon Yoo

Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/open-dice.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/open-dice.c~mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix
+++ a/drivers/misc/open-dice.c
@@ -95,7 +95,7 @@ static int open_dice_mmap(struct file *f
 		if (vma->vm_flags & VM_WRITE)
 			return -EPERM;
 		/* Ensure userspace cannot acquire VM_WRITE later. */
-		vm_flags_clear(vma, VM_MAYSHARE);
+		vm_flags_clear(vma, VM_MAYWRITE);
 	}
 
 	/* Create write-combine mapping so all clients observe a wipe. */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch
mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix.patch
mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix-2.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
mm-remove-the-swap_readpage-return-value-fix.patch
block-remove-rw_page-fix.patch
mm-add-memcpy_from_file_folio-fix.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch

