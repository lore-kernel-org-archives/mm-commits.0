Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAEE9C00528
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 19:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjGXTFv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 15:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjGXTFt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 15:05:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3633B10E6
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 12:05:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FABF61004
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 19:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE25EC433C8;
        Mon, 24 Jul 2023 19:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690225546;
        bh=4DHm0DfJYpuH5mRXqjAILP8p5m8eNKMfZcMgJw2AiQE=;
        h=Date:To:From:Subject:From;
        b=YiImLaVBpWtbT/qpsU0/TE7cxvYmbQ5m4dNoiDiLMuglixYjdeyPUSlWPkQy/R3Lp
         3hQ8whU51tshP4er6rwpoL4y7chwC6qyRrVNGD7OnFGcAygNVCHWdDghgzSEUye/eL
         wXa+5oEGvZEbg+y7+sMdLfLjSLHveu9VQtfcfNds=
Date:   Mon, 24 Jul 2023 12:05:46 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        punit.agrawal@bytedance.com, edumazet@google.com,
        arjunroy@google.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-per-vma-locks-on-file-backed-vmas.patch added to mm-unstable branch
Message-Id: <20230724190546.BE25EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: allow per-VMA locks on file-backed VMAs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-allow-per-vma-locks-on-file-backed-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-allow-per-vma-locks-on-file-backed-vmas.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: allow per-VMA locks on file-backed VMAs
Date: Mon, 24 Jul 2023 19:54:02 +0100

Remove the TCP layering violation by allowing per-VMA locks on all VMAs. 
The fault path will immediately fail in handle_mm_fault().  There may be a
small performance reduction from this patch as a little unnecessary work
will be done on each page fault.  See later patches for the improvement.

Link: https://lkml.kernel.org/r/20230724185410.1124082-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS            |    1 -
 include/linux/net_mm.h |   17 -----------------
 include/net/tcp.h      |    1 -
 mm/memory.c            |   12 ++++++------
 net/ipv4/tcp.c         |   11 ++++-------
 5 files changed, 10 insertions(+), 32 deletions(-)

--- a/include/linux/net_mm.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-#ifdef CONFIG_MMU
-
-#ifdef CONFIG_INET
-extern const struct vm_operations_struct tcp_vm_ops;
-static inline bool vma_is_tcp(const struct vm_area_struct *vma)
-{
-	return vma->vm_ops == &tcp_vm_ops;
-}
-#else
-static inline bool vma_is_tcp(const struct vm_area_struct *vma)
-{
-	return false;
-}
-#endif /* CONFIG_INET*/
-
-#endif /* CONFIG_MMU */
--- a/include/net/tcp.h~mm-allow-per-vma-locks-on-file-backed-vmas
+++ a/include/net/tcp.h
@@ -45,7 +45,6 @@
 #include <linux/memcontrol.h>
 #include <linux/bpf-cgroup.h>
 #include <linux/siphash.h>
-#include <linux/net_mm.h>
 
 extern struct inet_hashinfo tcp_hashinfo;
 
--- a/MAINTAINERS~mm-allow-per-vma-locks-on-file-backed-vmas
+++ a/MAINTAINERS
@@ -14809,7 +14809,6 @@ NETWORKING [TCP]
 M:	Eric Dumazet <edumazet@google.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	include/linux/net_mm.h
 F:	include/linux/tcp.h
 F:	include/net/tcp.h
 F:	include/trace/events/tcp.h
--- a/mm/memory.c~mm-allow-per-vma-locks-on-file-backed-vmas
+++ a/mm/memory.c
@@ -77,7 +77,6 @@
 #include <linux/ptrace.h>
 #include <linux/vmalloc.h>
 #include <linux/sched/sysctl.h>
-#include <linux/net_mm.h>
 
 #include <trace/events/kmem.h>
 
@@ -5360,6 +5359,11 @@ vm_fault_t handle_mm_fault(struct vm_are
 		goto out;
 	}
 
