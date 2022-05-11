Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78432C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 11 May 2022 18:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245463AbiEKSbB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 May 2022 14:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346268AbiEKSbA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 May 2022 14:31:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB7D205C8
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 11:30:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E452161DED
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 18:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B87C340EE;
        Wed, 11 May 2022 18:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652293856;
        bh=lPpsH0thlvN4acPmwapP4IFcJ4WNDEl4wdPPgag9EK4=;
        h=Date:To:From:Subject:From;
        b=wb131sRybdrC6R4hAbFwm4JFZS+3/z0T1qT3ldaaCDKmId73yRq/SLxd5MZAnz8Uv
         zjCMfzje3gtJvcBacoxWkufSeFY8fgqb02bNC13Eu3q80H4qh7sJ5+ElyNFeqcIkMV
         CIXKO/qrSSBu11pgnjcKtJet01n/jVIq0kcRgzNQ=
Date:   Wed, 11 May 2022 11:30:55 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rostedt@goodmis.org,
        jirislaby@kernel.org, gregkh@linuxfoundation.org,
        akinobu.mita@gmail.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tty-fix-deadlock-caused-by-calling-printk-under-tty_port-lock.patch added to mm-nonmm-unstable branch
Message-Id: <20220511183056.44B87C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tty: fix deadlock caused by calling printk() under tty_port->lock
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tty-fix-deadlock-caused-by-calling-printk-under-tty_port-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tty-fix-deadlock-caused-by-calling-printk-under-tty_port-lock.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: tty: fix deadlock caused by calling printk() under tty_port->lock

pty_write() invokes kmalloc() which may invoke a normal printk() to print
failure message.  This can cause a deadlock in the scenario reported by
syz-bot below:

       CPU0              CPU1                    CPU2
       ----              ----                    ----
                         lock(console_owner);
                                                 lock(&port_lock_key);
  lock(&port->lock);
                         lock(&port_lock_key);
                                                 lock(&port->lock);
  lock(console_owner);

