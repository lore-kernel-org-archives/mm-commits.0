From: akpm@linux-foundation.org
Subject: + powerpc-export-of_find_property.patch added to -mm tree
Date: Wed, 14 Feb 2007 23:49:21 -0800
Message-ID: <200702150749.l1F7nLiD023334@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38263 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964982AbXBOHtx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 02:49:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, arnd.bergmann@de.ibm.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     powerpc: export of_find_property
has been added to the -mm tree.  Its filename is
     powerpc-export-of_find_property.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: powerpc: export of_find_property
From: Dave Jones <davej@redhat.com>

Without this, building drivers/serial/of_serial.c as a module fails.

WARNING: ".of_find_property" [drivers/serial/of_serial.ko] undefined!

Signed-off-by: Dave Jones <davej@redhat.com>
Acked-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/prom.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/kernel/prom.c~powerpc-export-of_find_property arch/powerpc/kernel/prom.c
--- a/arch/powerpc/kernel/prom.c~powerpc-export-of_find_property
+++ a/arch/powerpc/kernel/prom.c
@@ -1605,6 +1605,7 @@ struct property *of_find_property(const 
 
 	return pp;
 }
+EXPORT_SYMBOL(of_find_property);
 
 /*
  * Find a property with a given name for a given node
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
git-agpgart.patch
git-cpufreq.patch
powerpc-export-of_find_property.patch
loosen-dependancy-on-rtc-cmos.patch
