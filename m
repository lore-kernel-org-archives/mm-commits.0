Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E94BC001DE
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jul 2023 17:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjGYReT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jul 2023 13:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjGYReT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2023 13:34:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D87BA6
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 10:34:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E87C61839
        for <mm-commits@vger.kernel.org>; Tue, 25 Jul 2023 17:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD4EC433C9;
        Tue, 25 Jul 2023 17:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690306457;
        bh=XCrBK1hbbOSZ9/CC7JvQWFWRLX2rXCBa8k+oKqMqSJs=;
        h=Date:To:From:Subject:From;
        b=dhf2YNEEztq1zFlSsgAPwznm7NTwrVRYWNWrtKb60EkeAi60qfr6aKKC4/8JJ5kvj
         Abpj9a8ZePj5hzg5Jyr8lt0mtdVVFC3tARP12D+geSvZ5zqiZUvmO3iC0+yQhcAQEb
         pn3a/NM1oApWM5uak6RFhUEp6PsGmZyd8J2PerQY=
Date:   Tue, 25 Jul 2023 10:34:16 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        conor.dooley@microchip.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch added to mm-unstable branch
Message-Id: <20230725173416.EFD4EC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch

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
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix
Date: Tue, 25 Jul 2023 15:31:17 +0100

fix riscv

Link: https://lkml.kernel.org/r/CAJuCfpE6GWEx1rPBmNpUfoD5o-gNFz9-UFywzCE2PbEGBiVz7g@mail.gmail.com
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Reported-by: Conor Dooley <conor.dooley@microchip.com>
  Closes: https://lkml.kernel.org/r/20230725-anaconda-that-ac3f79880af1@wendy
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/mm/fault.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/riscv/mm/fault.c~mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix
+++ a/arch/riscv/mm/fault.c
@@ -297,7 +297,8 @@ void handle_page_fault(struct pt_regs *r
 	}
 
 	fault = handle_mm_fault(vma, addr, flags | FAULT_FLAG_VMA_LOCK, regs);
-	vma_end_read(vma);
+	if (!(fault & (VM_FAULT_RETRY | VM_FAULT_COMPLETED)))
+		vma_end_read(vma);
 
 	if (!(fault & VM_FAULT_RETRY)) {
 		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
rmap-pass-the-folio-to-__page_check_anon_rmap.patch
highmem-add-memcpy_to_folio-and-memcpy_from_folio.patch
affs-convert-affs_symlink_read_folio-to-use-the-folio.patch
affs-convert-data-read-and-write-to-use-folios.patch
migrate-use-folio_set_bh-instead-of-set_bh_page.patch
ntfs3-convert-ntfs_get_block_vbo-to-use-a-folio.patch
jbd2-use-a-folio-in-jbd2_journal_write_metadata_buffer.patch
buffer-remove-set_bh_page.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-remove-config_per_vma_lock-ifdefs.patch
mm-allow-per-vma-locks-on-file-backed-vmas.patch
mm-move-fault_flag_vma_lock-check-from-handle_mm_fault.patch
mm-handle-pud-faults-under-the-vma-lock.patch
mm-handle-some-pmd-faults-under-the-vma-lock.patch
mm-move-fault_flag_vma_lock-check-down-in-handle_pte_fault.patch
mm-move-fault_flag_vma_lock-check-down-from-do_fault.patch
mm-run-the-fault-around-code-under-the-vma-lock.patch
mm-handle-swap-and-numa-pte-faults-under-the-vma-lock.patch
mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock.patch

