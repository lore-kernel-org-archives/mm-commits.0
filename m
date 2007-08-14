From: akpm@linux-foundation.org
Subject: - x86-add-cpu-codenames-for-kconfigcpu.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:14:23 -0700
Message-ID: <200708141914.l7EJEN2D016611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54691 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763109AbXHNTcG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:32:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oliver.pntr@gmail.com, ak@suse.de, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     x86: add cpu codenames for Kconfig.cpu
has been removed from the -mm tree.  Its filename was
     x86-add-cpu-codenames-for-kconfigcpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: add cpu codenames for Kconfig.cpu
From: "Oliver Pinter" <oliver.pntr@gmail.com>

add cpu core name for arch/i386/Kconfig.cpu:Pentium 4 sections help
add Pentium D for arch/i386/Kconfig.cpu
add Pentium D for arch/x86_64/Kconfig

Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig.cpu |   34 +++++++++++++++++++++++++++++++---
 arch/x86_64/Kconfig   |    6 +++---
 2 files changed, 34 insertions(+), 6 deletions(-)

diff -puN arch/i386/Kconfig.cpu~x86-add-cpu-codenames-for-kconfigcpu arch/i386/Kconfig.cpu
--- a/arch/i386/Kconfig.cpu~x86-add-cpu-codenames-for-kconfigcpu
+++ a/arch/i386/Kconfig.cpu
@@ -115,11 +115,39 @@ config MPENTIUM4
 	bool "Pentium-4/Celeron(P4-based)/Pentium-4 M/older Xeon"
 	help
 	  Select this for Intel Pentium 4 chips.  This includes the
-	  Pentium 4, P4-based Celeron and Xeon, and Pentium-4 M
-	  (not Pentium M) chips.  This option enables compile flags
-	  optimized for the chip, uses the correct cache shift, and
+	  Pentium 4, Pentium D, P4-based Celeron and Xeon, and
+	  Pentium-4 M (not Pentium M) chips.  This option enables compile
+	  flags optimized for the chip, uses the correct cache shift, and
 	  applies any applicable Pentium III optimizations.
 
+	  CPUIDs: F[0-6][1-A] (in /proc/cpuinfo show = cpu family : 15 )
+
+	  Select this for:
+	    Pentiums (Pentium 4, Pentium D, Celeron, Celeron D) corename:
+		-Willamette
+		-Northwood
+		-Mobile Pentium 4
+		-Mobile Pentium 4 M
+		-Extreme Edition (Gallatin)
+		-Prescott
+		-Prescott 2M
+		-Cedar Mill
+		-Presler
+		-Smithfiled
+	    Xeons (Intel Xeon, Xeon MP, Xeon LV, Xeon MV) corename:
+	    	-Foster
+		-Prestonia
+		-Gallatin
+		-Nocona
+		-Irwindale
+		-Cranford
+		-Potomac
+		-Paxville
+		-Dempsey
+
+	  more info: http://balusc.xs4all.nl/srv/har-cpu.html
+
+
 config MK6
 	bool "K6/K6-II/K6-III"
 	help
diff -puN arch/x86_64/Kconfig~x86-add-cpu-codenames-for-kconfigcpu arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~x86-add-cpu-codenames-for-kconfigcpu
+++ a/arch/x86_64/Kconfig
@@ -171,9 +171,9 @@ config MK8
 config MPSC
        bool "Intel P4 / older Netburst based Xeon"
        help
-	  Optimize for Intel Pentium 4 and older Nocona/Dempsey Xeon CPUs
-	  with Intel Extended Memory 64 Technology(EM64T). For details see
-	  <http://www.intel.com/technology/64bitextensions/>.
+	  Optimize for Intel Pentium 4, Pentium D and older Nocona/Dempsey
+	  Xeon CPUs with Intel Extended Memory 64 Technology(EM64T). For
+	  details see <http://www.intel.com/technology/64bitextensions/>.
 	  Note that the latest Xeons (Xeon 51xx and 53xx) are not based on the
           Netburst core and shouldn't use this option. You can distinguish them
 	  using the cpu family field
_

Patches currently in -mm which might be from oliver.pntr@gmail.com are
