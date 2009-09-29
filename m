From: akpm@linux-foundation.org
Subject: + hid-core-fix-lockdep-in-hid_input_report-v2.patch added to -mm tree
Date: Tue, 29 Sep 2009 15:03:48 -0700
Message-ID: <200909292203.n8TM3mAp015862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751977AbZI2WEV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 18:04:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, jirislaby@gmail.com, jkosina@suse.cz


The patch titled
     hid-core: fix lockdep in hid_input_report()
has been added to the -mm tree.  Its filename is
     hid-core-fix-lockdep-in-hid_input_report-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hid-core: fix lockdep in hid_input_report()
From: Krzysztof Helt <krzysztof.h1@wp.pl>

There is a lockdep warning in the hid_input_report() due to
kmalloc(.,GFP_KERNEL) allocation of a temporary buffer.  Change
hid_input_report() call inside the hid_ctrl() after Jiri Slaby's advice. 
This converts kmalloc() call into kmalloc(.,GFP_ATOMIC).

The lockdep trace is:

WARNING: at kernel/lockdep.c:2457 lockdep_trace_alloc+0xca/0xd0()
Hardware name: Product Name
Modules linked in: usbhid(+) hid uhci_hcd ne2k_pci via_agp 8390 i2c_via
Pid: 0, comm: swapper Not tainted 2.6.31 #74
Call Trace:
 [<c0243b8a>] ? lockdep_trace_alloc+0xca/0xd0
 [<c0221d1c>] warn_slowpath_common+0x7c/0xa0
 [<c0243b8a>] ? lockdep_trace_alloc+0xca/0xd0
 [<c0221d55>] warn_slowpath_null+0x15/0x20
 [<c0243b8a>] lockdep_trace_alloc+0xca/0xd0
 [<c027d2c8>] kmem_cache_alloc+0x28/0x100
 [<cc9359ef>] ? hid_input_report+0x6f/0x220 [hid]
 [<cc9359ef>] hid_input_report+0x6f/0x220 [hid]
 [<cc94cabf>] hid_ctrl+0x7f/0x180 [usbhid]
 [<c03b28b1>] usb_hcd_giveback_urb+0x41/0xa0
 [<cc91a3fc>] uhci_giveback_urb+0x8c/0x280 [uhci_hcd]
 [<c0279853>] ? dma_pool_free+0xd3/0x120
 [<cc919848>] ? uhci_free_td+0x58/0xa0 [uhci_hcd]
 [<cc91ac01>] uhci_scan_schedule+0x301/0x910 [uhci_hcd]
 [<cc91cac4>] uhci_irq+0x94/0x940 [uhci_hcd]
 [<c0245c43>] ? __lock_acquire+0x433/0xab0
 [<c0206246>] ? mask_and_ack_8259A+0x66/0x100
 [<c03b494b>] usb_hcd_irq+0x6b/0x90
 [<c0255e7d>] handle_IRQ_event+0x2d/0xc0
 [<c0257e85>] handle_level_irq+0x65/0xe0
 [<c0204c74>] handle_irq+0x34/0x60
 [<c0204bc9>] do_IRQ+0x39/0xb0
 [<c024365c>] ? trace_hardirqs_on_caller+0x12c/0x180
 [<c020328e>] common_interrupt+0x2e/0x40
 [<c0208d48>] ? default_idle+0x38/0x50
 [<c02108df>] apm_cpu_idle+0x10f/0x290
 [<c0201b11>] cpu_idle+0x21/0x40
 [<c045892d>] rest_init+0x4d/0x60
 [<c0575815>] start_kernel+0x235/0x280
 [<c05751f0>] ? unknown_bootoption+0x0/0x210
 [<c057503f>] __init_begin+0x3f/0x50

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/usbhid/hid-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hid/usbhid/hid-core.c~hid-core-fix-lockdep-in-hid_input_report-v2 drivers/hid/usbhid/hid-core.c
--- a/drivers/hid/usbhid/hid-core.c~hid-core-fix-lockdep-in-hid_input_report-v2
+++ a/drivers/hid/usbhid/hid-core.c
@@ -455,7 +455,7 @@ static void hid_ctrl(struct urb *urb)
 		if (usbhid->ctrl[usbhid->ctrltail].dir == USB_DIR_IN)
 			hid_input_report(urb->context,
 				usbhid->ctrl[usbhid->ctrltail].report->type,
-				urb->transfer_buffer, urb->actual_length, 0);
+				urb->transfer_buffer, urb->actual_length, 1);
 		break;
 	case -ESHUTDOWN:	/* unplug */
 		unplug = 1;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

linux-next.patch
hid-core-fix-lockdep-in-hid_input_report-v2.patch
intelfb-fix-setting-of-active-pipe-with-lvds-displays.patch

