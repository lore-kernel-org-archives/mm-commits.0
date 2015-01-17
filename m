From: akpm@linux-foundation.org
Subject: +
 documentation-proc-add-proc-pid-numa_maps-interface-explanation-snippet.patch added to -mm tree
Date: Fri, 16 Jan 2015 16:06:10 -0800
Message-ID: <54b9a772.GzerQDpesd4rHx5/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbbAQAGL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jan 2015 19:06:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aquini@redhat.com, dave.hansen@linux.intel.com, hannes@cmpxchg.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/filesystems/proc.txt: add /proc/pid/numa_maps interface explanation snippet
has been added to the -mm tree.  Its filename is
     documentation-proc-add-proc-pid-numa_maps-interface-explanation-snippet.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-proc-add-proc-pid-numa_maps-interface-explanation-snippet.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-proc-add-proc-pid-numa_maps-interface-explanation-snippet.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rafael Aquini <aquini@redhat.com>
Subject: Documentation/filesystems/proc.txt: add /proc/pid/numa_maps interface explanation snippet

Add a small section to proc.txt doc in order to document its
/proc/pid/numa_maps interface.  It does not introduce any functional
changes, just documentation.

Signed-off-by: Rafael Aquini <aquini@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   33 +++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff -puN Documentation/filesystems/proc.txt~documentation-proc-add-proc-pid-numa_maps-interface-explanation-snippet Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~documentation-proc-add-proc-pid-numa_maps-interface-explanation-snippet
+++ a/Documentation/filesystems/proc.txt
@@ -144,6 +144,8 @@ Table 1-1: Process specific entries in /
  stack		Report full stack trace, enable via CONFIG_STACKTRACE
  smaps		a extension based on maps, showing the memory consumption of
 		each mapping and flags associated with it
+ numa_maps	an extension based on maps, showing the memory locality and
+		binding policy as well as mem usage (in pages) of each mapping.
 ..............................................................................
 
 For example, to get the status information of a process, all you have to do is
@@ -498,6 +500,37 @@ The /proc/pid/pagemap gives the PFN, whi
 using /proc/kpageflags and number of times a page is mapped using
 /proc/kpagecount. For detailed explanation, see Documentation/vm/pagemap.txt.
 
+The /proc/pid/numa_maps is an extension based on maps, showing the memory
+locality and binding policy, as well as the memory usage (in pages) of
+each mapping. The output follows a general format where mapping details get
+summarized separated by blank spaces, one mapping per each file line:
+
+address   policy    mapping details
+
+00400000 default file=/usr/local/bin/app kernelpagesize_kB=4 mapped=1 active=0 N3=1
+00600000 default file=/usr/local/bin/app kernelpagesize_kB=4 anon=1 dirty=1 N3=1
+3206000000 default file=/lib64/ld-2.12.so kernelpagesize_kB=4 mapped=26 mapmax=6 N0=24 N3=2
+320621f000 default file=/lib64/ld-2.12.so kernelpagesize_kB=4 anon=1 dirty=1 N3=1
+3206220000 default file=/lib64/ld-2.12.so kernelpagesize_kB=4 anon=1 dirty=1 N3=1
+3206221000 default kernelpagesize_kB=4 anon=1 dirty=1 N3=1
+3206800000 default file=/lib64/libc-2.12.so kernelpagesize_kB=4 mapped=59 mapmax=21 active=55 N0=41 N3=18
+320698b000 default file=/lib64/libc-2.12.so
+3206b8a000 default file=/lib64/libc-2.12.so kernelpagesize_kB=4 anon=2 dirty=2 N3=2
+3206b8e000 default file=/lib64/libc-2.12.so kernelpagesize_kB=4 anon=1 dirty=1 N3=1
+3206b8f000 default kernelpagesize_kB=4 anon=3 dirty=3 active=1 N3=3
+7f4dc10a2000 default kernelpagesize_kB=4 anon=3 dirty=3 N3=3
+7f4dc10b4000 default kernelpagesize_kB=4 anon=2 dirty=2 active=1 N3=2
+7f4dc1200000 default file=/anon_hugepage\040(deleted) huge kernelpagesize_kB=2048 anon=1 dirty=1 N3=1
+7fff335f0000 default stack kernelpagesize_kB=4 anon=3 dirty=3 N3=3
+7fff3369d000 default kernelpagesize_kB=4 mapped=1 mapmax=35 active=0 N3=1
+
+Where:
+"address" is the starting address for the mapping;
+"policy" reports the NUMA memory policy set for the mapping (see vm/numa_memory_policy.txt);
+"mapping details" summarizes mapping data such as mapping type, page usage counters,
+node locality page counters (N0 == node0, N1 == node1, ...) and the kernel page
+size, in KB, that is backing the mapping up.
+
 1.2 Kernel data
 ---------------
 
_

Patches currently in -mm which might be from aquini@redhat.com are

documentation-proc-add-proc-pid-numa_maps-interface-explanation-snippet.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps-fix.patch

