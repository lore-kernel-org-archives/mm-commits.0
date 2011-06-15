From: akpm@linux-foundation.org
Subject: + mm-remove-the-leftovers-of-noswapaccount.patch added to -mm tree
Date: Tue, 14 Jun 2011 18:27:24 -0700
Message-ID: <201106150124.p5F1Ofug031984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752837Ab1FOBhK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jun 2011 21:37:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, mhocko@suse.cz


The patch titled
     mm: remove the leftovers of noswapaccount
has been added to the -mm tree.  Its filename is
     mm-remove-the-leftovers-of-noswapaccount.patch

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
Subject: mm: remove the leftovers of noswapaccount
From: WANG Cong <xiyou.wangcong@gmail.com>

In commit a2c8990aed5ab ("memsw: remove noswapaccount kernel parameter"),
Michal forgot to remove some left pieces of noswapaccount in the tree,
this patch removes them all.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <>
---

 Documentation/feature-removal-schedule.txt |   16 ----------------
 init/Kconfig                               |    4 ++--
 mm/page_cgroup.c                           |    2 +-
 3 files changed, 3 insertions(+), 19 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~mm-remove-the-leftovers-of-noswapaccount Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~mm-remove-the-leftovers-of-noswapaccount
+++ a/Documentation/feature-removal-schedule.txt
@@ -509,22 +509,6 @@ Files:	net/netfilter/xt_connlimit.c
 
 ----------------------------
 
-What:	noswapaccount kernel command line parameter
-When:	2.6.40
-Why:	The original implementation of memsw feature enabled by
-	CONFIG_CGROUP_MEM_RES_CTLR_SWAP could be disabled by the noswapaccount
-	kernel parameter (introduced in 2.6.29-rc1). Later on, this decision
-	turned out to be not ideal because we cannot have the feature compiled
-	in and disabled by default and let only interested to enable it
-	(e.g. general distribution kernels might need it). Therefore we have
-	added swapaccount[=0|1] parameter (introduced in 2.6.37) which provides
-	the both possibilities. If we remove noswapaccount we will have
-	less command line parameters with the same functionality and we
-	can also cleanup the parameter handling a bit ().
-Who:	Michal Hocko <mhocko@suse.cz>
-
-----------------------------
-
 What:	ipt_addrtype match include file
 When:	2012
 Why:	superseded by xt_addrtype
diff -puN init/Kconfig~mm-remove-the-leftovers-of-noswapaccount init/Kconfig
--- a/init/Kconfig~mm-remove-the-leftovers-of-noswapaccount
+++ a/init/Kconfig
@@ -673,7 +673,7 @@ config CGROUP_MEM_RES_CTLR_SWAP
 	  be careful about enabling this. When memory resource controller
 	  is disabled by boot option, this will be automatically disabled and
 	  there will be no overhead from this. Even when you set this config=y,
-	  if boot option "noswapaccount" is set, swap will not be accounted.
+	  if boot option "swapaccount=0" is set, swap will not be accounted.
 	  Now, memory usage of swap_cgroup is 2 bytes per entry. If swap page
 	  size is 4096bytes, 512k per 1Gbytes of swap.
 config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
@@ -688,7 +688,7 @@ config CGROUP_MEM_RES_CTLR_SWAP_ENABLED
 	  parameter should have this option unselected.
 	  For those who want to have the feature enabled by default should
 	  select this option (if, for some reason, they need to disable it
-	  then noswapaccount does the trick).
+	  then swapaccount=0 does the trick).
 
 config CGROUP_PERF
 	bool "Enable perf_event per-cpu per-container group (cgroup) monitoring"
diff -puN mm/page_cgroup.c~mm-remove-the-leftovers-of-noswapaccount mm/page_cgroup.c
--- a/mm/page_cgroup.c~mm-remove-the-leftovers-of-noswapaccount
+++ a/mm/page_cgroup.c
@@ -537,7 +537,7 @@ int swap_cgroup_swapon(int type, unsigne
 nomem:
 	printk(KERN_INFO "couldn't allocate enough memory for swap_cgroup.\n");
 	printk(KERN_INFO
-		"swap_cgroup can be disabled by noswapaccount boot option\n");
+		"swap_cgroup can be disabled by swapaccount=0 boot option\n");
 	return -ENOMEM;
 }
 
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

gcov-disable-config_constructors-when-not-needed-by-config_gcov_kernel.patch
documentation-feature-removal-scheduletxt-remove-ns_cgroup-from-feature-removal-scheduletxt.patch
linux-next.patch
cris-fix-a-build-error-in-kernel-forkc.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
cris-fix-a-build-error-in-sync_serial_open.patch
cris-fix-the-prototype-of-sync_serial_ioctl.patch
cris-add-missing-declaration-of-kgdb_init-and-breakpoint.patch
mm-remove-the-leftovers-of-noswapaccount.patch
cris-fix-some-build-warnings-in-pinmuxc.patch
kexec-remove-kmsg_dump_kexec.patch

