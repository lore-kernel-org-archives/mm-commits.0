Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A08CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 15:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbjJRPxK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 11:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232454AbjJRPxJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 11:53:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CAC11B
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 08:53:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC958C433C8;
        Wed, 18 Oct 2023 15:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697644388;
        bh=R8c2RedWm94h+yXbVim89+8Kun6z901IIS4MeBtPMMk=;
        h=Date:To:From:Subject:From;
        b=GrIYhQ6vkALRs+HQ1z9grqjiVqCNKFZa2whpmfU7bo8LSa7KSD2tbxMIclWdC7/0b
         d4EewB7iVXIiptO89oVbyWS6JdtTkRcOgfWkrtzPAEmvG8xB7KduidzC5ijCW5HAWO
         ga8yR4v4XxQrPhq5ri1d4NDPDP0fg0WRUD8Ip1Yc=
Date:   Wed, 18 Oct 2023 08:53:07 -0700
To:     mm-commits@vger.kernel.org, philip.li@intel.com,
        lstoakes@gmail.com, lkp@intel.com, dan.carpenter@linaro.org,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-fix-the-unchecked-dereference-warning-in-vread_iter.patch added to mm-hotfixes-unstable branch
Message-Id: <20231018155307.DC958C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: fix the unchecked dereference warning in vread_iter()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmalloc-fix-the-unchecked-dereference-warning-in-vread_iter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-fix-the-unchecked-dereference-warning-in-vread_iter.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

So add checking on whether 'vm' is not null when dereferencing it in
vread_iter(). This mutes smatch complaint.

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

mm-vmalloc-fix-the-unchecked-dereference-warning-in-vread_iter.patch

