Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FBE6C47082
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 23:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04713613D9
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 23:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbhEZXha (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 May 2021 19:37:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233517AbhEZXh3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 May 2021 19:37:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F38FF613CD;
        Wed, 26 May 2021 23:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622072157;
        bh=3Sv+w8jsbalbluyg90uLE7iGKoAC1OrENR5RAmXT35s=;
        h=Date:From:To:Subject:From;
        b=nZz/SNmXcnIghL0amGBTCnt1JEwYKbjnvk8UEkjXROSGw5Vw60EZlSZaq5WYW3aG3
         FoW9Yb+v9mHO7dyxC7UZqo2E4y1NfZSSgVaxH9vx0pf4CvERgRpa5eDCCKm1paqs4i
         pdjuD4+8A0EOscHzPVxR/pB/mTNMJJnfDCWDUAQQ=
Date:   Wed, 26 May 2021 16:35:56 -0700
From:   akpm@linux-foundation.org
To:     acme@redhat.com, andrii.nakryiko@gmail.com, andrii@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, david@redhat.com,
        hritikxx8@gmail.com, john.fastabend@gmail.com, jolsa@kernel.org,
        kafai@fb.com, kpsingh@kernel.org, masahiroy@kernel.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        msuchanek@suse.de, songliubraving@fb.com, yhs@fb.com
Subject:  +
 mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix.patch added
 to -mm tree
Message-ID: <20210526233556.uFe6_mPfz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: work around a pahole limitation with zero-sized struct pagesets
has been added to the -mm tree.  Its filename is
     mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: work around a pahole limitation with zero-sized struct pagesets

Michal Suchanek reported the following problem with linux-next

  [    0.000000] Linux version 5.13.0-rc2-next-20210519-1.g3455ff8-vanilla (geeko@buildhost) (gcc (SUSE Linux) 10.3.0, GNU ld (GNU Binutils; openSUSE Tumbleweed) 2.36.1.20210326-3) #1 SMP Wed May 19 10:05:10 UTC 2021 (3455ff8)
  [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.13.0-rc2-next-20210519-1.g3455ff8-vanilla root=UUID=ec42c33e-a2c2-4c61-afcc-93e9527 8f687 plymouth.enable=0 resume=/dev/disk/by-uuid/f1fe4560-a801-4faf-a638-834c407027c7 mitigations=auto earlyprintk initcall_debug nomodeset earlycon ignore_loglevel console=ttyS0,115200
...
  [   26.093364] calling  tracing_set_default_clock+0x0/0x62 @ 1
  [   26.098937] initcall tracing_set_default_clock+0x0/0x62 returned 0 after 0 usecs
  [   26.106330] calling  acpi_gpio_handle_deferred_request_irqs+0x0/0x7c @ 1
  [   26.113033] initcall acpi_gpio_handle_deferred_request_irqs+0x0/0x7c returned 0 after 3 usecs
  [   26.121559] calling  clk_disable_unused+0x0/0x102 @ 1
  [   26.126620] initcall clk_disable_unused+0x0/0x102 returned 0 after 0 usecs
  [   26.133491] calling  regulator_init_complete+0x0/0x25 @ 1
  [   26.138890] initcall regulator_init_complete+0x0/0x25 returned 0 after 0 usecs
  [   26.147816] Freeing unused decrypted memory: 2036K
  [   26.153682] Freeing unused kernel image (initmem) memory: 2308K
  [   26.165776] Write protecting the kernel read-only data: 26624k
  [   26.173067] Freeing unused kernel image (text/rodata gap) memory: 2036K
  [   26.180416] Freeing unused kernel image (rodata/data gap) memory: 1184K
  [   26.187031] Run /init as init process
  [   26.190693]   with arguments:
  [   26.193661]     /init
  [   26.195933]   with environment:
  [   26.199079]     HOME=/
  [   26.201444]     TERM=linux
  [   26.204152]     BOOT_IMAGE=/boot/vmlinuz-5.13.0-rc2-next-20210519-1.g3455ff8-vanilla
  [   26.254154] BPF:      type_id=35503 offset=178440 size=4
  [   26.259125] BPF:
  [   26.261054] BPF:Invalid offset
  [   26.264119] BPF:
  [   26.264119]
  [   26.267437] failed to validate module [efivarfs] BTF: -22

Andrii Nakryiko bisected the problem to the commit "mm/page_alloc: convert
per-cpu list protection to local_lock" currently staged in mmotm.  In his
own words

  The immediate problem is two different definitions of numa_node per-cpu
  variable. They both are at the same offset within .data..percpu ELF
  section, they both have the same name, but one of them is marked as
  static and another as global. And one is int variable, while another
  is struct pagesets. I'll look some more tomorrow, but adding Jiri and
  Arnaldo for visibility.

  [110907] DATASEC '.data..percpu' size=178904 vlen=303
  ...
        type_id=27753 offset=163976 size=4 (VAR 'numa_node')
        type_id=27754 offset=163976 size=4 (VAR 'numa_node')

  [27753] VAR 'numa_node' type_id=27556, linkage=static
  [27754] VAR 'numa_node' type_id=20, linkage=global

  [20] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED

  [27556] STRUCT 'pagesets' size=0 vlen=1
        'lock' type_id=507 bits_offset=0

  [506] STRUCT '(anon)' size=0 vlen=0
  [507] TYPEDEF 'local_lock_t' type_id=506

The patch in question introduces a zero-sized per-cpu struct and while
this is not wrong, versions of pahole prior to 1.22 (unreleased) get
confused during BTF generation with two separate variables occupying the
same address.

This patch checks for older versions of pahole and forces struct pagesets
to be non-zero sized as a workaround when CONFIG_DEBUG_INFO_BTF is set.  A
warning is emitted so that distributions can update pahole when 1.22 is
released.

Link: https://lkml.kernel.org/r/20210526080741.GW30378@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Michal Suchanek <msuchanek@suse.de>
Reported-by: Hritik Vijay <hritikxx8@gmail.com>
Debugged-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Andrii Nakryiko <andrii@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    3 +++
 mm/page_alloc.c   |   11 +++++++++++
 2 files changed, 14 insertions(+)

--- a/lib/Kconfig.debug~mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix
+++ a/lib/Kconfig.debug
@@ -313,6 +313,9 @@ config DEBUG_INFO_BTF
 config PAHOLE_HAS_SPLIT_BTF
 	def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "119")
 
+config PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT
+	def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "122")
+
 config DEBUG_INFO_BTF_MODULES
 	def_bool y
 	depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF
