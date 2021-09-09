Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6140BC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 433B7611C0
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346074AbhIIVFE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349239AbhIIVEO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:04:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C84D7611C0;
        Thu,  9 Sep 2021 21:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221384;
        bh=8EXRXXmAx6rcWs7nSPkqiGW7PgOcX4LdMYllN2Q8VGM=;
        h=Date:From:To:Subject:From;
        b=dQ3U399zSsTbuZxMcbJ0NqlgiHXCYGtaBj0kdNi6LIkyaSwqxEysl49XQyO/MJEDK
         uoWHjPvHQV9LNHcin4amMI/2+cZG5qDY3pD5sT+g7BKPiUSnGLWXm6zQ/AJRt6Mkuw
         6TQy2W1JTYp5YPqJNc5okInQdLWlkQSQ+WJkQbcQ=
Date:   Thu, 09 Sep 2021 14:03:03 -0700
From:   akpm@linux-foundation.org
To:     alexander.shishkin@linux.intel.com, amit@kernel.org,
        benh@kernel.crashing.org, brendanhiggins@google.com,
        corbet@lwn.net, david@redhat.com, dwmw@amazon.com,
        elver@google.com, fan.du@intel.com, foersleo@amazon.de,
        greg@kroah.com, gthelen@google.com, joe@perches.com,
        Jonathan.Cameron@huawei.com, markubo@amazon.de, mgorman@suse.de,
        mheyne@amazon.de, minchan@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, namhyung@kernel.org,
        peterz@infradead.org, riel@surriel.com, rientjes@google.com,
        rostedt@goodmis.org, shakeelb@google.com, shuah@kernel.org,
        sieberf@amazon.com, sjpark@amazon.de, vbabka@suse.cz,
        vdavydov.dev@gmail.com
Subject:  [merged] documentation-add-documents-for-damon.patch
 removed from -mm tree
Message-ID: <20210909210303.VwnZFDtIf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: add documents for DAMON
has been removed from the -mm tree.  Its filename was
     documentation-add-documents-for-damon.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: SeongJae Park <sjpark@amazon.de>
Subject: Documentation: add documents for DAMON

This commit adds documents for DAMON under
`Documentation/admin-guide/mm/damon/` and `Documentation/vm/damon/`.

Link: https://lkml.kernel.org/r/20210716081449.22187-11-sj38.park@gmail.com
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reviewed-by: Fernand Sieber <sieberf@amazon.com>
Reviewed-by: Markus Boehme <markubo@amazon.de>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Fan Du <fan.du@intel.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Marco Elver <elver@google.com>
Cc: Maximilian Heyne <mheyne@amazon.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/index.rst |   15 +
 Documentation/admin-guide/mm/damon/start.rst |  114 +++++++++++
 Documentation/admin-guide/mm/damon/usage.rst |  112 +++++++++++
 Documentation/admin-guide/mm/index.rst       |    1=20
 Documentation/vm/damon/api.rst               |   20 ++
 Documentation/vm/damon/design.rst            |  166 +++++++++++++++++
 Documentation/vm/damon/faq.rst               |   51 +++++
 Documentation/vm/damon/index.rst             |   30 +++
 Documentation/vm/index.rst                   |    1=20
 9 files changed, 510 insertions(+)

--- /dev/null
+++ a/Documentation/admin-guide/mm/damon/index.rst
@@ -0,0 +1,15 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+Monitoring Data Accesses
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+:doc:`DAMON </vm/damon/index>` allows light-weight data access monitoring.
+Using DAMON, users can analyze the memory access patterns of their systems=
 and
