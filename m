From: akpm@linux-foundation.org
Subject: + kernel-makefile-prevent-unnecessary-rebuilding-due-to-config_datagz.patch added to -mm tree
Date: Wed, 06 Jul 2011 14:08:05 -0700
Message-ID: <201107062108.p66L851Y031750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756173Ab1GFVIw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jul 2011 17:08:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pefoley2@verizon.net, mmarek@suse.cz, rdunlap@xenotime.net


The patch titled
     kernel/Makefile: prevent unnecessary rebuilding due to config_data.gz
has been added to the -mm tree.  Its filename is
     kernel-makefile-prevent-unnecessary-rebuilding-due-to-config_datagz.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

kernel-makefile-prevent-unnecessary-rebuilding-due-to-config_datagz.patch