+	if ((flags & FAULT_FLAG_VMA_LOCK) && !vma_is_anonymous(vma)) {
+		vma_end_read(vma);
+		return VM_FAULT_RETRY;
+	}
+
 	/*
 	 * Enable the memcg OOM handling for faults triggered in user
 	 * space.  Kernel faults are handled more gracefully.
@@ -5531,12 +5535,8 @@ retry:
 	if (!vma)
 		goto inval;
 
-	/* Only anonymous and tcp vmas are supported for now */
-	if (!vma_is_anonymous(vma) && !vma_is_tcp(vma))
-		goto inval;
-
 	/* find_mergeable_anon_vma uses adjacent vmas which are not locked */
-	if (!vma->anon_vma && !vma_is_tcp(vma))
+	if (vma_is_anonymous(vma) && !vma->anon_vma)
 		goto inval;
 
 	if (!vma_start_read(vma))
--- a/net/ipv4/tcp.c~mm-allow-per-vma-locks-on-file-backed-vmas
+++ a/net/ipv4/tcp.c
@@ -1739,7 +1739,7 @@ void tcp_update_recv_tstamps(struct sk_b
 }
 
 #ifdef CONFIG_MMU
-const struct vm_operations_struct tcp_vm_ops = {
+static const struct vm_operations_struct tcp_vm_ops = {
 };
 
 int tcp_mmap(struct file *file, struct socket *sock,
@@ -2042,13 +2042,10 @@ static struct vm_area_struct *find_tcp_v
 					   unsigned long address,
 					   bool *mmap_locked)
 {
-	struct vm_area_struct *vma = NULL;
+	struct vm_area_struct *vma = lock_vma_under_rcu(mm, address);
 
-#ifdef CONFIG_PER_VMA_LOCK
-	vma = lock_vma_under_rcu(mm, address);
-#endif
 	if (vma) {
-		if (!vma_is_tcp(vma)) {
+		if (vma->vm_ops != &tcp_vm_ops) {
 			vma_end_read(vma);
 			return NULL;
 		}
@@ -2058,7 +2055,7 @@ static struct vm_area_struct *find_tcp_v
 
 	mmap_read_lock(mm);
 	vma = vma_lookup(mm, address);
-	if (!vma || !vma_is_tcp(vma)) {
+	if (!vma || vma->vm_ops != &tcp_vm_ops) {
 		mmap_read_unlock(mm);
 		return NULL;
 	}
_

Patches currently in -mm which might be from willy@infradead.org are

rmap-pass-the-folio-to-__page_check_anon_rmap.patch
highmem-add-memcpy_to_folio-and-memcpy_from_folio.patch
affs-convert-affs_symlink_read_folio-to-use-the-folio.patch
affs-convert-data-read-and-write-to-use-folios.patch
migrate-use-folio_set_bh-instead-of-set_bh_page.patch
ntfs3-convert-ntfs_get_block_vbo-to-use-a-folio.patch
jbd2-use-a-folio-in-jbd2_journal_write_metadata_buffer.patch
buffer-remove-set_bh_page.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-remove-config_per_vma_lock-ifdefs.patch
mm-allow-per-vma-locks-on-file-backed-vmas.patch
mm-move-fault_flag_vma_lock-check-from-handle_mm_fault.patch
mm-handle-pud-faults-under-the-vma-lock.patch
mm-handle-some-pmd-faults-under-the-vma-lock.patch
mm-move-fault_flag_vma_lock-check-down-in-handle_pte_fault.patch
mm-move-fault_flag_vma_lock-check-down-from-do_fault.patch
mm-run-the-fault-around-code-under-the-vma-lock.patch
mm-handle-swap-and-numa-pte-faults-under-the-vma-lock.patch
mm-handle-faults-that-merely-update-the-accessed-bit-under-the-vma-lock.patch

