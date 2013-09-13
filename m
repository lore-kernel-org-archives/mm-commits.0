From: akpm@linux-foundation.org
Subject: [merged] memcg-rename-resource_max-to-res_counter_max.patch
 removed from -mm tree
Date: Fri, 13 Sep 2013 13:02:36 -0700
Message-ID: <52336f5c.e1ET6tNIfpwI4E9b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab3IMUCh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nishimura@mxp.nes.nec.co.jp, mhocko@suse.cz, jeff.liu@oracle.com, h.huangqiang@huawei.com, handai.szj@taobao.com

Subject: [merged] memcg-rename-resource_max-to-res_counter_max.patch removed from -mm tree
To: handai.szj@taobao.com,h.huangqiang@huawei.com,jeff.liu@oracle.com,mhocko@suse.cz,nishimura@mxp.nes.nec.co.jp,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:36 -0700


The patch titled
     Subject: memcg: rename RESOURCE_MAX to RES_COUNTER_MAX
has been removed from the -mm tree.  Its filename was
     memcg-rename-resource_max-to-res_counter_max.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sha Zhengju <handai.szj@taobao.com>
Subject: memcg: rename RESOURCE_MAX to RES_COUNTER_MAX

RESOURCE_MAX is far too general name, change it to RES_COUNTER_MAX.

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Jeff Liu <jeff.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/res_counter.h |    2 +-
 kernel/res_counter.c        |    8 ++++----
 mm/memcontrol.c             |    4 ++--
 net/ipv4/tcp_memcontrol.c   |   10 +++++-----
 4 files changed, 12 insertions(+), 12 deletions(-)

diff -puN include/linux/res_counter.h~memcg-rename-resource_max-to-res_counter_max include/linux/res_counter.h
--- a/include/linux/res_counter.h~memcg-rename-resource_max-to-res_counter_max
+++ a/include/linux/res_counter.h
@@ -54,7 +54,7 @@ struct res_counter {
 	struct res_counter *parent;
 };
 
-#define RESOURCE_MAX ULLONG_MAX
+#define RES_COUNTER_MAX ULLONG_MAX
 
 /**
  * Helpers to interact with userspace
diff -puN kernel/res_counter.c~memcg-rename-resource_max-to-res_counter_max kernel/res_counter.c
--- a/kernel/res_counter.c~memcg-rename-resource_max-to-res_counter_max
+++ a/kernel/res_counter.c
@@ -17,8 +17,8 @@
 void res_counter_init(struct res_counter *counter, struct res_counter *parent)
 {
 	spin_lock_init(&counter->lock);
-	counter->limit = RESOURCE_MAX;
-	counter->soft_limit = RESOURCE_MAX;
+	counter->limit = RES_COUNTER_MAX;
+	counter->soft_limit = RES_COUNTER_MAX;
 	counter->parent = parent;
 }
 
@@ -182,12 +182,12 @@ int res_counter_memparse_write_strategy(
 {
 	char *end;
 
-	/* return RESOURCE_MAX(unlimited) if "-1" is specified */
+	/* return RES_COUNTER_MAX(unlimited) if "-1" is specified */
 	if (*buf == '-') {
 		*res = simple_strtoull(buf + 1, &end, 10);
 		if (*res != 1 || *end != '\0')
 			return -EINVAL;
-		*res = RESOURCE_MAX;
+		*res = RES_COUNTER_MAX;
 		return 0;
 	}
 
diff -puN mm/memcontrol.c~memcg-rename-resource_max-to-res_counter_max mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-rename-resource_max-to-res_counter_max
+++ a/mm/memcontrol.c
@@ -4967,7 +4967,7 @@ static int memcg_update_kmem_limit(struc
 	 */
 	mutex_lock(&memcg_create_mutex);
 	mutex_lock(&set_limit_mutex);
-	if (!memcg->kmem_account_flags && val != RESOURCE_MAX) {
+	if (!memcg->kmem_account_flags && val != RES_COUNTER_MAX) {
 		if (cgroup_task_count(css->cgroup) || memcg_has_children(memcg)) {
 			ret = -EBUSY;
 			goto out;
@@ -4977,7 +4977,7 @@ static int memcg_update_kmem_limit(struc
 
 		ret = memcg_update_cache_sizes(memcg);
 		if (ret) {
-			res_counter_set_limit(&memcg->kmem, RESOURCE_MAX);
+			res_counter_set_limit(&memcg->kmem, RES_COUNTER_MAX);
 			goto out;
 		}
 		static_key_slow_inc(&memcg_kmem_enabled_key);
diff -puN net/ipv4/tcp_memcontrol.c~memcg-rename-resource_max-to-res_counter_max net/ipv4/tcp_memcontrol.c
--- a/net/ipv4/tcp_memcontrol.c~memcg-rename-resource_max-to-res_counter_max
+++ a/net/ipv4/tcp_memcontrol.c
@@ -87,8 +87,8 @@ static int tcp_update_limit(struct mem_c
 	if (!cg_proto)
 		return -EINVAL;
 
-	if (val > RESOURCE_MAX)
-		val = RESOURCE_MAX;
+	if (val > RES_COUNTER_MAX)
+		val = RES_COUNTER_MAX;
 
 	tcp = tcp_from_cgproto(cg_proto);
 
@@ -101,9 +101,9 @@ static int tcp_update_limit(struct mem_c
 		tcp->tcp_prot_mem[i] = min_t(long, val >> PAGE_SHIFT,
 					     net->ipv4.sysctl_tcp_mem[i]);
 
-	if (val == RESOURCE_MAX)
+	if (val == RES_COUNTER_MAX)
 		clear_bit(MEMCG_SOCK_ACTIVE, &cg_proto->flags);
-	else if (val != RESOURCE_MAX) {
+	else if (val != RES_COUNTER_MAX) {
 		/*
 		 * The active bit needs to be written after the static_key
 		 * update. This is what guarantees that the socket activation
@@ -187,7 +187,7 @@ static u64 tcp_cgroup_read(struct cgroup
 
 	switch (cft->private) {
 	case RES_LIMIT:
-		val = tcp_read_stat(memcg, RES_LIMIT, RESOURCE_MAX);
+		val = tcp_read_stat(memcg, RES_LIMIT, RES_COUNTER_MAX);
 		break;
 	case RES_USAGE:
 		val = tcp_read_usage(memcg);
_

Patches currently in -mm which might be from handai.szj@taobao.com are

origin.patch

