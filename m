From: akpm@linux-foundation.org
Subject: [patch 48/84] scripts/gdb: Adjust module reference counter
 reported by lx-lsmod
Date: Mon, 23 May 2016 16:24:37 -0700
Message-ID: <57439135.sgkbj0s4ofNf/Dlv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42264 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbcEWXYi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:24:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jan.kiszka@siemens.com

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
