From: akpm@linux-foundation.org
Subject: + sysctl-use-proc_dointvec_unsigned-where-appropriate.patch added to -mm tree
Date: Mon, 07 Mar 2011 15:05:45 -0800
Message-ID: <201103072305.p27N5j7j000477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756385Ab1CGXOQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 18:14:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com


The patch titled
     sysctl: use proc_dointvec_unsigned() where appropriate
has been added to the -mm tree.  Its filename is
     sysctl-use-proc_dointvec_unsigned-where-appropriate.patch

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
Subject: sysctl: use proc_dointvec_unsigned() where appropriate
From: Dave Young <hidave.darkstar@gmail.com>

Use the new proc_do_intvec_unsigned() handler for various unsigned inputs.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff -puN kernel/sysctl.c~sysctl-use-proc_dointvec_unsigned-where-appropriate kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-use-proc_dointvec_unsigned-where-appropriate
+++ a/kernel/sysctl.c
@@ -1164,8 +1164,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_max_map_count,
 		.maxlen		= sizeof(sysctl_max_map_count),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
+		.proc_handler	= proc_dointvec_unsigned,
 	},
 #else
 	{
@@ -1173,8 +1172,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_nr_trim_pages,
 		.maxlen		= sizeof(sysctl_nr_trim_pages),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &zero,
+		.proc_handler	= proc_dointvec_unsigned,
 	},
 #endif
 	{
@@ -1189,16 +1187,14 @@ static struct ctl_table vm_table[] = {
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
@@ -1206,8 +1202,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_legacy_va_layout,
 		.maxlen		= sizeof(sysctl_legacy_va_layout),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-		.extra1		= &zero,
+		.proc_handler	= proc_dointvec_unsigned,
 	},
 #endif
 #ifdef CONFIG_NUMA
@@ -1216,8 +1211,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &zone_reclaim_mode,
 		.maxlen		= sizeof(zone_reclaim_mode),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-		.extra1		= &zero,
+		.proc_handler	= proc_dointvec_unsigned,
 	},
 	{
 		.procname	= "min_unmapped_ratio",
@@ -1272,8 +1266,7 @@ static struct ctl_table vm_table[] = {
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

sysctl-add-proc_dointvec_bool-handler.patch
sysctl-use-proc_dointvec_bool-where-appropriate.patch
sysctl-add-proc_dointvec_unsigned-handler.patch
sysctl-use-proc_dointvec_unsigned-where-appropriate.patch

