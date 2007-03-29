From: akpm@linux-foundation.org
Subject: - remove-constant_tsc-reporting-from-proc-cpuinfo-power.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:38:40 -0700
Message-ID: <200703292338.l2TNceci015237@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43110 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934387AbXC2Xim (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:38:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joerg.roedel@amd.com, mm-commits@vger.kernel.org


The patch titled
     remove constant_tsc reporting from /proc/cpuinfo' power flags
has been removed from the -mm tree.  Its filename was
     remove-constant_tsc-reporting-from-proc-cpuinfo-power.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove constant_tsc reporting from /proc/cpuinfo' power flags
From: Joerg Roedel <joerg.roedel@amd.com>

remove the reporting of the constant_tsc flag from the "power management"
field in /proc/cpuinfo.  The NULL value there was replaced by "" because
the former would result in a printout of [8] if the flag is set.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/proc.c |    3 +--
 arch/x86_64/kernel/setup.c  |    5 ++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/cpu/proc.c~remove-constant_tsc-reporting-from-proc-cpuinfo-power arch/i386/kernel/cpu/proc.c
--- a/arch/i386/kernel/cpu/proc.c~remove-constant_tsc-reporting-from-proc-cpuinfo-power
+++ a/arch/i386/kernel/cpu/proc.c
@@ -72,8 +72,7 @@ static int show_cpuinfo(struct seq_file 
 		"stc",
 		"100mhzsteps",
 		"hwpstate",
-		NULL,
-		NULL,	/* constant_tsc - moved to flags */
+		"",	/* constant_tsc - moved to flags */
 		/* nothing */
 	};
 	struct cpuinfo_x86 *c = v;
diff -puN arch/x86_64/kernel/setup.c~remove-constant_tsc-reporting-from-proc-cpuinfo-power arch/x86_64/kernel/setup.c
--- a/arch/x86_64/kernel/setup.c~remove-constant_tsc-reporting-from-proc-cpuinfo-power
+++ a/arch/x86_64/kernel/setup.c
@@ -987,9 +987,8 @@ static int show_cpuinfo(struct seq_file 
 		"stc",
 		"100mhzsteps",
 		"hwpstate",
-		NULL,	/* tsc invariant mapped to constant_tsc */
-		NULL,
-		/* nothing */	/* constant_tsc - moved to flags */
+		"",	/* tsc invariant mapped to constant_tsc */
+		/* nothing */
 	};
 
 
_

Patches currently in -mm which might be from joerg.roedel@amd.com are

git-kvm.patch
i386-extend-alternative-instructions-framework.patch
x86_64-changes-to-x86_64-architecture-for.patch
