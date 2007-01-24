From: akpm@osdl.org
Subject: + sysctl-remove-insert_at_head-from-register_sysctl.patch added to -mm tree
Date: Tue, 23 Jan 2007 19:13:49 -0800
Message-ID: <200701240313.l0O3Dn2Z006988@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49362 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030194AbXAXDRT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 22:17:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, ralf@linux-mips.org, schwidefsky@de.ibm.com


The patch titled
     sysctl: remove insert_at_head from register_sysctl
has been added to the -mm tree.  Its filename is
     sysctl-remove-insert_at_head-from-register_sysctl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: remove insert_at_head from register_sysctl
From: Eric W. Biederman <ebiederm@xmission.com>

The semantic effect of insert_at_head is that it would allow new registered
sysctl entries to override existing sysctl entries of the same name.  Which is
pain for caching and the proc interface never implemented.

I have done an audit and discovered that none of the current users of
register_sysctl care as (excpet for directories) they do not register
duplicate sysctl entries.

So this patch simply removes the support for overriding existing entries in
the sys_sysctl interface since no one uses it or cares and it makes future
enhancments harder.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/arm/kernel/isa.c                        |    2 +-
 arch/frv/kernel/pm.c                         |    2 +-
 arch/frv/kernel/sysctl.c                     |    2 +-
 arch/ia64/kernel/crash.c                     |    2 +-
 arch/ia64/kernel/perfmon.c                   |    2 +-
 arch/ia64/sn/kernel/xpc_main.c               |    2 +-
 arch/mips/au1000/common/power.c              |    2 +-
 arch/mips/lasat/sysctl.c                     |    2 +-
 arch/powerpc/kernel/idle.c                   |    2 +-
 arch/ppc/kernel/ppc_htab.c                   |    2 +-
 arch/s390/appldata/appldata_base.c           |    4 ++--
 arch/s390/kernel/debug.c                     |    2 +-
 arch/s390/mm/cmm.c                           |    2 +-
 arch/sh64/kernel/traps.c                     |    2 +-
 arch/x86_64/ia32/ia32_binfmt.c               |    2 +-
 arch/x86_64/kernel/vsyscall.c                |    2 +-
 arch/x86_64/mm/init.c                        |    2 +-
 drivers/cdrom/cdrom.c                        |    2 +-
 drivers/char/hpet.c                          |    2 +-
 drivers/char/ipmi/ipmi_poweroff.c            |    2 +-
 drivers/char/rtc.c                           |    2 +-
 drivers/macintosh/mac_hid.c                  |    2 +-
 drivers/md/md.c                              |    2 +-
 drivers/net/wireless/arlan-proc.c            |    2 +-
 drivers/parport/procfs.c                     |    6 +++---
 drivers/scsi/scsi_sysctl.c                   |    2 +-
 fs/coda/sysctl.c                             |    2 +-
 fs/dquot.c                                   |    2 +-
 fs/lockd/svc.c                               |    2 +-
 fs/nfs/sysctl.c                              |    2 +-
 fs/ntfs/sysctl.c                             |    2 +-
 fs/ocfs2/cluster/nodemanager.c               |    2 +-
 fs/xfs/linux-2.6/xfs_sysctl.c                |    2 +-
 include/linux/sysctl.h                       |    4 ++--
 ipc/ipc_sysctl.c                             |    2 +-
 ipc/mqueue.c                                 |    2 +-
 kernel/sysctl.c                              |    9 ++-------
 kernel/utsname_sysctl.c                      |    2 +-
 net/appletalk/sysctl_net_atalk.c             |    2 +-
 net/ax25/sysctl_net_ax25.c                   |    2 +-
 net/bridge/br_netfilter.c                    |    2 +-
 net/core/neighbour.c                         |    2 +-
 net/dccp/sysctl.c                            |    2 +-
 net/decnet/dn_dev.c                          |    2 +-
 net/decnet/sysctl_net_decnet.c               |    2 +-
 net/ipv4/devinet.c                           |    4 ++--
 net/ipv4/ipvs/ip_vs_ctl.c                    |    2 +-
 net/ipv4/ipvs/ip_vs_lblc.c                   |    2 +-
 net/ipv4/ipvs/ip_vs_lblcr.c                  |    2 +-
 net/ipv4/netfilter/ip_conntrack_proto_sctp.c |    2 +-
 net/ipv4/netfilter/ip_conntrack_standalone.c |    2 +-
 net/ipv4/netfilter/ip_queue.c                |    2 +-
 net/ipv6/addrconf.c                          |    4 ++--
 net/ipv6/netfilter/ip6_queue.c               |    2 +-
 net/ipv6/sysctl_net_ipv6.c                   |    2 +-
 net/ipx/sysctl_net_ipx.c                     |    2 +-
 net/irda/irsysctl.c                          |    2 +-
 net/llc/sysctl_net_llc.c                     |    2 +-
 net/netfilter/nf_conntrack_standalone.c      |    2 +-
 net/netfilter/nf_sysctl.c                    |    2 +-
 net/netrom/sysctl_net_netrom.c               |    2 +-
 net/rose/sysctl_net_rose.c                   |    2 +-
 net/rxrpc/sysctl.c                           |    2 +-
 net/sctp/sysctl.c                            |    2 +-
 net/sunrpc/sysctl.c                          |    2 +-
 net/sunrpc/xprtsock.c                        |    2 +-
 net/unix/sysctl_net_unix.c                   |    2 +-
 net/x25/sysctl_net_x25.c                     |    2 +-
 68 files changed, 75 insertions(+), 80 deletions(-)

diff -puN arch/arm/kernel/isa.c~sysctl-remove-insert_at_head-from-register_sysctl arch/arm/kernel/isa.c
--- a/arch/arm/kernel/isa.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/arch/arm/kernel/isa.c
@@ -70,5 +70,5 @@ register_isa_ports(unsigned int membase,
 	isa_membase = membase;
 	isa_portbase = portbase;
 	isa_portshift = portshift;
-	isa_sysctl_header = register_sysctl_table(ctl_bus, 0);
+	isa_sysctl_header = register_sysctl_table(ctl_bus);
 }
diff -puN arch/frv/kernel/pm.c~sysctl-remove-insert_at_head-from-register_sysctl arch/frv/kernel/pm.c
--- a/arch/frv/kernel/pm.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/arch/frv/kernel/pm.c
@@ -455,7 +455,7 @@ static struct ctl_table pm_dir_table[] =
  */
 static int __init pm_init(void)
 {
-	register_sysctl_table(pm_dir_table, 0);
+	register_sysctl_table(pm_dir_table);
 	return 0;
 }
 
diff -puN arch/frv/kernel/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl arch/frv/kernel/sysctl.c
--- a/arch/frv/kernel/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/arch/frv/kernel/sysctl.c
@@ -216,7 +216,7 @@ static struct ctl_table frv_dir_table[] 
  */
 static int __init frv_sysctl_init(void)
 {
-	register_sysctl_table(frv_dir_table, 0);
+	register_sysctl_table(frv_dir_table);
 	return 0;
 }
 
