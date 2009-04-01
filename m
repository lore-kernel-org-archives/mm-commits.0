From: akpm@linux-foundation.org
Subject: + remove-sgi_gru-as-a-valid-config-option-for-ia64-configs-with-sgi_uv.patch added to -mm tree
Date: Wed, 01 Apr 2009 12:31:50 -0700
Message-ID: <200904011931.n31JVoTf024130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759283AbZDATeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:34:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, steiner@sgi.com


The patch titled
     sgi-gru: remove SGI_GRU as a valid config option for ia64 configs with SGI_UV
has been added to the -mm tree.  Its filename is
     remove-sgi_gru-as-a-valid-config-option-for-ia64-configs-with-sgi_uv.patch

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
Subject: sgi-gru: remove SGI_GRU as a valid config option for ia64 configs with SGI_UV
From: Robin Holt <holt@sgi.com>

Some current configs turn on GRU for ia64.  The GRU code does not
correctly load on boot on ia64 (GRU does continue to work for x86-64), so
changing the IA64 Kconfig to not select GRU on ia64 configs for now until
we have time to fix.

Signed-off-by: Robin Holt <holt@sgi.com>
Acked-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/configs/generic_defconfig |    3 ---
 drivers/misc/Kconfig                |    4 ++--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -puN arch/ia64/configs/generic_defconfig~remove-sgi_gru-as-a-valid-config-option-for-ia64-configs-with-sgi_uv arch/ia64/configs/generic_defconfig
--- a/arch/ia64/configs/generic_defconfig~remove-sgi_gru-as-a-valid-config-option-for-ia64-configs-with-sgi_uv
+++ a/arch/ia64/configs/generic_defconfig
@@ -193,7 +193,6 @@ CONFIG_BOUNCE=y
 CONFIG_NR_QUICK=1
 CONFIG_VIRT_TO_BUS=y
 CONFIG_UNEVICTABLE_LRU=y
-CONFIG_MMU_NOTIFIER=y
 CONFIG_ARCH_SELECT_MEMORY_MODEL=y
 CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
 CONFIG_ARCH_FLATMEM_ENABLE=y
@@ -416,8 +415,6 @@ CONFIG_SGI_IOC4=y
 # CONFIG_ENCLOSURE_SERVICES is not set
 CONFIG_SGI_XP=m
 # CONFIG_HP_ILO is not set
-CONFIG_SGI_GRU=m
-# CONFIG_SGI_GRU_DEBUG is not set
 # CONFIG_C2PORT is not set
 CONFIG_HAVE_IDE=y
 CONFIG_IDE=y
diff -puN drivers/misc/Kconfig~remove-sgi_gru-as-a-valid-config-option-for-ia64-configs-with-sgi_uv drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~remove-sgi_gru-as-a-valid-config-option-for-ia64-configs-with-sgi_uv
+++ a/drivers/misc/Kconfig
@@ -165,7 +165,7 @@ config SGI_XP
 	depends on (IA64_GENERIC || IA64_SGI_SN2 || IA64_SGI_UV || X86_UV) && SMP
 	select IA64_UNCACHED_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
 	select GENERIC_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
-	select SGI_GRU if (IA64_GENERIC || IA64_SGI_UV || X86_64) && SMP
+	select SGI_GRU if X86_64 && SMP
 	---help---
 	  An SGI machine can be divided into multiple Single System
 	  Images which act independently of each other and have
@@ -189,7 +189,7 @@ config HP_ILO
 
 config SGI_GRU
 	tristate "SGI GRU driver"
-	depends on (X86_UV || IA64_SGI_UV || IA64_GENERIC) && SMP
+	depends on X86_UV && SMP
 	default n
 	select MMU_NOTIFIER
 	---help---
_

Patches currently in -mm which might be from holt@sgi.com are

remove-sgi_gru-as-a-valid-config-option-for-ia64-configs-with-sgi_uv.patch
xpc_sn2-fix-max-warning-about-pointers-of-different-types.patch
factor-out-ifdefs-from-kernel-spinlockc-to-lock_contended_flags.patch
allow-rwlocks-to-re-enable-interrupts.patch
ia64-implement-interrupt-enabling-rwlocks.patch

