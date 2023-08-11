Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3696DC04A94
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237159AbjHKXOJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237156AbjHKXNa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67353C17
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76B3267942
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC711C433C7;
        Fri, 11 Aug 2023 23:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794977;
        bh=sm86qNhyRa8SJTx7SQfAM0FJjel+otQ5evRzhgucFgY=;
        h=Date:To:From:Subject:From;
        b=QdHKn4/ztj27b1nHb9eRQ7pgZmQsI3mWM7DeHBw0EXNgf3lLK9zznO7i5xp1osddJ
         TJVZ9XbbL/aIHOLGx0I/QOrAWrFb6wQgi8Z254tsEoeFEkaKUN3O36yVUPcXa7sacI
         cvt/R0skKbGnL5GRmKI22Oli7RtVOpcVRjdJ9vdQ=
Date:   Fri, 11 Aug 2023 16:02:57 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        punit.agrawal@bytedance.com, edumazet@google.com,
        arjunroy@google.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-allow-per-vma-locks-on-file-backed-vmas.patch removed from -mm tree
Message-Id: <20230811230257.CC711C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: allow per-VMA locks on file-backed VMAs
has been removed from the -mm tree.  Its filename was
     mm-allow-per-vma-locks-on-file-backed-vmas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
 mm/memory.c            |   10 +++++-----
 net/ipv4/tcp.c         |   11 ++++-------
 5 files changed, 9 insertions(+), 31 deletions(-)

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
@@ -14829,7 +14829,6 @@ NETWORKING [TCP]
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
 
@@ -5223,6 +5222,11 @@ vm_fault_t handle_mm_fault(struct vm_are
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
@@ -5394,10 +5398,6 @@ retry:
 	if (!vma)
 		goto inval;
 
-	/* Only anonymous and tcp vmas are supported for now */
-	if (!vma_is_anonymous(vma) && !vma_is_tcp(vma))
-		goto inval;
-
 	if (!vma_start_read(vma))
 		goto inval;
 
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

mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-improve-the-comment-in-isolate_migratepages_block.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api-fix.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api-fix.patch
riscv-implement-the-new-page-table-range-api.patch
s390-implement-the-new-page-table-range-api.patch
sh-implement-the-new-page-table-range-api.patch
sparc32-implement-the-new-page-table-range-api.patch
sparc64-implement-the-new-page-table-range-api.patch
um-implement-the-new-page-table-range-api.patch
x86-implement-the-new-page-table-range-api.patch
xtensa-implement-the-new-page-table-range-api.patch
mm-remove-page_mapping_file.patch
mm-rationalise-flush_icache_pages-and-flush_icache_page.patch
mm-tidy-up-set_ptes-definition.patch
mm-use-flush_icache_pages-in-do_set_pmd.patch
mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch

