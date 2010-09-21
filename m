From: akpm@linux-foundation.org
Subject: + ipmi-fix-hardcoded-ipmi-device-exit-path-warning.patch added to -mm tree
Date: Tue, 21 Sep 2010 14:15:35 -0700
Message-ID: <201009212115.o8LLFZ1R001993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981Ab0IUVQJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 17:16:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, minyard@acm.org


The patch titled
     ipmi: fix hardcoded ipmi device exit path warning
has been added to the -mm tree.  Its filename is
     ipmi-fix-hardcoded-ipmi-device-exit-path-warning.patch

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
Subject: ipmi: fix hardcoded ipmi device exit path warning
From: Yinghai Lu <yinghai@kernel.org>

When modprobe.conf has
options ipmi_si type="kcs" ports=0xCA2 regspacings="4"

ipmi_si can be loaded properly, but when try to unload it get:

Sep 20 15:00:27 xx abrt: Kerneloops: Reported 1 kernel oopses to Abrt
Sep 20 15:00:27 xx abrtd: Directory 'kerneloops-1285020027-1' creation detected
Sep 20 15:00:27 xx abrtd: New crash /var/spool/abrt/kerneloops-1285020027-1, processing
Sep 20 15:01:09 xx kernel: ------------[ cut here ]------------
Sep 20 15:01:09 xx kernel: WARNING: at drivers/base/driver.c:262 driver_unregister+0x8a/0xa0()
Sep 20 15:01:09 xx kernel: Hardware name: Sun Fire x4800
Sep 20 15:01:09 xx kernel: Unexpected driver unregister!
Sep 20 15:01:09 xx kernel: Modules linked in: ipmi_si(-) ipmi_msghandler ip6table_filter ip6_tables ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat bridge stp llc autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf xt_physdev be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb3i iw_cxgb3 cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi dm_mirror dm_region_hash dm_log dm_mod vhost_net macvtap macvlan tun kvm_intel kvm uinput sg ses enclosure ahci libahci pcspkr i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support igb dca i7core_edac edac_core ext3 jbd mbcache sd_mod crc_t10dif megaraid_sas [last unloaded: ipmi_devintf]
Sep 20 15:01:09 xx kernel: Pid: 10625, comm: modprobe Tainted: G        W   2.6.36-rc5-tip+ #6
Sep 20 15:01:09 xx kernel: Call Trace:
Sep 20 15:01:09 xx kernel: [<ffffffff810600df>] warn_slowpath_common+0x7f/0xc0
Sep 20 15:01:09 xx kernel: [<ffffffff810601d6>] warn_slowpath_fmt+0x46/0x50
Sep 20 15:01:09 xx kernel: [<ffffffff812ff60a>] driver_unregister+0x8a/0xa0
Sep 20 15:01:09 xx kernel: [<ffffffff812ae112>] pnp_unregister_driver+0x12/0x20
Sep 20 15:01:09 xx kernel: [<ffffffffa01d0327>] cleanup_ipmi_si+0x3c/0xa7 [ipmi_si]
Sep 20 15:01:09 xx kernel: [<ffffffff81099a60>] sys_delete_module+0x1a0/0x270
Sep 20 15:01:09 xx kernel: [<ffffffff814b7070>] ? do_page_fault+0x150/0x320
Sep 20 15:01:09 xx kernel: [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
Sep 20 15:01:09 xx kernel: ---[ end trace 0d1967161adcee0d ]---

We need to check if ipmi_pnp_driver is loaded before we try to unload it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-hardcoded-ipmi-device-exit-path-warning drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-hardcoded-ipmi-device-exit-path-warning
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -305,6 +305,9 @@ static int num_force_kipmid;
 #ifdef CONFIG_PCI
 static int pci_registered;
 #endif
+#ifdef CONFIG_ACPI
+static int pnp_registered;
+#endif
 #ifdef CONFIG_PPC_OF
 static int of_registered;
 #endif
@@ -3359,6 +3362,7 @@ static __devinit int init_ipmi_si(void)
 
 #ifdef CONFIG_ACPI
 	pnp_register_driver(&ipmi_pnp_driver);
+	pnp_registered = 1;
 #endif
 
 #ifdef CONFIG_DMI
@@ -3526,7 +3530,8 @@ static __exit void cleanup_ipmi_si(void)
 		pci_unregister_driver(&ipmi_pci_driver);
 #endif
 #ifdef CONFIG_ACPI
-	pnp_unregister_driver(&ipmi_pnp_driver);
+	if (pnp_registered)
+		pnp_unregister_driver(&ipmi_pnp_driver);
 #endif
 
 #ifdef CONFIG_PPC_OF
_

Patches currently in -mm which might be from yinghai@kernel.org are

ipmi-fix-acpi-probe-print.patch
linux-next.patch
ipmi-fix-hardcoded-ipmi-device-exit-path-warning.patch
maintainers-add-irq-subsystem.patch

