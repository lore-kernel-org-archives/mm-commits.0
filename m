From: akpm@linux-foundation.org
Subject: + sgi-xp-only-build-for-ia64-sn2-when-config_ia64_generic-specified-v2.patch added to -mm tree
Date: Mon, 27 Oct 2008 15:03:05 -0700
Message-ID: <200810272203.m9RM353o015716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273AbYJ0WD3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 18:03:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dcn@sgi.com, tony.luck@intel.com


The patch titled
     sgi-xp: only build for ia64-sn2 when CONFIG_IA64_GENERIC specified
has been added to the -mm tree.  Its filename is
     sgi-xp-only-build-for-ia64-sn2-when-config_ia64_generic-specified-v2.patch

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
Subject: sgi-xp: only build for ia64-sn2 when CONFIG_IA64_GENERIC specified
From: Dean Nelson <dcn@sgi.com>

For the time being build for ia64-sn2 alone when CONFIG_IA64_GENERIC is
specified.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/Makefile   |    4 ++--
 drivers/misc/sgi-xp/xp.h       |    4 ++++
 drivers/misc/sgi-xp/xpc_main.c |    4 ++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/misc/sgi-xp/Makefile~sgi-xp-only-build-for-ia64-sn2-when-config_ia64_generic-specified-v2 drivers/misc/sgi-xp/Makefile
--- a/drivers/misc/sgi-xp/Makefile~sgi-xp-only-build-for-ia64-sn2-when-config_ia64_generic-specified-v2
+++ a/drivers/misc/sgi-xp/Makefile
@@ -5,14 +5,14 @@
 obj-$(CONFIG_SGI_XP)		+= xp.o
 xp-y				:= xp_main.o
 xp-$(CONFIG_IA64_SGI_SN2)	+= xp_sn2.o xp_nofault.o
-xp-$(CONFIG_IA64_GENERIC)	+= xp_sn2.o xp_nofault.o xp_uv.o
+xp-$(CONFIG_IA64_GENERIC)	+= xp_sn2.o xp_nofault.o
 xp-$(CONFIG_IA64_SGI_UV)	+= xp_uv.o
 xp-$(CONFIG_X86_64)		+= xp_uv.o
 
 obj-$(CONFIG_SGI_XP)		+= xpc.o
 xpc-y				:= xpc_main.o xpc_channel.o xpc_partition.o
 xpc-$(CONFIG_IA64_SGI_SN2)	+= xpc_sn2.o
-xpc-$(CONFIG_IA64_GENERIC)	+= xpc_sn2.o xpc_uv.o
+xpc-$(CONFIG_IA64_GENERIC)	+= xpc_sn2.o
 xpc-$(CONFIG_IA64_SGI_UV) 	+= xpc_uv.o
 xpc-$(CONFIG_X86_64)		+= xpc_uv.o
 
diff -puN drivers/misc/sgi-xp/xp.h~sgi-xp-only-build-for-ia64-sn2-when-config_ia64_generic-specified-v2 drivers/misc/sgi-xp/xp.h
--- a/drivers/misc/sgi-xp/xp.h~sgi-xp-only-build-for-ia64-sn2-when-config_ia64_generic-specified-v2
+++ a/drivers/misc/sgi-xp/xp.h
@@ -19,7 +19,11 @@
 #include <asm/system.h>
 #include <asm/sn/arch.h>	/* defines is_shub1() and is_shub2() */
 #define is_shub()	ia64_platform_is("sn2")
+#ifdef CONFIG_IA64_SGI_UV
 #define is_uv()		ia64_platform_is("uv")
+#else
+#define is_uv()		0
+#endif
 #endif
 #ifdef CONFIG_X86_64
 #include <asm/genapic.h>
diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xp-only-build-for-ia64-sn2-when-config_ia64_generic-specified-v2 drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xp-only-build-for-ia64-sn2-when-config_ia64_generic-specified-v2
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -1104,7 +1104,7 @@ xpc_do_exit(enum xp_retval reason)
 
 	if (is_shub())
 		xpc_exit_sn2();
-	else
+	else if (is_uv())
 		xpc_exit_uv();
 }
 
@@ -1363,7 +1363,7 @@ out_2:
 out_1:
 	if (is_shub())
 		xpc_exit_sn2();
-	else
+	else if (is_uv())
 		xpc_exit_uv();
 	return ret;
 }
_

Patches currently in -mm which might be from dcn@sgi.com are

sgi-xp-only-build-for-ia64-sn2-when-config_ia64_generic-specified-v2.patch