As commit dbdda842fe96 ("printk: Add console owner and waiter logic to
load balance console writes") said, such deadlock can be prevented by
using printk_deferred() in kmalloc() (which is invoked in the section
guarded by the port->lock).  But there are too many printk() on the
kmalloc() path, and kmalloc() can be called from anywhere, so changing
printk() to printk_deferred() is too complicated and inelegant.

Therefore, this patch chooses to specify __GFP_NOWARN to kmalloc(), so
that printk() will not be called, and this deadlock problem can be
avoided.

Syzbot reported the following lockdep error:

======================================================
WARNING: possible circular locking dependency detected
5.4.143-00237-g08ccc19a-dirty #10 Not tainted
------------------------------------------------------
syz-executor.4/29420 is trying to acquire lock:
ffffffff8aedb2a0 (console_owner){....}-{0:0}, at: console_trylock_spinning kernel/printk/printk.c:1752 [inline]
ffffffff8aedb2a0 (console_owner){....}-{0:0}, at: vprintk_emit+0x2ca/0x470 kernel/printk/printk.c:2023

but task is already holding lock:
ffff8880119c9158 (&port->lock){-.-.}-{2:2}, at: pty_write+0xf4/0x1f0 drivers/tty/pty.c:120

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (&port->lock){-.-.}-{2:2}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x35/0x50 kernel/locking/spinlock.c:159
       tty_port_tty_get drivers/tty/tty_port.c:288 [inline]          		<-- lock(&port->lock);
       tty_port_default_wakeup+0x1d/0xb0 drivers/tty/tty_port.c:47
       serial8250_tx_chars+0x530/0xa80 drivers/tty/serial/8250/8250_port.c:1767
       serial8250_handle_irq.part.0+0x31f/0x3d0 drivers/tty/serial/8250/8250_port.c:1854
       serial8250_handle_irq drivers/tty/serial/8250/8250_port.c:1827 [inline] 	<-- lock(&port_lock_key);
       serial8250_default_handle_irq+0xb2/0x220 drivers/tty/serial/8250/8250_port.c:1870
       serial8250_interrupt+0xfd/0x200 drivers/tty/serial/8250/8250_core.c:126
       __handle_irq_event_percpu+0x109/0xa50 kernel/irq/handle.c:156
       [...]

-> #1 (&port_lock_key){-.-.}-{2:2}:
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x35/0x50 kernel/locking/spinlock.c:159
       serial8250_console_write+0x184/0xa40 drivers/tty/serial/8250/8250_port.c:3198
										<-- lock(&port_lock_key);
       call_console_drivers kernel/printk/printk.c:1819 [inline]
       console_unlock+0x8cb/0xd00 kernel/printk/printk.c:2504
       vprintk_emit+0x1b5/0x470 kernel/printk/printk.c:2024			<-- lock(console_owner);
       vprintk_func+0x8d/0x250 kernel/printk/printk_safe.c:394
       printk+0xba/0xed kernel/printk/printk.c:2084
       register_console+0x8b3/0xc10 kernel/printk/printk.c:2829
       univ8250_console_init+0x3a/0x46 drivers/tty/serial/8250/8250_core.c:681
       console_init+0x49d/0x6d3 kernel/printk/printk.c:2915
       start_kernel+0x5e9/0x879 init/main.c:713
       secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:241

-> #0 (console_owner){....}-{0:0}:
       [...]
       lock_acquire+0x127/0x340 kernel/locking/lockdep.c:4734
       console_trylock_spinning kernel/printk/printk.c:1773 [inline]		<-- lock(console_owner);
       vprintk_emit+0x307/0x470 kernel/printk/printk.c:2023
       vprintk_func+0x8d/0x250 kernel/printk/printk_safe.c:394
       printk+0xba/0xed kernel/printk/printk.c:2084
       fail_dump lib/fault-inject.c:45 [inline]
       should_fail+0x67b/0x7c0 lib/fault-inject.c:144
       __should_failslab+0x152/0x1c0 mm/failslab.c:33
       should_failslab+0x5/0x10 mm/slab_common.c:1224
       slab_pre_alloc_hook mm/slab.h:468 [inline]
       slab_alloc_node mm/slub.c:2723 [inline]
       slab_alloc mm/slub.c:2807 [inline]
       __kmalloc+0x72/0x300 mm/slub.c:3871
       kmalloc include/linux/slab.h:582 [inline]
       tty_buffer_alloc+0x23f/0x2a0 drivers/tty/tty_buffer.c:175
       __tty_buffer_request_room+0x156/0x2a0 drivers/tty/tty_buffer.c:273
       tty_insert_flip_string_fixed_flag+0x93/0x250 drivers/tty/tty_buffer.c:318
       tty_insert_flip_string include/linux/tty_flip.h:37 [inline]
       pty_write+0x126/0x1f0 drivers/tty/pty.c:122				<-- lock(&port->lock);
       n_tty_write+0xa7a/0xfc0 drivers/tty/n_tty.c:2356
       do_tty_write drivers/tty/tty_io.c:961 [inline]
       tty_write+0x512/0x930 drivers/tty/tty_io.c:1045
       __vfs_write+0x76/0x100 fs/read_write.c:494
       [...]

other info that might help us debug this:

Chain exists of:
  console_owner --> &port_lock_key --> &port->lock

Link: https://lkml.kernel.org/r/20220511061951.1114-2-zhengqi.arch@bytedance.com
Link: https://lkml.kernel.org/r/20220510113809.80626-2-zhengqi.arch@bytedance.com
Fixes: b6da31b2c07c ("tty: Fix data race in tty_insert_flip_string_fixed_flag")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Jiri Slaby <jirislaby@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/tty_buffer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/tty_buffer.c~tty-fix-deadlock-caused-by-calling-printk-under-tty_port-lock
+++ a/drivers/tty/tty_buffer.c
@@ -175,7 +175,8 @@ static struct tty_buffer *tty_buffer_all
 	 */
 	if (atomic_read(&port->buf.mem_used) > port->buf.mem_limit)
 		return NULL;
-	p = kmalloc(sizeof(struct tty_buffer) + 2 * size, GFP_ATOMIC);
+	p = kmalloc(sizeof(struct tty_buffer) + 2 * size,
+		    GFP_ATOMIC | __GFP_NOWARN);
 	if (p == NULL)
 		return NULL;
 
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-fix-missing-handler-for-__gfp_nowarn.patch
mm-fix-missing-handler-for-__gfp_nowarn-v2.patch
tty-fix-deadlock-caused-by-calling-printk-under-tty_port-lock.patch
tty-fix-deadlock-caused-by-calling-printk-under-tty_port-lock-v2.patch

