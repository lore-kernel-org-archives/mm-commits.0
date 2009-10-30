From: akpm@linux-foundation.org
Subject: [merged] cpufreq-add-cpufreq_get-stub-for-config_cpu_freq=n.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:48:15 -0700
Message-ID: <200910302048.n9UKmFP4005510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757469AbZJ3UtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:49:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, avi@redhat.com, davej@codemonkey.org.uk, eparis@redhat.com, jirislaby@gmail.com, mtosatti@redhat.com, mm-commits@vger.kernel.org


The patch titled
     cpufreq: add cpufreq_get() stub for CONFIG_CPU_FREQ=n
has been removed from the -mm tree.  Its filename was
     cpufreq-add-cpufreq_get-stub-for-config_cpu_freq=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: add cpufreq_get() stub for CONFIG_CPU_FREQ=n
From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_CPU_FREQ is disabled, cpufreq_get() needs a stub.  Used by kvm
(although it looks like a bit of the kvm code could be omitted when
CONFIG_CPU_FREQ is disabled).

arch/x86/built-in.o: In function `kvm_arch_init':
(.text+0x10de7): undefined reference to `cpufreq_get'

(Needed in linux-next's KVM tree, but it's correct in 2.6.32).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Tested-by: Eric Paris <eparis@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/cpufreq.h~cpufreq-add-cpufreq_get-stub-for-config_cpu_freq=n include/linux/cpufreq.h
--- a/include/linux/cpufreq.h~cpufreq-add-cpufreq_get-stub-for-config_cpu_freq=n
+++ a/include/linux/cpufreq.h
@@ -291,8 +291,15 @@ struct global_attr {
 int cpufreq_get_policy(struct cpufreq_policy *policy, unsigned int cpu);
 int cpufreq_update_policy(unsigned int cpu);
 
+#ifdef CONFIG_CPU_FREQ
 /* query the current CPU frequency (in kHz). If zero, cpufreq couldn't detect it */
 unsigned int cpufreq_get(unsigned int cpu);
+#else
+static inline unsigned int cpufreq_get(unsigned int cpu)
+{
+	return 0;
+}
+#endif
 
 /* query the last known CPU freq (in kHz). If zero, cpufreq couldn't detect it */
 #ifdef CONFIG_CPU_FREQ
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-depends-on-acpi.patch
scsi-fix-func-names-in-kernel-doc.patch
readahead-add-blk_run_backing_dev.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
spi-add-pci-interface-driver-for-designware-spi-core-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

