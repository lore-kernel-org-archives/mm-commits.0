From: akpm@linux-foundation.org
Subject: + seq_file-add-seq_set_overflow-seq_overflow.patch added to -mm tree
Date: Wed, 01 Feb 2012 13:09:53 -0800
Message-ID: <20120201210954.39C2AA016E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:33306 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289Ab2BAVJz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Feb 2012 16:09:55 -0500
Received: by ggnp1 with SMTP id p1so177516ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Feb 2012 13:09:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, eric.dumazet@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: seq_file: add seq_set_overflow(), seq_overflow()
has been added to the -mm tree.  Its filename is
     seq_file-add-seq_set_overflow-seq_overflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: seq_file: add seq_set_overflow(), seq_overflow()

It is undocumented but a seq_file's overflow state is indicated by
m->count == m->size.  Add seq_set_overflow() and seq_overflow() to
set/check overflow status explicitly.

Based on an idea from Eric Dumazet.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |   36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff -puN fs/seq_file.c~seq_file-add-seq_set_overflow-seq_overflow fs/seq_file.c
--- a/fs/seq_file.c~seq_file-add-seq_set_overflow-seq_overflow
+++ a/fs/seq_file.c
@@ -13,6 +13,22 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 
+
+/*
+ * seq file has a buffer but it may overflow. At overflow, larger buffer
+ * is re-allocated and all data will be printed, again.
+ * Now, overflow check is done by m->count == m->size.
+ */
+static bool seq_overflow(struct seq_file *m)
+{
+	return m->count == m->size;
+}
+
+static void seq_set_overflow(struct seq_file *m)
+{
+	m->count = m->size;
+}
+
 /**
  *	seq_open -	initialize sequential file
  *	@file: file we initialize
@@ -92,7 +108,7 @@ static int traverse(struct seq_file *m, 
 			error = 0;
 			m->count = 0;
 		}
-		if (m->count == m->size)
+		if (seq_overflow(m))
 			goto Eoverflow;
 		if (pos + m->count > offset) {
 			m->from = offset - pos;
@@ -234,7 +250,7 @@ Fill:
 			break;
 		}
 		err = m->op->show(m, p);
-		if (m->count == m->size || err) {
+		if (seq_overflow(m) || err) {
 			m->count = offs;
 			if (likely(err <= 0))
 				break;
@@ -361,7 +377,7 @@ int seq_escape(struct seq_file *m, const
 			*p++ = '0' + (c & 07);
 			continue;
 		}
-		m->count = m->size;
+		seq_set_overflow(m);
 		return -1;
         }
 	m->count = p - m->buf;
@@ -383,7 +399,7 @@ int seq_printf(struct seq_file *m, const
 			return 0;
 		}
 	}
-	m->count = m->size;
+	seq_set_overflow(m);
 	return -1;
 }
 EXPORT_SYMBOL(seq_printf);
@@ -512,7 +528,7 @@ int seq_bitmap(struct seq_file *m, const
 			return 0;
 		}
 	}
-	m->count = m->size;
+	seq_set_overflow(m);
 	return -1;
 }
 EXPORT_SYMBOL(seq_bitmap);
@@ -528,7 +544,7 @@ int seq_bitmap_list(struct seq_file *m, 
 			return 0;
 		}
 	}
-	m->count = m->size;
+	seq_set_overflow(m);
 	return -1;
 }
 EXPORT_SYMBOL(seq_bitmap_list);
@@ -639,7 +655,7 @@ int seq_puts(struct seq_file *m, const c
 		m->count += len;
 		return 0;
 	}
-	m->count = m->size;
+	seq_set_overflow(m);
 	return -1;
 }
 EXPORT_SYMBOL(seq_puts);
@@ -673,7 +689,7 @@ int seq_put_decimal_ull(struct seq_file 
 	m->count += len;
 	return 0;
 overflow:
-	m->count = m->size;
+	seq_set_overflow(m);
 	return -1;
 }
 EXPORT_SYMBOL(seq_put_decimal_ull);
@@ -683,7 +699,7 @@ int seq_put_decimal_ll(struct seq_file *
 {
 	if (num < 0) {
 		if (m->count + 3 >= m->size) {
-			m->count = m->size;
+			seq_set_overflow(m);
 			return -1;
 		}
 		if (delimiter)
@@ -711,7 +727,7 @@ int seq_write(struct seq_file *seq, cons
 		seq->count += len;
 		return 0;
 	}
-	seq->count = seq->size;
+	seq_set_overflow(seq);
 	return -1;
 }
 EXPORT_SYMBOL(seq_write);
_
Subject: Subject: seq_file: add seq_set_overflow(), seq_overflow()

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-postpone-migrated-page-mapping-reset.patch
linux-next.patch
mm-memcontrolc-fix-warning-with-config_numa=n.patch
mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm.patch
mm-oom-fold-oom_kill_task-into-oom_kill_process.patch
mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch
mm-add-rss-counters-consistency-check.patch
mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch
mm-make-get_mm_counter-static-inline.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch
idr-make-idr_get_next-good-for-rcu_read_lock.patch
cgroup-revert-ss_id_lock-to-spinlock.patch
memcg-let-css_get_next-rely-upon-rcu_read_lock.patch
memcg-remove-pcg_cache-page_cgroup-flag.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
proc-speedup-proc-stat-handling.patch
procfs-add-num_to_str-to-speed-up-proc-stat.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix-2.patch
procfs-speed-up-proc-pid-stat-statm.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch

