Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F60EB64DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jul 2023 19:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbjGLTG0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jul 2023 15:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjGLTG0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2023 15:06:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66CA1FC1
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 12:06:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 656B4618D7
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 19:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB750C433C8;
        Wed, 12 Jul 2023 19:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689188783;
        bh=boNbDo1xX0kmuFn1/PmnBu5x7m9zIflSWCt3//4d2so=;
        h=Date:To:From:Subject:From;
        b=d00M4v/NJSLvENVaHLBqv4i1soQkYpuf1Oplv1H7Xml55GcV2S3IRI1Cr0i9oa/gd
         cUspU39Qmfh9qKTkQ5ptAWphyInazhO6A4N5RoKxFLOXShsWdvmHdyvy7m9WF6K3J5
         NAoZSMGF4LHJiOnT8Rztzzs072+9Eg+T/YfcCgzw=
Date:   Wed, 12 Jul 2023 12:06:23 -0700
To:     mm-commits@vger.kernel.org, tim.c.chen@linux.intel.com,
        shakeelb@google.com, lipeng.zhu@intel.com, Liam.Howlett@oracle.com,
        kirill@shutemov.name, dave.hansen@intel.com,
        dan.j.williams@intel.com, yu.ma@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-move-vma-operations-to-mm_struct-out-of-the-critical-section-of-file-mapping-lock.patch added to mm-unstable branch
Message-Id: <20230712190623.BB750C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: move vma operations to mm_struct out of the critical section of file mapping lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-move-vma-operations-to-mm_struct-out-of-the-critical-section-of-file-mapping-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-move-vma-operations-to-mm_struct-out-of-the-critical-section-of-file-mapping-lock.patch

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
@@ -2811,12 +2808,10 @@ cannot_expand:
 
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

mm-mmap-move-vma-operations-to-mm_struct-out-of-the-critical-section-of-file-mapping-lock.patch

