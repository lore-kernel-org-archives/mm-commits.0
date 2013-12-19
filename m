From: akpm@linux-foundation.org
Subject: [merged]
 keys-fix-uninitialized-persistent_keyring_register_sem.patch removed from
 -mm tree
Date: Thu, 19 Dec 2013 11:54:11 -0800
Message-ID: <52b34ee3./4IFo85Art4mi5Dr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab3LSTyM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 14:54:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jwboyer@fedoraproject.org, dhowells@redhat.com, xiaoguangrong@linux.vnet.ibm.com

Subject: [merged] keys-fix-uninitialized-persistent_keyring_register_sem.patch removed from -mm tree
To: xiaoguangrong@linux.vnet.ibm.com,dhowells@redhat.com,jwboyer@fedoraproject.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 11:54:11 -0800


The patch titled
     Subject: KEYS: fix uninitialized persistent_keyring_register_sem
has been removed from the -mm tree.  Its filename was
     keys-fix-uninitialized-persistent_keyring_register_sem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: KEYS: fix uninitialized persistent_keyring_register_sem

We run into this bug:
[ 2736.063245] Unable to handle kernel paging request for data at address 0x00000000
[ 2736.063293] Faulting instruction address: 0xc00000000037efb0
[ 2736.063300] Oops: Kernel access of bad area, sig: 11 [#1]
[ 2736.063303] SMP NR_CPUS=2048 NUMA pSeries
[ 2736.063310] Modules linked in: sg nfsv3 rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6table_security ip6table_raw ip6t_REJECT iptable_nat nf_nat_ipv4 iptable_mangle iptable_security iptable_raw ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack ebtable_filter ebtables ip6table_filter iptable_filter ip_tables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 nf_nat nf_conntrack ip6_tables ibmveth pseries_rng nx_crypto nfsd auth_rpcgss nfs_acl lockd sunrpc binfmt_misc xfs libcrc32c dm_service_time sd_mod crc_t10dif crct10dif_common ibmvfc scsi_transport_fc scsi_tgt dm_mirror dm_region_hash dm_log dm_multipath dm_mod
[ 2736.063383] CPU: 1 PID: 7128 Comm: ssh Not tainted 3.10.0-48.el7.ppc64 #1
[ 2736.063389] task: c000000131930120 ti: c0000001319a0000 task.ti: c0000001319a0000
[ 2736.063394] NIP: c00000000037efb0 LR: c0000000006c40f8 CTR: 0000000000000000
[ 2736.063399] REGS: c0000001319a3870 TRAP: 0300   Not tainted  (3.10.0-48.el7.ppc64)
[ 2736.063403] MSR: 8000000000009032 <SF,EE,ME,IR,DR,RI>  CR: 28824242  XER: 20000000
[ 2736.063415] SOFTE: 0
[ 2736.063418] CFAR: c00000000000908c
[ 2736.063421] DAR: 0000000000000000, DSISR: 40000000
[ 2736.063425]
GPR00: c0000000006c40f8 c0000001319a3af0 c000000001074788 c0000001319a3bf0
GPR04: 0000000000000000 0000000000000000 0000000000000020 000000000000000a
GPR08: fffffffe00000002 00000000ffff0000 0000000080000001 c000000000924888
GPR12: 0000000028824248 c000000007e00400 00001fffffa0f998 0000000000000000
GPR16: 0000000000000022 00001fffffa0f998 0000010022e92470 0000000000000000
GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR24: 0000000000000000 c000000000f4a828 00003ffffe527108 0000000000000000
GPR28: c000000000f4a730 c000000000f4a828 0000000000000000 c0000001319a3bf0
[ 2736.063498] NIP [c00000000037efb0] .__list_add+0x30/0x110
[ 2736.063504] LR [c0000000006c40f8] .rwsem_down_write_failed+0x78/0x264
[ 2736.063508] PACATMSCRATCH [800000000280f032]
[ 2736.063511] Call Trace:
[ 2736.063516] [c0000001319a3af0] [c0000001319a3b80] 0xc0000001319a3b80 (unreliable)
[ 2736.063523] [c0000001319a3b80] [c0000000006c40f8] .rwsem_down_write_failed+0x78/0x264
[ 2736.063530] [c0000001319a3c50] [c0000000006c1bb0] .down_write+0x70/0x78
[ 2736.063536] [c0000001319a3cd0] [c0000000002e5ffc] .keyctl_get_persistent+0x20c/0x320
[ 2736.063542] [c0000001319a3dc0] [c0000000002e2388] .SyS_keyctl+0x238/0x260
[ 2736.063548] [c0000001319a3e30] [c000000000009e7c] syscall_exit+0x0/0x7c
[ 2736.063553] Instruction dump:
[ 2736.063556] 7c0802a6 fba1ffe8 fbc1fff0 fbe1fff8 7cbd2b78 7c9e2378 7c7f1b78 f8010010
[ 2736.063566] f821ff71 e8a50008 7fa52040 40de00c0 <e8be0000> 7fbd2840 40de0094 7fbff040
[ 2736.063579] ---[ end trace 2708241785538296 ]---

It's caused by uninitialized persistent_keyring_register_sem.

The bug was introduced by commit f36f8c75 ("KEYS: Add per-user_namespace
registers for persistent per-UID kerberos caches").  Two typos are in that
commit: CONFIG_KEYS_KERBEROS_CACHE should be CONFIG_PERSISTENT_KEYRINGS
and krb_cache_register_sem should be persistent_keyring_register_sem.

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Acked-by: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/user.c~keys-fix-uninitialized-persistent_keyring_register_sem kernel/user.c
--- a/kernel/user.c~keys-fix-uninitialized-persistent_keyring_register_sem
+++ a/kernel/user.c
@@ -51,9 +51,9 @@ struct user_namespace init_user_ns = {
 	.owner = GLOBAL_ROOT_UID,
 	.group = GLOBAL_ROOT_GID,
 	.proc_inum = PROC_USER_INIT_INO,
-#ifdef CONFIG_KEYS_KERBEROS_CACHE
-	.krb_cache_register_sem =
-	__RWSEM_INITIALIZER(init_user_ns.krb_cache_register_sem),
+#ifdef CONFIG_PERSISTENT_KEYRINGS
+	.persistent_keyring_register_sem =
+	__RWSEM_INITIALIZER(init_user_ns.persistent_keyring_register_sem),
 #endif
 };
 EXPORT_SYMBOL_GPL(init_user_ns);
_

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

origin.patch

