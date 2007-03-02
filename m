From: akpm@linux-foundation.org
Subject: + remove-constant_tsc-reporting-from-proc-cpuinfo-power.patch added to -mm tree
Date: Thu, 01 Mar 2007 18:33:24 -0800
Message-ID: <200703020233.l222XOpR030137@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35907 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932753AbXCBCdc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 21:33:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joerg.roedel@amd.com


The patch titled
     remove constant_tsc reporting from /proc/cpuinfo' power flags
has been added to the -mm tree.  Its filename is
     remove-constant_tsc-reporting-from-proc-cpuinfo-power.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
remove-constant_tsc-reporting-from-proc-cpuinfo-power.patch
