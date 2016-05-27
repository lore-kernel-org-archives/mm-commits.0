From: akpm@linux-foundation.org
Subject: [merged]
 scripts-gdb-adjust-module-reference-counter-reported-by-lx-lsmod.patch
 removed from -mm tree
Date: Fri, 27 May 2016 11:43:56 -0700
Message-ID: <5748956c.HyrSkUFADpUIemJU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbcE0Sn5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:43:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: Adjust module reference counter reported by lx-lsmod
has been removed from the -mm tree.  Its filename was
     scripts-gdb-adjust-module-reference-counter-reported-by-lx-lsmod.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: Adjust module reference counter reported by lx-lsmod

This takes the MODULE_REF_BASE into account.

Link: http://lkml.kernel.org/r/d926d2d54caa034adb964b52215090cbdb875249.1462865983.git.jan.kiszka@siemens.com
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/modules.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/gdb/linux/modules.py~scripts-gdb-adjust-module-reference-counter-reported-by-lx-lsmod scripts/gdb/linux/modules.py
--- a/scripts/gdb/linux/modules.py~scripts-gdb-adjust-module-reference-counter-reported-by-lx-lsmod
+++ a/scripts/gdb/linux/modules.py
@@ -78,7 +78,7 @@ class LxLsmod(gdb.Command):
                 address=str(layout['base']).split()[0],
                 name=module['name'].string(),
                 size=str(layout['size']),
-                ref=str(module['refcnt']['counter'])))
+                ref=str(module['refcnt']['counter'] - 1)))
 
             source_list = module['source_list']
             t = self._module_use_type.get_type().pointer()
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are


