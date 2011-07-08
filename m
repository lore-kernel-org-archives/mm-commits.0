From: akpm@linux-foundation.org
Subject: + samples-hidraw-is-busted.patch added to -mm tree
Date: Fri, 08 Jul 2011 13:51:54 -0700
Message-ID: <201107082129.p68LTgIt015992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752912Ab1GHV35 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2011 17:29:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jkosina@suse.cz


The patch titled
     samples/hidraw is busted
has been added to the -mm tree.  Its filename is
     samples-hidraw-is-busted.patch

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
Subject: samples/hidraw is busted
From: Andrew Morton <akpm@linux-foundation.org>

In file included from /usr/include/sys/time.h:31,
                 from /usr/include/linux/input.h:12,
                 from samples/hidraw/hid-example.c:14:
/usr/include/sys/select.h:78: error: conflicting types for 'fd_set'
/usr/include/linux/types.h:12: error: previous declaration of 'fd_set' was here
In file included from /usr/include/linux/input.h:14,
                 from samples/hidraw/hid-example.c:14:
/usr/include/sys/types.h:46: error: conflicting types for 'loff_t'
/usr/include/linux/types.h:30: error: previous declaration of 'loff_t' was here
/usr/include/sys/types.h:62: error: conflicting types for 'dev_t'
/usr/include/linux/types.h:13: error: previous declaration of 'dev_t' was here
In file included from /usr/include/sys/types.h:133,
                 from /usr/include/linux/input.h:14,
                 from samples/hidraw/hid-example.c:14:
/usr/include/time.h:105: error: conflicting types for 'timer_t'
/usr/include/linux/types.h:22: error: previous declaration of 'timer_t' was here
In file included from /usr/include/linux/input.h:14,
                 from samples/hidraw/hid-example.c:14:
/usr/include/sys/types.h:198: error: conflicting types for 'int64_t'
/usr/include/linux/types.h:98: error: previous declaration of 'int64_t' was here
/usr/include/sys/types.h:204: error: conflicting types for 'u_int64_t'
/usr/include/linux/types.h:97: error: previous declaration of 'u_int64_t' was here
In file included from /usr/include/linux/input.h:14,
                 from samples/hidraw/hid-example.c:14:
/usr/include/sys/types.h:235: error: conflicting types for 'blkcnt_t'
/usr/include/linux/types.h:114: error: previous declaration of 'blkcnt_t' was here
samples/hidraw/hid-example.c:15:26: error: linux/hidraw.h: No such file or directory
samples/hidraw/hid-example.c: In function 'main':
samples/hidraw/hid-example.c:48: error: storage size of 'rpt_desc' isn't known
samples/hidraw/hid-example.c:49: error: storage size of 'info' isn't known
samples/hidraw/hid-example.c:65: error: 'HIDIOCGRDESCSIZE' undeclared (first use in this function)
samples/hidraw/hid-example.c:65: error: (Each undeclared identifier is reported only once
samples/hidraw/hid-example.c:65: error: for each function it appears in.)
samples/hidraw/hid-example.c:73: error: 'HIDIOCGRDESC' undeclared (first use in this function)
samples/hidraw/hid-example.c:84: warning: implicit declaration of function 'HIDIOCGRAWNAME'
samples/hidraw/hid-example.c:91: warning: implicit declaration of function 'HIDIOCGRAWPHYS'
samples/hidraw/hid-example.c:98: error: 'HIDIOCGRAWINFO' undeclared (first use in this function)
samples/hidraw/hid-example.c:49: warning: unused variable 'info'
samples/hidraw/hid-example.c:48: warning: unused variable 'rpt_desc'
samples/hidraw/hid-example.c: In function 'bus_str':
samples/hidraw/hid-example.c:171: error: 'BUS_VIRTUAL' undeclared (first use in this function)

Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN samples/Makefile~samples-hidraw-is-busted samples/Makefile
--- a/samples/Makefile~samples-hidraw-is-busted
+++ a/samples/Makefile
@@ -1,4 +1,4 @@
 # Makefile for Linux samples code
 
 obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ tracepoints/ trace_events/ \
-			   hw_breakpoint/ kfifo/ kdb/ hidraw/
+			   hw_breakpoint/ kfifo/ kdb/
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
memcg-fix-reclaimable-lru-check-in-memcg-checkpatch-fixes.patch
memcg-fix-reclaimable-lru-check-in-memcg-fix.patch
memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event-fix.patch
mm-preallocate-page-before-lock_page-at-filemap-cow-fix.patch
w1-ds1wm-add-a-reset-recovery-parameter-checkpatch-fixes.patch
xtensa-prevent-arbitrary-read-in-ptrace-fix.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver-fix.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-net-skgec-support-dlink-dge-530t-rev-c1.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-re-scanning-pci-fix.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-gma500-psb_intel_displayc-fix-build.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
mm-memoryc-remove-zap_block_size.patch
mm-memblockc-avoid-abuse-of-red_inactive.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
drivers-misc-add-support-the-fsa9480-usb-switch-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-skip-calibration-delay-if-previously-done-4.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

