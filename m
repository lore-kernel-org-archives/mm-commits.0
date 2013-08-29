From: akpm@linux-foundation.org
Subject: [merged] timer_list-correct-the-iterator-for-timer_list.patch
 removed from -mm tree
Date: Thu, 29 Aug 2013 12:42:55 -0700
Message-ID: <521fa43f.Wqgrum6vdSQlpb22%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218Ab3H2Tm4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Aug 2013 15:42:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tglx@linutronix.de, stable@vger.kernel.org, john.stultz@linaro.org, jlayton@redhat.com, holger@freyther.de, berke.durak@xiphos.com, nzimmer@sgi.com

Subject: [merged] timer_list-correct-the-iterator-for-timer_list.patch removed from -mm tree
To: nzimmer@sgi.com,berke.durak@xiphos.com,holger@freyther.de,jlayton@redhat.com,john.stultz@linaro.org,stable@vger.kernel.org,tglx@linutronix.de,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 29 Aug 2013 12:42:55 -0700


The patch titled
     Subject: timer_list: correct the iterator for timer_list
has been removed from the -mm tree.  Its filename was
     timer_list-correct-the-iterator-for-timer_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nathan Zimmer <nzimmer@sgi.com>
Subject: timer_list: correct the iterator for timer_list

Correct the issue with /proc/timer_list reported by Holger.  When reading
from the proc file with a sufficiently small buffer, 2k so not really that
small, there was one could get hung trying to read the file a chunk at a
time.

The timer_list_start function failed to account for the possibility that
the offset was adjusted outside the timer_list_next.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Reported-by: Holger Hans Peter Freyther <holger@freyther.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Berke Durak <berke.durak@xiphos.com>
Cc: Jeff Layton <jlayton@redhat.com>
Tested-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org> # 3.10.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timer_list.c |   41 +++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff -puN kernel/time/timer_list.c~timer_list-correct-the-iterator-for-timer_list kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~timer_list-correct-the-iterator-for-timer_list
+++ a/kernel/time/timer_list.c
@@ -265,10 +265,9 @@ static inline void timer_list_header(str
 static int timer_list_show(struct seq_file *m, void *v)
 {
 	struct timer_list_iter *iter = v;
-	u64 now = ktime_to_ns(ktime_get());
 
 	if (iter->cpu == -1 && !iter->second_pass)
-		timer_list_header(m, now);
+		timer_list_header(m, iter->now);
 	else if (!iter->second_pass)
 		print_cpu(m, iter->cpu, iter->now);
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
@@ -298,33 +297,41 @@ void sysrq_timer_list_show(void)
 	return;
 }
 
-static void *timer_list_start(struct seq_file *file, loff_t *offset)
+static void *move_iter(struct timer_list_iter *iter, loff_t offset)
 {
-	struct timer_list_iter *iter = file->private;
-
-	if (!*offset) {
-		iter->cpu = -1;
-		iter->now = ktime_to_ns(ktime_get());
-	} else if (iter->cpu >= nr_cpu_ids) {
+	for (; offset; offset--) {
+		iter->cpu = cpumask_next(iter->cpu, cpu_online_mask);
+		if (iter->cpu >= nr_cpu_ids) {
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
-		if (!iter->second_pass) {
-			iter->cpu = -1;
-			iter->second_pass = true;
-		} else
-			return NULL;
+			if (!iter->second_pass) {
+				iter->cpu = -1;
+				iter->second_pass = true;
+			} else
+				return NULL;
 #else
-		return NULL;
+			return NULL;
 #endif
+		}
 	}
 	return iter;
 }
 
+static void *timer_list_start(struct seq_file *file, loff_t *offset)
+{
+	struct timer_list_iter *iter = file->private;
+
+	if (!*offset)
+		iter->now = ktime_to_ns(ktime_get());
+	iter->cpu = -1;
+	iter->second_pass = false;
+	return move_iter(iter, *offset);
+}
+
 static void *timer_list_next(struct seq_file *file, void *v, loff_t *offset)
 {
 	struct timer_list_iter *iter = file->private;
-	iter->cpu = cpumask_next(iter->cpu, cpu_online_mask);
 	++*offset;
-	return timer_list_start(file, offset);
+	return move_iter(iter, 1);
 }
 
 static void timer_list_stop(struct seq_file *seq, void *v)
_

Patches currently in -mm which might be from nzimmer@sgi.com are

origin.patch

