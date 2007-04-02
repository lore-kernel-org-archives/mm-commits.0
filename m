From: akpm@linux-foundation.org
Subject: + kbuild-fix-dependency-generation.patch added to -mm tree
Date: Sun, 01 Apr 2007 22:25:31 -0700
Message-ID: <200704020525.l325PV8V024922@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35969 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274AbXDBFZm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 01:25:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, sam@ravnborg.org


The patch titled
     kbuild: fix dependency generation
has been added to the -mm tree.  Its filename is
     kbuild-fix-dependency-generation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kbuild: fix dependency generation
From: Jan Beulich <jbeulich@novell.com>

Commit 2e3646e51b2d6415549b310655df63e7e0d7a080 changed the way
the split config tree is built, but failed to also adjust fixdep
accordingly - if changing a config option from or to m, files
referencing the respective CONFIG_..._MODULE (but not the
corresponding CONFIG_...) didn't get rebuilt.

The problem is that trisate symbol are represent with three
SYMBOL=n => no symbol defined
SYMBOL=y => CONFIG_SYMBOL defined to '1'
SYMBOL=m => CONFIG_SYMBOL_MODULE defined to '1'

But conf_split_config do not distingush between the =y and =m case,
so only the =y case is honoured.
This is fixed in fixdep so when a CONFIG symbol with
_MODULE is found we skip that part and only look
for the CONFIG_SYMBOL version.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/basic/fixdep.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN scripts/basic/fixdep.c~kbuild-fix-dependency-generation scripts/basic/fixdep.c
--- a/scripts/basic/fixdep.c~kbuild-fix-dependency-generation
+++ a/scripts/basic/fixdep.c
@@ -28,9 +28,11 @@
  * the dependency on linux/autoconf.h by a dependency on every config
  * option which is mentioned in any of the listed prequisites.
  *
- * To be exact, split-include populates a tree in include/config/,
- * e.g. include/config/his/driver.h, which contains the #define/#undef
- * for the CONFIG_HIS_DRIVER option.
+ * kconfig populates a tree in include/config/ with an empty file
+ * for each config symbol and when the configuration is updated
+ * the files representing changed config options are touched
+ * which then let make pick up the changes and the files that use
+ * the config symbols are rebuilt.
  *
  * So if the user changes his CONFIG_HIS_DRIVER option, only the objects
  * which depend on "include/linux/config/his/driver.h" will be rebuilt,
@@ -245,6 +247,8 @@ void parse_config_file(char *map, size_t
 		continue;
 
 	found:
+		if (!memcmp(q - 7, "_MODULE", 7))
+			q -= 7;
 		use_config(p+7, q-p-7);
 	}
 }
_

Patches currently in -mm which might be from jbeulich@novell.com are

remove-pci_dac_dma_-apis.patch
kbuild-fix-dependency-generation.patch
use-stop_machine_run-in-the-intel-rng-driver.patch
