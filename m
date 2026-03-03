Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A926C6BFCE
	for <mm-commits@vger.kernel.org>; Tue,  3 Mar 2026 01:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772501738; cv=none; b=GTGjY3GLH4mKJ0usw10jjAmbnAJ39uY45b19pyCI8sqyQziZnfsHIsMII9THAYxoyj/2DE9lzsPceP7FYromHOGxOPA+ksVmBOJg51vGxy9A2tfrfUt1I4Iqki4LwVm1pvWrLreGHb9V4dTaLD5DxzIgXZwCOaIPJK4Vdl75POg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772501738; c=relaxed/simple;
	bh=9FIORy0ttAoIidT+i5G8KwSVSiClIFXtcC1/bdYzYbo=;
	h=Date:To:From:Subject:Message-Id; b=UDcTjDwlS1dw4o/XrqLT7NDebK0raxnfsmK/yULL0UBUCD3gub+fvWVnU06nuWT0nMSOE7y4W3ZA950uHUcveLZhZwFG7Vpk5hQpntcJ1ULWmepufgGZehN/pojWrYUKADbWZGQtdyn5GxxV0xWA5FluIGAWY6/XavlC/rYLBn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kHUHdtJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kHUHdtJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303E4C19423;
	Tue,  3 Mar 2026 01:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772501738;
	bh=9FIORy0ttAoIidT+i5G8KwSVSiClIFXtcC1/bdYzYbo=;
	h=Date:To:From:Subject:From;
	b=kHUHdtJf5w2O6rIw5ekx29rPcj6kVruwuX6+KkjFGwfjE70cpJ3fLsU6ydW6loYau
	 HyoBNbAOGjNew0fNAGwWLMSChqBb56dYRh13+/40WcYPmpO/NVs8uY/Qqk71POw081
	 N1YoNZu8BSKEIDhuYIa+Nfw08Td5L5FqrWLxRTY4=
Date: Mon, 02 Mar 2026 17:35:37 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,inwardvessel@gmail.com,hannes@cmpxchg.org,wujianyue000@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-optimize-stat-output-for-11%-sys-time-reduce.patch removed from -mm tree
Message-Id: <20260303013538.303E4C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, memcg: optimize stat output for 11% sys time reduction
has been removed from the -mm tree.  Its filename was
     mm-optimize-stat-output-for-11%-sys-time-reduce.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: mm, memcg: optimize stat output for 11% sys time reduction
Date: Fri, 23 Jan 2026 23:01:08 +0800

Replace seq_buf_printf() calls in memcg stat formatting with a lightweight
helper function and replace seq_printf() in numa stat output with direct
seq operations to avoid printf format parsing overhead.

Key changes:
- Add memcg_seq_buf_print_stat() helper that embeds separator and
  newline directly in the number buffer to reduce function calls
- Replace seq_buf_printf() in memcg_stat_format() with
  memcg_seq_buf_print_stat()
- Replace seq_printf() in memory_numa_stat_show() and
  memcg_numa_stat_show() with seq_puts() and seq_put_decimal_ull()
- Update memory_stat_format() and related v1 stats formatting

Performance improvement (1M reads of memory.stat + memory.numa_stat):
- Before: real 0m9.663s, user 0m4.840s, sys 0m4.823s
- After:  real 0m8.909s, user 0m4.661s, sys 0m4.247s
- Result: ~11% sys time reduction

Test script:
  for ((i=1; i<=1000000; i++)); do
      : > /dev/null < /sys/fs/cgroup/memory.stat
      : > /dev/null < /sys/fs/cgroup/memory.numa_stat
  done

Link: https://lkml.kernel.org/r/20260123150108.43443-2-wujianyue000@gmail.com
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
Suggested-by: JP Kobryn <inwardvessel@gmail.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: JP Kobryn <inwardvessel@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |   84 +++++++++++++++++++++++------------------
 mm/memcontrol-v1.h |    4 +
 mm/memcontrol.c    |   88 ++++++++++++++++++++++++++++++++++---------
 3 files changed, 123 insertions(+), 53 deletions(-)

--- a/mm/memcontrol.c~mm-optimize-stat-output-for-11%-sys-time-reduce
+++ a/mm/memcontrol.c
@@ -42,6 +42,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/limits.h>
+#include <linux/sprintf.h>
 #include <linux/export.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
@@ -1478,6 +1479,53 @@ static bool memcg_accounts_hugetlb(void)
 }
 #endif /* CONFIG_HUGETLB_PAGE */
 
+/* Max 2^64 - 1 = 18446744073709551615 (20 digits) */
+#define MEMCG_DEC_U64_MAX_LEN 20
+
+/**
+ * memcg_seq_buf_print_stat - Write a name-value pair to a seq_buf with newline
+ * @s: The seq_buf to write to
+ * @prefix: Optional prefix string (can be NULL or "")
+ * @name: The name string to write
+ * @sep: Separator character between name and value (typically ' ' or '=')
+ * @val: The u64 value to write
+ *
+ * This helper efficiently formats and writes "<prefix><name><sep><value>\n"
+ * to a seq_buf. It manually converts the value to a string using num_to_str
+ * and embeds the separator and newline in the buffer to minimize function
+ * calls for better performance.
+ *
+ * The function checks for overflow at each step and returns early if any
+ * operation would cause the buffer to overflow.
+ *
+ * Example: memcg_seq_buf_print_stat(s, "total_", "cache", ' ', 1048576)
+ *          Output: "total_cache 1048576\n"
+ */
+void memcg_seq_buf_print_stat(struct seq_buf *s, const char *prefix,
+			      const char *name, char sep, u64 val)
+{
+	char num_buf[MEMCG_DEC_U64_MAX_LEN + 2];  /* +2 for separator and newline */
+	int num_len;
+
+	/* Embed separator at the beginning */
+	num_buf[0] = sep;
+
+	/* Convert number starting at offset 1 */
+	num_len = num_to_str(num_buf + 1, sizeof(num_buf) - 2, val, 0);
+	if (num_len <= 0)
+		return;
+
+	/* Embed newline at the end */
+	num_buf[num_len + 1] = '\n';
+
+	if (prefix && *prefix && seq_buf_puts(s, prefix))
+		return;
+	if (seq_buf_puts(s, name))
+		return;
+	/* Output separator, value, and newline in one call */
+	seq_buf_putmem(s, num_buf, num_len + 2);
+}
+
 static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 {
 	int i;
@@ -1503,26 +1551,26 @@ static void memcg_stat_format(struct mem
 			continue;
 #endif
 		size = memcg_page_state_output(memcg, memory_stats[i].idx);
-		seq_buf_printf(s, "%s %llu\n", memory_stats[i].name, size);
+		memcg_seq_buf_print_stat(s, NULL, memory_stats[i].name, ' ', size);
 
 		if (unlikely(memory_stats[i].idx == NR_SLAB_UNRECLAIMABLE_B)) {
 			size += memcg_page_state_output(memcg,
 							NR_SLAB_RECLAIMABLE_B);
-			seq_buf_printf(s, "slab %llu\n", size);
+			memcg_seq_buf_print_stat(s, NULL, "slab", ' ', size);
 		}
 	}
 
 	/* Accumulated memory events */
-	seq_buf_printf(s, "pgscan %lu\n",
-		       memcg_events(memcg, PGSCAN_KSWAPD) +
-		       memcg_events(memcg, PGSCAN_DIRECT) +
-		       memcg_events(memcg, PGSCAN_PROACTIVE) +
-		       memcg_events(memcg, PGSCAN_KHUGEPAGED));
-	seq_buf_printf(s, "pgsteal %lu\n",
-		       memcg_events(memcg, PGSTEAL_KSWAPD) +
-		       memcg_events(memcg, PGSTEAL_DIRECT) +
-		       memcg_events(memcg, PGSTEAL_PROACTIVE) +
-		       memcg_events(memcg, PGSTEAL_KHUGEPAGED));
+	memcg_seq_buf_print_stat(s, NULL, "pgscan", ' ',
+				 memcg_events(memcg, PGSCAN_KSWAPD) +
+				 memcg_events(memcg, PGSCAN_DIRECT) +
+				 memcg_events(memcg, PGSCAN_PROACTIVE) +
+				 memcg_events(memcg, PGSCAN_KHUGEPAGED));
+	memcg_seq_buf_print_stat(s, NULL, "pgsteal", ' ',
+				 memcg_events(memcg, PGSTEAL_KSWAPD) +
+				 memcg_events(memcg, PGSTEAL_DIRECT) +
+				 memcg_events(memcg, PGSTEAL_PROACTIVE) +
+				 memcg_events(memcg, PGSTEAL_KHUGEPAGED));
 
 	for (i = 0; i < ARRAY_SIZE(memcg_vm_event_stat); i++) {
 #ifdef CONFIG_MEMCG_V1
@@ -1530,9 +1578,9 @@ static void memcg_stat_format(struct mem
 		    memcg_vm_event_stat[i] == PGPGOUT)
 			continue;
 #endif
-		seq_buf_printf(s, "%s %lu\n",
-			       vm_event_name(memcg_vm_event_stat[i]),
-			       memcg_events(memcg, memcg_vm_event_stat[i]));
+		memcg_seq_buf_print_stat(s, NULL,
+					 vm_event_name(memcg_vm_event_stat[i]), ' ',
+					 memcg_events(memcg, memcg_vm_event_stat[i]));
 	}
 }
 
@@ -4560,7 +4608,12 @@ static int memory_numa_stat_show(struct
 		if (memory_stats[i].idx >= NR_VM_NODE_STAT_ITEMS)
 			continue;
 
-		seq_printf(m, "%s", memory_stats[i].name);
+		/*
+		 * Output format: "stat_name N0=value0 N1=value1 ...\n"
+		 * Use seq_puts and seq_put_decimal_ull to avoid printf
+		 * format parsing overhead in this hot path.
+		 */
+		seq_puts(m, memory_stats[i].name);
 		for_each_node_state(nid, N_MEMORY) {
 			u64 size;
 			struct lruvec *lruvec;
@@ -4568,7 +4621,8 @@ static int memory_numa_stat_show(struct
 			lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 			size = lruvec_page_state_output(lruvec,
 							memory_stats[i].idx);
-			seq_printf(m, " N%d=%llu", nid, size);
+			seq_put_decimal_ull(m, " N", nid);
+			seq_put_decimal_ull(m, "=", size);
 		}
 		seq_putc(m, '\n');
 	}
--- a/mm/memcontrol-v1.c~mm-optimize-stat-output-for-11%-sys-time-reduce
+++ a/mm/memcontrol-v1.c
@@ -10,7 +10,7 @@
 #include <linux/poll.h>
 #include <linux/sort.h>
 #include <linux/file.h>
-#include <linux/seq_buf.h>
+#include <linux/string.h>
 
 #include "internal.h"
 #include "swap.h"
@@ -1816,26 +1816,39 @@ static int memcg_numa_stat_show(struct s
 
 	mem_cgroup_flush_stats(memcg);
 
+	/*
+	 * Output format: "stat_name=value N0=value0 N1=value1 ...\n"
+	 * Use seq_puts and seq_put_decimal_ull to avoid printf format
+	 * parsing overhead in this hot path.
+	 */
 	for (stat = stats; stat < ARRAY_END(stats); stat++) {
-		seq_printf(m, "%s=%lu", stat->name,
-			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
-						   false));
-		for_each_node_state(nid, N_MEMORY)
-			seq_printf(m, " N%d=%lu", nid,
-				   mem_cgroup_node_nr_lru_pages(memcg, nid,
-							stat->lru_mask, false));
+		seq_puts(m, stat->name);
+		seq_put_decimal_ull(m, "=",
+				    mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
+							    false));
+		for_each_node_state(nid, N_MEMORY) {
+			seq_put_decimal_ull(m, " N", nid);
+			seq_put_decimal_ull(m, "=",
+					    mem_cgroup_node_nr_lru_pages(memcg, nid,
+									 stat->lru_mask,
+									 false));
+		}
 		seq_putc(m, '\n');
 	}
 
 	for (stat = stats; stat < ARRAY_END(stats); stat++) {
-
-		seq_printf(m, "hierarchical_%s=%lu", stat->name,
-			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
-						   true));
-		for_each_node_state(nid, N_MEMORY)
-			seq_printf(m, " N%d=%lu", nid,
-				   mem_cgroup_node_nr_lru_pages(memcg, nid,
-							stat->lru_mask, true));
+		seq_puts(m, "hierarchical_");
+		seq_puts(m, stat->name);
+		seq_put_decimal_ull(m, "=",
+				    mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
+							    true));
+		for_each_node_state(nid, N_MEMORY) {
+			seq_put_decimal_ull(m, " N", nid);
+			seq_put_decimal_ull(m, "=",
+					    mem_cgroup_node_nr_lru_pages(memcg, nid,
+									 stat->lru_mask,
+									 true));
+		}
 		seq_putc(m, '\n');
 	}
 
