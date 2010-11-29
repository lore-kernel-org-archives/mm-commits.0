From: akpm@linux-foundation.org
Subject: [merged] cgroups-make-swap-accounting-default-behavior-configurable.patch removed from -mm tree
Date: Mon, 29 Nov 2010 11:51:15 -0800
Message-ID: <201011291951.oATJpinL007315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220Ab0K2TwF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Nov 2010 14:52:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     cgroups: make swap accounting default behavior configurable
has been removed from the -mm tree.  Its filename was
     cgroups-make-swap-accounting-default-behavior-configurable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: make swap accounting default behavior configurable
From: Michal Hocko <mhocko@suse.cz>

Swap accounting can be configured by CONFIG_CGROUP_MEM_RES_CTLR_SWAP
configuration option and then it is turned on by default.  There is a boot
option (noswapaccount) which can disable this feature.

This makes it hard for distributors to enable the configuration option as
this feature leads to a bigger memory consumption and this is a no-go for
general purpose distribution kernel.  On the other hand swap accounting
may be very usuful for some workloads.

This patch adds a new configuration option which controls the default
behavior (CGROUP_MEM_RES_CTLR_SWAP_ENABLED).  If the option is selected
then the feature is turned on by default.

It also adds a new boot parameter swapaccount[=1|0] which enhances the
original noswapaccount parameter semantic by means of enable/disable logic
(defaults to 1 if no value is provided to be still consistent with
noswapaccount).

The default behavior is unchanged (if CONFIG_CGROUP_MEM_RES_CTLR_SWAP is
enabled then CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED is enabled as well)

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 +++++
 init/Kconfig                        |   13 +++++++++++++
 mm/memcontrol.c                     |   21 +++++++++++++++++++--
 3 files changed, 37 insertions(+), 2 deletions(-)

diff -puN Documentation/kernel-parameters.txt~cgroups-make-swap-accounting-default-behavior-configurable Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~cgroups-make-swap-accounting-default-behavior-configurable
+++ a/Documentation/kernel-parameters.txt
@@ -2385,6 +2385,11 @@ and is between 256 and 4096 characters. 
 			improve throughput, but will also increase the
 			amount of memory reserved for use by the client.
 
+	swapaccount[=0|1]
+			[KNL] Enable accounting of swap in memory resource
+			controller if no parameter or 1 is given or disable
+			it if 0 is given (See Documentation/cgroups/memory.txt)
+
 	swiotlb=	[IA-64] Number of I/O TLB slabs
 
 	switches=	[HW,M68k]
diff -puN init/Kconfig~cgroups-make-swap-accounting-default-behavior-configurable init/Kconfig
--- a/init/Kconfig~cgroups-make-swap-accounting-default-behavior-configurable
+++ a/init/Kconfig
@@ -613,6 +613,19 @@ config CGROUP_MEM_RES_CTLR_SWAP
 	  if boot option "noswapaccount" is set, swap will not be accounted.
 	  Now, memory usage of swap_cgroup is 2 bytes per entry. If swap page
 	  size is 4096bytes, 512k per 1Gbytes of swap.
+config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
+	bool "Memory Resource Controller Swap Extension enabled by default"
+	depends on CGROUP_MEM_RES_CTLR_SWAP
+	default y
+	help
+	  Memory Resource Controller Swap Extension comes with its price in
+	  a bigger memory consumption. General purpose distribution kernels
+	  which want to enable the feautre but keep it disabled by default
+	  and let the user enable it by swapaccount boot command line
+	  parameter should have this option unselected.
+	  For those who want to have the feature enabled by default should
+	  select this option (if, for some reason, they need to disable it
+	  then noswapaccount does the trick).
 
 menuconfig CGROUP_SCHED
 	bool "Group CPU scheduler"
diff -puN mm/memcontrol.c~cgroups-make-swap-accounting-default-behavior-configurable mm/memcontrol.c
--- a/mm/memcontrol.c~cgroups-make-swap-accounting-default-behavior-configurable
+++ a/mm/memcontrol.c
@@ -61,7 +61,14 @@ struct mem_cgroup *root_mem_cgroup __rea
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 /* Turned on only when memory cgroup is enabled && really_do_swap_account = 1 */
 int do_swap_account __read_mostly;
-static int really_do_swap_account __initdata = 1; /* for remember boot option*/
+
+/* for remember boot option*/
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED
+static int really_do_swap_account __initdata = 1;
+#else
+static int really_do_swap_account __initdata = 0;
+#endif
+
 #else
 #define do_swap_account		(0)
 #endif
@@ -4920,10 +4927,20 @@ struct cgroup_subsys mem_cgroup_subsys =
 };
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+static int __init enable_swap_account(char *s)
+{
+	/* consider enabled if no parameter or 1 is given */
+	if (!s || !strcmp(s, "1"))
+		really_do_swap_account = 1;
+	else if (!strcmp(s, "0"))
+		really_do_swap_account = 0;
+	return 1;
+}
+__setup("swapaccount", enable_swap_account);
 
 static int __init disable_swap_account(char *s)
 {
-	really_do_swap_account = 0;
+	enable_swap_account("0");
 	return 1;
 }
 __setup("noswapaccount", disable_swap_account);
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch

