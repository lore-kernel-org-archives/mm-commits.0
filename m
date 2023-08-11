Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E941BC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbjHKW6o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236793AbjHKW6h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E011AE
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC1B06554C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E533C433C7;
        Fri, 11 Aug 2023 22:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794715;
        bh=stxixlheJ3qam94ghXIbbxtSxCh7PE9Ec4/wCmBsw8U=;
        h=Date:To:From:Subject:From;
        b=hIfedSEuOe9oV8eAJJ/nFt/DEnE0xk+v29VkfQ+R61IkaZBE+hic+Aq0PkDvZdvwJ
         5HJoC4wQ1zUXIWe3NyFArfCIea1pVERMdwbdDRH76rtUyFW5TE/GSibwMAKZQgQNMm
         nXGS1al/agMpnO1j28e6DHDoGxR/RWUbamn4p3hs=
Date:   Fri, 11 Aug 2023 15:58:34 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, npiggin@gmail.com,
        mpe@ellerman.id.au, gregkh@linuxfoundation.org,
        christophe.leroy@csgroup.eu, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-arguments-of-show_mem.patch removed from -mm tree
Message-Id: <20230811225835.3E533C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove arguments of show_mem()
has been removed from the -mm tree.  Its filename was
     mm-remove-arguments-of-show_mem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: remove arguments of show_mem()
Date: Fri, 30 Jun 2023 14:22:52 +0800

All callers of show_mem() pass 0 and NULL, so we can remove the two
arguments by directly calling __show_mem(0, NULL, MAX_NR_ZONES - 1) in
show_mem().

Link: https://lkml.kernel.org/r/20230630062253.189440-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/xmon/xmon.c  |    2 +-
 drivers/tty/sysrq.c       |    2 +-
 drivers/tty/vt/keyboard.c |    2 +-
 include/linux/mm.h        |    4 ++--
 init/initramfs.c          |    2 +-
 kernel/panic.c            |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/powerpc/xmon/xmon.c~mm-remove-arguments-of-show_mem
+++ a/arch/powerpc/xmon/xmon.c
@@ -1084,7 +1084,7 @@ cmds(struct pt_regs *excp)
 				memzcan();
 				break;
 			case 'i':
-				show_mem(0, NULL);
+				show_mem();
 				break;
 			default:
 				termch = cmd;
--- a/drivers/tty/sysrq.c~mm-remove-arguments-of-show_mem
+++ a/drivers/tty/sysrq.c
@@ -342,7 +342,7 @@ static const struct sysrq_key_op sysrq_f
 
 static void sysrq_handle_showmem(int key)
 {
-	show_mem(0, NULL);
+	show_mem();
 }
 static const struct sysrq_key_op sysrq_showmem_op = {
 	.handler	= sysrq_handle_showmem,
--- a/drivers/tty/vt/keyboard.c~mm-remove-arguments-of-show_mem
+++ a/drivers/tty/vt/keyboard.c
@@ -606,7 +606,7 @@ static void fn_scroll_back(struct vc_dat
 
 static void fn_show_mem(struct vc_data *vc)
 {
-	show_mem(0, NULL);
+	show_mem();
 }
 
 static void fn_show_state(struct vc_data *vc)
--- a/include/linux/mm.h~mm-remove-arguments-of-show_mem
+++ a/include/linux/mm.h
@@ -3068,9 +3068,9 @@ extern void mem_init(void);
 extern void __init mmap_init(void);
 
 extern void __show_mem(unsigned int flags, nodemask_t *nodemask, int max_zone_idx);
-static inline void show_mem(unsigned int flags, nodemask_t *nodemask)
+static inline void show_mem(void)
 {
-	__show_mem(flags, nodemask, MAX_NR_ZONES - 1);
+	__show_mem(0, NULL, MAX_NR_ZONES - 1);
 }
 extern long si_mem_available(void);
 extern void si_meminfo(struct sysinfo * val);
--- a/init/initramfs.c~mm-remove-arguments-of-show_mem
+++ a/init/initramfs.c
@@ -61,7 +61,7 @@ static void __init error(char *x)
 }
 
 #define panic_show_mem(fmt, ...) \
-	({ show_mem(0, NULL); panic(fmt, ##__VA_ARGS__); })
+	({ show_mem(); panic(fmt, ##__VA_ARGS__); })
 
 /* link hash */
 
--- a/kernel/panic.c~mm-remove-arguments-of-show_mem
+++ a/kernel/panic.c
@@ -216,7 +216,7 @@ static void panic_print_sys_info(bool co
 		show_state();
 
 	if (panic_print & PANIC_PRINT_MEM_INFO)
-		show_mem(0, NULL);
+		show_mem();
 
 	if (panic_print & PANIC_PRINT_TIMER_INFO)
 		sysrq_timer_list_show();
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-factor-out-vma-stack-and-heap-checks.patch
drm-amdkfd-use-vma_is_initial_stack-and-vma_is_initial_heap.patch
selinux-use-vma_is_initial_stack-and-vma_is_initial_heap.patch
perf-core-use-vma_is_initial_stack-and-vma_is_initial_heap.patch
mm-hugetlb-use-flush_hugetlb_tlb_range-in-move_hugetlb_page_tables.patch
arm64-hugetlb-enable-__have_arch_flush_hugetlb_tlb_range.patch
mm-memtest-convert-to-memtest_report_meminfo.patch

