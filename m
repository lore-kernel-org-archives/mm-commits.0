From: akpm@linux-foundation.org
Subject: + mm-tracepoint-fixup-documentation-and-examples.patch added to -mm tree
Date: Mon, 14 Nov 2011 15:31:04 -0800
Message-ID: <201111142331.pAENV4Ou018521@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:35954 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab1KNXbG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2011 18:31:06 -0500
Received: by ywb5 with SMTP id 5so667434ywb.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2011 15:31:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     Subject: mm-tracepoint: fix documentation and examples
has been added to the -mm tree.  Its filename is
     mm-tracepoint-fixup-documentation-and-examples.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm-tracepoint: fix documentation and examples

We renamed the page-free mm tracepoints.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/tracepoint-analysis.txt |   40 +++++++++---------
 tools/perf/Documentation/examples.txt       |   34 +++++++--------
 2 files changed, 37 insertions(+), 37 deletions(-)

diff -puN Documentation/trace/tracepoint-analysis.txt~mm-tracepoint-fixup-documentation-and-examples Documentation/trace/tracepoint-analysis.txt
--- a/Documentation/trace/tracepoint-analysis.txt~mm-tracepoint-fixup-documentation-and-examples
+++ a/Documentation/trace/tracepoint-analysis.txt
@@ -93,14 +93,14 @@ By specifying the -a switch and analysin
 for a duration of time can be examined.
 
  $ perf stat -a \
-	-e kmem:mm_page_alloc -e kmem:mm_page_free_direct \
-	-e kmem:mm_pagevec_free \
+	-e kmem:mm_page_alloc -e kmem:mm_page_free \
+	-e kmem:mm_page_free_batched \
 	sleep 10
  Performance counter stats for 'sleep 10':
 
            9630  kmem:mm_page_alloc
-           2143  kmem:mm_page_free_direct
-           7424  kmem:mm_pagevec_free
+           2143  kmem:mm_page_free
+           7424  kmem:mm_page_free_batched
 
    10.002577764  seconds time elapsed
 
@@ -119,15 +119,15 @@ basis using set_ftrace_pid.
 Events can be activated and tracked for the duration of a process on a local
 basis using PCL such as follows.
 
-  $ perf stat -e kmem:mm_page_alloc -e kmem:mm_page_free_direct \
-		 -e kmem:mm_pagevec_free ./hackbench 10
+  $ perf stat -e kmem:mm_page_alloc -e kmem:mm_page_free \
+		 -e kmem:mm_page_free_batched ./hackbench 10
   Time: 0.909
 
     Performance counter stats for './hackbench 10':
 
           17803  kmem:mm_page_alloc
-          12398  kmem:mm_page_free_direct
-           4827  kmem:mm_pagevec_free
+          12398  kmem:mm_page_free
+           4827  kmem:mm_page_free_batched
 
     0.973913387  seconds time elapsed
 
@@ -146,8 +146,8 @@ to know what the standard deviation is. 
 performance analyst to do it by hand. In the event that the discrete event
 occurrences are useful to the performance analyst, then perf can be used.
 
-  $ perf stat --repeat 5 -e kmem:mm_page_alloc -e kmem:mm_page_free_direct
-			-e kmem:mm_pagevec_free ./hackbench 10
+  $ perf stat --repeat 5 -e kmem:mm_page_alloc -e kmem:mm_page_free
+			-e kmem:mm_page_free_batched ./hackbench 10
   Time: 0.890
   Time: 0.895
   Time: 0.915
@@ -157,8 +157,8 @@ occurrences are useful to the performanc
    Performance counter stats for './hackbench 10' (5 runs):
 
           16630  kmem:mm_page_alloc         ( +-   3.542% )
-          11486  kmem:mm_page_free_direct   ( +-   4.771% )
-           4730  kmem:mm_pagevec_free       ( +-   2.325% )
+          11486  kmem:mm_page_free	    ( +-   4.771% )
+           4730  kmem:mm_page_free_batched  ( +-   2.325% )
 
     0.982653002  seconds time elapsed   ( +-   1.448% )
 
@@ -168,15 +168,15 @@ aggregation of discrete events, then a s
 Using --repeat, it is also possible to view how events are fluctuating over
 time on a system-wide basis using -a and sleep.
 
-  $ perf stat -e kmem:mm_page_alloc -e kmem:mm_page_free_direct \
-		-e kmem:mm_pagevec_free \
+  $ perf stat -e kmem:mm_page_alloc -e kmem:mm_page_free \
+		-e kmem:mm_page_free_batched \
 		-a --repeat 10 \
 		sleep 1
   Performance counter stats for 'sleep 1' (10 runs):
 
            1066  kmem:mm_page_alloc         ( +-  26.148% )
-            182  kmem:mm_page_free_direct   ( +-   5.464% )
-            890  kmem:mm_pagevec_free       ( +-  30.079% )
+            182  kmem:mm_page_free          ( +-   5.464% )
+            890  kmem:mm_page_free_batched  ( +-  30.079% )
 
     1.002251757  seconds time elapsed   ( +-   0.005% )
 
@@ -220,8 +220,8 @@ were generating events within the kernel
 data must be recorded. At the time of writing, this required root:
 
   $ perf record -c 1 \
-	-e kmem:mm_page_alloc -e kmem:mm_page_free_direct \
-	-e kmem:mm_pagevec_free \
+	-e kmem:mm_page_alloc -e kmem:mm_page_free \
+	-e kmem:mm_page_free_batched \
 	./hackbench 10
   Time: 0.894
   [ perf record: Captured and wrote 0.733 MB perf.data (~32010 samples) ]
@@ -260,8 +260,8 @@ noticed that X was generating an insane 
 at it:
 
   $ perf record -c 1 -f \
