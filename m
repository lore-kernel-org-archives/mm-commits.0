Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE08C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  1 Nov 2023 19:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345947AbjKATjS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345933AbjKATjM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2023 15:39:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444AC9F
        for <mm-commits@vger.kernel.org>; Wed,  1 Nov 2023 12:39:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73BCC43397;
        Wed,  1 Nov 2023 19:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698867545;
        bh=efC1UbjHF/LarAiX5kLdGuVsoZ00dtT8iCgSLrn8bV0=;
        h=Date:To:From:Subject:From;
        b=xOrmx2ZSztNqdm9HlzqcUFxjSfQmt9PfOJei25/kjrrUG5er9vKghQ4YocRNbfMP9
         /gLNk+h4AqlgvaQV+J6DdfF6oi/W5lwHxuQYKuKDHxkR53y5lxlByi6xnrDDVsD6p3
         oozVx6A+G4q5Mv6qGdyZAMeAihI+wTRRdQyhV84A=
Date:   Wed, 01 Nov 2023 12:39:03 -0700
To:     mm-commits@vger.kernel.org, philip.li@intel.com,
        lstoakes@gmail.com, lkp@intel.com, dan.carpenter@linaro.org,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-fix-the-unchecked-dereference-warning-in-vread_iter.patch removed from -mm tree
Message-Id: <20231101193905.D73BCC43397@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: fix the unchecked dereference warning in vread_iter()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-the-unchecked-dereference-warning-in-vread_iter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc: fix the unchecked dereference warning in vread_iter()
Date: Wed, 18 Oct 2023 22:50:14 +0800

LKP reported smatch warning as below:

===================
smatch warnings:
mm/vmalloc.c:3689 vread_iter() error: we previously assumed 'vm' could be null (see line 3667)
......
06c8994626d1b7  @3667 size = vm ? get_vm_area_size(vm) : va_size(va);
......
06c8994626d1b7  @3689 else if (!(vm->flags & VM_IOREMAP))
                                 ^^^^^^^^^
Unchecked dereference
=====================

This is not a runtime bug because the possible null 'vm' in the
pointed place could only happen when flags == VMAP_BLOCK.  However, the
case 'flags == VMAP_BLOCK' should never happen and has been detected
with WARN_ON.  Please check vm_map_ram() implementation and the earlier
checking in vread_iter() at below:

                ~~~~~~~~~~~~~~~~~~~~~~~~~~
                /*
                 * VMAP_BLOCK indicates a sub-type of vm_map_ram area, need
                 * be set together with VMAP_RAM.
                 */
                WARN_ON(flags == VMAP_BLOCK);

                if (!vm && !flags)
                        continue;
                ~~~~~~~~~~~~~~~~~~~~~~~~~~

So add checking on whether 'vm' could be null when dereferencing it in
vread_iter(). This mutes smatch complaint.

Link: https://lkml.kernel.org/r/ZTCURc8ZQE+KrTvS@MiWiFi-R3L-srv
Link: https://lkml.kernel.org/r/ZS/2k6DIMd0tZRgK@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202310171600.WCrsOwFj-lkp@intel.com/
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Philip Li <philip.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-the-unchecked-dereference-warning-in-vread_iter
+++ a/mm/vmalloc.c
@@ -3809,7 +3809,7 @@ long vread_iter(struct iov_iter *iter, c
 
 		if (flags & VMAP_RAM)
 			copied = vmap_ram_vread_iter(iter, addr, n, flags);
-		else if (!(vm->flags & VM_IOREMAP))
+		else if (!(vm && (vm->flags & VM_IOREMAP)))
 			copied = aligned_vread_iter(iter, addr, n);
 		else /* IOREMAP area is treated as memory hole */
 			copied = zero_iter(iter, n);
_

Patches currently in -mm which might be from bhe@redhat.com are


