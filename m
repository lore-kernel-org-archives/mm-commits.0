From: akpm@linux-foundation.org
Subject: + cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch added to -mm tree
Date: Fri, 27 May 2011 13:06:14 -0700
Message-ID: <201105272043.p4RKh1YQ020034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753437Ab1E0Unu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:43:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cl@linux-foundation.org, holt@sgi.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, menage@google.com, mhocko@suse.cz, penberg@cs.helsinki.fi, rientjes@google.com, steiner@sgi.com


The patch titled
     cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2
has been added to the -mm tree.  Its filename is
     cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch

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
Subject: cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

fix CONFIG_NUMA=y, MAX_NUMNODES>1 build

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Paul Menage <menage@google.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   12 +++++++++---
 mempolicy.c              |    0 
 2 files changed, 9 insertions(+), 3 deletions(-)

diff -puN include/linux/bitmap.h~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2 include/linux/bitmap.h
diff -puN include/linux/nodemask.h~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2 include/linux/nodemask.h
--- a/include/linux/nodemask.h~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2
+++ a/include/linux/nodemask.h
@@ -433,8 +433,6 @@ static inline void node_set_offline(int 
 	nr_online_nodes = num_node_state(N_ONLINE);
 }
 
-extern int node_random(const nodemask_t *maskp);
-
 #else
 
 static inline int node_state(int node, enum node_states state)
@@ -466,7 +464,15 @@ static inline int num_node_state(enum no
 #define node_set_online(node)	   node_set_state((node), N_ONLINE)
 #define node_set_offline(node)	   node_clear_state((node), N_ONLINE)
 
-static inline int node_random(const nodemask_t *mask) { return 0; }
+#endif
+
+#if defined(CONFIG_NUMA) && (MAX_NUMNODES > 1)
+extern int node_random(const nodemask_t *maskp);
+#else
+static inline int node_random(const nodemask_t *mask)
+{
+	return 0;
+}
 #endif
 
 #define node_online_map 	node_states[N_ONLINE]
diff -puN kernel/fork.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2 kernel/fork.c
diff -puN lib/bitmap.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2 lib/bitmap.c
diff -puN mm/mempolicy.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2 mm/mempolicy.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
backlight-add-backlight-type-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
rfcomm-corec-avoid-dangling-pointer-check-session-exists-checkpatch-fixes.patch
slab-use-numa_no_node.patch
mm.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

