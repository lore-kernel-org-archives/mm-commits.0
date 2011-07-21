From: akpm@linux-foundation.org
Subject: [merged] kernel-makefile-prevent-unnecessary-rebuilding-due-to-config_datagz.patch removed from -mm tree
Date: Thu, 21 Jul 2011 12:12:31 -0700
Message-ID: <201107211912.p6LJCObq032251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189Ab1GUTM7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jul 2011 15:12:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pefoley2@verizon.net, mmarek@suse.cz, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     kernel/Makefile: prevent unnecessary rebuilding due to config_data.gz
has been removed from the -mm tree.  Its filename was
     kernel-makefile-prevent-unnecessary-rebuilding-due-to-config_datagz.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/Makefile: prevent unnecessary rebuilding due to config_data.gz
From: Peter Foley <pefoley2@verizon.net>

When IKCONFIG is built-in, make oldconfig will cause the kernel to be
relinked even if .config didn't change.  This happens because of a
config_data.gz dependency on .config.  This patch changes the if_changed
to a filechk so that config_data.h is only rebuilt when the contents have
actually changed.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/Makefile~kernel-makefile-prevent-unnecessary-rebuilding-due-to-config_datagz kernel/Makefile
--- a/kernel/Makefile~kernel-makefile-prevent-unnecessary-rebuilding-due-to-config_datagz
+++ a/kernel/Makefile
@@ -125,11 +125,10 @@ targets += config_data.gz
 $(obj)/config_data.gz: $(KCONFIG_CONFIG) FORCE
 	$(call if_changed,gzip)
 
-quiet_cmd_ikconfiggz = IKCFG   $@
-      cmd_ikconfiggz = (echo "static const char kernel_config_data[] __used = MAGIC_START"; cat $< | scripts/bin2c; echo "MAGIC_END;") > $@
+      filechk_ikconfiggz = (echo "static const char kernel_config_data[] __used = MAGIC_START"; cat $< | scripts/bin2c; echo "MAGIC_END;")
 targets += config_data.h
 $(obj)/config_data.h: $(obj)/config_data.gz FORCE
-	$(call if_changed,ikconfiggz)
+	$(call filechk,ikconfiggz)
 
 $(obj)/time.o: $(obj)/timeconst.h
 
_

Patches currently in -mm which might be from pefoley2@verizon.net are

linux-next.patch

