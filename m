From: akpm@linux-foundation.org
Subject: [folded] cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:46:51 -0700
Message-ID: <200906172246.n5HMkpUD006979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755981AbZFQWrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:47:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix
has been removed from the -mm tree.  Its filename was
     cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch

This patch was dropped because it was folded into cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix
From: Andrew Morton <akpm@linux-foundation.org>

Fix shift for cpuset_subsys_id >= 32.

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cgroup.c~cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix
+++ a/kernel/cgroup.c
@@ -845,7 +845,7 @@ static int parse_cgroupfs_options(char *
 	unsigned long mask = (unsigned long)-1;
 
 #ifdef CONFIG_CPUSETS
-	mask = ~(1 << cpuset_subsys_id);
+	mask = ~(1UL << cpuset_subsys_id);
 #endif
 
 	opts->subsys_bits = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
maintainers-fbdev-is-orphaned.patch
gpio-pca953x-get-platform_data-from-openfirmware.patch
documentation-changes-perl-is-needed-to-build-the-kernel.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

