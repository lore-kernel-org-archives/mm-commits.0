From: akpm@linux-foundation.org
Subject: + bootmemc-avoid-c90-declaration-warning-cleanup.patch added to -mm tree
Date: Thu, 18 Jun 2009 13:25:38 -0700
Message-ID: <200906182025.n5IKPcQ7004072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbZFRU1L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 16:27:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, hannes@cmpxchg.org, joe@perches.com, penberg@cs.helsinki.fi, tj@kernel.org


The patch titled
     bootmemc-avoid-c90-declaration-warning-cleanup
has been added to the -mm tree.  Its filename is
     bootmemc-avoid-c90-declaration-warning-cleanup.patch

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
Subject: bootmemc-avoid-c90-declaration-warning-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Joe Perches <joe@perches.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/bootmem.c~bootmemc-avoid-c90-declaration-warning-cleanup mm/bootmem.c
--- a/mm/bootmem.c~bootmemc-avoid-c90-declaration-warning-cleanup
+++ a/mm/bootmem.c
@@ -537,11 +537,13 @@ static void * __init alloc_arch_preferre
 
 #ifdef CONFIG_HAVE_ARCH_BOOTMEM
 	{
-	bootmem_data_t *p_bdata;
+		bootmem_data_t *p_bdata;
 
-	p_bdata = bootmem_arch_preferred_node(bdata, size, align, goal, limit);
-	if (p_bdata)
-		return alloc_bootmem_core(p_bdata, size, align, goal, limit);
+		p_bdata = bootmem_arch_preferred_node(bdata, size, align,
+							goal, limit);
+		if (p_bdata)
+			return alloc_bootmem_core(p_bdata, size, align,
+							goal, limit);
 	}
 #endif
 	return NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
maintainers-fbdev-is-orphaned.patch
gpio-pca953x-get-platform_data-from-openfirmware.patch
documentation-changes-perl-is-needed-to-build-the-kernel.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist.patch
edac-add-cpc925-memory-controller-driver.patch
edac-add-edac_device_alloc_index.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions.patch
lib-add-lib-gcdc.patch
bootmemc-avoid-c90-declaration-warning-cleanup.patch
char-moxa-prevent-opening-unavailable-ports.patch

