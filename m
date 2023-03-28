Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63084C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjC1XNH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjC1XNH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:13:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB071BF0
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:13:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6137B81F4D
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505E9C433D2;
        Tue, 28 Mar 2023 23:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045183;
        bh=whzD+PD6xUjQhWVUszgaM4td94JDzpjktojdxOjIwH4=;
        h=Date:To:From:Subject:From;
        b=xoRXUcQFRnWgdB6zAtcDwg5X4O+vbwgaUc0U3Phk79iUijGN9q5wy8Or1K1a/RthC
         zL/Gw0hffWbq4ksfhI7Jdgrzag1NJDo/zQ7SqP+gVJn2ki6obPJAEnesUawjia1dbP
         6XVWMCuxv0nFq87Rahkhiq6AhDU+xufNcRL/qx/4=
Date:   Tue, 28 Mar 2023 16:13:02 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        pgofman@codeweavers.com, peterx@redhat.com, david@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch removed from -mm tree
Message-Id: <20230328231303.505E9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-userfaultfd-support-wp-on-multiple-vmas-fix
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch

This patch was dropped because it was folded into mm-userfaultfd-support-wp-on-multiple-vmas.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-userfaultfd-support-wp-on-multiple-vmas-fix
Date: Thu Feb 23 03:13:06 PM PST 2023

s/VM_WARN_ON_ONCE/VM_WARN_ONCE/ to fix build

Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Paul Gofman <pgofman@codeweavers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-support-wp-on-multiple-vmas-fix
+++ a/mm/userfaultfd.c
@@ -717,7 +717,7 @@ long uffd_wp_range(struct mm_struct *dst
 	struct mmu_gather tlb;
 	long ret;
 
-	VM_WARN_ON_ONCE(start < dst_vma->vm_start || start + len > dst_vma->vm_end,
+	VM_WARN_ONCE(start < dst_vma->vm_start || start + len > dst_vma->vm_end,
 			"The address range exceeds VMA boundary.\n");
 	if (enable_wp)
 		mm_cp_flags = MM_CP_UFFD_WP;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-userfaultfd-support-wp-on-multiple-vmas.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch
mm-treewide-redefine-max_order-sanely-fix-2.patch
mm-treewide-redefine-max_order-sanely-fix-3-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
mm-vmalloc-convert-vread-to-vread_iter-v8-fix.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch
notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch

