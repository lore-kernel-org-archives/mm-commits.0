From: akpm@linux-foundation.org
Subject: + net-replace-get_cpu_var-through-this_cpu_ptr.patch added to -mm tree
Date: Tue, 04 Mar 2014 14:27:33 -0800
Message-ID: <53165355.DBb9+3hEnvaXhe7N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42853 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbaCDW1e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 17:27:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, edumazet@google.com, davem@davemloft.net, cl@linux.com

Subject: + net-replace-get_cpu_var-through-this_cpu_ptr.patch added to -mm tree
To: cl@linux.com,davem@davemloft.net,edumazet@google.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 14:27:33 -0800


The patch titled
     Subject: net: replace get_cpu_var through this_cpu_ptr
has been added to the -mm tree.  Its filename is
     net-replace-get_cpu_var-through-this_cpu_ptr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-replace-get_cpu_var-through-this_cpu_ptr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-replace-get_cpu_var-through-this_cpu_ptr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: net: replace get_cpu_var through this_cpu_ptr

Replace uses of get_cpu_var for address calculation through this_cpu_ptr.

Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/netfilter/nf_conntrack.h |    2 +-
 include/net/snmp.h                   |    4 ++--
 net/core/dev.c                       |   14 +++++++-------
 net/core/drop_monitor.c              |    2 +-
 net/core/skbuff.c                    |    2 +-
 net/ipv4/route.c                     |    4 ++--
 net/ipv4/syncookies.c                |    2 +-
 net/ipv4/tcp.c                       |    2 +-
 net/ipv4/tcp_output.c                |    2 +-
 net/ipv6/syncookies.c                |    2 +-
 net/rds/ib_rdma.c                    |    2 +-
 11 files changed, 19 insertions(+), 19 deletions(-)

diff -puN include/net/netfilter/nf_conntrack.h~net-replace-get_cpu_var-through-this_cpu_ptr include/net/netfilter/nf_conntrack.h
--- a/include/net/netfilter/nf_conntrack.h~net-replace-get_cpu_var-through-this_cpu_ptr
+++ a/include/net/netfilter/nf_conntrack.h
@@ -235,7 +235,7 @@ extern s32 (*nf_ct_nat_offset)(const str
 DECLARE_PER_CPU(struct nf_conn, nf_conntrack_untracked);
 static inline struct nf_conn *nf_ct_untracked_get(void)
 {
-	return &__raw_get_cpu_var(nf_conntrack_untracked);
+	return raw_cpu_ptr(&nf_conntrack_untracked);
 }
 void nf_ct_untracked_status_or(unsigned long bits);
 
diff -puN include/net/snmp.h~net-replace-get_cpu_var-through-this_cpu_ptr include/net/snmp.h
--- a/include/net/snmp.h~net-replace-get_cpu_var-through-this_cpu_ptr
+++ a/include/net/snmp.h
@@ -170,7 +170,7 @@ struct linux_xfrm_mib {
 
 #define SNMP_ADD_STATS64_BH(mib, field, addend) 			\
 	do {								\
-		__typeof__(*mib[0]) *ptr = __this_cpu_ptr((mib)[0]);	\
+		__typeof__(*mib[0]) *ptr = raw_cpu_ptr((mib)[0]);	\
 		u64_stats_update_begin(&ptr->syncp);			\
 		ptr->mibs[field] += addend;				\
 		u64_stats_update_end(&ptr->syncp);			\
@@ -192,7 +192,7 @@ struct linux_xfrm_mib {
 #define SNMP_UPD_PO_STATS64_BH(mib, basefield, addend)			\
 	do {								\
 		__typeof__(*mib[0]) *ptr;				\
-		ptr = __this_cpu_ptr((mib)[0]);				\
+		ptr = raw_cpu_ptr((mib)[0]);				\
 		u64_stats_update_begin(&ptr->syncp);			\
 		ptr->mibs[basefield##PKTS]++;				\
 		ptr->mibs[basefield##OCTETS] += addend;			\
diff -puN net/core/dev.c~net-replace-get_cpu_var-through-this_cpu_ptr net/core/dev.c
--- a/net/core/dev.c~net-replace-get_cpu_var-through-this_cpu_ptr
+++ a/net/core/dev.c
@@ -2134,7 +2134,7 @@ static inline void __netif_reschedule(st
 	unsigned long flags;
 
 	local_irq_save(flags);
-	sd = &__get_cpu_var(softnet_data);
+	sd = this_cpu_ptr(&softnet_data);
 	q->next_sched = NULL;
 	*sd->output_queue_tailp = q;
 	sd->output_queue_tailp = &q->next_sched;
@@ -3127,7 +3127,7 @@ static void rps_trigger_softirq(void *da
 static int rps_ipi_queued(struct softnet_data *sd)
 {
 #ifdef CONFIG_RPS
-	struct softnet_data *mysd = &__get_cpu_var(softnet_data);
+	struct softnet_data *mysd = this_cpu_ptr(&softnet_data);
 
 	if (sd != mysd) {
 		sd->rps_ipi_next = mysd->rps_ipi_list;
@@ -3154,7 +3154,7 @@ static bool skb_flow_limit(struct sk_buf
 	if (qlen < (netdev_max_backlog >> 1))
 		return false;
 
-	sd = &__get_cpu_var(softnet_data);
+	sd = this_cpu_ptr(&softnet_data);
 
 	rcu_read_lock();
 	fl = rcu_dereference(sd->flow_limit);
@@ -3305,7 +3305,7 @@ EXPORT_SYMBOL(netif_rx_ni);
 
 static void net_tx_action(struct softirq_action *h)
 {
-	struct softnet_data *sd = &__get_cpu_var(softnet_data);
+	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
 
 	if (sd->completion_queue) {
 		struct sk_buff *clist;
@@ -3735,7 +3735,7 @@ EXPORT_SYMBOL(netif_receive_skb);
 static void flush_backlog(void *arg)
 {
 	struct net_device *dev = arg;
-	struct softnet_data *sd = &__get_cpu_var(softnet_data);
+	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
 	struct sk_buff *skb, *tmp;
 
 	rps_lock(sd);
@@ -4207,7 +4207,7 @@ void __napi_schedule(struct napi_struct
 	unsigned long flags;
 
 	local_irq_save(flags);
-	____napi_schedule(&__get_cpu_var(softnet_data), n);
+	____napi_schedule(this_cpu_ptr(&softnet_data), n);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(__napi_schedule);
@@ -4328,7 +4328,7 @@ EXPORT_SYMBOL(netif_napi_del);
 
 static void net_rx_action(struct softirq_action *h)
 {
-	struct softnet_data *sd = &__get_cpu_var(softnet_data);
+	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
 	unsigned long time_limit = jiffies + 2;
 	int budget = netdev_budget;
 	void *have;
diff -puN net/core/drop_monitor.c~net-replace-get_cpu_var-through-this_cpu_ptr net/core/drop_monitor.c
--- a/net/core/drop_monitor.c~net-replace-get_cpu_var-through-this_cpu_ptr
+++ a/net/core/drop_monitor.c
@@ -146,7 +146,7 @@ static void trace_drop_common(struct sk_
 	unsigned long flags;
 
 	local_irq_save(flags);
-	data = &__get_cpu_var(dm_cpu_data);
+	data = this_cpu_ptr(&dm_cpu_data);
 	spin_lock(&data->lock);
 	dskb = data->skb;
 
diff -puN net/core/skbuff.c~net-replace-get_cpu_var-through-this_cpu_ptr net/core/skbuff.c
--- a/net/core/skbuff.c~net-replace-get_cpu_var-through-this_cpu_ptr
+++ a/net/core/skbuff.c
@@ -344,7 +344,7 @@ static void *__netdev_alloc_frag(unsigne
 	unsigned long flags;
 
 	local_irq_save(flags);
-	nc = &__get_cpu_var(netdev_alloc_cache);
+	nc = this_cpu_ptr(&netdev_alloc_cache);
 	if (unlikely(!nc->frag.page)) {
 refill:
 		for (order = NETDEV_FRAG_PAGE_MAX_ORDER; ;) {
diff -puN net/ipv4/route.c~net-replace-get_cpu_var-through-this_cpu_ptr net/ipv4/route.c
--- a/net/ipv4/route.c~net-replace-get_cpu_var-through-this_cpu_ptr
+++ a/net/ipv4/route.c
@@ -1302,7 +1302,7 @@ static bool rt_cache_route(struct fib_nh
 	if (rt_is_input_route(rt)) {
 		p = (struct rtable **)&nh->nh_rth_input;
 	} else {
-		p = (struct rtable **)__this_cpu_ptr(nh->nh_pcpu_rth_output);
+		p = (struct rtable **)raw_cpu_ptr(nh->nh_pcpu_rth_output);
 	}
 	orig = *p;
 
@@ -1933,7 +1933,7 @@ static struct rtable *__mkroute_output(c
 				do_cache = false;
 				goto add;
 			}
-			prth = __this_cpu_ptr(nh->nh_pcpu_rth_output);
+			prth = raw_cpu_ptr(nh->nh_pcpu_rth_output);
 		}
 		rth = rcu_dereference(*prth);
 		if (rt_cache_valid(rth)) {
diff -puN net/ipv4/syncookies.c~net-replace-get_cpu_var-through-this_cpu_ptr net/ipv4/syncookies.c
--- a/net/ipv4/syncookies.c~net-replace-get_cpu_var-through-this_cpu_ptr
+++ a/net/ipv4/syncookies.c
@@ -40,7 +40,7 @@ static u32 cookie_hash(__be32 saddr, __b
 
 	net_get_random_once(syncookie_secret, sizeof(syncookie_secret));
 
-	tmp  = __get_cpu_var(ipv4_cookie_scratch);
+	tmp  = this_cpu_ptr(ipv4_cookie_scratch);
 	memcpy(tmp + 4, syncookie_secret[c], sizeof(syncookie_secret[c]));
 	tmp[0] = (__force u32)saddr;
 	tmp[1] = (__force u32)daddr;
diff -puN net/ipv4/tcp.c~net-replace-get_cpu_var-through-this_cpu_ptr net/ipv4/tcp.c
--- a/net/ipv4/tcp.c~net-replace-get_cpu_var-through-this_cpu_ptr
+++ a/net/ipv4/tcp.c
@@ -3031,7 +3031,7 @@ struct tcp_md5sig_pool *tcp_get_md5sig_p
 	local_bh_disable();
 	p = ACCESS_ONCE(tcp_md5sig_pool);
 	if (p)
-		return __this_cpu_ptr(p);
+		return raw_cpu_ptr(p);
 
 	local_bh_enable();
 	return NULL;
diff -puN net/ipv4/tcp_output.c~net-replace-get_cpu_var-through-this_cpu_ptr net/ipv4/tcp_output.c
--- a/net/ipv4/tcp_output.c~net-replace-get_cpu_var-through-this_cpu_ptr
+++ a/net/ipv4/tcp_output.c
@@ -831,7 +831,7 @@ void tcp_wfree(struct sk_buff *skb)
 
 		/* queue this socket to tasklet queue */
 		local_irq_save(flags);
-		tsq = &__get_cpu_var(tsq_tasklet);
+		tsq = this_cpu_ptr(&tsq_tasklet);
 		list_add(&tp->tsq_node, &tsq->head);
 		tasklet_schedule(&tsq->tasklet);
 		local_irq_restore(flags);
diff -puN net/ipv6/syncookies.c~net-replace-get_cpu_var-through-this_cpu_ptr net/ipv6/syncookies.c
--- a/net/ipv6/syncookies.c~net-replace-get_cpu_var-through-this_cpu_ptr
+++ a/net/ipv6/syncookies.c
@@ -67,7 +67,7 @@ static u32 cookie_hash(const struct in6_
 
 	net_get_random_once(syncookie6_secret, sizeof(syncookie6_secret));
 
-	tmp  = __get_cpu_var(ipv6_cookie_scratch);
+	tmp  = this_cpu_ptr(ipv6_cookie_scratch);
 
 	/*
 	 * we have 320 bits of information to hash, copy in the remaining
diff -puN net/rds/ib_rdma.c~net-replace-get_cpu_var-through-this_cpu_ptr net/rds/ib_rdma.c
--- a/net/rds/ib_rdma.c~net-replace-get_cpu_var-through-this_cpu_ptr
+++ a/net/rds/ib_rdma.c
@@ -267,7 +267,7 @@ static inline struct rds_ib_mr *rds_ib_r
 	unsigned long *flag;
 
 	preempt_disable();
-	flag = &__get_cpu_var(clean_list_grace);
+	flag = this_cpu_ptr(&clean_list_grace);
 	set_bit(CLEAN_LIST_BUSY_BIT, flag);
 	ret = llist_del_first(&pool->clean_list);
 	if (ret)
_

Patches currently in -mm which might be from cl@linux.com are

mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
kthread-ensure-locality-of-task_struct-allocations.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
kobject-dont-block-for-each-kobject_uevent.patch
kobject-dont-block-for-each-kobject_uevent-v2.patch
slub-do-not-drop-slab_mutex-for-sysfs_slab_add.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
percpu-add-raw_cpu_ops.patch
mm-use-raw_cpu-ops-for-determining-current-numa-node.patch
modules-use-raw_cpu_write-for-initialization-of-per-cpu-refcount.patch
net-replace-__this_cpu_inc-in-routec-with-raw_cpu_inc.patch
percpu-add-preemption-checks-to-__this_cpu-ops.patch
mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
tracing-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
percpu-replace-__get_cpu_var-with-this_cpu_ptr.patch
kernel-misc-replace-__get_cpu_var-uses.patch
drivers-char-random-replace-__get_cpu_var-uses.patch
drivers-cpuidle-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-oprofile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-leds-replace-__get_cpu_var-use-through-this_cpu_ptr.patch
drivers-clocksource-replace-__get_cpu_var-used-for-address-calculation.patch
parisc-replace-__get_cpu_var-uses-for-address-calculation.patch
metag-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-replace-__get_cpu_var-uses-for-address-calculation.patch
drivers-net-ethernet-tile-__get_cpu_var-call-introduced-in-314.patch
tilegx-another-case-of-get_cpu_var.patch
time-replace-__get_cpu_var-uses.patch
scheduler-replace-__get_cpu_var-with-this_cpu_ptr.patch
tick-sched-fix-two-new-uses-of-__get_cpu_ptr.patch
block-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
rcu-replace-__this_cpu_ptr-uses-with-raw_cpu_ptr.patch
watchdog-replace-__raw_get_cpu_var-uses.patch
net-replace-get_cpu_var-through-this_cpu_ptr.patch
md-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
irqchips-replace-__this_cpu_ptr-uses.patch
x86-replace-__get_cpu_var-uses.patch
x86-change-__get_cpu_var-calls-introduced-in-314.patch
uv-replace-__get_cpu_var.patch
arm-replace-__this_cpu_ptr-with-raw_cpu_ptr.patch
mips-replace-__get_cpu_var-uses-in-fpu-emulator.patch
mips-replace-__get_cpu_var-uses.patch
s390-rename-__this_cpu_ptr-to-raw_cpu_ptr.patch
s390-replace-__get_cpu_var-uses.patch
s390-handle-new-__get_cpu_var-calls-added-in-314.patch
ia64-replace-__get_cpu_var-uses.patch
powerpc-replace-__get_cpu_var-uses.patch
powerpc-handle-new-__get_cpu_var-calls-in-314.patch
sparc-replace-__get_cpu_var-uses.patch
tile-replace-__get_cpu_var-uses.patch
blackfin-replace-__get_cpu_var-uses.patch
avr32-replace-__get_cpu_var-with-__this_cpu_write.patch
alpha-replace-__get_cpu_var.patch
sh-replace-__get_cpu_var-uses.patch

