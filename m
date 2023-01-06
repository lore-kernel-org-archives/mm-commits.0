Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9728EC53210
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 03:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjAFDW4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 22:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjAFDWz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 22:22:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378BE676DE
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 19:22:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8F8B61CD3
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 03:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBA6C433D2;
        Fri,  6 Jan 2023 03:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672975373;
        bh=MO+Q+p3eh6rmiDnOS9OACNBlC892Fn+XXJs9lugKbME=;
        h=Date:To:From:Subject:From;
        b=SZTlSq4v4+GtLhjiloqoq9T2498K9+owqlJ6EK2qAhDe5cw6LQ2kXEKziyUSrfPi8
         G1iTrHSBOcYM5e2Vz7rAh/jasBOImR1hYOQrns5DeOaN4guTb/watJcQN06ob26oUs
         /5uNs+0HFcLTeDtTuG7zA68DEwdBh/o2nUlOar6M=
Date:   Thu, 05 Jan 2023 19:22:52 -0800
To:     mm-commits@vger.kernel.org, nico@fluxnic.net,
        gregkh@linuxfoundation.org, axboe@kernel.dk,
        asml.silence@gmail.com, arnd@arndb.de, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-misc-open-dice-dont-touch-vm_mayshare.patch added to mm-unstable branch
Message-Id: <20230106032253.2BBA6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/misc/open-dice: don't touch VM_MAYSHARE
has been added to the -mm mm-unstable branch.  Its filename is
     drivers-misc-open-dice-dont-touch-vm_mayshare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-misc-open-dice-dont-touch-vm_mayshare.patch

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

mm-hugetlb-fix-pte-marker-handling-in-hugetlb_change_protection.patch
mm-hugetlb-fix-uffd-wp-handling-for-migration-entries-in-hugetlb_change_protection.patch
mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch
mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch
mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch
selftests-vm-cow-add-cow-tests-for-collapsing-of-pte-mapped-anon-thp.patch
mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping.patch
mm-nommu-dont-use-vm_mayshare-for-map_private-mappings.patch
drivers-misc-open-dice-dont-touch-vm_mayshare.patch

