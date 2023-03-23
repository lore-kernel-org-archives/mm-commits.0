Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5327C6FD1C
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 22:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbjCWWax (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Mar 2023 18:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbjCWWar (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Mar 2023 18:30:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EA929E21
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 15:30:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C14FBCE23CD
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 22:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED72C433D2;
        Thu, 23 Mar 2023 22:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679610633;
        bh=lr1xk9Mi2JG663QS1SX986s2heWZx7GW5J/TJ4MajHI=;
        h=Date:To:From:Subject:From;
        b=Pj17Wk156bvAkMcY4cigXfYkx0/+ms9Oj2GaZy3KWg8+XfPaGVMoVwaaKRtsaKg4W
         S/r8PuCnbUSv7RJ7ssKzWK0yMhwavGzXf0SEpkq44ZBUAwfQ+d6ceC3jlJvU4bfvCZ
         nnpJaz9P1inqaNvA9aix5JxpjPb9sk1ECQXHaAuk=
Date:   Thu, 23 Mar 2023 15:30:32 -0700
To:     mm-commits@vger.kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-convert-vread-to-vread_iter-v8-fix.patch added to mm-unstable branch
Message-Id: <20230323223033.1ED72C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-convert-vread-to-vread_iter-v8-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-convert-vread-to-vread_iter-v8-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-convert-vread-to-vread_iter-v8-fix.patch

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
Subject: mm-vmalloc-convert-vread-to-vread_iter-v8-fix
Date: Thu Mar 23 03:28:43 PM PDT 2023

Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    2 +-
 mm/vmalloc.c            |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-convert-vread-to-vread_iter-v8-fix
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
--- a/mm/vmalloc.c~mm-vmalloc-convert-vread-to-vread_iter-v8-fix
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

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch
mm-treewide-redefine-max_order-sanely-fix-2.patch
mm-treewide-redefine-max_order-sanely-fix-3-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
mm-vmalloc-convert-vread-to-vread_iter-v8-fix.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch
notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch

