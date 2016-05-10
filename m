From: akpm@linux-foundation.org
Subject: +
 scripts-gdb-adjust-module-reference-counter-reported-by-lx-lsmod.patch
 added to -mm tree
Date: Tue, 10 May 2016 12:34:14 -0700
Message-ID: <573237b6.zxy49JmQcnNlwEUa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbcEJTeQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 15:34:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: Adjust module reference counter reported by lx-lsmod
has been added to the -mm tree.  Its filename is
     scripts-gdb-adjust-module-reference-counter-reported-by-lx-lsmod.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-adjust-module-reference-counter-reported-by-lx-lsmod.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-adjust-module-reference-counter-reported-by-lx-lsmod.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scripts-gdb-adjust-module-reference-counter-reported-by-lx-lsmod.patch
scripts-gdb-cast-cpu-numbers-to-integer.patch

