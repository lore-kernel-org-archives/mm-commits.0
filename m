Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA7DC001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237029AbjHKXDI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237095AbjHKXB3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:01:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322533C30
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD8C96492A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CEE2C433C7;
        Fri, 11 Aug 2023 23:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794847;
        bh=oLVSYEApSrOWRRukublasxCw07BrsxWpUhBtg73drAI=;
        h=Date:To:From:Subject:From;
        b=e2M22qkkPEjKP46H7GKWMfNogc7eJTu/iPHn9WApd66aFU5zGu18W4UtzCyrMXGYW
         q6RB4+wV450VS29ENvsPvKsx8ipaGbzSeJjk1OVPGeaCb5aa0drAhj5nT6B2pBDEv0
         84yJ3F0pYZzi2dLzvw/bv6YEGbea4hQgqYvxKId8=
Date:   Fri, 11 Aug 2023 16:00:46 -0700
To:     mm-commits@vger.kernel.org, tim.c.chen@linux.intel.com,
        shakeelb@google.com, lipeng.zhu@intel.com, Liam.Howlett@oracle.com,
        kirill@shutemov.name, dave.hansen@intel.com,
        dan.j.williams@intel.com, yu.ma@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-move-vma-operations-to-mm_struct-out-of-the-critical-section-of-file-mapping-lock.patch removed from -mm tree
Message-Id: <20230811230047.1CEE2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: move vma operations to mm_struct out of the critical section of file mapping lock
has been removed from the -mm tree.  Its filename was
     mm-mmap-move-vma-operations-to-mm_struct-out-of-the-critical-section-of-file-mapping-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yu Ma <yu.ma@intel.com>
Subject: mm/mmap: move vma operations to mm_struct out of the critical section of file mapping lock
Date: Wed, 12 Jul 2023 10:57:39 -0400

UnixBench/Execl represents a class of workload where bash scripts are
spawned frequently to do some short jobs.  When running multiple parallel
tasks, hot osq_lock is observed from do_mmap and exit_mmap.  Both of them
come from load_elf_binary through the call chain
"execl->do_execveat_common->bprm_execve->load_elf_binary".

In do_mmap,it will call mmap_region to create vma node, initialize it and
insert it to vma maintain structure in mm_struct and i_mmap tree of the
mapping file, then increase map_count to record the number of vma nodes
used.  The hot osq_lock is to protect operations on file's i_mmap tree. 
For the mm_struct member change like vma insertion and map_count update,
they do not affect i_mmap tree.  Move those operations out of the lock's
critical section, to reduce hold time on the lock.

With this change, on Intel Sapphire Rapids 112C/224T platform, based on
v6.0-rc6, the 160 parallel score improves by 12%.  The patch has no
obvious performance gain on v6.5-rc1 due to regression of this benchmark
from this commit f1a7941243c102a44e8847e3b94ff4ff3ec56f25 (mm: convert
mm's rss stats into percpu_counter).  Related discussion and conclusion
can be referred at the mail thread initiated by 0day as below: Link:
https://lore.kernel.org/linux-mm/a4aa2e13-7187-600b-c628-7e8fb108def0@intel.com/

Link: https://lkml.kernel.org/r/20230712145739.604215-1-yu.ma@intel.com
Signed-off-by: Yu Ma <yu.ma@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Kirill A . Shutemov <kirill@shutemov.name>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Zhu, Lipeng <lipeng.zhu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/mm/mmap.c~mm-mmap-move-vma-operations-to-mm_struct-out-of-the-critical-section-of-file-mapping-lock
+++ a/mm/mmap.c
@@ -412,14 +412,11 @@ static int vma_link(struct mm_struct *mm
 	if (vma_iter_prealloc(&vmi))
 		return -ENOMEM;
 
+	vma_iter_store(&vmi, vma);
+
 	if (vma->vm_file) {
 		mapping = vma->vm_file->f_mapping;
 		i_mmap_lock_write(mapping);
-	}
-
-	vma_iter_store(&vmi, vma);
-
-	if (mapping) {
 		__vma_link_file(vma, mapping);
 		i_mmap_unlock_write(mapping);
 	}
@@ -2812,12 +2809,10 @@ cannot_expand:
 
 	/* Lock the VMA since it is modified after insertion into VMA tree */
 	vma_start_write(vma);
-	if (vma->vm_file)
-		i_mmap_lock_write(vma->vm_file->f_mapping);
-
 	vma_iter_store(&vmi, vma);
 	mm->map_count++;
 	if (vma->vm_file) {
+		i_mmap_lock_write(vma->vm_file->f_mapping);
 		if (vma->vm_flags & VM_SHARED)
 			mapping_allow_writable(vma->vm_file->f_mapping);
 
_

Patches currently in -mm which might be from yu.ma@intel.com are