diff -puN arch/ia64/kernel/crash.c~sysctl-remove-insert_at_head-from-register_sysctl arch/ia64/kernel/crash.c
--- a/arch/ia64/kernel/crash.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/arch/ia64/kernel/crash.c
@@ -214,7 +214,7 @@ machine_crash_setup(void)
 	if((ret = register_die_notifier(&kdump_init_notifier_nb)) != 0)
 		return ret;
 #ifdef CONFIG_SYSCTL
-	register_sysctl_table(sys_table, 0);
+	register_sysctl_table(sys_table);
 #endif
 	return 0;
 }
diff -puN arch/ia64/kernel/perfmon.c~sysctl-remove-insert_at_head-from-register_sysctl arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/arch/ia64/kernel/perfmon.c
@@ -6726,7 +6726,7 @@ pfm_init(void)
 	/*
 	 * create /proc/sys/kernel/perfmon (for debugging purposes)
 	 */
-	pfm_sysctl_header = register_sysctl_table(pfm_sysctl_root, 0);
+	pfm_sysctl_header = register_sysctl_table(pfm_sysctl_root);
 
 	/*
 	 * initialize all our spinlocks
diff -puN arch/ia64/sn/kernel/xpc_main.c~sysctl-remove-insert_at_head-from-register_sysctl arch/ia64/sn/kernel/xpc_main.c
--- a/arch/ia64/sn/kernel/xpc_main.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/arch/ia64/sn/kernel/xpc_main.c
@@ -1241,7 +1241,7 @@ xpc_init(void)
 	snprintf(xpc_part->bus_id, BUS_ID_SIZE, "part");
 	snprintf(xpc_chan->bus_id, BUS_ID_SIZE, "chan");
 
-	xpc_sysctl = register_sysctl_table(xpc_sys_dir, 0);
+	xpc_sysctl = register_sysctl_table(xpc_sys_dir);
 
 	/*
 	 * The first few fields of each entry of xpc_partitions[] need to
diff -puN arch/mips/au1000/common/power.c~sysctl-remove-insert_at_head-from-register_sysctl arch/mips/au1000/common/power.c
--- a/arch/mips/au1000/common/power.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/arch/mips/au1000/common/power.c
@@ -461,7 +461,7 @@ static struct ctl_table pm_dir_table[] =
  */
 static int __init pm_init(void)
 {
-	register_sysctl_table(pm_dir_table, 0);
+	register_sysctl_table(pm_dir_table);
 	return 0;
 }
 
diff -puN arch/mips/lasat/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl arch/mips/lasat/sysctl.c
--- a/arch/mips/lasat/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/arch/mips/lasat/sysctl.c
@@ -432,7 +432,7 @@ static int __init lasat_register_sysctl(
 	struct ctl_table_header *lasat_table_header;
 
 	lasat_table_header =
-		register_sysctl_table(lasat_root_table, 0);
+		register_sysctl_table(lasat_root_table);
 
 	return 0;
 }
diff -puN arch/powerpc/kernel/idle.c~sysctl-remove-insert_at_head-from-register_sysctl arch/powerpc/kernel/idle.c
--- a/arch/powerpc/kernel/idle.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/arch/powerpc/kernel/idle.c
@@ -125,7 +125,7 @@ static ctl_table powersave_nap_sysctl_ro
 static int __init
 register_powersave_nap_sysctl(void)
 {
-	register_sysctl_table(powersave_nap_sysctl_root, 0);
+	register_sysctl_table(powersave_nap_sysctl_root);
 
 	return 0;
 }
