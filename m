From: akpm@linux-foundation.org
Subject: + include-net-netprio_cgrouph-fix-build.patch added to -mm tree
Date: Wed, 23 Nov 2011 13:59:23 -0800
Message-ID: <201111232240.pANMeUMB012878@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:57883 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1KWWkl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2011 17:40:41 -0500
Received: by yenm12 with SMTP id m12so275833yen.1
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2011 14:40:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davem@davemloft.net, john.r.fastabend@intel.com, nhorman@tuxdriver.com, robert.w.love@intel.com


The patch titled
     Subject: include/net/netprio_cgroup.h: fix build
has been added to the -mm tree.  Its filename is
     include-net-netprio_cgrouph-fix-build.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/net/netprio_cgroup.h: fix build

In file included from include/linux/netdevice.h:53,
                 from include/linux/icmpv6.h:173,
                 from include/linux/ipv6.h:220,
                 from include/net/ipv6.h:16,
                 from include/linux/sunrpc/clnt.h:26,
                 from include/linux/nfs_fs.h:50,
                 from init/do_mounts.c:20:
include/net/netprio_cgroup.h:23: error: field 'css' has incomplete type

Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: John Fastabend <john.r.fastabend@intel.com>
Cc: Robert Love <robert.w.love@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/netprio_cgroup.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/net/netprio_cgroup.h~include-net-netprio_cgrouph-fix-build include/net/netprio_cgroup.h
--- a/include/net/netprio_cgroup.h~include-net-netprio_cgrouph-fix-build
+++ a/include/net/netprio_cgroup.h
@@ -18,8 +18,9 @@
 #include <linux/hardirq.h>
 #include <linux/rcupdate.h>
 
-struct cgroup_netprio_state
-{
+struct cgroup_subsys_state;
+
+struct cgroup_netprio_state {
 	struct cgroup_subsys_state css;
 	u32 prioidx;
 };
_
Subject: Subject: include/net/netprio_cgroup.h: fix build

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
vmscan-use-atomic-long-for-shrinker-batching.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
mm-more-intensive-memory-corruption-debug-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch
include-net-netprio_cgrouph-fix-build.patch