-		-e kmem:mm_page_alloc -e kmem:mm_page_free_direct \
-		-e kmem:mm_pagevec_free \
+		-e kmem:mm_page_alloc -e kmem:mm_page_free \
+		-e kmem:mm_page_free_batched \
 		-p `pidof X`
 
 This was interrupted after a few seconds and
diff -puN tools/perf/Documentation/examples.txt~mm-tracepoint-fixup-documentation-and-examples tools/perf/Documentation/examples.txt
--- a/tools/perf/Documentation/examples.txt~mm-tracepoint-fixup-documentation-and-examples
+++ a/tools/perf/Documentation/examples.txt
@@ -17,8 +17,8 @@ titan:~> perf list
   kmem:kmem_cache_alloc_node               [Tracepoint event]
   kmem:kfree                               [Tracepoint event]
   kmem:kmem_cache_free                     [Tracepoint event]
-  kmem:mm_page_free_direct                 [Tracepoint event]
-  kmem:mm_pagevec_free                     [Tracepoint event]
+  kmem:mm_page_free                        [Tracepoint event]
+  kmem:mm_page_free_batched                [Tracepoint event]
   kmem:mm_page_alloc                       [Tracepoint event]
   kmem:mm_page_alloc_zone_locked           [Tracepoint event]
   kmem:mm_page_pcpu_drain                  [Tracepoint event]
@@ -29,15 +29,15 @@ measured. For example the page alloc/fre
 run' are:
 
  titan:~> perf stat -e kmem:mm_page_pcpu_drain -e kmem:mm_page_alloc
- -e kmem:mm_pagevec_free -e kmem:mm_page_free_direct ./hackbench 10
+ -e kmem:mm_page_free_batched -e kmem:mm_page_free ./hackbench 10
  Time: 0.575
 
  Performance counter stats for './hackbench 10':
 
           13857  kmem:mm_page_pcpu_drain
           27576  kmem:mm_page_alloc
-           6025  kmem:mm_pagevec_free
-          20934  kmem:mm_page_free_direct
+           6025  kmem:mm_page_free_batched
+          20934  kmem:mm_page_free
 
     0.613972165  seconds time elapsed
 
@@ -45,8 +45,8 @@ You can observe the statistical properti
 'repeat the workload N times' feature of perf stat:
 
  titan:~> perf stat --repeat 5 -e kmem:mm_page_pcpu_drain -e
-   kmem:mm_page_alloc -e kmem:mm_pagevec_free -e
-   kmem:mm_page_free_direct ./hackbench 10
+   kmem:mm_page_alloc -e kmem:mm_page_free_batched -e
+   kmem:mm_page_free ./hackbench 10
  Time: 0.627
  Time: 0.644
  Time: 0.564
@@ -57,8 +57,8 @@ You can observe the statistical properti
 
           12920  kmem:mm_page_pcpu_drain    ( +-   3.359% )
           25035  kmem:mm_page_alloc         ( +-   3.783% )
-           6104  kmem:mm_pagevec_free       ( +-   0.934% )
-          18376  kmem:mm_page_free_direct   ( +-   4.941% )
+           6104  kmem:mm_page_free_batched  ( +-   0.934% )
+          18376  kmem:mm_page_free	    ( +-   4.941% )
 
     0.643954516  seconds time elapsed   ( +-   2.363% )
 
@@ -158,15 +158,15 @@ Or you can observe the whole system's pa
 seconds:
 
 titan:~/git> perf stat -a -e kmem:mm_page_pcpu_drain -e
-kmem:mm_page_alloc -e kmem:mm_pagevec_free -e
-kmem:mm_page_free_direct sleep 10
+kmem:mm_page_alloc -e kmem:mm_page_free_batched -e
+kmem:mm_page_free sleep 10
 
  Performance counter stats for 'sleep 10':
 
          171585  kmem:mm_page_pcpu_drain
          322114  kmem:mm_page_alloc
-          73623  kmem:mm_pagevec_free
-         254115  kmem:mm_page_free_direct
+          73623  kmem:mm_page_free_batched
+         254115  kmem:mm_page_free
 
    10.000591410  seconds time elapsed
 
@@ -174,15 +174,15 @@ Or observe how fluctuating the page allo
 analysis done over ten 1-second intervals:
 
  titan:~/git> perf stat --repeat 10 -a -e kmem:mm_page_pcpu_drain -e
-   kmem:mm_page_alloc -e kmem:mm_pagevec_free -e
-   kmem:mm_page_free_direct sleep 1
+   kmem:mm_page_alloc -e kmem:mm_page_free_batched -e
+   kmem:mm_page_free sleep 1
 
  Performance counter stats for 'sleep 1' (10 runs):
 
           17254  kmem:mm_page_pcpu_drain    ( +-   3.709% )
           34394  kmem:mm_page_alloc         ( +-   4.617% )
-           7509  kmem:mm_pagevec_free       ( +-   4.820% )
-          25653  kmem:mm_page_free_direct   ( +-   3.672% )
+           7509  kmem:mm_page_free_batched  ( +-   4.820% )
+          25653  kmem:mm_page_free	    ( +-   3.672% )
 
     1.058135029  seconds time elapsed   ( +-   3.089% )
 
_
Subject: Subject: mm-tracepoint: fix documentation and examples

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
vmscan-fix-initial-shrinker-size-handling.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-add-free_hot_cold_page_list-helper.patch
mm-add-free_hot_cold_page_list-helper-v2.patch
mm-add-free_hot_cold_page_list-helper-v3.patch
mm-remove-unused-pagevec_free.patch
mm-tracepoint-rename-page-free-events.patch
mm-tracepoint-fixup-documentation-and-examples.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch

