Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF70C77B70
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbjDFChB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234912AbjDFCgm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:36:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EAA6A64
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:36:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3B4C64221
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D89C433EF;
        Thu,  6 Apr 2023 02:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680748599;
        bh=CPK6Fk80KOpaYsyNQoAt/8GvIqpnYX8m0BFWV3vDbOA=;
        h=Date:To:From:Subject:From;
        b=Jx1JFh86FSNAF3S+7aNEzk8bkzEdSjqbjZ4tArCMNVJSF3B3pxaPPZAu0AysTV7f0
         1W3a77DY8vSdiE2CWHtBgpi5otYx67k52u5XJo0m/lgQiRFz/PPqxsRYjCt+pS08GI
         KXrZUivMOPpcWTdW10auytYMNVQ0zCOF4QKWsV8w=
Date:   Wed, 05 Apr 2023 19:36:38 -0700
To:     mm-commits@vger.kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmalloc-convert-vread-to-vread_iter-v8-fix.patch removed from -mm tree
Message-Id: <20230406023639.11D89C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-vmalloc-convert-vread-to-vread_iter-v8-fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-convert-vread-to-vread_iter-v8-fix.patch

This patch was dropped because it was folded into mm-vmalloc-convert-vread-to-vread_iter.patch

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

mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix.patch
mm-vmalloc-convert-vread-to-vread_iter.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch
notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch

