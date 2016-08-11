From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 11 Aug 2016 11:35:49 -0700
Message-ID: <57acc585.UOEZrVP8K6yoFKU9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbcHKSfv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 14:35:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.gcc-plugins |   16 ----------------
 scripts/gcc-plugins/Makefile |    5 -----
 2 files changed, 21 deletions(-)

diff -puN scripts/Makefile.gcc-plugins~linux-next-git-rejects scripts/Makefile.gcc-plugins
--- a/scripts/Makefile.gcc-plugins~linux-next-git-rejects
+++ a/scripts/Makefile.gcc-plugins
@@ -26,21 +26,6 @@ ifdef CONFIG_GCC_PLUGINS
   endif
 
   GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
-<<<<<<< HEAD
-
-  export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN GCC_PLUGIN_SUBDIR SANCOV_PLUGIN
-
-  ifneq ($(PLUGINCC),)
-    # SANCOV_PLUGIN can be only in CFLAGS_KCOV because avoid duplication.
-    GCC_PLUGINS_CFLAGS := $(filter-out $(SANCOV_PLUGIN), $(GCC_PLUGINS_CFLAGS))
-  endif
-
-  KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
-  GCC_PLUGIN := $(gcc-plugin-y)
-  GCC_PLUGIN_SUBDIR := $(gcc-plugin-subdir-y)
-endif
-
-=======
 
   export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN GCC_PLUGIN_SUBDIR SANCOV_PLUGIN DISABLE_LATENT_ENTROPY_PLUGIN
 
@@ -54,7 +39,6 @@ endif
   GCC_PLUGIN_SUBDIR := $(gcc-plugin-subdir-y)
 endif
 
->>>>>>> linux-next/akpm-base
 # If plugins aren't supported, abort the build before hard-to-read compiler
 # errors start getting spewed by the main build.
 PHONY += gcc-plugins-check
diff -puN scripts/gcc-plugins/Makefile~linux-next-git-rejects scripts/gcc-plugins/Makefile
--- a/scripts/gcc-plugins/Makefile~linux-next-git-rejects
+++ a/scripts/gcc-plugins/Makefile
@@ -22,11 +22,6 @@ $(HOSTLIBS)-y := $(foreach p,$(GCC_PLUGI
 always := $($(HOSTLIBS)-y)
 $(foreach p,$($(HOSTLIBS)-y:%.so=%),$(eval $(p)-objs := $(p).o))
 
-<<<<<<< HEAD
-$(foreach p,$($(HOSTLIBS)-y:%.so=%),$(eval $(p)-objs := $(p).o))
