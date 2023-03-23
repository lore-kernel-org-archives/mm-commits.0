Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B55D7C6FD1C
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 19:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbjCWThJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Mar 2023 15:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjCWThJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Mar 2023 15:37:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D731F5C2
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 12:37:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEE2862873
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 19:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DC9C433EF;
        Thu, 23 Mar 2023 19:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679600227;
        bh=C9dQfygdKdfl11BlgoIwp4pQqqXb4Go3Lg50nWB3BkI=;
        h=Date:To:From:Subject:From;
        b=0zRCHYP1ROrCzwDZS4sW8s4lqHKWgEpWnF5PDrtNzDBclUXFZsLKZZwswGSPa2slq
         ADXWA1j4GRq6Wc2uUCEdlCMEGua1wuMDfUFRIdCaBvzkANc8GxsuctcitmlpU3f1/4
         2pRWAklnkXTQYq4hUhIeR+nA+CuCKpxmA4dGuoVo=
Date:   Thu, 23 Mar 2023 12:37:06 -0700
To:     mm-commits@vger.kernel.org, lstoakes@gmail.com,
        sfr@canb.auug.org.au, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-convert-vread-to-vread_iter-fix.patch added to mm-unstable branch
Message-Id: <20230323193707.04DC9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: fix sparc64 warning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-convert-vread-to-vread_iter-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-convert-vread-to-vread_iter-fix.patch

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
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm: vmalloc: fix sparc64 warning

This fixes this warning from a sparc64 defconfig build:

In file included from /home/sfr/next/next/include/linux/wait.h:11,
                 from /home/sfr/next/next/include/linux/swait.h:8,
                 from /home/sfr/next/next/include/linux/completion.h:12,
                 from /home/sfr/next/next/include/linux/mm_types.h:14,
                 from /home/sfr/next/next/include/linux/uio.h:10,
                 from /home/sfr/next/next/include/linux/vmalloc.h:12,
                 from /home/sfr/next/next/include/asm-generic/io.h:994,
                 from /home/sfr/next/next/arch/sparc/include/asm/io.h:22,
                 from /home/sfr/next/next/arch/sparc/vdso/vclock_gettime.c:=
18:
/home/sfr/next/next/arch/sparc/include/asm/current.h:18:30: warning: call-c=
lobbered register used for global register variable
   18 | register struct task_struct *current asm("g4");
      |                              ^~~~~~~

Link: https://lkml.kernel.org/r/20230320144721.663280c3@canb.auug.org.au
Fixes: 4e29dd9708cb ("mm: vmalloc: convert vread() to vread_iter()")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    2 +-
 mm/vmalloc.c            |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-convert-vread-to-vread_iter-fix
+++ a/include/linux/vmalloc.h
@@ -9,12 +9,12 @@
 #include <asm/page.h>		/* pgprot_t */
 #include <linux/rbtree.h>
 #include <linux/overflow.h>
-#include <linux/uio.h>
 
 #include <asm/vmalloc.h>
 
 struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
 struct notifier_block;		/* in notifier.h */
+struct iov_iter;		/* in uio.h */
 
 /* bits in flags of vmalloc's vm_struct below */
 #define VM_IOREMAP		0x00000001	/* ioremap() and friends */
--- a/mm/vmalloc.c~mm-vmalloc-convert-vread-to-vread_iter-fix
+++ a/mm/vmalloc.c
@@ -33,6 +33,7 @@
 #include <linux/compiler.h>
 #include <linux/memcontrol.h>
 #include <linux/llist.h>
+#include <linux/uio.h>
 #include <linux/bitops.h>
 #include <linux/rbtree_augmented.h>
 #include <linux/overflow.h>
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-vmalloc-convert-vread-to-vread_iter-fix.patch

