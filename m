Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06776C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjASBVf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjASBT5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:19:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0110C6CCD1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADD9BB81D66
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5F8C433F0;
        Thu, 19 Jan 2023 01:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090993;
        bh=B/oOcisUwURhASUpfsqnzXNP48lUbstNngggYuOQZd8=;
        h=Date:To:From:Subject:From;
        b=FS2bzG/yTHzGGm5llcdJL7FKmfL5FWeo+CdpYyEltWwypuX0zT1BMXVlRILAL/zXI
         qivwLtplQju+DGD1eHrwbylU/HI6zNIzuMKV658Z3pLplUDTmAeP3gllc5tVAf/iYG
         CpiSYY/er32nhvwlMyZUJ/5dNiDbp8Zc8jQPSTc8=
Date:   Wed, 18 Jan 2023 17:16:32 -0800
To:     mm-commits@vger.kernel.org, nico@fluxnic.net,
        gregkh@linuxfoundation.org, axboe@kernel.dk,
        asml.silence@gmail.com, arnd@arndb.de, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivers-misc-open-dice-dont-touch-vm_mayshare.patch removed from -mm tree
Message-Id: <20230119011633.5C5F8C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: drivers/misc/open-dice: don't touch VM_MAYSHARE
has been removed from the -mm tree.  Its filename was
     drivers-misc-open-dice-dont-touch-vm_mayshare.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: drivers/misc/open-dice: don't touch VM_MAYSHARE
Date: Mon, 2 Jan 2023 17:08:56 +0100

A MAP_SHARED mapping always has VM_MAYSHARE set, and writable
(VM_MAYWRITE) MAP_SHARED mappings have VM_SHARED set as well.  To identify
a MAP_SHARED mapping, it's sufficient to look at VM_MAYSHARE.

We cannot have VM_MAYSHARE|VM_WRITE mappings without having VM_SHARED set.
Consequently, current code will never actually end up clearing
VM_MAYSHARE and that code is confusing, because nobody is supposed to mess
with VM_MAYWRITE.

Let's clean it up and restructure the code. No functional change intended.

Link: https://lkml.kernel.org/r/20230102160856.500584-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/open-dice.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/misc/open-dice.c~drivers-misc-open-dice-dont-touch-vm_mayshare
+++ a/drivers/misc/open-dice.c
@@ -90,15 +90,13 @@ static int open_dice_mmap(struct file *f
 {
 	struct open_dice_drvdata *drvdata = to_open_dice_drvdata(filp);
 
-	/* Do not allow userspace to modify the underlying data. */
-	if ((vma->vm_flags & VM_WRITE) && (vma->vm_flags & VM_SHARED))
-		return -EPERM;
-
-	/* Ensure userspace cannot acquire VM_WRITE + VM_SHARED later. */
-	if (vma->vm_flags & VM_WRITE)
-		vma->vm_flags &= ~VM_MAYSHARE;
-	else if (vma->vm_flags & VM_SHARED)
+	if (vma->vm_flags & VM_MAYSHARE) {
+		/* Do not allow userspace to modify the underlying data. */
+		if (vma->vm_flags & VM_WRITE)
+			return -EPERM;
+		/* Ensure userspace cannot acquire VM_WRITE later. */
 		vma->vm_flags &= ~VM_MAYWRITE;
+	}
 
 	/* Create write-combine mapping so all clients observe a wipe. */
 	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
_

Patches currently in -mm which might be from david@redhat.com are

mm-debug_vm_pgtable-more-pte_swp_exclusive-sanity-checks.patch
mm-debug_vm_pgtable-more-pte_swp_exclusive-sanity-checks-fix.patch
alpha-mm-support-__have_arch_pte_swp_exclusive.patch
arc-mm-support-__have_arch_pte_swp_exclusive.patch
arm-mm-support-__have_arch_pte_swp_exclusive.patch
csky-mm-support-__have_arch_pte_swp_exclusive.patch
hexagon-mm-support-__have_arch_pte_swp_exclusive.patch
ia64-mm-support-__have_arch_pte_swp_exclusive.patch
loongarch-mm-support-__have_arch_pte_swp_exclusive.patch
m68k-mm-remove-dummy-__swp-definitions-for-nommu.patch
m68k-mm-support-__have_arch_pte_swp_exclusive.patch
microblaze-mm-support-__have_arch_pte_swp_exclusive.patch
mips-mm-support-__have_arch_pte_swp_exclusive.patch
nios2-mm-refactor-swap-pte-layout.patch
nios2-mm-support-__have_arch_pte_swp_exclusive.patch
openrisc-mm-support-__have_arch_pte_swp_exclusive.patch
parisc-mm-support-__have_arch_pte_swp_exclusive.patch
powerpc-mm-support-__have_arch_pte_swp_exclusive-on-32bit-book3s.patch
powerpc-nohash-mm-support-__have_arch_pte_swp_exclusive.patch
riscv-mm-support-__have_arch_pte_swp_exclusive.patch
sh-mm-support-__have_arch_pte_swp_exclusive.patch
sparc-mm-support-__have_arch_pte_swp_exclusive-on-32bit.patch
sparc-mm-support-__have_arch_pte_swp_exclusive-on-64bit.patch
um-mm-support-__have_arch_pte_swp_exclusive.patch
x86-mm-support-__have_arch_pte_swp_exclusive-also-on-32bit.patch
xtensa-mm-support-__have_arch_pte_swp_exclusive.patch
mm-remove-__have_arch_pte_swp_exclusive.patch

