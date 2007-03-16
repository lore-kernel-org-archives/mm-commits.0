From: akpm@linux-foundation.org
Subject: + initialise-sak-member-for-each-virtual-console-to-prevent-oops.patch added to -mm tree
Date: Thu, 15 Mar 2007 17:58:48 -0800
Message-ID: <200703160158.l2G1wmHS032464@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48915 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbXCPCAH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 22:00:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ebiederm@xmission.com, stable@kernel.org


The patch titled
     Initialise SAK member for each virtual console to prevent oops
has been added to the -mm tree.  Its filename is
     initialise-sak-member-for-each-virtual-console-to-prevent-oops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Initialise SAK member for each virtual console to prevent oops
From: Bernhard Walle <bwalle@suse.de>

Initialise the SAK member of the vc_cons variable on all virtual terminals,
not only the first one.  This prevents an oops when trying Sysrq-C on e.g. 
the second virtual terminal:

  kernel BUG at kernel/workqueue.c:212!
  invalid opcode: 0000 [1] SMP
  CPU 0
  Modules linked in: i915 drm deflate zlib_deflate twofish twofish_common serpent blowfish des ce
  Pid: 0, comm: swapper Not tainted 2.6.21-rc3-default #15
  RIP: 0010:[<ffffffff8028c955>]  [<ffffffff8028c955>] queue_work+0x32/0x51
  RSP: 0018:ffffffff805fada8  EFLAGS: 00010013
  RAX: ffffffff80683f38 RBX: ffffffff804ae700 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: ffffffff80683f30 RDI: ffff81000134a840
  RBP: 0000000000000001 R08: 0000000000000005 R09: 0000000000000002
  R10: ffffffff805990e0 R11: ffff810037f4c0f0 R12: 000000000000006b
  R13: ffff81007aa23000 R14: 0000000000000001 R15: 0000000000000096
  FS:  0000000000000000(0000) GS:ffffffff804d8000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
  CR2: 00002b72026e9000 CR3: 0000000079175000 CR4: 00000000000006e0
  Process swapper (pid: 0, threadinfo ffffffff8059e000, task ffffffff80490840)
  Stack:  0000000000000096 ffffffff803635db ffffffff805fadf8 0000000000000001
   ffff8100013c2e40 0000000000000025 ffff81007c931c00 ffff81007aa23000
   0000000000000001 ffffffff8035e3ee 0000000000000092 ffff810037cc8000
  Call Trace:
   <IRQ>  [<ffffffff803635db>] __handle_sysrq+0x98/0x129
   [<ffffffff8035e3ee>] kbd_event+0x32e/0x56a
   [<ffffffff8037d502>] input_event+0x422/0x44a
   [<ffffffff80381d71>] atkbd_interrupt+0x449/0x503
   [<ffffffff8037a42d>] serio_interrupt+0x37/0x6f
   [<ffffffff8037affb>] i8042_interrupt+0x1f4/0x20a
   [<ffffffff8026bd20>] smp_send_timer_broadcast_ipi+0x2d/0x4e
   [<ffffffff8020eee5>] handle_IRQ_event+0x25/0x53
   [<ffffffff802a924c>] handle_edge_irq+0xe4/0x128
   [<ffffffff802562ac>] call_softirq+0x1c/0x28
   [<ffffffff802632eb>] do_IRQ+0x6c/0xd3
   [<ffffffff8024f4e7>] mwait_idle+0x0/0x45
   [<ffffffff80255631>] ret_from_intr+0x0/0xa
   <EOI>  [<ffffffff80248a4d>] datagram_poll+0x0/0xc8
   [<ffffffff8024f529>] mwait_idle+0x42/0x45
   [<ffffffff80242c05>] cpu_idle+0x8b/0xae
   [<ffffffff805a8779>] start_kernel+0x2b9/0x2c5
   [<ffffffff805a815e>] _sinittext+0x15e/0x162

  Code: 0f 0b eb fe 48 8b 07 48 63 d2 48 f7 d0 48 8b 3c d0 e8 13 ff
  RIP  [<ffffffff8028c955>] queue_work+0x32/0x51
   RSP <ffffffff805fada8>
  Kernel panic - not syncing: Aiee, killing interrupt handler!

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Acked-by: Eric Biederman <ebiederm@xmission.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/vt.c~initialise-sak-member-for-each-virtual-console-to-prevent-oops drivers/char/vt.c
--- a/drivers/char/vt.c~initialise-sak-member-for-each-virtual-console-to-prevent-oops
+++ a/drivers/char/vt.c
@@ -724,6 +724,7 @@ int vc_allocate(unsigned int currcons)	/
 		return -ENOMEM;
 	    memset(vc, 0, sizeof(*vc));
 	    vc_cons[currcons].d = vc;
+	    INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 	    visual_init(vc, currcons, 1);
 	    if (!*vc->vc_uni_pagedir_loc)
 		con_set_default_unimap(vc);
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
initialise-sak-member-for-each-virtual-console-to-prevent-oops.patch
git-r8169.patch
fix-wrong-proc-iomem-on-sgi-altix.patch
ia64-platform_kernel_launch_event-is-noop-on-generic-kernel.patch
