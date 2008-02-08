From: akpm@linux-foundation.org
Subject: + moduleparam-fix-alpha-ia64-and-ppc64-compile-failures.patch added to -mm tree
Date: Fri, 08 Feb 2008 14:43:39 -0800
Message-ID: <200802082243.m18Mhdqh017577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763029AbYBHWob (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 17:44:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, anton@samba.org, bunk@stusta.de, kamalesh@linux.vnet.ibm.com, paulus@samba.org, rth@twiddle.net, rusty@rustcorp.com.au, tony.luck@intel.com


The patch titled
     moduleparam: fix alpha, ia64 and ppc64 compile failures
has been added to the -mm tree.  Its filename is
     moduleparam-fix-alpha-ia64-and-ppc64-compile-failures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: moduleparam: fix alpha, ia64 and ppc64 compile failures
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

On alpha, ia64 and ppc64 only relocations to local data can go into
read-only sections. The vast majority of module parameters use the global
generic param_set_*/param_get_* functions, so the 'const' attribute for
struct kernel_param is not only useless, but it also causes compile
failures due to 'section type conflict' in those rare cases where
param_set/get are local functions.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=8964

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/moduleparam.h |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN include/linux/moduleparam.h~moduleparam-fix-alpha-ia64-and-ppc64-compile-failures include/linux/moduleparam.h
--- a/include/linux/moduleparam.h~moduleparam-fix-alpha-ia64-and-ppc64-compile-failures
+++ a/include/linux/moduleparam.h
@@ -62,6 +62,16 @@ struct kparam_array
 	void *elem;
 };
 
+/* On alpha, ia64 and ppc64 relocations to global data cannot go into
+   read-only sections (which is part of respective UNIX ABI on these
+   platforms). So 'const' makes no sense and even causes compile failures
+   with some compilers. */
+#if defined(CONFIG_ALPHA) || defined(CONFIG_IA64) || defined(CONFIG_PPC64)
+#define __moduleparam_const
+#else
+#define __moduleparam_const const
+#endif
+
 /* This is the fundamental function for registering boot/module
    parameters.  perm sets the visibility in sysfs: 000 means it's
    not there, read bits mean it's readable, write bits mean it's
@@ -71,7 +81,7 @@ struct kparam_array
 	static int __param_perm_check_##name __attribute__((unused)) =	\
 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2));	\
 	static const char __param_str_##name[] = prefix #name;		\
-	static struct kernel_param const __param_##name			\
+	static struct kernel_param __moduleparam_const __param_##name	\
 	__used								\
     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
 	= { __param_str_##name, perm, set, get, { arg } }
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

origin.patch
moduleparam-fix-alpha-ia64-and-ppc64-compile-failures.patch
make-sure-nobodys-leaking-resources.patch
