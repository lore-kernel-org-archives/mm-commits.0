From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-use-proc_dointvec_unsigned-where-appropriate.patch removed from -mm tree
Date: Thu, 18 Aug 2011 14:52:38 -0700
Message-ID: <201108182152.p7ILqcZK029870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754337Ab1HRVwl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Aug 2011 17:52:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, adobriyan@gmail.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: use proc_dointvec_unsigned() where appropriate
has been removed from the -mm tree.  Its filename was
     sysctl-use-proc_dointvec_unsigned-where-appropriate.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: use proc_dointvec_unsigned() where appropriate
From: Dave Young <hidave.darkstar@gmail.com>

Use the new proc_do_intvec_unsigned() handler for various unsigned inputs.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff -puN kernel/sysctl.c~sysctl-use-proc_dointvec_unsigned-where-appropriate kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-use-proc_dointvec_unsigned-where-appropriate
+++ a/kernel/sysctl.c
@@ -1194,8 +1194,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_max_map_count,
 		.maxlen		= sizeof(sysctl_max_map_count),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
+		.proc_handler	= proc_dointvec_unsigned,
 	},
 #else
 	{
@@ -1203,8 +1202,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_nr_trim_pages,
 		.maxlen		= sizeof(sysctl_nr_trim_pages),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
+		.proc_handler	= proc_dointvec_unsigned,
 	},
 #endif
 	{
@@ -1219,16 +1217,14 @@ static struct ctl_table vm_table[] = {
 		.data		= &block_dump,
 		.maxlen		= sizeof(block_dump),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-		.extra1		= &zero,
+		.proc_handler	= proc_dointvec_unsigned,
 	},
 	{
 		.procname	= "vfs_cache_pressure",
 		.data		= &sysctl_vfs_cache_pressure,
 		.maxlen		= sizeof(sysctl_vfs_cache_pressure),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-		.extra1		= &zero,
+		.proc_handler	= proc_dointvec_unsigned,
 	},
 #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
 	{
@@ -1236,8 +1232,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_legacy_va_layout,
 		.maxlen		= sizeof(sysctl_legacy_va_layout),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-		.extra1		= &zero,
+		.proc_handler	= proc_dointvec_unsigned,
 	},
 #endif
 #ifdef CONFIG_NUMA
@@ -1246,8 +1241,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &zone_reclaim_mode,
 		.maxlen		= sizeof(zone_reclaim_mode),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-		.extra1		= &zero,
+		.proc_handler	= proc_dointvec_unsigned,
 	},
 	{
 		.procname	= "min_unmapped_ratio",
@@ -1302,8 +1296,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &vdso_enabled,
 		.maxlen		= sizeof(vdso_enabled),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-		.extra1		= &zero,
+		.proc_handler	= proc_dointvec_unsigned,
 	},
 #endif
 #ifdef CONFIG_HIGHMEM
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are


