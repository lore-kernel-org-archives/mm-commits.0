From: akpm@linux-foundation.org
Subject: + eeepc-laptop-fix-oops-when-changing-backlight-brightness-during-eeepc-laptop-init.patch added to -mm tree
Date: Mon, 02 Feb 2009 15:10:45 -0800
Message-ID: <200902022310.n12NAk8d009253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751783AbZBBXMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 18:12:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@youmustbejoking.demon.co.uk, corentincj@iksaif.net, hpa@zytor.com, lenb@kernel.org, mingo@elte.hu, mjg@redhat.com, noodles@earth.li, stable@kernel.org, tglx@linutronix.de


The patch titled
     eeepc-laptop: fix oops when changing backlight brightness during eeepc-laptop init
has been added to the -mm tree.  Its filename is
     eeepc-laptop-fix-oops-when-changing-backlight-brightness-during-eeepc-laptop-init.patch

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
Subject: eeepc-laptop: fix oops when changing backlight brightness during eeepc-laptop init
From: Darren Salt <linux@youmustbejoking.demon.co.uk>

I got the following oops while changing the backlight brightness during
startup.  When it happens, it prevents use of the hotkeys, Fn-Fx, and the
lid button.

It's a clear use-before-init, as I verified by testing with an
appropriately-placed "else printk".

BUG: unable to handle kernel NULL pointer dereference at 00000000
*pde = 00000000
Oops: 0002 [#1] PREEMPT SMP
Pid: 160, comm: kacpi_notify Not tainted (2.6.28.1-eee901 #4) 901
EIP: 0060:[<c0264e68>]  [<c0264e68>] eeepc_hotk_notify+26/da
EFLAGS: 00010246 CPU: 1
Using defaults from ksymoops -t elf32-i386 -a i386
EAX: 00000009 EBX: 00000000 ECX: 00000009 EDX: f70dbf64
ESI: 00000029 EDI: f7335188 EBP: c02112c9 ESP: f70dbf80
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
 f70731e0 f73acd50 c02164ac f7335180 f70aa040 c02112e6 f733518c c012b62f
 f70aa044 f70aa040 c012bdba f70aa04c 00000000 c012be6e 00000000 f70bdf80
 c012e198 f70dbfc4 f70dbfc4 f70aa040 c012bdba 00000000 c012e0c9 c012e091
Call Trace:
 [<c02164ac>] ? acpi_ev_notify_dispatch+4c/55
 [<c02112e6>] ? acpi_os_execute_deferred+1d/25
 [<c012b62f>] ? run_workqueue+71/f1
 [<c012bdba>] ? worker_thread+0/bf
 [<c012be6e>] ? worker_thread+b4/bf
 [<c012e198>] ? autoremove_wake_function+0/2b
 [<c012bdba>] ? worker_thread+0/bf
 [<c012e0c9>] ? kthread+38/5f
 [<c012e091>] ? kthread+0/5f
 [<c0103abf>] ? kernel_thread_helper+7/10
Code: 00 00 00 00 c3 83 3d 60 5c 50 c0 00 56 89 d6 53 0f 84 c4 00 00 00 8d 42
e0 83 f8 0f 77 0f 8b 1d 68 5c 50 c0 89 d8 e8 a9 fa ff ff <89> 03 8b 1d 60 5c
50 c0 89 f2 83 e2 7f 0f b7 4c 53 10 8d 41 01

Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
Cc: Len Brown <lenb@kernel.org>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Jonathan McDowell <noodles@earth.li>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@kernel.org>		[2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/eeepc-laptop.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/platform/x86/eeepc-laptop.c~eeepc-laptop-fix-oops-when-changing-backlight-brightness-during-eeepc-laptop-init drivers/platform/x86/eeepc-laptop.c
--- a/drivers/platform/x86/eeepc-laptop.c~eeepc-laptop-fix-oops-when-changing-backlight-brightness-during-eeepc-laptop-init
+++ a/drivers/platform/x86/eeepc-laptop.c
@@ -515,7 +515,8 @@ static int eeepc_hotk_check(void)
 static void notify_brn(void)
 {
 	struct backlight_device *bd = eeepc_backlight_device;
-	bd->props.brightness = read_brightness(bd);
+	if (bd)
+		bd->props.brightness = read_brightness(bd);
 }
 
 static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
_

Patches currently in -mm which might be from linux@youmustbejoking.demon.co.uk are

eeepc-laptop-fix-oops-when-changing-backlight-brightness-during-eeepc-laptop-init.patch