@@ -1901,17 +1914,17 @@ void memcg1_stat_format(struct mem_cgrou
 		unsigned long nr;
 
 		nr = memcg_page_state_local_output(memcg, memcg1_stats[i]);
-		seq_buf_printf(s, "%s %lu\n", memcg1_stat_names[i], nr);
+		memcg_seq_buf_print_stat(s, NULL, memcg1_stat_names[i], ' ', (u64)nr);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
-		seq_buf_printf(s, "%s %lu\n", vm_event_name(memcg1_events[i]),
-			       memcg_events_local(memcg, memcg1_events[i]));
+		memcg_seq_buf_print_stat(s, NULL, vm_event_name(memcg1_events[i]),
+					 ' ', memcg_events_local(memcg, memcg1_events[i]));
 
 	for (i = 0; i < NR_LRU_LISTS; i++)
-		seq_buf_printf(s, "%s %lu\n", lru_list_name(i),
-			       memcg_page_state_local(memcg, NR_LRU_BASE + i) *
-			       PAGE_SIZE);
+		memcg_seq_buf_print_stat(s, NULL, lru_list_name(i), ' ',
+					 memcg_page_state_local(memcg, NR_LRU_BASE + i) *
+					 PAGE_SIZE);
 
 	/* Hierarchical information */
 	memory = memsw = PAGE_COUNTER_MAX;
@@ -1919,28 +1932,27 @@ void memcg1_stat_format(struct mem_cgrou
 		memory = min(memory, READ_ONCE(mi->memory.max));
 		memsw = min(memsw, READ_ONCE(mi->memsw.max));
 	}
-	seq_buf_printf(s, "hierarchical_memory_limit %llu\n",
-		       (u64)memory * PAGE_SIZE);
-	seq_buf_printf(s, "hierarchical_memsw_limit %llu\n",
-		       (u64)memsw * PAGE_SIZE);
+	memcg_seq_buf_print_stat(s, NULL, "hierarchical_memory_limit", ' ',
+				 (u64)memory * PAGE_SIZE);
+	memcg_seq_buf_print_stat(s, NULL, "hierarchical_memsw_limit", ' ',
+				 (u64)memsw * PAGE_SIZE);
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
 
 		nr = memcg_page_state_output(memcg, memcg1_stats[i]);
-		seq_buf_printf(s, "total_%s %llu\n", memcg1_stat_names[i],
-			       (u64)nr);
+		memcg_seq_buf_print_stat(s, "total_", memcg1_stat_names[i], ' ',
+					 (u64)nr);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
-		seq_buf_printf(s, "total_%s %llu\n",
-			       vm_event_name(memcg1_events[i]),
-			       (u64)memcg_events(memcg, memcg1_events[i]));
+		memcg_seq_buf_print_stat(s, "total_", vm_event_name(memcg1_events[i]),
+					 ' ', (u64)memcg_events(memcg, memcg1_events[i]));
 
 	for (i = 0; i < NR_LRU_LISTS; i++)
-		seq_buf_printf(s, "total_%s %llu\n", lru_list_name(i),
-			       (u64)memcg_page_state(memcg, NR_LRU_BASE + i) *
-			       PAGE_SIZE);
+		memcg_seq_buf_print_stat(s, "total_", lru_list_name(i), ' ',
+					 (u64)memcg_page_state(memcg, NR_LRU_BASE + i) *
+					 PAGE_SIZE);
 
 #ifdef CONFIG_DEBUG_VM
 	{
@@ -1955,8 +1967,8 @@ void memcg1_stat_format(struct mem_cgrou
 			anon_cost += mz->lruvec.anon_cost;
 			file_cost += mz->lruvec.file_cost;
 		}
-		seq_buf_printf(s, "anon_cost %lu\n", anon_cost);
-		seq_buf_printf(s, "file_cost %lu\n", file_cost);
+		memcg_seq_buf_print_stat(s, NULL, "anon_cost", ' ', (u64)anon_cost);
+		memcg_seq_buf_print_stat(s, NULL, "file_cost", ' ', (u64)file_cost);
 	}
 #endif
 }
--- a/mm/memcontrol-v1.h~mm-optimize-stat-output-for-11%-sys-time-reduce
+++ a/mm/memcontrol-v1.h
@@ -4,6 +4,7 @@
 #define __MM_MEMCONTROL_V1_H
 
 #include <linux/cgroup-defs.h>
+#include <linux/seq_buf.h>
 
 /* Cgroup v1 and v2 common declarations */
 
@@ -30,6 +31,9 @@ int memory_stat_show(struct seq_file *m,
 void mem_cgroup_private_id_get_many(struct mem_cgroup *memcg, unsigned int n);
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg);
 
+void memcg_seq_buf_print_stat(struct seq_buf *s, const char *prefix,
+			      const char *name, char sep, u64 val);
+
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
 
_

Patches currently in -mm which might be from wujianyue000@gmail.com are


