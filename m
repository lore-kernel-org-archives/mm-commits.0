From: akpm@linux-foundation.org
Subject: + documentation-update-tracepoint-analysistxt.patch added to -mm tree
Date: Tue, 22 Dec 2009 14:41:48 -0800
Message-ID: <200912222241.nBMMfmea028680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751565AbZLVWmV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Dec 2009 17:42:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mel@csn.ul.ie, rostedt@goodmis.org


The patch titled
     Documentation: update tracepoint-analysis.txt
has been added to the -mm tree.  Its filename is
     documentation-update-tracepoint-analysistxt.patch

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
Subject: Documentation: update tracepoint-analysis.txt
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix grammar, spelling, punctuation, hyphenation, section numbering.  Tell
what PCL means.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/tracepoint-analysis.txt |   60 +++++++++---------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff -puN Documentation/trace/tracepoint-analysis.txt~documentation-update-tracepoint-analysistxt Documentation/trace/tracepoint-analysis.txt
--- a/Documentation/trace/tracepoint-analysis.txt~documentation-update-tracepoint-analysistxt
+++ a/Documentation/trace/tracepoint-analysis.txt
@@ -10,8 +10,8 @@ Tracepoints (see Documentation/trace/tra
 creating custom kernel modules to register probe functions using the event
 tracing infrastructure.
 
-Simplistically, tracepoints will represent an important event that when can
-be taken in conjunction with other tracepoints to build a "Big Picture" of
+Simplistically, tracepoints represent important events that can be
+taken in conjunction with other tracepoints to build a "Big Picture" of
 what is going on within the system. There are a large number of methods for
 gathering and interpreting these events. Lacking any current Best Practises,
 this document describes some of the methods that can be used.
@@ -33,12 +33,12 @@ calling
 
 will give a fair indication of the number of events available.
 
-2.2 PCL
+2.2 PCL (Performance Counters for Linux)
 -------
 
-Discovery and enumeration of all counters and events, including tracepoints
+Discovery and enumeration of all counters and events, including tracepoints,
 are available with the perf tool. Getting a list of available events is a
-simple case of
+simple case of:
 
   $ perf list 2>&1 | grep Tracepoint
   ext4:ext4_free_inode                     [Tracepoint event]
@@ -49,19 +49,19 @@ simple case of
   [ .... remaining output snipped .... ]
 
 
-2. Enabling Events
+3. Enabling Events
 ==================
 
-2.1 System-Wide Event Enabling
+3.1 System-Wide Event Enabling
 ------------------------------
 
 See Documentation/trace/events.txt for a proper description on how events
 can be enabled system-wide. A short example of enabling all events related
-to page allocation would look something like
+to page allocation would look something like:
 
   $ for i in `find /sys/kernel/debug/tracing/events -name "enable" | grep mm_`; do echo 1 > $i; done
 
-2.2 System-Wide Event Enabling with SystemTap
+3.2 System-Wide Event Enabling with SystemTap
 ---------------------------------------------
 
 In SystemTap, tracepoints are accessible using the kernel.trace() function
@@ -86,7 +86,7 @@ were allocating the pages.
           print_count()
   }
 
-2.3 System-Wide Event Enabling with PCL
+3.3 System-Wide Event Enabling with PCL
 ---------------------------------------
 
 By specifying the -a switch and analysing sleep, the system-wide events
@@ -107,16 +107,16 @@ for a duration of time can be examined.
 Similarly, one could execute a shell and exit it as desired to get a report
 at that point.
 
-2.4 Local Event Enabling
+3.4 Local Event Enabling
 ------------------------
 
 Documentation/trace/ftrace.txt describes how to enable events on a per-thread
 basis using set_ftrace_pid.
 
-2.5 Local Event Enablement with PCL
+3.5 Local Event Enablement with PCL
 -----------------------------------
 
-Events can be activate and tracked for the duration of a process on a local
+Events can be activated and tracked for the duration of a process on a local
 basis using PCL such as follows.
 
   $ perf stat -e kmem:mm_page_alloc -e kmem:mm_page_free_direct \
@@ -131,18 +131,18 @@ basis using PCL such as follows.
 
     0.973913387  seconds time elapsed
 
-3. Event Filtering
+4. Event Filtering
 ==================
 
 Documentation/trace/ftrace.txt covers in-depth how to filter events in
 ftrace.  Obviously using grep and awk of trace_pipe is an option as well
 as any script reading trace_pipe.
 
-4. Analysing Event Variances with PCL
+5. Analysing Event Variances with PCL
 =====================================
 
 Any workload can exhibit variances between runs and it can be important
-to know what the standard deviation in. By and large, this is left to the
+to know what the standard deviation is. By and large, this is left to the
 performance analyst to do it by hand. In the event that the discrete event
 occurrences are useful to the performance analyst, then perf can be used.
 
@@ -166,7 +166,7 @@ In the event that some higher-level even
 aggregation of discrete events, then a script would need to be developed.
 
 Using --repeat, it is also possible to view how events are fluctuating over
-time on a system wide basis using -a and sleep.
+time on a system-wide basis using -a and sleep.
 
   $ perf stat -e kmem:mm_page_alloc -e kmem:mm_page_free_direct \
 		-e kmem:mm_pagevec_free \
@@ -180,7 +180,7 @@ time on a system wide basis using -a and
 
     1.002251757  seconds time elapsed   ( +-   0.005% )
 
-5. Higher-Level Analysis with Helper Scripts
+6. Higher-Level Analysis with Helper Scripts
 ============================================
 
 When events are enabled the events that are triggering can be read from
@@ -190,11 +190,11 @@ be gathered on-line as appropriate. Exam
 
   o Reading information from /proc for the PID that triggered the event
   o Deriving a higher-level event from a series of lower-level events.
-  o Calculate latencies between two events
+  o Calculating latencies between two events
 
 Documentation/trace/postprocess/trace-pagealloc-postprocess.pl is an example
 script that can read trace_pipe from STDIN or a copy of a trace. When used
-on-line, it can be interrupted once to generate a report without existing
+on-line, it can be interrupted once to generate a report without exiting
 and twice to exit.
 
 Simplistically, the script just reads STDIN and counts up events but it
@@ -212,12 +212,12 @@ also can do more such as
     processes, the parent process responsible for creating all the helpers
     can be identified
 
-6. Lower-Level Analysis with PCL
+7. Lower-Level Analysis with PCL
 ================================
 
-There may also be a requirement to identify what functions with a program
+There may also be a requirement to identify what functions within a program
 were generating events within the kernel. To begin this sort of analysis, the
-data must be recorded. At the time of writing, this required root
+data must be recorded. At the time of writing, this required root:
 
   $ perf record -c 1 \
 	-e kmem:mm_page_alloc -e kmem:mm_page_free_direct \
@@ -253,11 +253,11 @@ perf report.
   # (For more details, try: perf report --sort comm,dso,symbol)
   #
 
-According to this, the vast majority of events occured triggered on events
-within the VDSO. With simple binaries, this will often be the case so lets
+According to this, the vast majority of events triggered on events
+within the VDSO. With simple binaries, this will often be the case so let's
 take a slightly different example. In the course of writing this, it was
-noticed that X was generating an insane amount of page allocations so lets look
-at it
+noticed that X was generating an insane amount of page allocations so let's look
+at it:
 
   $ perf record -c 1 -f \
 		-e kmem:mm_page_alloc -e kmem:mm_page_free_direct \
@@ -280,8 +280,8 @@ This was interrupted after a few seconds
   # (For more details, try: perf report --sort comm,dso,symbol)
   #
 
-So, almost half of the events are occuring in a library. To get an idea which
-symbol.
+So, almost half of the events are occurring in a library. To get an idea which
+symbol:
 
   $ perf report --sort comm,dso,symbol
   # Samples: 27666
@@ -297,7 +297,7 @@ symbol.
        0.01%     Xorg  /opt/gfx-test/lib/libpixman-1.so.0.13.1  [.] get_fast_path
        0.00%     Xorg  [kernel]                                 [k] ftrace_trace_userstack
 
-To see where within the function pixmanFillsse2 things are going wrong
+To see where within the function pixmanFillsse2 things are going wrong:
 
   $ perf annotate pixmanFillsse2
   [ ... ]
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
lib-stringc-fix-kernel-doc-warnings.patch
mm-tracing-cleanup-documentation-trace-events-kmemtxt.patch
docs-large-update-to-ioctl-numbertxt.patch
documentation-update-mmiotracetxt.patch
documentation-update-tracepoint-analysistxt.patch
documentation-update-ftrace-designtxt.patch
documentation-update-ring-buffer-designtxt.patch
linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

