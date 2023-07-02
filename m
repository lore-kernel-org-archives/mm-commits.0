Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C33EB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 19:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjGBTDB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 15:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjGBTCx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 15:02:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475DEB2
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 12:02:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D193260C81
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 19:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220F5C433C9;
        Sun,  2 Jul 2023 19:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688324571;
        bh=1wM1LPAWlrgZ998xANXjvcHVdK7b/IlzWkF04GOZWX0=;
        h=Date:To:From:Subject:From;
        b=IPwC1ewf0yea4fMP4ilw9gjovUqocllW/3EpqoVz9J63xP5wglRAcohy8ItqFI1rI
         8Ci4qVZI/T0LmV12fa3ei2Gxy/AOXfnz2zNh387HXz9IC9cEvoDRk99tUiIpB8jGHX
         /4TIbsoDyK7Yd7iqrB1Vv9UbO7OqIhb9DJV7ALng=
Date:   Sun, 02 Jul 2023 12:02:50 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, npiggin@gmail.com,
        mpe@ellerman.id.au, gregkh@linuxfoundation.org,
        christophe.leroy@csgroup.eu, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-arguments-of-show_mem.patch added to mm-unstable branch
Message-Id: <20230702190251.220F5C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove arguments of show_mem()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-arguments-of-show_mem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-arguments-of-show_mem.patch

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
@@ -3085,9 +3085,9 @@ extern void mem_init(void);
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

mm-remove-arguments-of-show_mem.patch
mm-make-show_free_areas-static.patch

