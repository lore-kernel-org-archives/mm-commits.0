From: akpm@linux-foundation.org
Subject: - x86-64-remove-unused-variable-maxcpus.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:04 -0700
Message-ID: <200707192010.l6JKA421020638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52897 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760026AbXGSUPW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86-64: remove unused variable maxcpus
has been removed from the -mm tree.  Its filename was
     x86-64-remove-unused-variable-maxcpus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64: remove unused variable maxcpus
From: "Jan Beulich" <jbeulich@novell.com>

.. and adjust documentation to properly reflect options that are
x86-64 specific.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86_64/boot-options.txt |    6 ------
 arch/x86_64/kernel/mpparse.c          |    1 -
 2 files changed, 7 deletions(-)

diff -puN Documentation/x86_64/boot-options.txt~x86-64-remove-unused-variable-maxcpus Documentation/x86_64/boot-options.txt
--- a/Documentation/x86_64/boot-options.txt~x86-64-remove-unused-variable-maxcpus
+++ a/Documentation/x86_64/boot-options.txt
@@ -136,12 +136,6 @@ Non Executable Mappings
 
 SMP
 
-  nosmp	Only use a single CPU
-
-  maxcpus=NUMBER only use upto NUMBER CPUs
-
-  cpumask=MASK   only use cpus with bits set in mask
-
   additional_cpus=NUM Allow NUM more CPUs for hotplug
 		 (defaults are specified by the BIOS, see Documentation/x86_64/cpu-hotplug-spec)
 
diff -puN arch/x86_64/kernel/mpparse.c~x86-64-remove-unused-variable-maxcpus arch/x86_64/kernel/mpparse.c
--- a/arch/x86_64/kernel/mpparse.c~x86-64-remove-unused-variable-maxcpus
+++ a/arch/x86_64/kernel/mpparse.c
@@ -32,7 +32,6 @@
 
 /* Have we found an MP table */
 int smp_found_config;
-unsigned int __initdata maxcpus = NR_CPUS;
 
 /*
  * Various Linux-internal data structures created from the
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
git-kbuild.patch
