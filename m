From: akpm@linux-foundation.org
Subject: [merged] seq_file-add-seq_set_overflow-seq_overflow.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:52 -0700
Message-ID: <20120326193252.69ACFA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:62114 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab2CZTcx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:53 -0400
Received: by mail-yx0-f202.google.com with SMTP id q2so832475yen.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, eric.dumazet@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: seq_file: add seq_set_overflow(), seq_overflow()
has been removed from the -mm tree.  Its filename was
     seq_file-add-seq_set_overflow-seq_overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: seq_file: add seq_set_overflow(), seq_overflow()

It is undocumented but a seq_file's overflow state is indicated by
m->count == m->size.  Add seq_set_overflow() and seq_overflow() to
set/check overflow status explicitly.

Based on an idea from Eric Dumazet.

[akpm@linux-foundation.org: tweak code comment]
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
+ * seq_files have a buffer which can may overflow. When this happens a larger
+ * buffer is reallocated and all the data will be printed again.
+ * The overflow state is true when m->count == m->size.
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

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-coredump-fail-allocations-when-coredumping-instead-of-oom-killing.patch
memcg-change-behavior-of-moving-charges-at-task-move.patch
memcg-change-behavior-of-moving-charges-at-task-move-fix.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch

