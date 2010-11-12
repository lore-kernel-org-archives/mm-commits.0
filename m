From: akpm@linux-foundation.org
Subject: + leds-fix-bug-with-reading-nas-ss4200-dmi-code.patch added to -mm tree
Date: Thu, 11 Nov 2010 18:45:29 -0800
Message-ID: <201011120248.oAC2m3Un016864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754001Ab0KLCsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Nov 2010 21:48:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, arjan@linux.intel.com, dave@sr71.net, rpurdie@linux.intel.com, stable@kernel.org


The patch titled
     leds: fix bug with reading NAS SS4200 dmi code
has been added to the -mm tree.  Its filename is
     leds-fix-bug-with-reading-nas-ss4200-dmi-code.patch

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
Subject: leds: fix bug with reading NAS SS4200 dmi code
From: Steven Rostedt <rostedt@goodmis.org>

While running randconfg with ktest.pl I stumbled upon this bug:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000003
IP: [<ffffffff815fe44f>] strstr+0x39/0x86
PGD 0
Oops: 0000 [#1] SMP
last sysfs file:
CPU 0
Modules linked in:

Pid: 1, comm: swapper Not tainted 2.6.37-rc1-test+ #6 DG965MQ/
RIP: 0010:[<ffffffff815fe44f>]  [<ffffffff815fe44f>] strstr+0x39/0x86
RSP: 0018:ffff8800797cbd80  EFLAGS: 00010213
RAX: 0000000000000000 RBX: 0000000000000003 RCX: ffffffffffffffff
RDX: 0000000000000000 RSI: ffffffff82eb7ac9 RDI: 0000000000000003
RBP: ffff8800797cbda0 R08: ffff880000000003 R09: 0000000000030725
R10: ffff88007d294c00 R11: 0000000000014c00 R12: 0000000000000020
R13: ffffffff82eb7ac9 R14: ffffffffffffffff R15: ffffffff82eb7b08
FS:  0000000000000000(0000) GS:ffff88007d200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000003 CR3: 0000000002a1d000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff8800797ca000, task ffff8800797d0000)
Stack:
 00000000000000ba ffffffff82eb7ac9 ffffffff82eb7ab8 00000000000000ba
 ffff8800797cbdf0 ffffffff81e2050f ffff8800797cbdc0 00000000815f913b
 ffff8800797cbe00 ffffffff82eb7ab8 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff81e2050f>] dmi_matches+0x117/0x154
 [<ffffffff81e205d7>] dmi_check_system+0x3d/0x8d
 [<ffffffff82e1ad25>] ? nas_gpio_init+0x0/0x2c8
 [<ffffffff82e1ad49>] nas_gpio_init+0x24/0x2c8
 [<ffffffff820d750d>] ? wm8350_led_init+0x0/0x20
 [<ffffffff82e1ad25>] ? nas_gpio_init+0x0/0x2c8
 [<ffffffff810022f7>] do_one_initcall+0xab/0x1b2
 [<ffffffff82da749c>] kernel_init+0x248/0x331
 [<ffffffff8100e624>] kernel_thread_helper+0x4/0x10
 [<ffffffff82da7254>] ? kernel_init+0x0/0x331

Found that the nas_led_whitelist dmi_system_id structure array had no
NULL end delimiter, causing the dmi_check_system() loop to read an
undefined entry.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Richard Purdie <rpurdie@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-ss4200.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/leds/leds-ss4200.c~leds-fix-bug-with-reading-nas-ss4200-dmi-code drivers/leds/leds-ss4200.c
--- a/drivers/leds/leds-ss4200.c~leds-fix-bug-with-reading-nas-ss4200-dmi-code
+++ a/drivers/leds/leds-ss4200.c
@@ -102,6 +102,7 @@ static struct dmi_system_id __initdata n
 			DMI_MATCH(DMI_PRODUCT_VERSION, "1.00.00")
 		}
 	},
+	{}
 };
 
 /*
_

Patches currently in -mm which might be from rostedt@goodmis.org are

leds-fix-bug-with-reading-nas-ss4200-dmi-code.patch
linux-next.patch