--- a/mm/page_alloc.c~mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix
+++ a/mm/page_alloc.c
@@ -124,6 +124,17 @@ static DEFINE_MUTEX(pcp_batch_high_lock)
 
 struct pagesets {
 	local_lock_t lock;
+#if defined(CONFIG_DEBUG_INFO_BTF) &&			\
+    !defined(CONFIG_DEBUG_LOCK_ALLOC) &&		\
+    !defined(CONFIG_PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT)
+	/*
+	 * pahole 1.21 and earlier gets confused by zero-sized per-CPU
+	 * variables and produces invalid BTF. Ensure that
+	 * sizeof(struct pagesets) != 0 for older versions of pahole.
+	 */
+	char __pahole_hack;
+	#warning "pahole too old to support zero-sized struct pagesets"
+#endif
 };
 static DEFINE_PER_CPU(struct pagesets, pagesets) = {
 	.lock = INIT_LOCAL_LOCK(lock),
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix.patch
mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch
mm-vmstat-inline-numa-event-counter-updates.patch
mm-page_alloc-batch-the-accounting-updates-in-the-bulk-allocator.patch
mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch
mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-avoid-conflating-irqs-disabled-with-zone-lock.patch
mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-delete-vmpercpu_pagelist_fraction.patch
mm-page_alloc-disassociate-the-pcp-high-from-pcp-batch.patch
mm-page_alloc-adjust-pcp-high-after-cpu-hotplug-events.patch
mm-page_alloc-scale-the-number-of-pages-that-are-batch-freed.patch
mm-page_alloc-limit-the-number-of-pages-on-pcp-lists-when-reclaim-is-active.patch
mm-page_alloc-introduce-vmpercpu_pagelist_high_fraction.patch
mm-vmscan-remove-kerneldoc-like-comment-from-isolate_lru_pages.patch
mm-vmalloc-include-header-for-prototype-of-set_iounmap_nonlazy.patch
mm-page_alloc-make-should_fail_alloc_page-a-static-function-should_fail_alloc_page-static.patch
mm-mapping_dirty_helpers-remove-double-note-in-kerneldoc.patch
mm-early_ioremap-add-prototype-for-early_memremap_pgprot_adjust.patch
mm-memcontrolc-fix-kerneldoc-comment-for-mem_cgroup_calculate_protection.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__try_online_node.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__remove_memory.patch
mm-zbud-add-kerneldoc-fields-for-zbud_pool.patch
mm-z3fold-add-kerneldoc-fields-for-z3fold_pool.patch
mm-swap-make-swap_address_space-an-inline-function.patch
mm-mmap_lock-remove-dead-code-for-config_tracing-configurations.patch
mm-page_alloc-move-prototype-for-find_suitable_fallback.patch
mm-swap-make-node_data-an-inline-function-on-config_flatmem.patch

