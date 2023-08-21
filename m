Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD00BEE49A8
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjHUUmG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjHUUlD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:41:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E270CE9
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F72B649CB
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57B2C433C8;
        Mon, 21 Aug 2023 20:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650440;
        bh=kX15joC8k/d4qSa/zi3yoQHzWjREVmesa7aBpij+Y3w=;
        h=Date:To:From:Subject:From;
        b=LbPpZ+SapkNWImUOtILwMtvevGjFpxbo7Ve8foXglicekXW5/sXM0w/oonF0sPQzZ
         5JPto+duJZ/LtNkXw+qsv41FEjrMPm4/p6fe+zJV2k5IfUYb5Lxbtsl9EZ2OxPiJsz
         G+3FgyL+2c4ZyC1+SODSx3VMfw0GtRWzTBT57FE0=
Date:   Mon, 21 Aug 2023 13:40:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, mjguzik@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-dummy_vm_ops-out-of-a-header.patch removed from -mm tree
Message-Id: <20230821204040.B57B2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: move dummy_vm_ops out of a header
has been removed from the -mm tree.  Its filename was
     mm-move-dummy_vm_ops-out-of-a-header.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: mm: move dummy_vm_ops out of a header
Date: Mon, 7 Aug 2023 01:16:11 +0200

Otherwise the kernel ends up with multiple copies:
$ nm vmlinux | grep dummy_vm_ops
ffffffff81e4ea00 d dummy_vm_ops.2
ffffffff81e11760 d dummy_vm_ops.254
ffffffff81e406e0 d dummy_vm_ops.4
ffffffff81e3c780 d dummy_vm_ops.7

While here prefix it with vma_.

Link: https://lkml.kernel.org/r/20230806231611.1395735-1-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 +++---
 mm/init-mm.c       |    2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-move-dummy_vm_ops-out-of-a-header
+++ a/include/linux/mm.h
@@ -751,17 +751,17 @@ static inline struct vm_area_struct *loc
 
 #endif /* CONFIG_PER_VMA_LOCK */
 
+extern const struct vm_operations_struct vma_dummy_vm_ops;
+
 /*
  * WARNING: vma_init does not initialize vma->vm_lock.
  * Use vm_area_alloc()/vm_area_free() if vma needs locking.
  */
 static inline void vma_init(struct vm_area_struct *vma, struct mm_struct *mm)
 {
-	static const struct vm_operations_struct dummy_vm_ops = {};
-
 	memset(vma, 0, sizeof(*vma));
 	vma->vm_mm = mm;
-	vma->vm_ops = &dummy_vm_ops;
+	vma->vm_ops = &vma_dummy_vm_ops;
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
 	vma_mark_detached(vma, false);
 	vma_numab_state_init(vma);
--- a/mm/init-mm.c~mm-move-dummy_vm_ops-out-of-a-header
+++ a/mm/init-mm.c
@@ -17,6 +17,8 @@
 #define INIT_MM_CONTEXT(name)
 #endif
 
+const struct vm_operations_struct vma_dummy_vm_ops;
+
 /*
  * For dynamically allocated mm_structs, there is a dynamically sized cpumask
  * at the end of the structure, the size of which depends on the maximum CPU
_

Patches currently in -mm which might be from mjguzik@gmail.com are

kernel-fork-stop-playing-lockless-games-for-exe_file-replacement.patch

