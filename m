Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF3A15A8;
	Fri,  1 Aug 2025 22:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754087632; cv=none; b=IhWRtF6aRKMz9dalRqSLQ2uZMWMKPQ9UYIus9o2P5J/zFOx77XKJS6LSSttqvN9JEfafrM6d4XoZMQmOgQvkc4Qx7+tJmRM7hibbVhTOCLXh/XfQVr7p+CxCFFL0mVZIPx2ciAyrW+w0ns560m/jUSOCqIEwU0FA8NxGfjv7+bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754087632; c=relaxed/simple;
	bh=XR2iOz+NKXihv2SS642evv9ShOJCP5XCWMsYDJkGAJc=;
	h=Date:To:From:Subject:Message-Id; b=W3cPheGm00zYr00izTHh2j//gFFl1qix+o0KeWRiOoGVlAC3VErv0Qblj/yJzgRrPJvepuFVibjbWH9b9lBlchbUoPCi8SEmfng2vHMiQ9yZ6LcdIrxJNLebIBKO0CDccwBE+gkyLSSBhyuuzL8HCFF3Yk3fbqi4i2ff5Ty7Z1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XZQ6Thjg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XZQ6Thjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A85EC4CEE7;
	Fri,  1 Aug 2025 22:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754087632;
	bh=XR2iOz+NKXihv2SS642evv9ShOJCP5XCWMsYDJkGAJc=;
	h=Date:To:From:Subject:From;
	b=XZQ6ThjgUiMwH7qZejUakDjymSkD6Xl08qlL9bKsnNZW5JxV2DeRdV6xWRnI9ONeO
	 5zfX1sijnK2WH4i+VsWFy5Oi2CftGr4TV5C5OsaK99DLIlVW9vMIrbI0SQ9MovFpM5
	 Ew0IooNyzhKlzDYjnERQWS1m4M9356UoGXsDXw3g=
Date: Fri, 01 Aug 2025 15:33:51 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,lujialin4@huawei.com,longman@redhat.com,leitao@debian.org,catalin.marinas@arm.com,gubowen5@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-possible-deadlock-in-console_trylock_spinning.patch added to mm-hotfixes-unstable branch
Message-Id: <20250801223352.3A85EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix possible deadlock in console_trylock_spinning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-possible-deadlock-in-console_trylock_spinning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-possible-deadlock-in-console_trylock_spinning.patch

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
From: Gu Bowen <gubowen5@huawei.com>
Subject: mm: fix possible deadlock in console_trylock_spinning
Date: Wed, 30 Jul 2025 17:49:14 +0800

kmemleak_scan_thread() invokes scan_block() which may invoke a nomal
printk() to print warning message.  This can cause a deadlock in the
scenario reported below:

       CPU0                    CPU1
       ----                    ----
  lock(kmemleak_lock);
                               lock(&port->lock);
                               lock(kmemleak_lock);
  lock(console_owner);

To solve this problem, switch to printk_safe mode before printing warning
message, this will redirect all printk()-s to a special per-CPU buffer,
which will be flushed later from a safe context (irq work), and this
deadlock problem can be avoided.

Our syztester report the following lockdep error:

======================================================
WARNING: possible circular locking dependency detected
5.10.0-22221-gca646a51dd00 #16 Not tainted
------------------------------------------------------
kmemleak/182 is trying to acquire lock:
ffffffffaf9e9020 (console_owner){-...}-{0:0}, at: console_trylock_spinning+0xda/0x1d0 kernel/printk/printk.c:1900

but task is already holding lock:
ffffffffb007cf58 (kmemleak_lock){-.-.}-{2:2}, at: scan_block+0x3d/0x220 mm/kmemleak.c:1310

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #3 (kmemleak_lock){-.-.}-{2:2}:
       validate_chain+0x5df/0xac0 kernel/locking/lockdep.c:3729
       __lock_acquire+0x514/0x940 kernel/locking/lockdep.c:4958
       lock_acquire+0x15a/0x3a0 kernel/locking/lockdep.c:5569
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x3b/0x60 kernel/locking/spinlock.c:164
       create_object.isra.0+0x36/0x80 mm/kmemleak.c:691
       kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
       slab_post_alloc_hook mm/slab.h:518 [inline]
       slab_alloc_node mm/slub.c:2987 [inline]
       slab_alloc mm/slub.c:2995 [inline]
       __kmalloc+0x637/0xb60 mm/slub.c:4100
       kmalloc include/linux/slab.h:620 [inline]
       tty_buffer_alloc+0x127/0x140 drivers/tty/tty_buffer.c:176
       __tty_buffer_request_room+0x9b/0x110 drivers/tty/tty_buffer.c:276
       tty_insert_flip_string_fixed_flag+0x60/0x130 drivers/tty/tty_buffer.c:321
       tty_insert_flip_string include/linux/tty_flip.h:36 [inline]
       tty_insert_flip_string_and_push_buffer+0x3a/0xb0 drivers/tty/tty_buffer.c:578
       process_output_block+0xc2/0x2e0 drivers/tty/n_tty.c:592
       n_tty_write+0x298/0x540 drivers/tty/n_tty.c:2433
       do_tty_write drivers/tty/tty_io.c:1041 [inline]
       file_tty_write.constprop.0+0x29b/0x4b0 drivers/tty/tty_io.c:1147
       redirected_tty_write+0x51/0x90 drivers/tty/tty_io.c:1176
       call_write_iter include/linux/fs.h:2117 [inline]
       do_iter_readv_writev+0x274/0x350 fs/read_write.c:741
       do_iter_write+0xbb/0x1f0 fs/read_write.c:867
       vfs_writev+0xfa/0x380 fs/read_write.c:940
       do_writev+0xd6/0x1d0 fs/read_write.c:983
       do_syscall_64+0x2b/0x40 arch/x86/entry/common.c:46
       entry_SYSCALL_64_after_hwframe+0x6c/0xd6

