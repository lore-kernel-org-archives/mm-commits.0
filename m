From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch removed from -mm
 tree
Date: Wed, 10 Dec 2014 15:19:22 -0800
Message-ID: <5488d4fa.5fzfjiqtcACJt+Cx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758169AbaLJXTX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:19:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, ebiederm@xmission.com, nicolas.dichtel@6wind.com, thierry.herbelot@6wind.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-proc-use-a-rb-tree-for-the-directory-entries-fix
has been removed from the -mm tree.  Its filename was
     fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch

This patch was dropped because it was folded into fs-proc-use-a-rb-tree-for-the-directory-entries.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-proc-use-a-rb-tree-for-the-directory-entries-fix

initialise proc_root.subdir at compile time

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Thierry Herbelot <thierry.herbelot@6wind.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/root.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/root.c~fs-proc-use-a-rb-tree-for-the-directory-entries-fix fs/proc/root.c
--- a/fs/proc/root.c~fs-proc-use-a-rb-tree-for-the-directory-entries-fix
+++ a/fs/proc/root.c
@@ -166,7 +166,6 @@ void __init proc_root_init(void)
 {
 	int err;
 
-	proc_root.subdir = RB_ROOT;
 	proc_init_inodecache();
 	err = register_filesystem(&proc_fs_type);
 	if (err)
@@ -252,6 +251,7 @@ struct proc_dir_entry proc_root = {
 	.proc_iops	= &proc_root_inode_operations, 
 	.proc_fops	= &proc_root_operations,
 	.parent		= &proc_root,
+	.subdir		= RB_ROOT,
 	.name		= "/proc",
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory.patch
slab-improve-checking-for-invalid-gfp_flags.patch
mm-memcontrol-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-fix-huge-zero-page-accounting-in-smaps-report.patch
fs-proc-use-a-rb-tree-for-the-directory-entries.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support-fix.patch
rtc-ds1374-add-watchdog-support-fix.patch
rtc-ds1374-add-watchdog-support-checkpatch-fixes.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch

