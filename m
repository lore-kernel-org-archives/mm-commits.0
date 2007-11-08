From: akpm@linux-foundation.org
Subject: + blackfin-remove-dead-config-symbol-from-blackfin-code.patch added to -mm tree
Date: Thu, 08 Nov 2007 09:39:52 -0800
Message-ID: <200711081739.lA8HdqHc006472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757013AbXKHRkg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 12:40:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olsajiri@gmail.com, bryan.wu@analog.com


The patch titled
     blackfin: remove dead config symbol from BLACKFIN code
has been added to the -mm tree.  Its filename is
     blackfin-remove-dead-config-symbol-from-blackfin-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: blackfin: remove dead config symbol from BLACKFIN code
From: Jiri Olsa <olsajiri@gmail.com>

Remove dead config symbols from BLACKFIN code.

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Cc: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-blackfin/mach-bf527/mem_init.h |    9 +--------
 include/asm-blackfin/mach-bf537/mem_init.h |    9 +--------
 2 files changed, 2 insertions(+), 16 deletions(-)

diff -puN include/asm-blackfin/mach-bf527/mem_init.h~blackfin-remove-dead-config-symbol-from-blackfin-code include/asm-blackfin/mach-bf527/mem_init.h
--- a/include/asm-blackfin/mach-bf527/mem_init.h~blackfin-remove-dead-config-symbol-from-blackfin-code
+++ a/include/asm-blackfin/mach-bf527/mem_init.h
@@ -29,7 +29,7 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#if (CONFIG_MEM_MT48LC16M16A2TG_75 || CONFIG_MEM_MT48LC64M4A2FB_7E || CONFIG_MEM_MT48LC16M8A2TG_75 || CONFIG_MEM_GENERIC_BOARD || CONFIG_MEM_MT48LC32M8A2_75 || CONFIG_MEM_MT48LC32M16A2TG_75)
+#if (CONFIG_MEM_MT48LC16M16A2TG_75 || CONFIG_MEM_MT48LC64M4A2FB_7E || CONFIG_MEM_GENERIC_BOARD || CONFIG_MEM_MT48LC32M8A2_75 || CONFIG_MEM_MT48LC32M16A2TG_75)
 #if (CONFIG_SCLK_HZ > 119402985)
 #define SDRAM_tRP       TRP_2
 #define SDRAM_tRP_num   2
@@ -111,13 +111,6 @@
 #define SDRAM_CL    CL_3
 #endif
 
-#if (CONFIG_MEM_MT48LC16M8A2TG_75)
-  /*SDRAM INFORMATION: */
-#define SDRAM_Tref  64		/* Refresh period in milliseconds   */
-#define SDRAM_NRA   4096	/* Number of row addresses in SDRAM */
-#define SDRAM_CL    CL_3
-#endif
-
 #if (CONFIG_MEM_MT48LC32M8A2_75)
   /*SDRAM INFORMATION: */
 #define SDRAM_Tref  64		/* Refresh period in milliseconds   */
diff -puN include/asm-blackfin/mach-bf537/mem_init.h~blackfin-remove-dead-config-symbol-from-blackfin-code include/asm-blackfin/mach-bf537/mem_init.h
--- a/include/asm-blackfin/mach-bf537/mem_init.h~blackfin-remove-dead-config-symbol-from-blackfin-code
+++ a/include/asm-blackfin/mach-bf537/mem_init.h
@@ -29,7 +29,7 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#if (CONFIG_MEM_MT48LC16M16A2TG_75 || CONFIG_MEM_MT48LC64M4A2FB_7E || CONFIG_MEM_MT48LC16M8A2TG_75 || CONFIG_MEM_GENERIC_BOARD || CONFIG_MEM_MT48LC32M8A2_75)
+#if (CONFIG_MEM_MT48LC16M16A2TG_75 || CONFIG_MEM_MT48LC64M4A2FB_7E || CONFIG_MEM_GENERIC_BOARD || CONFIG_MEM_MT48LC32M8A2_75)
 #if (CONFIG_SCLK_HZ > 119402985)
 #define SDRAM_tRP       TRP_2
 #define SDRAM_tRP_num   2
@@ -111,13 +111,6 @@
 #define SDRAM_CL    CL_3
 #endif
 
-#if (CONFIG_MEM_MT48LC16M8A2TG_75)
-  /*SDRAM INFORMATION: */
-#define SDRAM_Tref  64		/* Refresh period in milliseconds   */
-#define SDRAM_NRA   4096	/* Number of row addresses in SDRAM */
-#define SDRAM_CL    CL_3
-#endif
-
 #if (CONFIG_MEM_MT48LC32M8A2_75)
   /*SDRAM INFORMATION: */
 #define SDRAM_Tref  64		/* Refresh period in milliseconds   */
_

Patches currently in -mm which might be from olsajiri@gmail.com are

drivers-serial-s3c2410c-remove-dead-config-symbols.patch
blackfin-remove-dead-config-symbol-from-blackfin-code.patch