-> #2 (&port->lock){-.-.}-{2:2}:
       validate_chain+0x5df/0xac0 kernel/locking/lockdep.c:3729
       __lock_acquire+0x514/0x940 kernel/locking/lockdep.c:4958
       lock_acquire+0x15a/0x3a0 kernel/locking/lockdep.c:5569
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x3b/0x60 kernel/locking/spinlock.c:164
       tty_port_tty_get+0x1f/0xa0 drivers/tty/tty_port.c:289
       tty_port_default_wakeup+0xb/0x30 drivers/tty/tty_port.c:48
       serial8250_tx_chars+0x259/0x430 drivers/tty/serial/8250/8250_port.c:1906
       __start_tx drivers/tty/serial/8250/8250_port.c:1598 [inline]
       serial8250_start_tx+0x304/0x320 drivers/tty/serial/8250/8250_port.c:1720
       uart_write+0x1a1/0x2e0 drivers/tty/serial/serial_core.c:635
       do_output_char+0x2c0/0x370 drivers/tty/n_tty.c:444
       process_output drivers/tty/n_tty.c:511 [inline]
       n_tty_write+0x269/0x540 drivers/tty/n_tty.c:2445
       do_tty_write drivers/tty/tty_io.c:1041 [inline]
       file_tty_write.constprop.0+0x29b/0x4b0 drivers/tty/tty_io.c:1147
       call_write_iter include/linux/fs.h:2117 [inline]
       do_iter_readv_writev+0x274/0x350 fs/read_write.c:741
       do_iter_write+0xbb/0x1f0 fs/read_write.c:867
       vfs_writev+0xfa/0x380 fs/read_write.c:940
       do_writev+0xd6/0x1d0 fs/read_write.c:983
       do_syscall_64+0x2b/0x40 arch/x86/entry/common.c:46
       entry_SYSCALL_64_after_hwframe+0x6c/0xd6

-> #1 (&port_lock_key){-.-.}-{2:2}:
       validate_chain+0x5df/0xac0 kernel/locking/lockdep.c:3729
       __lock_acquire+0x514/0x940 kernel/locking/lockdep.c:4958
       lock_acquire+0x15a/0x3a0 kernel/locking/lockdep.c:5569
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0x3b/0x60 kernel/locking/spinlock.c:164
       serial8250_console_write+0x292/0x320 drivers/tty/serial/8250/8250_port.c:3458
       call_console_drivers.constprop.0+0x185/0x240 kernel/printk/printk.c:1988
       console_unlock+0x2b4/0x640 kernel/printk/printk.c:2648
       register_console.part.0+0x2a1/0x390 kernel/printk/printk.c:3024
       univ8250_console_init+0x24/0x2b drivers/tty/serial/8250/8250_core.c:724
       console_init+0x188/0x24b kernel/printk/printk.c:3134
       start_kernel+0x2b0/0x41e init/main.c:1072
       secondary_startup_64_no_verify+0xc3/0xcb

-> #0 (console_owner){-...}-{0:0}:
       check_prev_add+0xfa/0x1380 kernel/locking/lockdep.c:2988
       check_prevs_add+0x1d8/0x3c0 kernel/locking/lockdep.c:3113
       validate_chain+0x5df/0xac0 kernel/locking/lockdep.c:3729
       __lock_acquire+0x514/0x940 kernel/locking/lockdep.c:4958
       lock_acquire+0x15a/0x3a0 kernel/locking/lockdep.c:5569
       console_trylock_spinning+0x10d/0x1d0 kernel/printk/printk.c:1921
       vprintk_emit+0x1a5/0x270 kernel/printk/printk.c:2134
       printk+0xb2/0xe7 kernel/printk/printk.c:2183
       lookup_object.cold+0xf/0x24 mm/kmemleak.c:405
       scan_block+0x1fa/0x220 mm/kmemleak.c:1357
       scan_object+0xdd/0x140 mm/kmemleak.c:1415
       scan_gray_list+0x8f/0x1c0 mm/kmemleak.c:1453
       kmemleak_scan+0x649/0xf30 mm/kmemleak.c:1608
       kmemleak_scan_thread+0x94/0xb6 mm/kmemleak.c:1721
       kthread+0x1c4/0x210 kernel/kthread.c:328
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:299

other info that might help us debug this:

Chain exists of:
  console_owner --> &port->lock --> kmemleak_lock

Link: https://lkml.kernel.org/r/20250730094914.566582-1-gubowen5@huawei.com
Signed-off-by: Gu Bowen <gubowen5@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Lu Jialin <lujialin4@huawei.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: <stable@vger.kernel.org>	[5.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/kmemleak.c~mm-fix-possible-deadlock-in-console_trylock_spinning
+++ a/mm/kmemleak.c
@@ -437,9 +437,11 @@ static struct kmemleak_object *__lookup_
 		else if (untagged_objp == untagged_ptr || alias)
 			return object;
 		else {
+			__printk_safe_enter();
 			kmemleak_warn("Found object by alias at 0x%08lx\n",
 				      ptr);
 			dump_object_info(object);
+			__printk_safe_exit();
 			break;
 		}
 	}
_

Patches currently in -mm which might be from gubowen5@huawei.com are

mm-fix-possible-deadlock-in-console_trylock_spinning.patch