+optimize those.
+
+.. toctree::
+   :maxdepth: 2
+
+   start
+   usage
--- /dev/null
+++ a/Documentation/admin-guide/mm/damon/start.rst
@@ -0,0 +1,114 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+Getting Started
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+This document briefly describes how you can use DAMON by demonstrating its
+default user space tool.  Please note that this document describes only a =
part
+of its features for brevity.  Please refer to :doc:`usage` for more detail=
s.
+
+
+TL; DR
+=3D=3D=3D=3D=3D=3D
+
+Follow the commands below to monitor and visualize the memory access patte=
rn of
+your workload. ::
+
+    # # build the kernel with CONFIG_DAMON_*=3Dy, install it, and reboot
+    # mount -t debugfs none /sys/kernel/debug/
+    # git clone https://github.com/awslabs/damo
+    # ./damo/damo record $(pidof <your workload>)
+    # ./damo/damo report heat --plot_ascii
+
+The final command draws the access heatmap of ``<your workload>``.  The he=
atmap
+shows which memory region (x-axis) is accessed when (y-axis) and how frequ=
ently
+(number; the higher the more accesses have been observed). ::
+
+    111111111111111111111111111111111111111111111111111111110000
+    111121111111111111111111111111211111111111111111111111110000
+    000000000000000000000000000000000000000000000000001555552000
+    000000000000000000000000000000000000000000000222223555552000
+    000000000000000000000000000000000000000011111677775000000000
+    000000000000000000000000000000000000000488888000000000000000
+    000000000000000000000000000000000177888400000000000000000000
+    000000000000000000000000000046666522222100000000000000000000
+    000000000000000000000014444344444300000000000000000000000000
+    000000000000000002222245555510000000000000000000000000000000
+    # access_frequency:  0  1  2  3  4  5  6  7  8  9
+    # x-axis: space (140286319947776-140286426374096: 101.496 MiB)
+    # y-axis: time (605442256436361-605479951866441: 37.695430s)
+    # resolution: 60x10 (1.692 MiB and 3.770s for each character)
+
+
+Prerequisites
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Kernel
+------
+
+You should first ensure your system is running on a kernel built with
+``CONFIG_DAMON_*=3Dy``.
+
+
+User Space Tool
+---------------
+
+For the demonstration, we will use the default user space tool for DAMON,
+called DAMON Operator (DAMO).  It is available at
+https://github.com/awslabs/damo.  The examples below assume that ``damo`` =
is on
+your ``$PATH``.  It's not mandatory, though.
+
+Because DAMO is using the debugfs interface (refer to :doc:`usage` for the
+detail) of DAMON, you should ensure debugfs is mounted.  Mount it manually=
 as
+below::
+
+    # mount -t debugfs none /sys/kernel/debug/
+
+or append the following line to your ``/etc/fstab`` file so that your syst=
em
+can automatically mount debugfs upon booting::
+
+    debugfs /sys/kernel/debug debugfs defaults 0 0
+
+
+Recording Data Access Patterns
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
+
+The commands below record the memory access patterns of a program and save=
 the
+monitoring results to a file. ::
+
+    $ git clone https://github.com/sjp38/masim
+    $ cd masim; make; ./masim ./configs/zigzag.cfg &
+    $ sudo damo record -o damon.data $(pidof masim)
+
+The first two lines of the commands download an artificial memory access
+generator program and run it in the background.  The generator will repeat=
edly
+access two 100 MiB sized memory regions one by one.  You can substitute th=
is
+with your real workload.  The last line asks ``damo`` to record the access
+pattern in the ``damon.data`` file.
+
+
+Visualizing Recorded Patterns
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
+
+The following three commands visualize the recorded access patterns and sa=
ve
+the results as separate image files. ::
+
+    $ damo report heats --heatmap access_pattern_heatmap.png
+    $ damo report wss --range 0 101 1 --plot wss_dist.png
+    $ damo report wss --range 0 101 1 --sortby time --plot wss_chron_chang=
e.png
+
+- ``access_pattern_heatmap.png`` will visualize the data access pattern in=
 a
+  heatmap, showing which memory region (y-axis) got accessed when (x-axis)
+  and how frequently (color).
+- ``wss_dist.png`` will show the distribution of the working set size.
+- ``wss_chron_change.png`` will show how the working set size has
+  chronologically changed.
+
+You can view the visualizations of this example workload at [1]_.
+Visualizations of other realistic workloads are available at [2]_ [3]_ [4]=
_.
+
+.. [1] https://damonitor.github.io/doc/html/v17/admin-guide/mm/damon/start=
.html#visualizing-recorded-patterns
+.. [2] https://damonitor.github.io/test/result/visual/latest/rec.heatmap.1=
.png.html
+.. [3] https://damonitor.github.io/test/result/visual/latest/rec.wss_sz.pn=
g.html
+.. [4] https://damonitor.github.io/test/result/visual/latest/rec.wss_time.=
png.html
--- /dev/null
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -0,0 +1,112 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+Detailed Usages
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+DAMON provides below three interfaces for different users.
+
+- *DAMON user space tool.*
+  This is for privileged people such as system administrators who want a
+  just-working human-friendly interface.  Using this, users can use the DA=
MON=E2=80=99s
+  major features in a human-friendly way.  It may not be highly tuned for
+  special cases, though.  It supports only virtual address spaces monitori=
ng.
+- *debugfs interface.*
+  This is for privileged user space programmers who want more optimized us=
e of
+  DAMON.  Using this, users can use DAMON=E2=80=99s major features by read=
ing
+  from and writing to special debugfs files.  Therefore, you can write and=
 use
+  your personalized DAMON debugfs wrapper programs that reads/writes the
+  debugfs files instead of you.  The DAMON user space tool is also a refer=
ence
+  implementation of such programs.  It supports only virtual address spaces
+  monitoring.
+- *Kernel Space Programming Interface.*
+  This is for kernel space programmers.  Using this, users can utilize eve=
ry
+  feature of DAMON most flexibly and efficiently by writing kernel space
+  DAMON application programs for you.  You can even extend DAMON for vario=
us
+  address spaces.
+
+Nevertheless, you could write your own user space tool using the debugfs
+interface.  A reference implementation is available at
+https://github.com/awslabs/damo.  If you are a kernel programmer, you could
+refer to :doc:`/vm/damon/api` for the kernel space programming interface. =
 For
+the reason, this document describes only the debugfs interface
+
+debugfs Interface
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+DAMON exports three files, ``attrs``, ``target_ids``, and ``monitor_on`` u=
nder
+its debugfs directory, ``<debugfs>/damon/``.
+
+
+Attributes
+----------
+
+Users can get and set the ``sampling interval``, ``aggregation interval``,
+``regions update interval``, and min/max number of monitoring target regio=
ns by
+reading from and writing to the ``attrs`` file.  To know about the monitor=
ing
+attributes in detail, please refer to the :doc:`/vm/damon/design`.  For
+example, below commands set those values to 5 ms, 100 ms, 1,000 ms, 10 and
+1000, and then check it again::
+
+    # cd <debugfs>/damon
+    # echo 5000 100000 1000000 10 1000 > attrs
+    # cat attrs
+    5000 100000 1000000 10 1000
+
+
+Target IDs
+----------
+
+Some types of address spaces supports multiple monitoring target.  For exa=
mple,
+the virtual memory address spaces monitoring can have multiple processes a=
s the
+monitoring targets.  Users can set the targets by writing relevant id valu=
es of
+the targets to, and get the ids of the current targets by reading from the
+``target_ids`` file.  In case of the virtual address spaces monitoring, the
+values should be pids of the monitoring target processes.  For example, be=
low
+commands set processes having pids 42 and 4242 as the monitoring targets a=
nd
+check it again::
+
+    # cd <debugfs>/damon
+    # echo 42 4242 > target_ids
+    # cat target_ids
+    42 4242
+
+Note that setting the target ids doesn't start the monitoring.
+
+
+Turning On/Off
+--------------
+
+Setting the files as described above doesn't incur effect unless you expli=
citly
+start the monitoring.  You can start, stop, and check the current status o=
f the
+monitoring by writing to and reading from the ``monitor_on`` file.  Writing
+``on`` to the file starts the monitoring of the targets with the attribute=
s.
+Writing ``off`` to the file stops those.  DAMON also stops if every target
+process is terminated.  Below example commands turn on, off, and check the
+status of DAMON::
+
+    # cd <debugfs>/damon
+    # echo on > monitor_on
+    # echo off > monitor_on
+    # cat monitor_on
+    off
+
+Please note that you cannot write to the above-mentioned debugfs files whi=
le
+the monitoring is turned on.  If you write to the files while DAMON is run=
ning,
+an error code such as ``-EBUSY`` will be returned.
+
+
+Tracepoint for Monitoring Results
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+DAMON provides the monitoring results via a tracepoint,
+``damon:damon_aggregated``.  While the monitoring is turned on, you could
+record the tracepoint events and show results using tracepoint supporting =
tools
+like ``perf``.  For example::
+
+    # echo on > monitor_on
+    # perf record -e damon:damon_aggregated &
+    # sleep 5
+    # kill 9 $(pidof perf)
+    # echo off > monitor_on
+    # perf script
--- a/Documentation/admin-guide/mm/index.rst~documentation-add-documents-fo=
r-damon
+++ a/Documentation/admin-guide/mm/index.rst
@@ -27,6 +27,7 @@ the Linux memory management.
=20
    concepts
    cma_debugfs
