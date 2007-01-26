From: akpm@osdl.org
Subject: - oops-in-drivers-net-shaperc.patch removed from -mm tree
Date: Thu, 25 Jan 2007 19:50:25 -0800
Message-ID: <200701260350.l0Q3oPD6006731@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43877 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030199AbXAZDur (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 22:50:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deweerdt@free.fr, davem@davemloft.net, frederik.deweerdt@gmail.com, shemminger@osdl.org, mm-commits@vger.kernel.org


The patch titled
     oops in drivers/net/shaper.c
has been removed from the -mm tree.  Its filename was
     oops-in-drivers-net-shaperc.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: oops in drivers/net/shaper.c
From: Frederik Deweerdt <deweerdt@free.fr>

Hi,

The following code:
[...]
	s = socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL));

	socket_address.sll_family = PF_PACKET;
	socket_address.sll_protocol = htons(ETH_P_IP);

	/*
	 * this happens to be shaper0 on my system
	 */
=>	socket_address.sll_ifindex = 2;

	socket_address.sll_hatype = ARPHRD_ETHER;
	socket_address.sll_pkttype = PACKET_OTHERHOST;

	socket_address.sll_halen = ETH_ALEN;
	socket_address.sll_addr[0] = 0x00;
	socket_address.sll_addr[1] = 0x04;
	socket_address.sll_addr[2] = 0x75;
	socket_address.sll_addr[3] = 0xC8;
	socket_address.sll_addr[4] = 0x28;
	socket_address.sll_addr[5] = 0xE5;
	socket_address.sll_addr[6] = 0x00;
	socket_address.sll_addr[7] = 0x00;

	memcpy((void *) buffer, (void *) dest_mac, ETH_ALEN);
	memcpy((void *) (buffer + ETH_ALEN), (void *) src_mac, ETH_ALEN);
	eh->h_proto = 0x00;

	for (j = 0; j < 1500; j++) {
		data[j] =
		    (unsigned
		     char) ((int) (255.0 * rand() / (RAND_MAX + 1.0)));
	}

	/*
	 * Oopses here
	 */
=>	send_result = sendto(s, buffer, 1499, 0,
			     (struct sockaddr *) &socket_address,
			     sizeof(socket_address));

[...]

Causes the following oops:

[   66.355049] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
[   66.355053]  printing eip:
[   66.355055] 00000000
[   66.355056] *pde = 00000000
[   66.355059] Oops: 0000 [#1]
[   66.355061] PREEMPT SMP DEBUG_PAGEALLOC
[   66.355065] last sysfs file: /devices/pci0000:00/0000:00:1e.2/modalias
[   66.355069] Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device af_packet ohci_hcd fuse cpufreq_stats cpufreq_powersave cpufreq_ondemand cpufreq_conservative speedstep_centrino freq_table processor ac battery i915 drm usb_storage parport_pc parport sr_mod serio_raw yenta_socket rsrc_nonstatic pcmcia_core ipw2200 tg3 snd_intel8x0 snd_ac97_codec pcspkr ac97_bus snd_pcm ehci_hcd snd_timer snd soundcore snd_page_alloc uhci_hcd usbcore shpchp pci_hotplug joydev evdev tsdev
[   66.355115] CPU:    0
[   66.355116] EIP:    0060:[<00000000>]    Not tainted VLI
[   66.355117] EFLAGS: 00210282   (2.6.20-rc4-mm1-def01 #2)
[   66.355122] EIP is at 0x0
[   66.355124] eax: f6a1f480   ebx: f705a500   ecx: 00000800   edx: 00000000
[   66.355128] esi: f6a1f480   edi: 00000800   ebp: f6261d90   esp: f6261d70
[   66.355131] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[   66.355134] Process aze (pid: 11005, ti=f6260000 task=f62d08b0 task.ti=f6260000)
[   66.355136] Stack: c0294465 f6261ec0 00000000 000005db f705a000 f6261f34 f6316380 f705a000
[   66.355145]        f6261dc4 f8adaf03 f6261ec0 00000000 000005db f6b1b400 f6a1f480 00080e38
[   66.355153]        f6261ec0 ffffffea f8adc1e0 000005db f6316380 f6261eac c030e1c5 000005db
[   66.355161] Call Trace:
[   66.355163]  [<c0105265>] show_trace_log_lvl+0x1a/0x30
[   66.355171]  [<c0105324>] show_stack_log_lvl+0xa9/0xd5
[   66.355176]  [<c0105549>] show_registers+0x1f9/0x362
[   66.355180]  [<c01057de>] die+0x12c/0x261
[   66.355184]  [<c039864f>] do_page_fault+0x2ef/0x5d0
[   66.355188]  [<c0396c74>] error_code+0x7c/0x84
[   66.355192]  [<f8adaf03>] packet_sendmsg+0x147/0x201 [af_packet]
[   66.355199]  [<c030e1c5>] sock_sendmsg+0xf9/0x116
[   66.355204]  [<c030eb54>] sys_sendto+0xbf/0xe0
[   66.355208]  [<c030f494>] sys_socketcall+0x1aa/0x277
[   66.355212]  [<c01041ea>] sysenter_past_esp+0x5f/0x99
[   66.355216]  =======================
[   66.355218] Code:  Bad EIP value.
[   66.355223] EIP: [<00000000>] 0x0 SS:ESP 0068:f6261d70

shaper_header() should check for shaper->dev not being NULL (ie. the
shaper was actually attached) as in the following patch.
This happens in mainline too (tested 2.6.19.2).

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Stephen Hemminger <shemminger@osdl.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/shaper.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/net/shaper.c~oops-in-drivers-net-shaperc drivers/net/shaper.c
--- a/drivers/net/shaper.c~oops-in-drivers-net-shaperc
+++ a/drivers/net/shaper.c
@@ -340,6 +340,10 @@ static int shaper_header(struct sk_buff 
 {
 	struct shaper *sh=dev->priv;
 	int v;
+
+	if (sh->dev == NULL)
+		return -ENODEV;
+
 	if(sh_debug)
 		printk("Shaper header\n");
 	skb->dev=sh->dev;
_

Patches currently in -mm which might be from deweerdt@free.fr are

git-acpi-early-acpi-lockup.patch
remove-tcp-header-from-tcp_v4_check-take-2.patch
oops-in-drivers-net-shaperc.patch
disable-init-initramfsc-updated-fix.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-user-ns-unshare.patch
reiser4-sb_sync_inodes-fix.patch
