From: akpm@linux-foundation.org
Subject: + drivers-watchdog-hpwdtc-mark-page-executable.patch added to -mm tree
Date: Tue, 20 Dec 2011 16:51:11 -0800
Message-ID: <20111221005112.821B65C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:43061 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab1LUAvO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2011 19:51:14 -0500
Received: by eekc1 with SMTP id c1so223212eek.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Dec 2011 16:51:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maxim.uvarov@oracle.com, wim@iguana.be


The patch titled
     Subject: drivers/watchdog/hpwdt.c: mark page executable
has been added to the -mm tree.  Its filename is
     drivers-watchdog-hpwdtc-mark-page-executable.patch

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
From: Maxim Uvarov <maxim.uvarov@oracle.com>
Subject: drivers/watchdog/hpwdt.c: mark page executable

Mark hpwdt watchdog pages executable to prevent failing:
BUG: unable to handle kernel paging request at c00f0000
 IP: [<c00f0000>] 0xc00effff
 *pdpt = 0000000000b7c001 *pde = 0000000000cf5067 *pte = 80000000000f0163
 Oops: 0011 [#1] SMP
 Modules linked in: hpwdt(+)(U) ipmi_si(U) ipmi_msghandler(U) serio_raw(U)
 pcspkr(U) k8temp(U) ext4(U) mbcache(U) jbd2(U) hpsa(U) cciss(U) lpfc(U)
 qla2xxx(U) scsi_transport_fc(U) scsi_tgt(U) radeon(U) ttm(U)
 drm_kms_helper(U) drm(U) hwmon(U) i2c_algo_bit(U) i2c_core(U) dm_mod(U)
 .
 Pid: 741, comm: modprobe Not tainted 2.6.39-100.0.15.el6uek.i686 #1 HP
 ProLiant BL685c G1
 EIP: 0060:[<c00f0000>] EFLAGS: 00010286 CPU: 1
 EIP is at 0xc00f0000
 EAX: 55524324 EBX: 00000000 ECX: 00000000 EDX: 00000000
 ESI: 00000000 EDI: 00000000 EBP: e892fda0 ESP: e892fd70
  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
 Process modprobe (pid: 741, ti=e892e000 task=e96d0da0 task.ti=e892e000)
 Stack:
  f902b020 00000060 0000007b 00000286 ffffffed c00f0000 e892fda0 e892fda0
  c00f0000 00000001 00000000 c00f0000 e892fdc4 f902b500 f902c0e0 c00f0000
  e892fdc4 c0439b6f c00ffee0 c0100000 c00f0000 e892fdf0 f902b627 ea276860
 Call Trace:
  [<f902b020>] ? asminline_call+0x20/0x50 [hpwdt]
  [<f902b500>] cru_detect+0x43/0xf6 [hpwdt]
  [<c0439b6f>] ? ioremap_nocache+0x1f/0x30
  [<f902b627>] hpwdt_init_nmi_decoding+0x74/0x16b [hpwdt]
  [<c085f469>] ? printk+0x1d/0x24
  [<f902b7f4>] hpwdt_init_one+0xd6/0x162 [hpwdt]
  [<c06d8475>] ? pm_runtime_enable+0x45/0x70
  [<c06149c7>] local_pci_probe+0x47/0xb0
  [<c0615978>] pci_device_probe+0x68/0x90
  [<c06d0aee>] really_probe+0x5e/0x210
  [<c06d9808>] ? pm_runtime_barrier+0x48/0xb0
  [<c06d0ce3>] driver_probe_device+0x43/0xa0
  [<c061494e>] ? pci_match_device+0x9e/0xb0
  [<c06d0dc1>] __driver_attach+0x81/0x90
  [<c06d0020>] bus_for_each_dev+0x50/0x70
  [<c06d08fe>] driver_attach+0x1e/0x20
  [<c06d0d40>] ? driver_probe_device+0xa0/0xa0
  [<c06d0397>] bus_add_driver+0x197/0x270
  [<c06157f0>] ? pci_dev_put+0x20/0x20
  [<c06d13ea>] driver_register+0x6a/0x130
  [<c0615ba5>] __pci_register_driver+0x45/0xb0
  [<f902e017>] hpwdt_init+0x17/0x19 [hpwdt]
  [<c0403035>] do_one_initcall+0x35/0x170
  [<f902e000>] ? 0xf902dfff
  [<c0491ac5>] sys_init_module+0x75/0x1c0
  [<c04ac8a6>] ? audit_syscall_exit+0x216/0x240
  [<c0868f9f>] sysenter_do_call+0x12/0x28
 Code: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  90 80 fc d8 75 0d e9 03 07 00 00 b8 04 00 00 02 05 00 00 9c
 EIP: [<c00f0000>] 0xc00f0000 SS:ESP 0068:e892fd70
 CR2: 00000000c00f0000

Signed-off-by: Maxim Uvarov <maxim.uvarov@oracle.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/hpwdt.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/watchdog/hpwdt.c~drivers-watchdog-hpwdtc-mark-page-executable drivers/watchdog/hpwdt.c
--- a/drivers/watchdog/hpwdt.c~drivers-watchdog-hpwdtc-mark-page-executable
+++ a/drivers/watchdog/hpwdt.c
@@ -335,6 +335,8 @@ static int __devinit detect_cru_service(
 	if (p == NULL)
 		return -ENOMEM;
 
+	set_memory_x((unsigned long)p & PAGE_MASK, ROM_SIZE >> PAGE_SHIFT);
+
 	for (q = p; q < p + ROM_SIZE; q += 16) {
 		rc = bios32_present(q);
 		if (!rc)
_
Subject: Subject: drivers/watchdog/hpwdt.c: mark page executable

Patches currently in -mm which might be from maxim.uvarov@oracle.com are

linux-next.patch
drivers-watchdog-hpwdtc-mark-page-executable.patch

