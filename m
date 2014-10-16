From: akpm@linux-foundation.org
Subject: + mm-numa-balancing-rearrange-kconfig-entry.patch added to -mm
 tree
Date: Thu, 16 Oct 2014 13:05:27 -0700
Message-ID: <54402507.ba2IwepIZ6EjhQSP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaJPUF1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Oct 2014 16:05:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/numa balancing: rearrange Kconfig entry
has been added to the -mm tree.  Its filename is
     mm-numa-balancing-rearrange-kconfig-entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-balancing-rearrange-kconfig-entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-balancing-rearrange-kconfig-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/numa balancing: rearrange Kconfig entry

Add the default enable config option after the NUMA_BALANCING option so
that it appears related in the nconfig interface.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN init/Kconfig~mm-numa-balancing-rearrange-kconfig-entry init/Kconfig
--- a/init/Kconfig~mm-numa-balancing-rearrange-kconfig-entry
+++ a/init/Kconfig
@@ -900,14 +900,6 @@ config ARCH_SUPPORTS_INT128
 config ARCH_WANT_NUMA_VARIABLE_LOCALITY
 	bool
 
-config NUMA_BALANCING_DEFAULT_ENABLED
-	bool "Automatically enable NUMA aware memory/task placement"
-	default y
-	depends on NUMA_BALANCING
-	help
-	  If set, automatic NUMA balancing will be enabled if running on a NUMA
-	  machine.
-
 config NUMA_BALANCING
 	bool "Memory placement aware NUMA scheduler"
 	depends on ARCH_SUPPORTS_NUMA_BALANCING
@@ -920,6 +912,14 @@ config NUMA_BALANCING
 
 	  This system will be inactive on UMA systems.
 
+config NUMA_BALANCING_DEFAULT_ENABLED
+	bool "Automatically enable NUMA aware memory/task placement"
+	default y
+	depends on NUMA_BALANCING
+	help
+	  If set, automatic NUMA balancing will be enabled if running on a NUMA
+	  machine.
+
 menuconfig CGROUPS
 	boolean "Control Group support"
 	select KERNFS
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
mm-numa-balancing-rearrange-kconfig-entry.patch

