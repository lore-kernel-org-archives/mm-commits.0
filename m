Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98510C7EE45
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjFJApQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjFJApM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E53E30F6
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3385360FDC
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860B2C433D2;
        Sat, 10 Jun 2023 00:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357910;
        bh=Ej7iyvEsR6Vk2qvpwdCNFJH3FzVeOFdOSJEszsSWBOM=;
        h=Date:To:From:Subject:From;
        b=RC8q/TwrRBbSrkCcC8tUfRUXCABM2ANOvgFLPMxlEdlpVnHk0pDrzk08XbiVu3udl
         79i8d/80uIQXu79PiwSGJ8BbKTXzeST4wa6rSXgPSBTbYj6+bX0ru8xLssaSKqF6X5
         OFV0tNVNxzRHipKfsLv08e/uaebKENLNYsuSnRmA=
Date:   Fri, 09 Jun 2023 17:45:09 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        tsbogend@alpha.franken.de, tj@kernel.org, tglx@linutronix.de,
        rafael@kernel.org, peterz@infradead.org, pavel@ucw.cz,
        paul@paul-moore.com, palmer@dabbelt.com, mpe@ellerman.id.au,
        monstr@monstr.eu, mingo@redhat.com, longman@redhat.com,
        linux@armlinux.org.uk, hca@linux.ibm.com, eparis@redhat.com,
        dennis@kernel.org, deller@gmx.de, cl@linux.com,
        catalin.marinas@arm.com, boqun.feng@gmail.com, arnd@arndb.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mm-percpu-unhide-pcpu_embed_first_chunk-prototype.patch removed from -mm tree
Message-Id: <20230610004510.860B2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: percpu: unhide pcpu_embed_first_chunk prototype
has been removed from the -mm tree.  Its filename was
     mm-percpu-unhide-pcpu_embed_first_chunk-prototype.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: percpu: unhide pcpu_embed_first_chunk prototype
Date: Wed, 17 May 2023 15:10:49 +0200

Patch series "mm/init/kernel: missing-prototypes warnings".

These are patches addressing -Wmissing-prototypes warnings in common
kernel code and memory management code files that usually get merged
through the -mm tree.


This patch (of 12):

This function is called whenever CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK or
CONFIG_HAVE_SETUP_PER_CPU_AREA, but only declared when the former is set:

mm/percpu.c:3055:12: error: no previous prototype for 'pcpu_embed_first_chunk' [-Werror=missing-prototypes]

There is no real point in hiding declarations, so just remove
the #ifdef here.

Link: https://lkml.kernel.org/r/20230517131102.934196-1-arnd@kernel.org
Link: https://lkml.kernel.org/r/20230517131102.934196-2-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/percpu.h~mm-percpu-unhide-pcpu_embed_first_chunk-prototype
+++ a/include/linux/percpu.h
@@ -103,12 +103,10 @@ extern void __init pcpu_free_alloc_info(
 extern void __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 					 void *base_addr);
 
-#ifdef CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK
 extern int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 				size_t atom_size,
 				pcpu_fc_cpu_distance_fn_t cpu_distance_fn,
 				pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn);
-#endif
 
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
 void __init pcpu_populate_pte(unsigned long addr);
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-page_poison-always-declare-__kernel_map_pages-function.patch
mm-sparse-mark-populate_section_memmap-static.patch
lib-devmem_is_allowed-include-linux-ioh.patch
locking-add-lockevent_read-prototype.patch
panic-hide-unused-global-functions.patch
panic-make-function-declarations-visible.patch
kunit-include-debugfs-header-file.patch
init-consolidate-prototypes-in-linux-inith.patch
init-move-cifs_root_data-prototype-into-linux-mounth.patch
thread_info-move-function-declarations-to-linux-thread_infoh.patch
time_namespace-always-provide-arch_get_vdso_data-prototype-for-vdso.patch
kcov-add-prototypes-for-helper-functions.patch
decompressor-provide-missing-prototypes.patch
syscalls-add-sys_ni_posix_timers-prototype.patch

