From: akpm@linux-foundation.org
Subject: + mm-make-get_mm_counter-static-inline.patch added to -mm tree
Date: Fri, 20 Jan 2012 15:36:41 -0800
Message-ID: <20120120233641.9D3F11E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:45383 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab2ATXgm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 18:36:42 -0500
Received: by yhjj52 with SMTP id j52so104309yhj.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 15:36:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name


The patch titled
     Subject: mm: make get_mm_counter static-inline
has been added to the -mm tree.  Its filename is
     mm-make-get_mm_counter-static-inline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: make get_mm_counter static-inline

Make get_mm_counter() always static inline, it is simple enough for that. 
And remove unused set_mm_counter()

bloat-o-meter:

add/remove: 0/1 grow/shrink: 4/12 up/down: 99/-341 (-242)
function                                     old     new   delta
try_to_unmap_one                             886     952     +66
sys_remap_file_pages                        1214    1230     +16
dup_mm                                      1684    1700     +16
do_exit                                     2277    2278      +1
zap_page_range                               208     205      -3
unmap_region                                 304     296      -8
static.oom_kill_process                      554     546      -8
try_to_unmap_file                           1716    1700     -16
getrusage                                    925     909     -16
flush_old_exec                              1704    1688     -16
static.dump_header                           416     390     -26
acct_update_integrals                        218     187     -31
do_task_stat                                2986    2954     -32
get_mm_counter                                34       -     -34
xacct_add_tsk                                371     334     -37
task_statm                                   172     118     -54
task_mem                                     383     323     -60

try_to_unmap_one() grows because update_hiwater_rss() now completely inline.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   21 +++++++++++----------
 mm/memory.c        |   18 ------------------
 2 files changed, 11 insertions(+), 28 deletions(-)

diff -puN include/linux/mm.h~mm-make-get_mm_counter-static-inline include/linux/mm.h
--- a/include/linux/mm.h~mm-make-get_mm_counter-static-inline
+++ a/include/linux/mm.h
@@ -1058,19 +1058,20 @@ int __get_user_pages_fast(unsigned long 
 /*
  * per-process(per-mm_struct) statistics.
  */
-static inline void set_mm_counter(struct mm_struct *mm, int member, long value)
-{
-	atomic_long_set(&mm->rss_stat.count[member], value);
-}
-
-#if defined(SPLIT_RSS_COUNTING)
-unsigned long get_mm_counter(struct mm_struct *mm, int member);
-#else
 static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
 {
-	return atomic_long_read(&mm->rss_stat.count[member]);
-}
+	long val = atomic_long_read(&mm->rss_stat.count[member]);
+
+#ifdef SPLIT_RSS_COUNTING
+	/*
+	 * counter is updated in asynchronous manner and may go to minus.
+	 * But it's never be expected number for users.
+	 */
+	if (val < 0)
+		val = 0;
 #endif
+	return (unsigned long)val;
+}
 
 static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
 {
diff -puN mm/memory.c~mm-make-get_mm_counter-static-inline mm/memory.c
--- a/mm/memory.c~mm-make-get_mm_counter-static-inline
+++ a/mm/memory.c
@@ -160,24 +160,6 @@ static void check_sync_rss_stat(struct t
 		__sync_task_rss_stat(task, task->mm);
 }
 
-unsigned long get_mm_counter(struct mm_struct *mm, int member)
-{
-	long val = 0;
-
-	/*
-	 * Don't use task->mm here...for avoiding to use task_get_mm()..
-	 * The caller must guarantee task->mm is not invalid.
-	 */
-	val = atomic_long_read(&mm->rss_stat.count[member]);
-	/*
-	 * counter is updated in asynchronous manner and may go to minus.
-	 * But it's never be expected number for users.
-	 */
-	if (val < 0)
-		return 0;
-	return (unsigned long)val;
-}
