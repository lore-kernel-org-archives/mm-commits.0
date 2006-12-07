From: akpm@osdl.org
Subject: - skip-data-conversion-in-compat_sys_mount-when-data_page-is-null.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:55:49 -0800
Message-ID: <200612072255.kB7MtnLr029145@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50296 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163582AbWLGW4Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:56:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amirkin@openvz.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     skip data conversion in compat_sys_mount when data_page is NULL
has been removed from the -mm tree.  Its filename was
     skip-data-conversion-in-compat_sys_mount-when-data_page-is-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: skip data conversion in compat_sys_mount when data_page is NULL
From: Andrey Mirkin <amirkin@openvz.org>

OpenVZ Linux kernel team has found a problem with mounting in compat mode.

Simple command "mount -t smbfs ..." on Fedora Core 5 distro in 32-bit mode
leads to oops:

Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
[<ffffffff802bc7c6>] compat_sys_mount+0xd6/0x290
PGD 34d48067 PUD 34d03067 PMD 0
Oops: 0000 [1] SMP
CPU: 0
Modules linked in: iptable_nat simfs smbfs ip_nat ip_conntrack vzdquota
parport_pc lp parport 8021q bridge llc vznetdev vzmon nfs lockd sunrpc vzdev
iptable_filter af_packet xt_length ipt_ttl xt_tcpmss ipt_TCPMSS
iptable_mangle xt_limit ipt_tos ipt_REJECT ip_tables x_tables thermal
processor fan button battery asus_acpi ac uhci_hcd ehci_hcd usbcore i2c_i801
i2c_core e100 mii floppy ide_cd cdrom
Pid: 14656, comm: mount
RIP: 0060:[<ffffffff802bc7c6>]  [<ffffffff802bc7c6>]
compat_sys_mount+0xd6/0x290
RSP: 0000:ffff810034d31f38  EFLAGS: 00010292
RAX: 000000000000002c RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff810034c86bc0 RSI: 0000000000000096 RDI: ffffffff8061fc90
RBP: ffff810034d31f78 R08: 0000000000000000 R09: 000000000000000d
R10: ffff810034d31e58 R11: 0000000000000001 R12: ffff810039dc3000
R13: 000000000805ea48 R14: 0000000000000000 R15: 00000000c0ed0000
FS:  0000000000000000(0000) GS:ffffffff80749000(0033) knlGS:00000000b7d556b0
CS:  0060 DS: 007b ES: 007b CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000034d43000 CR4: 00000000000006e0
Process mount (pid: 14656, veid=300, threadinfo ffff810034d30000, task
ffff810034c86bc0)
Stack:  0000000000000000 ffff810034dd0000 ffff810034e4a000 000000000805ea48
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
 000000000805ea48 ffffffff8021e64e 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff8021e64e>] ia32_sysret+0x0/0xa

Code: 83 3b 06 0f 85 41 01 00 00 0f b7 43 0c 89 43 14 0f b7 43 0a
RIP  [<ffffffff802bc7c6>] compat_sys_mount+0xd6/0x290
 RSP <ffff810034d31f38>
CR2: 0000000000000000

The problem is that data_page pointer can be NULL, so we should skip data
conversion in this case.

Signed-off-by: Andrey Mirkin <amirkin@openvz.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/compat.c~skip-data-conversion-in-compat_sys_mount-when-data_page-is-null fs/compat.c
--- a/fs/compat.c~skip-data-conversion-in-compat_sys_mount-when-data_page-is-null
+++ a/fs/compat.c
@@ -871,7 +871,7 @@ asmlinkage long compat_sys_mount(char __
 
 	retval = -EINVAL;
 
-	if (type_page) {
+	if (type_page && data_page) {
 		if (!strcmp((char *)type_page, SMBFS_NAME)) {
 			do_smb_super_data_conv((void *)data_page);
 		} else if (!strcmp((char *)type_page, NCPFS_NAME)) {
_

Patches currently in -mm which might be from amirkin@openvz.org are

origin.patch

