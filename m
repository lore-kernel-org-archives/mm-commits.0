From: akpm@linux-foundation.org
Subject: - cgroup-memory-controller-document-huge-memory-cache-overhead-in-kconfig.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:11:14 -0800
Message-ID: <200802250011.m1P0BEIH004854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761233AbYBYALn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:11:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@suse.de, balbir@in.ibm.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroup memory controller: document huge memory/cache overhead in Kconfig
has been removed from the -mm tree.  Its filename was
     cgroup-memory-controller-document-huge-memory-cache-overhead-in-kconfig.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup memory controller: document huge memory/cache overhead in Kconfig
From: Andi Kleen <andi@firstfloor.org>

Document huge memory/cache overhead of memory controller in Kconfig

I was a little surprised that 2.6.25-rc* increased struct page for the
memory controller.  At least on many x86-64 machines it will not fit into a
single cache line now anymore and also costs considerable amounts of RAM. 
At earlier review I remembered asking for a external data structure for
this.

It's also quite unobvious that a innocent looking Kconfig option with a
single line Kconfig description has such a negative effect.

This patch attempts to document these disadvantages at least so that users
configuring their kernel can make a informed decision.

Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Balbir Singh <balbir@in.ibm.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN init/Kconfig~cgroup-memory-controller-document-huge-memory-cache-overhead-in-kconfig init/Kconfig
--- a/init/Kconfig~cgroup-memory-controller-document-huge-memory-cache-overhead-in-kconfig
+++ a/init/Kconfig
@@ -394,6 +394,14 @@ config CGROUP_MEM_CONT
 	  Provides a memory controller that manages both page cache and
 	  RSS memory.
 
+	  Note that setting this option increases fixed memory overhead
+	  associated with each page of memory in the system by 4/8 bytes
+	  and also increases cache misses because struct page on many 64bit
+	  systems will not fit into a single cache line anymore.
+
+	  Only enable when you're ok with these trade offs and really
+	  sure you need the memory controller.
+
 config PROC_PID_CPUSET
 	bool "Include legacy /proc/<pid>/cpuset file"
 	depends on CPUSETS
_

Patches currently in -mm which might be from andi@firstfloor.org are

cgroup-memory-controller-document-huge-memory-cache-overhead-in-kconfig.patch
git-x86.patch