+   damon/index
    hugetlbpage
    idle_page_tracking
    ksm
--- /dev/null
+++ a/Documentation/vm/damon/api.rst
@@ -0,0 +1,20 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+API Reference
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Kernel space programs can use every feature of DAMON using below APIs.  Al=
l you
+need to do is including ``damon.h``, which is located in ``include/linux/`=
` of
+the source tree.
+
+Structures
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+.. kernel-doc:: include/linux/damon.h
+
+
+Functions
+=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+.. kernel-doc:: mm/damon/core.c
--- /dev/null
+++ a/Documentation/vm/damon/design.rst
@@ -0,0 +1,166 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D
+Design
+=3D=3D=3D=3D=3D=3D
+
+Configurable Layers
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+DAMON provides data access monitoring functionality while making the accur=
acy
+and the overhead controllable.  The fundamental access monitorings require
+primitives that dependent on and optimized for the target address space.  =
On
+the other hand, the accuracy and overhead tradeoff mechanism, which is the=
 core
+of DAMON, is in the pure logic space.  DAMON separates the two parts in
+different layers and defines its interface to allow various low level
+primitives implementations configurable with the core logic.
+
+Due to this separated design and the configurable interface, users can ext=
end
+DAMON for any address space by configuring the core logics with appropriat=
e low
+level primitive implementations.  If appropriate one is not provided, user=
s can
+implement the primitives on their own.
+
+For example, physical memory, virtual memory, swap space, those for specif=
ic
+processes, NUMA nodes, files, and backing memory devices would be supporta=
ble.
+Also, if some architectures or devices support special optimized access ch=
eck
+primitives, those will be easily configurable.
+
+
+Reference Implementations of Address Space Specific Primitives
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+The low level primitives for the fundamental access monitoring are defined=
 in
+two parts:
+
+1. Identification of the monitoring target address range for the address s=
pace.
+2. Access check of specific address range in the target space.
+
+DAMON currently provides the implementation of the primitives for only the
+virtual address spaces. Below two subsections describe how it works.
+
+
+VMA-based Target Address Range Construction
+-------------------------------------------
+
+Only small parts in the super-huge virtual address space of the processes =
are
+mapped to the physical memory and accessed.  Thus, tracking the unmapped
+address regions is just wasteful.  However, because DAMON can deal with so=
me
+level of noise using the adaptive regions adjustment mechanism, tracking e=
very
+mapping is not strictly required but could even incur a high overhead in s=
ome
+cases.  That said, too huge unmapped areas inside the monitoring target sh=
ould
+be removed to not take the time for the adaptive mechanism.
+
+For the reason, this implementation converts the complex mappings to three
+distinct regions that cover every mapped area of the address space.  The t=
wo
+gaps between the three regions are the two biggest unmapped areas in the g=
iven
+address space.  The two biggest unmapped areas would be the gap between the
+heap and the uppermost mmap()-ed region, and the gap between the lowermost
+mmap()-ed region and the stack in most of the cases.  Because these gaps a=
re
+exceptionally huge in usual address spaces, excluding these will be suffic=
ient
+to make a reasonable trade-off.  Below shows this in detail::
+
+    <heap>
+    <BIG UNMAPPED REGION 1>
+    <uppermost mmap()-ed region>
+    (small mmap()-ed regions and munmap()-ed regions)
+    <lowermost mmap()-ed region>
+    <BIG UNMAPPED REGION 2>
+    <stack>
+
+
+PTE Accessed-bit Based Access Check
+-----------------------------------
+
+The implementation for the virtual address space uses PTE Accessed-bit for
+basic access checks.  It finds the relevant PTE Accessed bit from the addr=
ess
+by walking the page table for the target task of the address.  In this way=
, the
+implementation finds and clears the bit for next sampling target address a=
nd
+checks whether the bit set again after one sampling period.  This could di=
sturb
+other kernel subsystems using the Accessed bits, namely Idle page tracking=
 and
+the reclaim logic.  To avoid such disturbances, DAMON makes it mutually
+exclusive with Idle page tracking and uses ``PG_idle`` and ``PG_young`` pa=
ge
+flags to solve the conflict with the reclaim logic, as Idle page tracking =
does.
+
+
+Address Space Independent Core Mechanisms
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Below four sections describe each of the DAMON core mechanisms and the five
+monitoring attributes, ``sampling interval``, ``aggregation interval``,
+``regions update interval``, ``minimum number of regions``, and ``maximum
+number of regions``.
+
+
+Access Frequency Monitoring
+---------------------------
+
+The output of DAMON says what pages are how frequently accessed for a given
+duration.  The resolution of the access frequency is controlled by setting
+``sampling interval`` and ``aggregation interval``.  In detail, DAMON chec=
ks
+access to each page per ``sampling interval`` and aggregates the results. =
 In
+other words, counts the number of the accesses to each page.  After each
+``aggregation interval`` passes, DAMON calls callback functions that previ=
ously
+registered by users so that users can read the aggregated results and then
+clears the results.  This can be described in below simple pseudo-code::
+
+    while monitoring_on:
+        for page in monitoring_target:
+            if accessed(page):
+                nr_accesses[page] +=3D 1
+        if time() % aggregation_interval =3D=3D 0:
+            for callback in user_registered_callbacks:
+                callback(monitoring_target, nr_accesses)
+            for page in monitoring_target:
+                nr_accesses[page] =3D 0
+        sleep(sampling interval)
+
+The monitoring overhead of this mechanism will arbitrarily increase as the
+size of the target workload grows.
+
+
+Region Based Sampling
+---------------------
+
+To avoid the unbounded increase of the overhead, DAMON groups adjacent pag=
es
+that assumed to have the same access frequencies into a region.  As long a=
s the
+assumption (pages in a region have the same access frequencies) is kept, o=
nly
+one page in the region is required to be checked.  Thus, for each ``sampli=
ng
+interval``, DAMON randomly picks one page in each region, waits for one
+``sampling interval``, checks whether the page is accessed meanwhile, and
+increases the access frequency of the region if so.  Therefore, the monito=
ring
+overhead is controllable by setting the number of regions.  DAMON allows u=
sers
+to set the minimum and the maximum number of regions for the trade-off.
+
+This scheme, however, cannot preserve the quality of the output if the
+assumption is not guaranteed.
+
+
+Adaptive Regions Adjustment
+---------------------------
+
+Even somehow the initial monitoring target regions are well constructed to
+fulfill the assumption (pages in same region have similar access frequenci=
es),
+the data access pattern can be dynamically changed.  This will result in l=
ow
+monitoring quality.  To keep the assumption as much as possible, DAMON
+adaptively merges and splits each region based on their access frequency.
+
+For each ``aggregation interval``, it compares the access frequencies of
+adjacent regions and merges those if the frequency difference is small.  T=
hen,
+after it reports and clears the aggregated access frequency of each region=
, it
+splits each region into two or three regions if the total number of regions
+will not exceed the user-specified maximum number of regions after the spl=
it.
+
+In this way, DAMON provides its best-effort quality and minimal overhead w=
hile
+keeping the bounds users set for their trade-off.
+
+
+Dynamic Target Space Updates Handling
+-------------------------------------
+
+The monitoring target address range could dynamically changed.  For exampl=
e,
+virtual memory could be dynamically mapped and unmapped.  Physical memory =
could
+be hot-plugged.
+
+As the changes could be quite frequent in some cases, DAMON checks the dyn=
amic
+memory mapping changes and applies it to the abstracted target area only f=
or
+each of a user-specified time interval (``regions update interval``).
--- /dev/null
+++ a/Documentation/vm/damon/faq.rst
@@ -0,0 +1,51 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
+Frequently Asked Questions
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
+
+Why a new subsystem, instead of extending perf or other user space tools?
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+First, because it needs to be lightweight as much as possible so that it c=
an be
+used online, any unnecessary overhead such as kernel - user space context
+switching cost should be avoided.  Second, DAMON aims to be used by other
+programs including the kernel.  Therefore, having a dependency on specific
+tools like perf is not desirable.  These are the two biggest reasons why D=
AMON
+is implemented in the kernel space.
+
+
+Can 'idle pages tracking' or 'perf mem' substitute DAMON?
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
+
+Idle page tracking is a low level primitive for access check of the physic=
al
+address space.  'perf mem' is similar, though it can use sampling to minim=
ize
+the overhead.  On the other hand, DAMON is a higher-level framework for the
+monitoring of various address spaces.  It is focused on memory management
+optimization and provides sophisticated accuracy/overhead handling mechani=
sms.
+Therefore, 'idle pages tracking' and 'perf mem' could provide a subset of
+DAMON's output, but cannot substitute DAMON.
+
+
+Does DAMON support virtual memory only?
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+No.  The core of the DAMON is address space independent.  The address space
+specific low level primitive parts including monitoring target regions
+constructions and actual access checks can be implemented and configured o=
n the
+DAMON core by the users.  In this way, DAMON users can monitor any address
+space with any access check technique.
+
+Nonetheless, DAMON provides vma tracking and PTE Accessed bit check based
+implementations of the address space dependent functions for the virtual m=
emory
+by default, for a reference and convenient use.  In near future, we will
+provide those for physical memory address space.
+
+
+Can I simply monitor page granularity?
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Yes.  You can do so by setting the ``min_nr_regions`` attribute higher tha=
n the
+working set size divided by the page size.  Because the monitoring target
+regions size is forced to be ``>=3Dpage size``, the region split will make=
 no
+effect.
--- /dev/null
+++ a/Documentation/vm/damon/index.rst
@@ -0,0 +1,30 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
+DAMON: Data Access MONitor
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
+
+DAMON is a data access monitoring framework subsystem for the Linux kernel.
+The core mechanisms of DAMON (refer to :doc:`design` for the detail) make =
it
+
+ - *accurate* (the monitoring output is useful enough for DRAM level memory
+   management; It might not appropriate for CPU Cache levels, though),
+ - *light-weight* (the monitoring overhead is low enough to be applied onl=
ine),
+   and
+ - *scalable* (the upper-bound of the overhead is in constant range regard=
less
+   of the size of target workloads).
+
+Using this framework, therefore, the kernel's memory management mechanisms=
 can
+make advanced decisions.  Experimental memory management optimization works
+that incurring high data accesses monitoring overhead could implemented ag=
ain.
+In user space, meanwhile, users who have some special workloads can write
+personalized applications for better understanding and optimizations of th=
eir
+workloads and systems.
+
+.. toctree::
+   :maxdepth: 2
+
+   faq
+   design
+   api
+   plans
--- a/Documentation/vm/index.rst~documentation-add-documents-for-damon
+++ a/Documentation/vm/index.rst
@@ -32,6 +32,7 @@ descriptions of data structures and algo
    arch_pgtable_helpers
    balance
    cleancache
+   damon/index
    free_page_reporting
    frontswap
    highmem
_

Patches currently in -mm which might be from sjpark@amazon.de are


