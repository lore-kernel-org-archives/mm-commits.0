From: akpm@linux-foundation.org
Subject: + memcg-add-page_cgroup_ino-helper.patch added to -mm tree
Date: Tue, 21 Jul 2015 16:33:52 -0700
Message-ID: <55aed6e0.0oEiR5f3svQhVyq8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932958AbbGUXdy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 19:33:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andreslc@google.com, corbet@lwn.net, gorcunov@openvz.org, gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.cz, minchan@kernel.org, raghavendra.kt@linux.vnet.ibm.com, rientjes@google.com, walken@google.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: add page_cgroup_ino helper
has been added to the -mm tree.  Its filename is
     memcg-add-page_cgroup_ino-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-add-page_cgroup_ino-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-add-page_cgroup_ino-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: add page_cgroup_ino helper

This patchset introduces a new user API for tracking user memory pages
that have not been used for a given period of time.  The purpose of this
is to provide the userspace with the means of tracking a workload's
working set, i.e.  the set of pages that are actively used by the
workload.  Knowing the working set size can be useful for partitioning the
system more efficiently, e.g.  by tuning memory cgroup limits
appropriately, or for job placement within a compute cluster.

==== USE CASES ====

The unified cgroup hierarchy has memory.low and memory.high knobs, which
are defined as the low and high boundaries for the workload working set
size.  However, the working set size of a workload may be unknown or
change in time.  With this patch set, one can periodically estimate the
amount of memory unused by each cgroup and tune their memory.low and
memory.high parameters accordingly, therefore optimizing the overall
memory utilization.

Another use case is balancing workloads within a compute cluster.  Knowing
how much memory is not really used by a workload unit may help take a more
optimal decision when considering migrating the unit to another node
within the cluster.

Also, as noted by Minchan, this would be useful for per-process reclaim
(https://lwn.net/Articles/545668/). With idle tracking, we could reclaim idle
pages only by smart user memory manager.

==== USER API ====

The user API consists of two new proc files:

 * /proc/kpageidle.  This file implements a bitmap where each bit corresponds
   to a page, indexed by PFN. When the bit is set, the corresponding page is
   idle. A page is considered idle if it has not been accessed since it was
   marked idle. To mark a page idle one should set the bit corresponding to the
   page by writing to the file. A value written to the file is OR-ed with the
   current bitmap value. Only user memory pages can be marked idle, for other
   page types input is silently ignored. Writing to this file beyond max PFN
   results in the ENXIO error. Only available when CONFIG_IDLE_PAGE_TRACKING is
   set.

   This file can be used to estimate the amount of pages that are not
   used by a particular workload as follows:

   1. mark all pages of interest idle by setting corresponding bits in the
      /proc/kpageidle bitmap
   2. wait until the workload accesses its working set
   3. read /proc/kpageidle and count the number of bits set

 * /proc/kpagecgroup.  This file contains a 64-bit inode number of the
   memory cgroup each page is charged to, indexed by PFN. Only available when
   CONFIG_MEMCG is set.

   This file can be used to find all pages (including unmapped file
   pages) accounted to a particular cgroup. Using /proc/kpageidle, one
   can then estimate the cgroup working set size.

For an example of using these files for estimating the amount of unused
memory pages per each memory cgroup, please see the script attached
below.

==== REASONING ====

The reason to introduce the new user API instead of using
/proc/PID/{clear_refs,smaps} is that the latter has two serious
drawbacks:

 - it does not count unmapped file pages
 - it affects the reclaimer logic

The new API attempts to overcome them both. For more details on how it
is achieved, please see the comment to patch 6.

==== PATCHSET STRUCTURE ====

The patch set is organized as follows:

 - patch 1 adds page_cgroup_ino() helper for the sake of
   /proc/kpagecgroup and patches 2-3 do related cleanup
 - patch 4 adds /proc/kpagecgroup, which reports cgroup ino each page is
   charged to
 - patch 5 introduces a new mmu notifier callback, clear_young, which is
   a lightweight version of clear_flush_young; it is used in patch 6
 - patch 6 implements the idle page tracking feature, including the
   userspace API, /proc/kpageidle
 - patch 7 exports idle flag via /proc/kpageflags

==== SIMILAR WORKS ====

Originally, the patch for tracking idle memory was proposed back in 2011
by Michel Lespinasse (see http://lwn.net/Articles/459269/).  The main
difference between Michel's patch and this one is that Michel implemented
a kernel space daemon for estimating idle memory size per cgroup while
this patch only provides the userspace with the minimal API for doing the
job, leaving the rest up to the userspace.  However, they both share the
same idea of Idle/Young page flags to avoid affecting the reclaimer logic.

==== PERFORMANCE EVALUATION ====

SPECjvm2008 (https://www.spec.org/jvm2008/) was used to evaluate the
performance impact introduced by this patch set.  Three runs were carried
out:

 - base: kernel without the patch
 - patched: patched kernel, the feature is not used
 - patched-active: patched kernel, 1 minute-period daemon is used for
   tracking idle memory

For tracking idle memory, idlememstat utility was used:
https://github.com/locker/idlememstat

testcase            base            patched        patched-active

compiler       537.40 ( 0.00)%   532.26 (-0.96)%   538.31 ( 0.17)%
compress       305.47 ( 0.00)%   301.08 (-1.44)%   300.71 (-1.56)%
crypto         284.32 ( 0.00)%   282.21 (-0.74)%   284.87 ( 0.19)%
derby          411.05 ( 0.00)%   413.44 ( 0.58)%   412.07 ( 0.25)%
mpegaudio      189.96 ( 0.00)%   190.87 ( 0.48)%   189.42 (-0.28)%
scimark.large   46.85 ( 0.00)%    46.41 (-0.94)%    47.83 ( 2.09)%
scimark.small  412.91 ( 0.00)%   415.41 ( 0.61)%   421.17 ( 2.00)%
serial         204.23 ( 0.00)%   213.46 ( 4.52)%   203.17 (-0.52)%
startup         36.76 ( 0.00)%    35.49 (-3.45)%    35.64 (-3.05)%
sunflow        115.34 ( 0.00)%   115.08 (-0.23)%   117.37 ( 1.76)%
xml            620.55 ( 0.00)%   619.95 (-0.10)%   620.39 (-0.03)%

composite      211.50 ( 0.00)%   211.15 (-0.17)%   211.67 ( 0.08)%

time idlememstat:

17.20user 65.16system 2:15:23elapsed 1%CPU (0avgtext+0avgdata 8476maxresident)k
448inputs+40outputs (1major+36052minor)pagefaults 0swaps

==== SCRIPT FOR COUNTING IDLE PAGES PER CGROUP ====
#! /usr/bin/python
#

import os
import stat
import errno
import struct

CGROUP_MOUNT = "/sys/fs/cgroup/memory"
BUFSIZE = 8 * 1024  # must be multiple of 8


def get_hugepage_size():
    with open("/proc/meminfo", "r") as f:
        for s in f:
            k, v = s.split(":")
            if k == "Hugepagesize":
                return int(v.split()[0]) * 1024

PAGE_SIZE = os.sysconf("SC_PAGE_SIZE")
HUGEPAGE_SIZE = get_hugepage_size()


def set_idle():
    f = open("/proc/kpageidle", "wb", BUFSIZE)
    while True:
        try:
            f.write(struct.pack("Q", pow(2, 64) - 1))
        except IOError as err:
            if err.errno == errno.ENXIO:
                break
            raise
    f.close()


def count_idle():
    f_flags = open("/proc/kpageflags", "rb", BUFSIZE)
    f_cgroup = open("/proc/kpagecgroup", "rb", BUFSIZE)

    with open("/proc/kpageidle", "rb", BUFSIZE) as f:
        while f.read(BUFSIZE): pass  # update idle flag

    idlememsz = {}
    while True:
        s1, s2 = f_flags.read(8), f_cgroup.read(8)
        if not s1 or not s2:
            break

        flags, = struct.unpack('Q', s1)
        cgino, = struct.unpack('Q', s2)

        unevictable = (flags >> 18) & 1
        huge = (flags >> 22) & 1
        idle = (flags >> 25) & 1

        if idle and not unevictable:
            idlememsz[cgino] = idlememsz.get(cgino, 0) + \
                (HUGEPAGE_SIZE if huge else PAGE_SIZE)

    f_flags.close()
    f_cgroup.close()
    return idlememsz


if __name__ == "__main__":
    print "Setting the idle flag for each page..."
    set_idle()

    raw_input("Wait until the workload accesses its working set, "
              "then press Enter")

    print "Counting idle pages..."
    idlememsz = count_idle()

    for dir, subdirs, files in os.walk(CGROUP_MOUNT):
        ino = os.stat(dir)[stat.ST_INO]
        print dir + ": " + str(idlememsz.get(ino, 0) / 1024) + " kB"
==== END SCRIPT ====




This patch (of 8):

Add page_cgroup_ino() helper to memcg.

This function returns the inode number of the closest online ancestor of
the memory cgroup a page is charged to.  It is required for exporting
information about which page is charged to which cgroup to userspace,
which will be introduced by a following patch.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reviewed-by: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 +
 mm/memcontrol.c            |   23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff -puN include/linux/memcontrol.h~memcg-add-page_cgroup_ino-helper include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-page_cgroup_ino-helper
+++ a/include/linux/memcontrol.h
@@ -345,6 +345,7 @@ static inline bool mm_match_cgroup(struc
 }
 
 struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page);
+unsigned long page_cgroup_ino(struct page *page);
 
 static inline bool mem_cgroup_disabled(void)
 {
diff -puN mm/memcontrol.c~memcg-add-page_cgroup_ino-helper mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-page_cgroup_ino-helper
+++ a/mm/memcontrol.c
@@ -441,6 +441,29 @@ struct cgroup_subsys_state *mem_cgroup_c
 	return &memcg->css;
 }
 
+/**
+ * page_cgroup_ino - return inode number of the memcg a page is charged to
+ * @page: the page
+ *
+ * Look up the closest online ancestor of the memory cgroup @page is charged to
+ * and return its inode number or 0 if @page is not charged to any cgroup. It
+ * is safe to call this function without holding a reference to @page.
+ */
+unsigned long page_cgroup_ino(struct page *page)
+{
+	struct mem_cgroup *memcg;
+	unsigned long ino = 0;
+
+	rcu_read_lock();
+	memcg = READ_ONCE(page->mem_cgroup);
+	while (memcg && !(memcg->css.flags & CSS_ONLINE))
+		memcg = parent_mem_cgroup(memcg);
+	if (memcg)
+		ino = cgroup_ino(memcg->css.cgroup);
+	rcu_read_unlock();
+	return ino;
+}
+
 static struct mem_cgroup_per_zone *
 mem_cgroup_page_zoneinfo(struct mem_cgroup *memcg, struct page *page)
 {
_

Patches currently in -mm which might be from vdavydov@parallels.com are

memcg-export-struct-mem_cgroup.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
memcg-get-rid-of-mem_cgroup_root_css-for-config_memcg.patch
memcg-get-rid-of-extern-for-functions-in-memcontrolh.patch
memcg-restructure-mem_cgroup_can_attach.patch
memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg.patch
memcg-add-page_cgroup_ino-helper.patch
hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch
memcg-zap-try_get_mem_cgroup_from_page.patch
proc-add-kpagecgroup-file.patch
mmu-notifier-add-clear_young-callback.patch
proc-add-kpageidle-file.patch
proc-export-idle-flag-via-kpageflags.patch
proc-add-cond_resched-to-proc-kpage-read-write-loop.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-swap-zswap-maybe_preload-refactoring.patch

