Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818480;
	b=W4va6JAsT43FqaEWoDqLcutPpJiFmF9i0aIEazMSliDlq6hVvX8J1JkHaLc4fW+fNeG6
	 o3jW8bq8m0mcc6tYKjyIgGoU8aSsDP8RXkNQPB1KJnjs4EtPljRiflZHYtKMpVGy0aDuC
	 UrQ5/4ZOesHuTQeiGnRFlLBTu0weV3cS7439v0/RdgWUfsDVsj84W4gbnz0KeclvDJIHh
	 5ZMA6na6hl+NjwMbR/beEPqEGadwxCyei7qe4zd+riSPKsgR/7NWdSGbm8JA8ga9AyKPV
	 cjQ2PYCQJEbGXcAZvnMAvg7ij7f+IPtLZMDKOp2vwvzJG7snrtYdsAf6xqSCD7EPhSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818480;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=RHyK13KBwkxx4f0mFpWjdN2kRmymPzJL//qXpf17W2M=;
	b=J4XsqJUmNbqKoO01zs1lhF3SMan/OMBq12V6HGoANAuE1WEhlX1K6x4vV08v2atLxR8Q
	 iMn2V/z1vRG7Xn/CyEDyTS5R6F4Mz2v7412qh+91PNIgXY1nEe7L9Y1sPv0OL9yyU9HFt
	 QPVDCBvkp3E9JW6IG2wHjJbZsEnSE162OJMOCDd2u+CU00H1i96lwW4PyCeTKcGIslVuf
	 lwew+gkZRPHpgcKFaoBy7y/nC0t8Z8Y0C8riRO/o2r8uX0S9yvHY8GYZNHrXkGpLeDtGp
	 ef/DBZi/AvZPgjnnlSas7/McLEc8WbqzYq79XHTYwrsf2FnM0kfGqpG5jYI3Tb4FnNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0FdHtyKj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3FE606A32D
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 18:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0FdHtyKj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC5A1F00A16;
	Wed,  4 Nov 2026 18:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793818479;
	bh=RHyK13KBwkxx4f0mFpWjdN2kRmymPzJL//qXpf17W2M=;
	h=Date:To:From:Subject;
	b=0FdHtyKjjrCzlBy7/2Mxa+7VGJ4B+6ZyAHZvb4CQtDYrR4XvNU8gcNPTB8p84KJ0u
	 Rfj/kno4/+8unoW5Du8uPOeV1PqHU6T12nSxuyIhP2JLzqT2wEDBW9bro+NzPjHN2R
	 urLT1r+IT4FQuEQr9R9npV2XSaYAzYXYM9VJmCPw=
Date: Wed, 04 Nov 2026 10:54:39 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,
	shakeel.butt@linux.dev,rostedt@goodmis.org,roman.gushchin@linux.dev,
	ridong.chen@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,
	mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,
	ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,
	david@fromorbit.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-add-lruvec_gen_size-helper.patch added to mm-new branch
Message-Id: <20261104185439.9DC5A1F00A16@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mglru: add lruvec_gen_size() helper
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-add-lruvec_gen_size-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-add-lruvec_gen_size-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm/mglru: add lruvec_gen_size() helper
Date: Wed, 04 Nov 2026 21:08:16 +0800

The number of pages of a given type in a generation is computed by
summing lrugen->nr_pages[gen][type][] over all zones and clamping each
per-zone counter to >= 0, since the counters are updated locklessly and
can transiently go negative. This loop is open-coded in
lruvec_evictable_size() and in the debugfs lru_gen output.

Add lruvec_gen_size() to compute it from a seq, and convert both users.
Put it in mm/vmscan.h so that the vmscan tracepoints, which include that
header, can use it as well.
An upcoming tracepoint and the MGLRU swappiness rework will also use it.

No functional change.

Link: https://lore.kernel.org/20261104130817.849089-7-ridong.chen@linux.dev
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ridong Chen <ridong.chen@linux.dev>
---

 mm/vmscan.c |   18 ++++++------------
 mm/vmscan.h |   16 ++++++++++++++++
 2 files changed, 22 insertions(+), 12 deletions(-)

--- a/mm/vmscan.c~mm-mglru-add-lruvec_gen_size-helper
+++ a/mm/vmscan.c
@@ -4195,18 +4195,15 @@ static void set_initial_priority(struct
 
 static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
 {
-	int gen, type, zone;
+	int type;
 	unsigned long seq, total = 0;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
 	for_each_evictable_type(type, swappiness) {
-		for (seq = min_seq[type]; seq <= max_seq; seq++) {
-			gen = lru_gen_from_seq(seq);
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
-		}
+		for (seq = min_seq[type]; seq <= max_seq; seq++)
+			total += lruvec_gen_size(lrugen, type, seq);
 	}
 
 	return total;
@@ -5688,20 +5685,17 @@ static int lru_gen_seq_show(struct seq_f
 		seq = 0;
 
 	for (; seq <= max_seq; seq++) {
-		int type, zone;
+		int type;
 		int gen = lru_gen_from_seq(seq);
 		unsigned long birth = READ_ONCE(lruvec->lrugen.timestamps[gen]);
 
 		seq_printf(m, " %10lu %10u", seq, jiffies_to_msecs(jiffies - birth));
 
 		for (type = 0; type < ANON_AND_FILE; type++) {
-			unsigned long size = 0;
 			char mark = full && seq < min_seq[type] ? 'x' : ' ';
 
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
-
-			seq_printf(m, " %10lu%c", size, mark);
+			seq_printf(m, " %10lu%c",
+				   lruvec_gen_size(lrugen, type, seq), mark);
 		}
 
 		seq_putc(m, '\n');
--- a/mm/vmscan.h~mm-mglru-add-lruvec_gen_size-helper
+++ a/mm/vmscan.h
@@ -3,6 +3,7 @@
 #define _MM_VMSCAN_H
 
 #include <linux/gfp_types.h>
+#include <linux/mm_inline.h>
 #include <linux/nodemask.h>
 #include <linux/swap.h>
 #include <linux/types.h>
@@ -115,4 +116,19 @@ struct scan_control {
 	struct reclaim_state reclaim_state;
 };
 
+#ifdef CONFIG_LRU_GEN
+/* The number of pages of @type in the generation @seq, summed over all zones */
+static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
+					    int type, unsigned long seq)
+{
+	int gen = lru_gen_from_seq(seq);
+	unsigned long size = 0;
+
+	for (int zone = 0; zone < MAX_NR_ZONES; zone++)
+		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+
+	return size;
+}
+#endif /* CONFIG_LRU_GEN */
+
 #endif /* _MM_VMSCAN_H */
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-migrate-move-nr_file_thps-on-cross-node-migration.patch
mm-migrate-move-nr_kernel_file_pages-on-cross-node-migration.patch
mm-memcontrol-drop-unused-vmscan-tracepoint-include.patch
mm-vmscan-move-vmscan-tracepoints-to-a-local-header.patch
mm-vmscan-move-struct-scan_control-to-a-dedicated-header.patch
mm-vmscan-pass-scan_control-to-the-vmscan-tracepoints.patch
mm-mglru-add-tracepoint-for-scan_folios.patch
mm-mglru-add-lruvec_gen_size-helper.patch
mm-mglru-add-tracepoint-for-aging.patch

