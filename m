From: akpm@linux-foundation.org
Subject: + ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch added to -mm tree
Date: Wed, 20 Feb 2013 14:51:00 -0800
Message-ID: <20130220225100.8E1855A41F6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:56625 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3BTWvC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Feb 2013 17:51:02 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so855388ves.5
        for <mm-commits@vger.kernel.org>; Wed, 20 Feb 2013 14:51:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhangyanfei@cn.fujitsu.com, davem@davemloft.net, horms@verge.net.au, ja@ssi.bg


The patch titled
     Subject: ipvs: change type of netns_ipvs->sysctl_sync_qlen_max
has been added to the -mm tree.  Its filename is
     ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -874,7 +874,7 @@ struct ip_vs_app {
 struct ipvs_master_sync_state {
 	struct list_head	sync_queue;
 	struct ip_vs_sync_buff	*sync_buff;
-	int			sync_queue_len;
+	unsigned long		sync_queue_len;
 	unsigned int		sync_queue_delay;
 	struct task_struct	*master_thread;
 	struct delayed_work	master_wakeup_work;
@@ -966,7 +966,7 @@ struct netns_ipvs {
 	int			sysctl_snat_reroute;
 	int			sysctl_sync_ver;
 	int			sysctl_sync_ports;
-	int			sysctl_sync_qlen_max;
+	unsigned long		sysctl_sync_qlen_max;
 	int			sysctl_sync_sock_size;
 	int			sysctl_cache_bypass;
 	int			sysctl_expire_nodest_conn;
@@ -1052,7 +1052,7 @@ static inline int sysctl_sync_ports(stru
 	return ACCESS_ONCE(ipvs->sysctl_sync_ports);
 }
 
-static inline int sysctl_sync_qlen_max(struct netns_ipvs *ipvs)
+static inline unsigned long sysctl_sync_qlen_max(struct netns_ipvs *ipvs)
 {
 	return ipvs->sysctl_sync_qlen_max;
 }
@@ -1099,7 +1099,7 @@ static inline int sysctl_sync_ports(stru
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
@@ -1747,9 +1747,9 @@ static struct ctl_table vs_vars[] = {
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

ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
mm-fix-return-type-for-functions-nr_free__pages.patch
ia64-use-%ld-to-print-pages-calculated-in-nr_free_buffer_pages.patch
fs-bufferc-change-type-of-max_buffer_heads-to-unsigned-long.patch
fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used.patch
vmscan-change-type-of-vm_total_pages-to-unsigned-long.patch
net-change-type-of-virtio_chan-p9_max_pages.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch
binfmt_elf-remove-unused-argument-in-fill_elf_header.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch

