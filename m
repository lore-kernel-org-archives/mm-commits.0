Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA76CDB474
	for <mm-commits@archiver.kernel.org>; Tue, 17 Oct 2023 15:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235167AbjJQPF2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235168AbjJQPFR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2023 11:05:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF952914B;
        Tue, 17 Oct 2023 07:58:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E191FC433C8;
        Tue, 17 Oct 2023 14:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697554714;
        bh=LFtdEVkTYiH8ADUxXztCxkHDxWuqDYiI5/3MG+760wQ=;
        h=Date:To:From:Subject:From;
        b=lC37/2T5/fBUxdX7cmJJNpbS0frWUcKmpo424Kul/QoqIMmh7AwuG75EuAfH1sLos
         rQQeCYfi2Cr46FJP6OeOswJiqiVN8sjlIrAEhp3C/TphmtPPGuFMlwjS6EF4huGf1B
         qGrhPVicMIZU4h1ooy7P3BF4oIPuul8/zVpPDMUA=
Date:   Tue, 17 Oct 2023 07:58:33 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        tglx@linutronix.de, stable@vger.kernel.org, peterz@infradead.org,
        mingo@redhat.com, mhocko@suse.com, luto@kernel.org, hpa@zytor.com,
        david@redhat.com, dave.hansen@linux.intel.com, bp@alien8.de,
        rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-drop-4mb-restriction-on-minimal-numa-node-size.patch added to mm-hotfixes-unstable branch
Message-Id: <20231017145833.E191FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/mm: drop 4MB restriction on minimal NUMA node size
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-mm-drop-4mb-restriction-on-minimal-numa-node-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-drop-4mb-restriction-on-minimal-numa-node-size.patch

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
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: x86/mm: drop 4MB restriction on minimal NUMA node size
Date: Tue, 17 Oct 2023 09:22:15 +0300

Qi Zheng reports crashes in a production environment and provides a
simplified example as a reproducer:

  For example, if we use qemu to start a two NUMA node kernel,
  one of the nodes has 2M memory (less than NODE_MIN_SIZE),
  and the other node has 2G, then we will encounter the
  following panic:

  [    0.149844] BUG: kernel NULL pointer dereference, address: 0000000000000000
  [    0.150783] #PF: supervisor write access in kernel mode
  [    0.151488] #PF: error_code(0x0002) - not-present page
  <...>
  [    0.156056] RIP: 0010:_raw_spin_lock_irqsave+0x22/0x40
  <...>
  [    0.169781] Call Trace:
  [    0.170159]  <TASK>
  [    0.170448]  deactivate_slab+0x187/0x3c0
  [    0.171031]  ? bootstrap+0x1b/0x10e
  [    0.171559]  ? preempt_count_sub+0x9/0xa0
  [    0.172145]  ? kmem_cache_alloc+0x12c/0x440
  [    0.172735]  ? bootstrap+0x1b/0x10e
  [    0.173236]  bootstrap+0x6b/0x10e
  [    0.173720]  kmem_cache_init+0x10a/0x188
  [    0.174240]  start_kernel+0x415/0x6ac
  [    0.174738]  secondary_startup_64_no_verify+0xe0/0xeb
  [    0.175417]  </TASK>
  [    0.175713] Modules linked in:
  [    0.176117] CR2: 0000000000000000

The crashes happen because of inconsistency between nodemask that has
nodes with less than 4MB as memoryless and the actual memory fed into
core mm.

The commit 9391a3f9c7f1 ("[PATCH] x86_64: Clear more state when ignoring
empty node in SRAT parsing") that introduced minimal size of a NUMA node
does not explain why a node size cannot be less than 4MB and what boot
failures this restriction might fix.

Since then a lot has changed and core mm won't confuse badly about small
node sizes.

Drop the limitation for the minimal node size.

Link: https://lkml.kernel.org/r/20231017062215.171670-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reported-by: Qi Zheng <zhengqi.arch@bytedance.com>
Closes: https://lore.kernel.org/all/20230212110305.93670-1-zhengqi.arch@bytedance.com/
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Ziljstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/numa.h |    7 -------
 arch/x86/mm/numa.c          |    7 -------
 2 files changed, 14 deletions(-)

--- a/arch/x86/include/asm/numa.h~x86-mm-drop-4mb-restriction-on-minimal-numa-node-size
+++ a/arch/x86/include/asm/numa.h
@@ -12,13 +12,6 @@
 
 #define NR_NODE_MEMBLKS		(MAX_NUMNODES*2)
 
-/*
- * Too small node sizes may confuse the VM badly. Usually they
- * result from BIOS bugs. So dont recognize nodes as standalone
- * NUMA entities that have less than this amount of RAM listed:
- */
-#define NODE_MIN_SIZE (4*1024*1024)
-
 extern int numa_off;
 
 /*
--- a/arch/x86/mm/numa.c~x86-mm-drop-4mb-restriction-on-minimal-numa-node-size
+++ a/arch/x86/mm/numa.c
@@ -601,13 +601,6 @@ static int __init numa_register_memblks(
 		if (start >= end)
 			continue;
 
-		/*
-		 * Don't confuse VM with a node that doesn't have the
-		 * minimum amount of memory:
-		 */
-		if (end && (end - start) < NODE_MIN_SIZE)
-			continue;
-
 		alloc_node_data(nid);
 	}
 
_

Patches currently in -mm which might be from rppt@kernel.org are

x86-mm-drop-4mb-restriction-on-minimal-numa-node-size.patch
nios2-define-virtual-address-space-for-modules.patch
mm-introduce-execmem_text_alloc-and-execmem_free.patch
mm-execmem-arch-convert-simple-overrides-of-module_alloc-to-execmem.patch
mm-execmem-arch-convert-remaining-overrides-of-module_alloc-to-execmem.patch
modules-execmem-drop-module_alloc.patch
mm-execmem-introduce-execmem_data_alloc.patch
arm64-execmem-extend-execmem_params-for-generated-code-allocations.patch
riscv-extend-execmem_params-for-generated-code-allocations.patch
powerpc-extend-execmem_params-for-kprobes-allocations.patch
powerpc-extend-execmem_params-for-kprobes-allocations-fix.patch
arch-make-execmem-setup-available-regardless-of-config_modules.patch
x86-ftrace-enable-dynamic-ftrace-without-config_modules.patch
kprobes-remove-dependency-on-config_modules.patch
bpf-remove-config_bpf_jit-dependency-on-config_modules-of.patch

