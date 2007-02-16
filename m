From: akpm@linux-foundation.org
Subject: - fix-cut-and-paste-breakage-in-arch-powerpc-platforms-pseries-pseriesh.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:02:49 -0800
Message-ID: <200702160802.l1G82nsM023961@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58785 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423388AbXBPIDC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:03:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Fix cut and paste breakage in arch/powerpc/platforms/pseries/pseries.h
has been removed from the -mm tree.  Its filename was
     fix-cut-and-paste-breakage-in-arch-powerpc-platforms-pseries-pseriesh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix cut and paste breakage in arch/powerpc/platforms/pseries/pseries.h
From: Michael Ellerman <michael@ellerman.id.au>

My "cleanup" patch (dce623e0827e8d0ad60ce7f385c3394bf1b0bae0) had a cut
and paste error for the !CONFIG_KEXEC case. Fifty lashes for me.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/pseries.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/platforms/pseries/pseries.h~fix-cut-and-paste-breakage-in-arch-powerpc-platforms-pseries-pseriesh arch/powerpc/platforms/pseries/pseries.h
--- a/arch/powerpc/platforms/pseries/pseries.h~fix-cut-and-paste-breakage-in-arch-powerpc-platforms-pseries-pseriesh
+++ a/arch/powerpc/platforms/pseries/pseries.h
@@ -29,8 +29,8 @@ static inline smp_init_pseries_xics(void
 extern void setup_kexec_cpu_down_xics(void);
 extern void setup_kexec_cpu_down_mpic(void);
 #else
-static inline setup_kexec_cpu_down_xics(void) { };
-static inline setup_kexec_cpu_down_mpic(void) { };
+static inline void setup_kexec_cpu_down_xics(void) { }
+static inline void setup_kexec_cpu_down_mpic(void) { }
 #endif
 
 #endif /* _PSERIES_PSERIES_H */
_

Patches currently in -mm which might be from michael@ellerman.id.au are

origin.patch
git-powerpc.patch
powerpc-rtas-msi-support.patch
