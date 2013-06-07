From: akpm@linux-foundation.org
Subject: [merged]
 ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch removed from -mm
 tree
Date: Fri, 07 Jun 2013 12:45:25 -0700
Message-ID: <51b23855.QcVGZNtUV1Qp3uB4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab3FGTp0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jun 2013 15:45:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ja@ssi.bg, horms@verge.net.au, davem@davemloft.net, zhangyanfei@cn.fujitsu.com

Subject: [merged] ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,davem@davemloft.net,horms@verge.net.au,ja@ssi.bg,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 07 Jun 2013 12:45:25 -0700


The patch titled
     Subject: ipvs: change type of netns_ipvs->sysctl_sync_qlen_max
has been removed from the -mm tree.  Its filename was
     ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: ipvs: change type of netns_ipvs->sysctl_sync_qlen_max

This member of struct netns_ipvs is calculated from nr_free_buffer_pages
so change its type to unsigned long in case of overflow.  Also, type of
its related proc var sync_qlen_max and the return type of function
sysctl_sync_qlen_max() should be changed to unsigned long, too.

Besides, the type of ipvs_master_sync_state->sync_queue_len should be
changed to unsigned long accordingly.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/ip_vs.h            |    8 ++++----
 net/netfilter/ipvs/ip_vs_ctl.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/net/ip_vs.h~ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max include/net/ip_vs.h
--- a/include/net/ip_vs.h~ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max
+++ a/include/net/ip_vs.h
@@ -905,7 +905,7 @@ struct ip_vs_app {
 struct ipvs_master_sync_state {
 	struct list_head	sync_queue;
 	struct ip_vs_sync_buff	*sync_buff;
-	int			sync_queue_len;
+	unsigned long		sync_queue_len;
 	unsigned int		sync_queue_delay;
 	struct task_struct	*master_thread;
 	struct delayed_work	master_wakeup_work;
@@ -998,7 +998,7 @@ struct netns_ipvs {
 	int			sysctl_snat_reroute;
 	int			sysctl_sync_ver;
 	int			sysctl_sync_ports;
-	int			sysctl_sync_qlen_max;
+	unsigned long		sysctl_sync_qlen_max;
 	int			sysctl_sync_sock_size;
 	int			sysctl_cache_bypass;
 	int			sysctl_expire_nodest_conn;
@@ -1085,7 +1085,7 @@ static inline int sysctl_sync_ports(stru
 	return ACCESS_ONCE(ipvs->sysctl_sync_ports);
 }
 
-static inline int sysctl_sync_qlen_max(struct netns_ipvs *ipvs)
+static inline unsigned long sysctl_sync_qlen_max(struct netns_ipvs *ipvs)
 {
 	return ipvs->sysctl_sync_qlen_max;
 }
@@ -1138,7 +1138,7 @@ static inline int sysctl_sync_ports(stru
 	return 1;
 }
 
-static inline int sysctl_sync_qlen_max(struct netns_ipvs *ipvs)
+static inline unsigned long sysctl_sync_qlen_max(struct netns_ipvs *ipvs)
 {
 	return IPVS_SYNC_QLEN_MAX;
 }
diff -puN net/netfilter/ipvs/ip_vs_ctl.c~ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max net/netfilter/ipvs/ip_vs_ctl.c
--- a/net/netfilter/ipvs/ip_vs_ctl.c~ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max
+++ a/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1716,9 +1716,9 @@ static struct ctl_table vs_vars[] = {
 	},
 	{
 		.procname	= "sync_qlen_max",
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_doulongvec_minmax,
 	},
 	{
 		.procname	= "sync_sock_size",
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

linux-next.patch
vmcore-clean-up-read_vmcore.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmcore-treat-memory-chunks-referenced-by-pt_load-program-header-entries-in-page-size-boundary-in-vmcore_list.patch
vmalloc-make-find_vm_area-check-in-range.patch
vmalloc-introduce-remap_vmalloc_range_partial.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-calculate-vmcore-file-size-from-buffer-size-and-total-size-of-vmcore-objects.patch
vmcore-support-mmap-on-proc-vmcore.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-vmalloc-only-call-setup_vmalloc_vm-only-in-__get_vm_area_node.patch
mm-vmalloc-call-setup_vmalloc_vm-instead-of-insert_vmalloc_vm.patch
mm-vmalloc-remove-insert_vmalloc_vm.patch
mm-vmalloc-use-clamp-to-simplify-code.patch
dev-oldmem-remove-the-interface.patch
dev-oldmem-remove-the-interface-fix.patch
documentation-kdump-kdumptxt-remove-dev-oldmem-description.patch
mips-remove-savemaxmem-parameter-setup.patch
powerpc-remove-savemaxmem-parameter-setup.patch
ia64-remove-setting-for-saved_max_pfn.patch
s390-remove-setting-for-saved_max_pfn.patch