diff -puN arch/ppc/kernel/ppc_htab.c~sysctl-remove-insert_at_head-from-register_sysctl arch/ppc/kernel/ppc_htab.c
--- a/arch/ppc/kernel/ppc_htab.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/arch/ppc/kernel/ppc_htab.c
@@ -457,7 +457,7 @@ static ctl_table htab_sysctl_root[] = {
 static int __init
 register_ppc_htab_sysctl(void)
 {
-	register_sysctl_table(htab_sysctl_root, 0);
+	register_sysctl_table(htab_sysctl_root);
 
 	return 0;
 }
diff -puN arch/s390/appldata/appldata_base.c~sysctl-remove-insert_at_head-from-register_sysctl arch/s390/appldata/appldata_base.c
--- a/arch/s390/appldata/appldata_base.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/arch/s390/appldata/appldata_base.c
@@ -506,7 +506,7 @@ int appldata_register_ops(struct appldat
 
 	ops->ctl_table[3].ctl_name = 0;
 
-	ops->sysctl_header = register_sysctl_table(ops->ctl_table,0);
+	ops->sysctl_header = register_sysctl_table(ops->ctl_table);
 
 	P_INFO("%s-ops registered!\n", ops->name);
 	return 0;
@@ -606,7 +606,7 @@ static int __init appldata_init(void)
 	/* Register cpu hotplug notifier */
 	register_hotcpu_notifier(&appldata_nb);
 
-	appldata_sysctl_header = register_sysctl_table(appldata_dir_table, 0);
+	appldata_sysctl_header = register_sysctl_table(appldata_dir_table);
 #ifdef MODULE
 	appldata_dir_table[0].de->owner = THIS_MODULE;
 	appldata_table[0].de->owner = THIS_MODULE;
diff -puN arch/s390/kernel/debug.c~sysctl-remove-insert_at_head-from-register_sysctl arch/s390/kernel/debug.c
--- a/arch/s390/kernel/debug.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/arch/s390/kernel/debug.c
@@ -1053,7 +1053,7 @@ __init debug_init(void)
 {
 	int rc = 0;
 
-	s390dbf_sysctl_header = register_sysctl_table(s390dbf_dir_table, 0);
+	s390dbf_sysctl_header = register_sysctl_table(s390dbf_dir_table);
 	down(&debug_lock);
 	debug_debugfs_root_entry = debugfs_create_dir(DEBUG_DIR_ROOT,NULL);
 	printk(KERN_INFO "debug: Initialization complete\n");
diff -puN arch/s390/mm/cmm.c~sysctl-remove-insert_at_head-from-register_sysctl arch/s390/mm/cmm.c
--- a/arch/s390/mm/cmm.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/arch/s390/mm/cmm.c
@@ -418,7 +418,7 @@ cmm_init (void)
 	int rc = -ENOMEM;
 
 #ifdef CONFIG_CMM_PROC
-	cmm_sysctl_header = register_sysctl_table(cmm_dir_table, 0);
+	cmm_sysctl_header = register_sysctl_table(cmm_dir_table);
 	if (!cmm_sysctl_header)
 		goto out;
 #endif
diff -puN arch/sh64/kernel/traps.c~sysctl-remove-insert_at_head-from-register_sysctl arch/sh64/kernel/traps.c
--- a/arch/sh64/kernel/traps.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/arch/sh64/kernel/traps.c
@@ -960,7 +960,7 @@ static ctl_table sh64_root[] = {
 static struct ctl_table_header *sysctl_header;
 static int __init init_sysctl(void)
 {
-	sysctl_header = register_sysctl_table(sh64_root, 0);
+	sysctl_header = register_sysctl_table(sh64_root);
 	return 0;
 }
 
diff -puN arch/x86_64/ia32/ia32_binfmt.c~sysctl-remove-insert_at_head-from-register_sysctl arch/x86_64/ia32/ia32_binfmt.c
--- a/arch/x86_64/ia32/ia32_binfmt.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/arch/x86_64/ia32/ia32_binfmt.c
@@ -367,7 +367,7 @@ static ctl_table abi_root_table2[] = {
 
 static __init int ia32_binfmt_init(void)
 { 
-	register_sysctl_table(abi_root_table2, 0);
+	register_sysctl_table(abi_root_table2);
 	return 0;
 }
 __initcall(ia32_binfmt_init);
diff -puN arch/x86_64/kernel/vsyscall.c~sysctl-remove-insert_at_head-from-register_sysctl arch/x86_64/kernel/vsyscall.c
--- a/arch/x86_64/kernel/vsyscall.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/arch/x86_64/kernel/vsyscall.c
@@ -324,7 +324,7 @@ static int __init vsyscall_init(void)
 	BUG_ON((unsigned long) &vgetcpu != VSYSCALL_ADDR(__NR_vgetcpu));
 	map_vsyscall();
 #ifdef CONFIG_SYSCTL
-	register_sysctl_table(kernel_root_table2, 0);
+	register_sysctl_table(kernel_root_table2);
 #endif
 	on_each_cpu(cpu_vsyscall_init, NULL, 0, 1);
 	hotcpu_notifier(cpu_vsyscall_notifier, 0);
diff -puN arch/x86_64/mm/init.c~sysctl-remove-insert_at_head-from-register_sysctl arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/arch/x86_64/mm/init.c
@@ -734,7 +734,7 @@ static ctl_table debug_root_table2[] = {
 
 static __init int x8664_sysctl_init(void)
 { 
-	register_sysctl_table(debug_root_table2, 0);
+	register_sysctl_table(debug_root_table2);
 	return 0;
 }
 __initcall(x8664_sysctl_init);
diff -puN drivers/cdrom/cdrom.c~sysctl-remove-insert_at_head-from-register_sysctl drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/drivers/cdrom/cdrom.c
@@ -3553,7 +3553,7 @@ static void cdrom_sysctl_register(void)
 	if (initialized == 1)
 		return;
 
-	cdrom_sysctl_header = register_sysctl_table(cdrom_root_table, 0);
+	cdrom_sysctl_header = register_sysctl_table(cdrom_root_table);
 
 	/* set the defaults */
 	cdrom_sysctl_settings.autoclose = autoclose;
diff -puN drivers/char/hpet.c~sysctl-remove-insert_at_head-from-register_sysctl drivers/char/hpet.c
--- a/drivers/char/hpet.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/drivers/char/hpet.c
@@ -1018,7 +1018,7 @@ static int __init hpet_init(void)
 	if (result < 0)
 		return -ENODEV;
 
-	sysctl_header = register_sysctl_table(dev_root, 0);
+	sysctl_header = register_sysctl_table(dev_root);
 
 	result = acpi_bus_register_driver(&hpet_acpi_driver);
 	if (result < 0) {
diff -puN drivers/char/ipmi/ipmi_poweroff.c~sysctl-remove-insert_at_head-from-register_sysctl drivers/char/ipmi/ipmi_poweroff.c
--- a/drivers/char/ipmi/ipmi_poweroff.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/drivers/char/ipmi/ipmi_poweroff.c
@@ -686,7 +686,7 @@ static int ipmi_poweroff_init (void)
 		printk(KERN_INFO PFX "Power cycle is enabled.\n");
 
 #ifdef CONFIG_PROC_FS
-	ipmi_table_header = register_sysctl_table(ipmi_root_table, 0);
+	ipmi_table_header = register_sysctl_table(ipmi_root_table);
 	if (!ipmi_table_header) {
 		printk(KERN_ERR PFX "Unable to register powercycle sysctl\n");
 		rv = -ENOMEM;
diff -puN drivers/char/rtc.c~sysctl-remove-insert_at_head-from-register_sysctl drivers/char/rtc.c
--- a/drivers/char/rtc.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/drivers/char/rtc.c
@@ -316,7 +316,7 @@ static struct ctl_table_header *sysctl_h
 
 static int __init init_sysctl(void)
 {
-    sysctl_header = register_sysctl_table(dev_root, 0);
+    sysctl_header = register_sysctl_table(dev_root);
     return 0;
 }
 
diff -puN drivers/macintosh/mac_hid.c~sysctl-remove-insert_at_head-from-register_sysctl drivers/macintosh/mac_hid.c
--- a/drivers/macintosh/mac_hid.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/drivers/macintosh/mac_hid.c
@@ -138,7 +138,7 @@ int __init mac_hid_init(void)
 		return err;
 
 #if defined(CONFIG_SYSCTL)
-	mac_hid_sysctl_header = register_sysctl_table(mac_hid_root_dir, 0);
+	mac_hid_sysctl_header = register_sysctl_table(mac_hid_root_dir);
 #endif /* CONFIG_SYSCTL */
 
 	return 0;
diff -puN drivers/md/md.c~sysctl-remove-insert_at_head-from-register_sysctl drivers/md/md.c
--- a/drivers/md/md.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/drivers/md/md.c
@@ -5548,7 +5548,7 @@ static int __init md_init(void)
 			    md_probe, NULL, NULL);
 
 	register_reboot_notifier(&md_notifier);
-	raid_table_header = register_sysctl_table(raid_root_table, 0);
+	raid_table_header = register_sysctl_table(raid_root_table);
 
 	md_geninit();
 	return (0);
diff -puN drivers/net/wireless/arlan-proc.c~sysctl-remove-insert_at_head-from-register_sysctl drivers/net/wireless/arlan-proc.c
--- a/drivers/net/wireless/arlan-proc.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/drivers/net/wireless/arlan-proc.c
@@ -1244,7 +1244,7 @@ int __init init_arlan_proc(void)
 		return 0;
 	for (i = 0; i < MAX_ARLANS && arlan_device[i]; i++)
 		arlan_table[i].ctl_name = i + 1;
-	arlan_device_sysctl_header = register_sysctl_table(arlan_root_table, 0);
+	arlan_device_sysctl_header = register_sysctl_table(arlan_root_table);
 	if (!arlan_device_sysctl_header)
 		return -1;
 
diff -puN drivers/parport/procfs.c~sysctl-remove-insert_at_head-from-register_sysctl drivers/parport/procfs.c
--- a/drivers/parport/procfs.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/drivers/parport/procfs.c
@@ -518,7 +518,7 @@ int parport_proc_register(struct parport
 	t->parport_dir[0].child = t->port_dir;
 	t->dev_dir[0].child = t->parport_dir;
 
-	t->sysctl_header = register_sysctl_table(t->dev_dir, 0);
+	t->sysctl_header = register_sysctl_table(t->dev_dir);
 	if (t->sysctl_header == NULL) {
 		kfree(t);
 		t = NULL;
@@ -574,7 +574,7 @@ int parport_device_proc_register(struct 
 	t->device_dir[0].child = t->vars;
 	t->vars[0].data = &device->timeslice;
 
-	t->sysctl_header = register_sysctl_table(t->dev_dir, 0);
+	t->sysctl_header = register_sysctl_table(t->dev_dir);
 	if (t->sysctl_header == NULL) {
 		kfree(t);
 		t = NULL;
@@ -597,7 +597,7 @@ int parport_device_proc_unregister(struc
 static int __init parport_default_proc_register(void)
 {
 	parport_default_sysctl_table.sysctl_header =
-		register_sysctl_table(parport_default_sysctl_table.dev_dir, 0);
+		register_sysctl_table(parport_default_sysctl_table.dev_dir);
 	return 0;
 }
 
diff -puN drivers/scsi/scsi_sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl drivers/scsi/scsi_sysctl.c
--- a/drivers/scsi/scsi_sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/drivers/scsi/scsi_sysctl.c
@@ -42,7 +42,7 @@ static struct ctl_table_header *scsi_tab
 
 int __init scsi_init_sysctl(void)
 {
-	scsi_table_header = register_sysctl_table(scsi_root_table, 0);
+	scsi_table_header = register_sysctl_table(scsi_root_table);
 	if (!scsi_table_header)
 		return -ENOMEM;
 	return 0;
diff -puN fs/coda/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl fs/coda/sysctl.c
--- a/fs/coda/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/fs/coda/sysctl.c
@@ -271,7 +271,7 @@ void coda_sysctl_init(void)
 
 #ifdef CONFIG_SYSCTL
 	if ( !fs_table_header )
-		fs_table_header = register_sysctl_table(fs_table, 0);
+		fs_table_header = register_sysctl_table(fs_table);
 #endif 
 }
 
diff -puN fs/dquot.c~sysctl-remove-insert_at_head-from-register_sysctl fs/dquot.c
--- a/fs/dquot.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/fs/dquot.c
@@ -1821,7 +1821,7 @@ static int __init dquot_init(void)
 
 	printk(KERN_NOTICE "VFS: Disk quotas %s\n", __DQUOT_VERSION__);
 
-	register_sysctl_table(sys_table, 0);
+	register_sysctl_table(sys_table);
 
 	dquot_cachep = kmem_cache_create("dquot", 
 			sizeof(struct dquot), sizeof(unsigned long) * 4,
diff -puN fs/lockd/svc.c~sysctl-remove-insert_at_head-from-register_sysctl fs/lockd/svc.c
--- a/fs/lockd/svc.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/fs/lockd/svc.c
@@ -512,7 +512,7 @@ module_param(nsm_use_hostnames, bool, 06
 
 static int __init init_nlm(void)
 {
-	nlm_sysctl_table = register_sysctl_table(nlm_sysctl_root, 0);
+	nlm_sysctl_table = register_sysctl_table(nlm_sysctl_root);
 	return nlm_sysctl_table ? 0 : -ENOMEM;
 }
 
diff -puN fs/nfs/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl fs/nfs/sysctl.c
--- a/fs/nfs/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/fs/nfs/sysctl.c
@@ -75,7 +75,7 @@ static ctl_table nfs_cb_sysctl_root[] = 
 
 int nfs_register_sysctl(void)
 {
-	nfs_callback_sysctl_table = register_sysctl_table(nfs_cb_sysctl_root, 0);
+	nfs_callback_sysctl_table = register_sysctl_table(nfs_cb_sysctl_root);
 	if (nfs_callback_sysctl_table == NULL)
 		return -ENOMEM;
 	return 0;
diff -puN fs/ntfs/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl fs/ntfs/sysctl.c
--- a/fs/ntfs/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/fs/ntfs/sysctl.c
@@ -70,7 +70,7 @@ int ntfs_sysctl(int add)
 {
 	if (add) {
 		BUG_ON(sysctls_root_table);
-		sysctls_root_table = register_sysctl_table(sysctls_root, 0);
+		sysctls_root_table = register_sysctl_table(sysctls_root);
 		if (!sysctls_root_table)
 			return -ENOMEM;
 #ifdef CONFIG_PROC_FS
diff -puN fs/ocfs2/cluster/nodemanager.c~sysctl-remove-insert_at_head-from-register_sysctl fs/ocfs2/cluster/nodemanager.c
--- a/fs/ocfs2/cluster/nodemanager.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/fs/ocfs2/cluster/nodemanager.c
@@ -922,7 +922,7 @@ static int __init init_o2nm(void)
 	o2hb_init();
 	o2net_init();
 
-	ocfs2_table_header = register_sysctl_table(ocfs2_root_table, 0);
+	ocfs2_table_header = register_sysctl_table(ocfs2_root_table);
 	if (!ocfs2_table_header) {
 		printk(KERN_ERR "nodemanager: unable to register sysctl\n");
 		ret = -ENOMEM; /* or something. */
diff -puN fs/xfs/linux-2.6/xfs_sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl fs/xfs/linux-2.6/xfs_sysctl.c
--- a/fs/xfs/linux-2.6/xfs_sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/fs/xfs/linux-2.6/xfs_sysctl.c
@@ -251,7 +251,7 @@ STATIC ctl_table xfs_root_table[] = {
 void
 xfs_sysctl_register(void)
 {
-	xfs_table_header = register_sysctl_table(xfs_root_table, 0);
+	xfs_table_header = register_sysctl_table(xfs_root_table);
 }
 
 void
diff -puN include/linux/sysctl.h~sysctl-remove-insert_at_head-from-register_sysctl include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/include/linux/sysctl.h
@@ -1034,8 +1034,8 @@ struct ctl_table_header
 	struct completion *unregistering;
 };
 
-struct ctl_table_header * register_sysctl_table(ctl_table * table, 
-						int insert_at_head);
+struct ctl_table_header * register_sysctl_table(ctl_table * table);
+
 void unregister_sysctl_table(struct ctl_table_header * table);
 
 #else /* __KERNEL__ */
diff -puN ipc/ipc_sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl ipc/ipc_sysctl.c
--- a/ipc/ipc_sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/ipc/ipc_sysctl.c
@@ -175,7 +175,7 @@ static struct ctl_table ipc_root_table[]
 
 static int __init ipc_sysctl_init(void)
 {
-	register_sysctl_table(ipc_root_table, 0);
+	register_sysctl_table(ipc_root_table);
 	return 0;
 }
 
diff -puN ipc/mqueue.c~sysctl-remove-insert_at_head-from-register_sysctl ipc/mqueue.c
--- a/ipc/mqueue.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/ipc/mqueue.c
@@ -1255,7 +1255,7 @@ static int __init init_mqueue_fs(void)
 		return -ENOMEM;
 
 	/* ignore failues - they are not fatal */
-	mq_sysctl_table = register_sysctl_table(mq_sysctl_root, 0);
+	mq_sysctl_table = register_sysctl_table(mq_sysctl_root);
 
 	error = register_filesystem(&mqueue_fs_type);
 	if (error)
diff -puN kernel/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/kernel/sysctl.c
@@ -1283,7 +1283,6 @@ int do_sysctl_strategy (ctl_table *table
 /**
  * register_sysctl_table - register a sysctl hierarchy
  * @table: the top-level table structure
- * @insert_at_head: whether the entry should be inserted in front or at the end
  *
  * Register a sysctl table hierarchy. @table should be a filled in ctl_table
  * array. An entry with a ctl_name of 0 terminates the table. 
@@ -1349,8 +1348,7 @@ int do_sysctl_strategy (ctl_table *table
  * This routine returns %NULL on a failure to register, and a pointer
  * to the table header on success.
  */
-struct ctl_table_header *register_sysctl_table(ctl_table * table, 
-					       int insert_at_head)
+struct ctl_table_header *register_sysctl_table(ctl_table * table)
 {
 	struct ctl_table_header *tmp;
 	tmp = kmalloc(sizeof(struct ctl_table_header), GFP_KERNEL);
@@ -1361,10 +1359,7 @@ struct ctl_table_header *register_sysctl
 	tmp->used = 0;
 	tmp->unregistering = NULL;
 	spin_lock(&sysctl_lock);
-	if (insert_at_head)
-		list_add(&tmp->ctl_entry, &root_table_header.ctl_entry);
-	else
-		list_add_tail(&tmp->ctl_entry, &root_table_header.ctl_entry);
+	list_add_tail(&tmp->ctl_entry, &root_table_header.ctl_entry);
 	spin_unlock(&sysctl_lock);
 #ifdef CONFIG_PROC_SYSCTL
 	register_proc_table(table, proc_sys_root, tmp);
diff -puN kernel/utsname_sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl kernel/utsname_sysctl.c
--- a/kernel/utsname_sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/kernel/utsname_sysctl.c
@@ -139,7 +139,7 @@ static struct ctl_table uts_root_table[]
 
 static int __init utsname_sysctl_init(void)
 {
-	register_sysctl_table(uts_root_table, 0);
+	register_sysctl_table(uts_root_table);
 	return 0;
 }
 
diff -puN net/appletalk/sysctl_net_atalk.c~sysctl-remove-insert_at_head-from-register_sysctl net/appletalk/sysctl_net_atalk.c
--- a/net/appletalk/sysctl_net_atalk.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/appletalk/sysctl_net_atalk.c
@@ -73,7 +73,7 @@ static struct ctl_table_header *atalk_ta
 
 void atalk_register_sysctl(void)
 {
-	atalk_table_header = register_sysctl_table(atalk_root_table, 0);
+	atalk_table_header = register_sysctl_table(atalk_root_table);
 }
 
 void atalk_unregister_sysctl(void)
diff -puN net/ax25/sysctl_net_ax25.c~sysctl-remove-insert_at_head-from-register_sysctl net/ax25/sysctl_net_ax25.c
--- a/net/ax25/sysctl_net_ax25.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/ax25/sysctl_net_ax25.c
@@ -245,7 +245,7 @@ void ax25_register_sysctl(void)
 
 	ax25_dir_table[0].child = ax25_table;
 
-	ax25_table_header = register_sysctl_table(ax25_root_table, 0);
+	ax25_table_header = register_sysctl_table(ax25_root_table);
 }
 
 void ax25_unregister_sysctl(void)
diff -puN net/bridge/br_netfilter.c~sysctl-remove-insert_at_head-from-register_sysctl net/bridge/br_netfilter.c
--- a/net/bridge/br_netfilter.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/bridge/br_netfilter.c
@@ -966,7 +966,7 @@ int br_netfilter_init(void)
 	}
 
 #ifdef CONFIG_SYSCTL
-	brnf_sysctl_header = register_sysctl_table(brnf_net_table, 0);
+	brnf_sysctl_header = register_sysctl_table(brnf_net_table);
 	if (brnf_sysctl_header == NULL) {
 		printk(KERN_WARNING
 		       "br_netfilter: can't register to sysctl.\n");
diff -puN net/core/neighbour.c~sysctl-remove-insert_at_head-from-register_sysctl net/core/neighbour.c
--- a/net/core/neighbour.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/core/neighbour.c
@@ -2701,7 +2701,7 @@ int neigh_sysctl_register(struct net_dev
 	t->neigh_proto_dir[0].child    = t->neigh_neigh_dir;
 	t->neigh_root_dir[0].child     = t->neigh_proto_dir;
 
-	t->sysctl_header = register_sysctl_table(t->neigh_root_dir, 0);
+	t->sysctl_header = register_sysctl_table(t->neigh_root_dir);
 	if (!t->sysctl_header) {
 		err = -ENOBUFS;
 		goto free_procname;
diff -puN net/dccp/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl net/dccp/sysctl.c
--- a/net/dccp/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/dccp/sysctl.c
@@ -127,7 +127,7 @@ static struct ctl_table_header *dccp_tab
 
 int __init dccp_sysctl_init(void)
 {
-	dccp_table_header = register_sysctl_table(dccp_root_table, 0);
+	dccp_table_header = register_sysctl_table(dccp_root_table);
 
 	return dccp_table_header != NULL ? 0 : -ENOMEM;
 }
diff -puN net/decnet/dn_dev.c~sysctl-remove-insert_at_head-from-register_sysctl net/decnet/dn_dev.c
--- a/net/decnet/dn_dev.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/decnet/dn_dev.c
@@ -282,7 +282,7 @@ static void dn_dev_sysctl_register(struc
 	t->dn_dev_root_dir[0].de = NULL;
 	t->dn_dev_vars[0].extra1 = (void *)dev;
 
-	t->sysctl_header = register_sysctl_table(t->dn_dev_root_dir, 0);
+	t->sysctl_header = register_sysctl_table(t->dn_dev_root_dir);
 	if (t->sysctl_header == NULL)
 		kfree(t);
 	else
diff -puN net/decnet/sysctl_net_decnet.c~sysctl-remove-insert_at_head-from-register_sysctl net/decnet/sysctl_net_decnet.c
--- a/net/decnet/sysctl_net_decnet.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/decnet/sysctl_net_decnet.c
@@ -491,7 +491,7 @@ static ctl_table dn_root_table[] = {
 
 void dn_register_sysctl(void)
 {
-	dn_table_header = register_sysctl_table(dn_root_table, 0);
+	dn_table_header = register_sysctl_table(dn_root_table);
 }
 
 void dn_unregister_sysctl(void)
diff -puN net/ipv4/devinet.c~sysctl-remove-insert_at_head-from-register_sysctl net/ipv4/devinet.c
--- a/net/ipv4/devinet.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/ipv4/devinet.c
@@ -1602,7 +1602,7 @@ static void devinet_sysctl_register(stru
 	t->devinet_root_dir[0].child  = t->devinet_proto_dir;
 	t->devinet_root_dir[0].de     = NULL;
 
-	t->sysctl_header = register_sysctl_table(t->devinet_root_dir, 0);
+	t->sysctl_header = register_sysctl_table(t->devinet_root_dir);
 	if (!t->sysctl_header)
 	    goto free_procname;
 
@@ -1636,7 +1636,7 @@ void __init devinet_init(void)
 	rtnetlink_links[PF_INET] = inet_rtnetlink_table;
 #ifdef CONFIG_SYSCTL
 	devinet_sysctl.sysctl_header =
-		register_sysctl_table(devinet_sysctl.devinet_root_dir, 0);
+		register_sysctl_table(devinet_sysctl.devinet_root_dir);
 	devinet_sysctl_register(NULL, &ipv4_devconf_dflt);
 #endif
 }
diff -puN net/ipv4/ipvs/ip_vs_ctl.c~sysctl-remove-insert_at_head-from-register_sysctl net/ipv4/ipvs/ip_vs_ctl.c
--- a/net/ipv4/ipvs/ip_vs_ctl.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/ipv4/ipvs/ip_vs_ctl.c
@@ -2359,7 +2359,7 @@ int ip_vs_control_init(void)
 	proc_net_fops_create("ip_vs", 0, &ip_vs_info_fops);
 	proc_net_fops_create("ip_vs_stats",0, &ip_vs_stats_fops);
 
-	sysctl_header = register_sysctl_table(vs_root_table, 0);
+	sysctl_header = register_sysctl_table(vs_root_table);
 
 	/* Initialize ip_vs_svc_table, ip_vs_svc_fwm_table, ip_vs_rtable */
 	for(idx = 0; idx < IP_VS_SVC_TAB_SIZE; idx++)  {
diff -puN net/ipv4/ipvs/ip_vs_lblc.c~sysctl-remove-insert_at_head-from-register_sysctl net/ipv4/ipvs/ip_vs_lblc.c
--- a/net/ipv4/ipvs/ip_vs_lblc.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/ipv4/ipvs/ip_vs_lblc.c
@@ -583,7 +583,7 @@ static struct ip_vs_scheduler ip_vs_lblc
 static int __init ip_vs_lblc_init(void)
 {
 	INIT_LIST_HEAD(&ip_vs_lblc_scheduler.n_list);
-	sysctl_header = register_sysctl_table(lblc_root_table, 0);
+	sysctl_header = register_sysctl_table(lblc_root_table);
 	return register_ip_vs_scheduler(&ip_vs_lblc_scheduler);
 }
 
diff -puN net/ipv4/ipvs/ip_vs_lblcr.c~sysctl-remove-insert_at_head-from-register_sysctl net/ipv4/ipvs/ip_vs_lblcr.c
--- a/net/ipv4/ipvs/ip_vs_lblcr.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/ipv4/ipvs/ip_vs_lblcr.c
@@ -841,7 +841,7 @@ static struct ip_vs_scheduler ip_vs_lblc
 static int __init ip_vs_lblcr_init(void)
 {
 	INIT_LIST_HEAD(&ip_vs_lblcr_scheduler.n_list);
-	sysctl_header = register_sysctl_table(lblcr_root_table, 0);
+	sysctl_header = register_sysctl_table(lblcr_root_table);
 #ifdef CONFIG_IP_VS_LBLCR_DEBUG
 	proc_net_create("ip_vs_lblcr", 0, ip_vs_lblcr_getinfo);
 #endif
diff -puN net/ipv4/netfilter/ip_conntrack_proto_sctp.c~sysctl-remove-insert_at_head-from-register_sysctl net/ipv4/netfilter/ip_conntrack_proto_sctp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
@@ -622,7 +622,7 @@ static int __init ip_conntrack_proto_sct
 	}
 
 #ifdef CONFIG_SYSCTL
-	ip_ct_sysctl_header = register_sysctl_table(ip_ct_net_table, 0);
+	ip_ct_sysctl_header = register_sysctl_table(ip_ct_net_table);
 	if (ip_ct_sysctl_header == NULL) {
 		ret = -ENOMEM;
 		printk("ip_conntrack_proto_sctp: can't register to sysctl.\n");
diff -puN net/ipv4/netfilter/ip_conntrack_standalone.c~sysctl-remove-insert_at_head-from-register_sysctl net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/ipv4/netfilter/ip_conntrack_standalone.c
@@ -849,7 +849,7 @@ static int __init ip_conntrack_standalon
 		goto cleanup_proc_stat;
 	}
 #ifdef CONFIG_SYSCTL
-	ip_ct_sysctl_header = register_sysctl_table(ip_ct_net_table, 0);
+	ip_ct_sysctl_header = register_sysctl_table(ip_ct_net_table);
 	if (ip_ct_sysctl_header == NULL) {
 		printk("ip_conntrack: can't register to sysctl.\n");
 		ret = -ENOMEM;
diff -puN net/ipv4/netfilter/ip_queue.c~sysctl-remove-insert_at_head-from-register_sysctl net/ipv4/netfilter/ip_queue.c
--- a/net/ipv4/netfilter/ip_queue.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/ipv4/netfilter/ip_queue.c
@@ -693,7 +693,7 @@ static int __init ip_queue_init(void)
 	}
 	
 	register_netdevice_notifier(&ipq_dev_notifier);
-	ipq_sysctl_header = register_sysctl_table(ipq_root_table, 0);
+	ipq_sysctl_header = register_sysctl_table(ipq_root_table);
 	
 	status = nf_register_queue_handler(PF_INET, &nfqh);
 	if (status < 0) {
diff -puN net/ipv6/addrconf.c~sysctl-remove-insert_at_head-from-register_sysctl net/ipv6/addrconf.c
--- a/net/ipv6/addrconf.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/ipv6/addrconf.c
@@ -4009,7 +4009,7 @@ static void addrconf_sysctl_register(str
 	t->addrconf_root_dir[0].child = t->addrconf_proto_dir;
 	t->addrconf_root_dir[0].de = NULL;
 
-	t->sysctl_header = register_sysctl_table(t->addrconf_root_dir, 0);
+	t->sysctl_header = register_sysctl_table(t->addrconf_root_dir);
 	if (t->sysctl_header == NULL)
 		goto free_procname;
 	else
@@ -4094,7 +4094,7 @@ int __init addrconf_init(void)
 	rtnetlink_links[PF_INET6] = inet6_rtnetlink_table;
 #ifdef CONFIG_SYSCTL
 	addrconf_sysctl.sysctl_header =
-		register_sysctl_table(addrconf_sysctl.addrconf_root_dir, 0);
+		register_sysctl_table(addrconf_sysctl.addrconf_root_dir);
 	addrconf_sysctl_register(NULL, &ipv6_devconf_dflt);
 #endif
 
diff -puN net/ipv6/netfilter/ip6_queue.c~sysctl-remove-insert_at_head-from-register_sysctl net/ipv6/netfilter/ip6_queue.c
--- a/net/ipv6/netfilter/ip6_queue.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/ipv6/netfilter/ip6_queue.c
@@ -683,7 +683,7 @@ static int __init ip6_queue_init(void)
 	}
 	
 	register_netdevice_notifier(&ipq_dev_notifier);
-	ipq_sysctl_header = register_sysctl_table(ipq_root_table, 0);
+	ipq_sysctl_header = register_sysctl_table(ipq_root_table);
 	
 	status = nf_register_queue_handler(PF_INET6, &nfqh);
 	if (status < 0) {
diff -puN net/ipv6/sysctl_net_ipv6.c~sysctl-remove-insert_at_head-from-register_sysctl net/ipv6/sysctl_net_ipv6.c
--- a/net/ipv6/sysctl_net_ipv6.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/ipv6/sysctl_net_ipv6.c
@@ -107,7 +107,7 @@ static ctl_table ipv6_root_table[] = {
 
 void ipv6_sysctl_register(void)
 {
-	ipv6_sysctl_header = register_sysctl_table(ipv6_root_table, 0);
+	ipv6_sysctl_header = register_sysctl_table(ipv6_root_table);
 }
 
 void ipv6_sysctl_unregister(void)
diff -puN net/ipx/sysctl_net_ipx.c~sysctl-remove-insert_at_head-from-register_sysctl net/ipx/sysctl_net_ipx.c
--- a/net/ipx/sysctl_net_ipx.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/ipx/sysctl_net_ipx.c
@@ -52,7 +52,7 @@ static struct ctl_table_header *ipx_tabl
 
 void ipx_register_sysctl(void)
 {
-	ipx_table_header = register_sysctl_table(ipx_root_table, 0);
+	ipx_table_header = register_sysctl_table(ipx_root_table);
 }
 
 void ipx_unregister_sysctl(void)
diff -puN net/irda/irsysctl.c~sysctl-remove-insert_at_head-from-register_sysctl net/irda/irsysctl.c
--- a/net/irda/irsysctl.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/irda/irsysctl.c
@@ -274,7 +274,7 @@ static struct ctl_table_header *irda_tab
  */
 int __init irda_sysctl_register(void)
 {
-	irda_table_header = register_sysctl_table(irda_root_table, 0);
+	irda_table_header = register_sysctl_table(irda_root_table);
 	if (!irda_table_header)
 		return -ENOMEM;
 
diff -puN net/llc/sysctl_net_llc.c~sysctl-remove-insert_at_head-from-register_sysctl net/llc/sysctl_net_llc.c
--- a/net/llc/sysctl_net_llc.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/llc/sysctl_net_llc.c
@@ -116,7 +116,7 @@ static struct ctl_table_header *llc_tabl
 
 int __init llc_sysctl_init(void)
 {
-	llc_table_header = register_sysctl_table(llc_root_table, 0);
+	llc_table_header = register_sysctl_table(llc_root_table);
 
 	return llc_table_header ? 0 : -ENOMEM;
 }
diff -puN net/netfilter/nf_conntrack_standalone.c~sysctl-remove-insert_at_head-from-register_sysctl net/netfilter/nf_conntrack_standalone.c
--- a/net/netfilter/nf_conntrack_standalone.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/netfilter/nf_conntrack_standalone.c
@@ -445,7 +445,7 @@ static int __init nf_conntrack_standalon
 	proc_stat->owner = THIS_MODULE;
 #endif
 #ifdef CONFIG_SYSCTL
-	nf_ct_sysctl_header = register_sysctl_table(nf_ct_net_table, 0);
+	nf_ct_sysctl_header = register_sysctl_table(nf_ct_net_table);
 	if (nf_ct_sysctl_header == NULL) {
 		printk("nf_conntrack: can't register to sysctl.\n");
 		ret = -ENOMEM;
diff -puN net/netfilter/nf_sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl net/netfilter/nf_sysctl.c
--- a/net/netfilter/nf_sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/netfilter/nf_sysctl.c
@@ -56,7 +56,7 @@ nf_register_sysctl_table(struct ctl_tabl
 	path = path_dup(path, table);
 	if (path == NULL)
 		return NULL;
-	header = register_sysctl_table(path, 0);
+	header = register_sysctl_table(path);
 	if (header == NULL)
 		path_free(path, table);
 	return header;
diff -puN net/netrom/sysctl_net_netrom.c~sysctl-remove-insert_at_head-from-register_sysctl net/netrom/sysctl_net_netrom.c
--- a/net/netrom/sysctl_net_netrom.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/netrom/sysctl_net_netrom.c
@@ -192,7 +192,7 @@ static ctl_table nr_root_table[] = {
 
 void __init nr_register_sysctl(void)
 {
-	nr_table_header = register_sysctl_table(nr_root_table, 0);
+	nr_table_header = register_sysctl_table(nr_root_table);
 }
 
 void nr_unregister_sysctl(void)
diff -puN net/rose/sysctl_net_rose.c~sysctl-remove-insert_at_head-from-register_sysctl net/rose/sysctl_net_rose.c
--- a/net/rose/sysctl_net_rose.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/rose/sysctl_net_rose.c
@@ -160,7 +160,7 @@ static ctl_table rose_root_table[] = {
 
 void __init rose_register_sysctl(void)
 {
-	rose_table_header = register_sysctl_table(rose_root_table, 0);
+	rose_table_header = register_sysctl_table(rose_root_table);
 }
 
 void rose_unregister_sysctl(void)
diff -puN net/rxrpc/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl net/rxrpc/sysctl.c
--- a/net/rxrpc/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/rxrpc/sysctl.c
@@ -97,7 +97,7 @@ static ctl_table rxrpc_dir_sysctl_table[
 int rxrpc_sysctl_init(void)
 {
 #ifdef CONFIG_SYSCTL
-	rxrpc_sysctl = register_sysctl_table(rxrpc_dir_sysctl_table, 0);
+	rxrpc_sysctl = register_sysctl_table(rxrpc_dir_sysctl_table);
 	if (!rxrpc_sysctl)
 		return -ENOMEM;
 #endif /* CONFIG_SYSCTL */
diff -puN net/sctp/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl net/sctp/sysctl.c
--- a/net/sctp/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/sctp/sysctl.c
@@ -254,7 +254,7 @@ static struct ctl_table_header * sctp_sy
 /* Sysctl registration.  */
 void sctp_sysctl_register(void)
 {
-	sctp_sysctl_header = register_sysctl_table(sctp_root_table, 0);
+	sctp_sysctl_header = register_sysctl_table(sctp_root_table);
 }
 
 /* Sysctl deregistration.  */
diff -puN net/sunrpc/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl net/sunrpc/sysctl.c
--- a/net/sunrpc/sysctl.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/sunrpc/sysctl.c
@@ -36,7 +36,7 @@ void
 rpc_register_sysctl(void)
 {
 	if (!sunrpc_table_header)
-		sunrpc_table_header = register_sysctl_table(sunrpc_table, 0);
+		sunrpc_table_header = register_sysctl_table(sunrpc_table);
 }
 
 void
diff -puN net/sunrpc/xprtsock.c~sysctl-remove-insert_at_head-from-register_sysctl net/sunrpc/xprtsock.c
--- a/net/sunrpc/xprtsock.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/sunrpc/xprtsock.c
@@ -1629,7 +1629,7 @@ int init_socket_xprt(void)
 {
 #ifdef RPC_DEBUG
 	if (!sunrpc_table_header)
-		sunrpc_table_header = register_sysctl_table(sunrpc_table, 0);
+		sunrpc_table_header = register_sysctl_table(sunrpc_table);
 #endif
 
 	return 0;
diff -puN net/unix/sysctl_net_unix.c~sysctl-remove-insert_at_head-from-register_sysctl net/unix/sysctl_net_unix.c
--- a/net/unix/sysctl_net_unix.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/unix/sysctl_net_unix.c
@@ -50,7 +50,7 @@ static struct ctl_table_header * unix_sy
 
 void unix_sysctl_register(void)
 {
-	unix_sysctl_header = register_sysctl_table(unix_root_table, 0);
+	unix_sysctl_header = register_sysctl_table(unix_root_table);
 }
 
 void unix_sysctl_unregister(void)
diff -puN net/x25/sysctl_net_x25.c~sysctl-remove-insert_at_head-from-register_sysctl net/x25/sysctl_net_x25.c
--- a/net/x25/sysctl_net_x25.c~sysctl-remove-insert_at_head-from-register_sysctl
+++ a/net/x25/sysctl_net_x25.c
@@ -98,7 +98,7 @@ static struct ctl_table x25_root_table[]
 
 void __init x25_register_sysctl(void)
 {
-	x25_table_header = register_sysctl_table(x25_root_table, 0);
+	x25_table_header = register_sysctl_table(x25_root_table);
 }
 
 void x25_unregister_sysctl(void)
_

Patches currently in -mm which might be from ebiederm@xmission.com are

kthread-api-conversion-for-dvb_frontend-and-av7110.patch
vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user-namespace-add-the-framework-fix.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-shared-mounts.patch
user_ns-handle-file-sigio.patch
user_ns-handle-file-sigio-fix.patch
user-ns-implement-user-ns-unshare.patch
user-ns-implement-user-ns-unshare-tidy.patch
user-ns-implement-user-ns-unshare-remove-config_user_ns.patch
remove-find_attach_pid.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
sysctl-x25-remove-unnecessary-insert_at_head-from-register_sysctl_table.patch
sysctl-move-ctl_sunrpc-to-sysctlh-where-it-belongs.patch
sysctl-sunrpc-remove-unnecessary-insert_at_head-flag.patch
sysctl-sunrpc-dont-unnecessarily-set-ctl_table-de.patch
sysctl-rose-remove-unnecessary-insert_at_head-flag.patch
sysctl-netrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-llc-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipx-remove-unnecessary-insert_at_head-flag.patch
sysctl-decnet-remove-unnecessary-insert_at_head-flag.patch
sysctl-dccp-remove-unnecessary-insert_at_head-flag.patch
sysctl-ax25-remove-unnecessary-insert_at_head-flag.patch
sysctl-atalk-remove-unnecessary-insert_at_head-flag.patch
sysctl-xfs-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-xfs-ctl_tables.patch
sysctl-c99-convert-xfs-ctl_tables-fixes.patch
sysctl-scsi-remove-unnecessary-insert_at_head-flag.patch
sysctl-md-remove-unnecessary-insert_at_head-flag.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipmi-remove-unnecessary-insert_at_head-flag.patch
sysctl-cdrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-cdrom-dont-set-de-owner.patch
sysctl-move-ctl_pm-into-sysctlh-where-it-belongs.patch
sysctl-frv-pm-remove-unnecessary-insert_at_head-flag.patch
sysctl-move-ctl_frv-into-sysctlh-where-it-belongs.patch
sysctl-frv-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-arch-frv-kernel-pmc.patch
sysctl-c99-convert-arch-frv-kernel-sysctlc.patch
sysctl-sn-remove-sysctl-abi-breakage.patch
sysctl-c99-convert-arch-ia64-sn-kernel-xpc_mainc.patch
sysctl-c99-convert-arch-ia64-kernel-perfmon-and-remove-abi-breakage.patch
sysctl-mips-au1000-remove-sys_sysctl-support.patch
sysctl-c99-convert-the-ctl_tables-in-arch-mips-au1000-common-powerc.patch
sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage.patch
sysctl-s390-move-sysctl-definitions-to-sysctlh.patch
sysctl-s390-remove-unnecessary-use-of-insert_at_head.patch
sysctl-c99-convert-ctl_tables-in-arch-powerpc-kernel-idlec.patch
sysctl-c99-convert-ctl_tables-entries-in-arch-ppc-kernel-ppc_htabc.patch
sysctl-c99-convert-arch-sh64-kernel-trapsc-and-remove-abi-breakage.patch
sysctl-x86_64-remove-unnecessary-use-of-insert_at_head.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-ia32-ia32_binfmtc.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-kernel-vsyscallc.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-mm-initc.patch
sysctl-remove-sys_sysctl-support-from-the-hpet-timer-driver.patch
sysctl-remove-sys_sysctl-support-from-drivers-char-rtcc.patch
sysctl-register-the-sysctl-number-used-by-the-arlan-driver.patch
sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc.patch
sysctl-c99-convert-coda-ctl_tables-and-remove-binary-sysctls.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch
sysctl-register-the-ocfs2-sysctl-numbers.patch
sysctl-move-init_irq_proc-into-init-main-where-it-belongs.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch
sysctl-remove-support-for-ctl_any.patch
sysctl-remove-support-for-directory-strategy-routines.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch
sysctl-allow-sysctl_perm-to-be-called-from-outside-of-sysctlc.patch
sysctl-reimplement-the-sysctl-proc-support.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
