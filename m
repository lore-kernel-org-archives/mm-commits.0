From: akpm@linux-foundation.org
Subject: [merged] memblock-add-no_bootmem-config-symbol.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:10:08 -0700
Message-ID: <201111012110.pA1LA82U017599@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:28962 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab1KAVKT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:10:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, hpa@zytor.com, tj@kernel.org, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: add NO_BOOTMEM config symbol
has been removed from the -mm tree.  Its filename was
     memblock-add-no_bootmem-config-symbol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sam Ravnborg <sam@ravnborg.org>
Subject: memblock: add NO_BOOTMEM config symbol

With the NO_BOOTMEM symbol added architectures may now use the following
syntax to tell that they do not need bootmem:

	select NO_BOOTMEM

This is much more convinient than adding a new kconfig symbol which was
otherwise required.

Adding this symbol does not conflict with the architctures that already
define their own symbol.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/Kconfig~memblock-add-no_bootmem-config-symbol mm/Kconfig
--- a/mm/Kconfig~memblock-add-no_bootmem-config-symbol
+++ a/mm/Kconfig
@@ -131,6 +131,9 @@ config SPARSEMEM_VMEMMAP
 config HAVE_MEMBLOCK
 	boolean
 
+config NO_BOOTMEM
+	boolean
+
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
linux-next.patch

