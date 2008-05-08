From: akpm@linux-foundation.org
Subject: - x86-geode-define-geode_has_vsa2-even-if-config_mgeode_lx-is-not-set.patch removed from -mm tree
Date: Thu, 08 May 2008 12:31:47 -0700
Message-ID: <200805081931.m48JVl3c001895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755838AbYEHTcw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 15:32:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, jordan.crouse@amd.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: geode: define geode_has_vsa2() even if CONFIG_MGEODE_LX is not set
has been removed from the -mm tree.  Its filename was
     x86-geode-define-geode_has_vsa2-even-if-config_mgeode_lx-is-not-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: geode: define geode_has_vsa2() even if CONFIG_MGEODE_LX is not set
From: Andres Salomon <dilinger@queued.net>

We want drivers to be able to use geode_has_vsa2 without having to worry
about what model geode is being compiled for.  This patch ensures that
geode_has_vsa2 is always defined.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/geode.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/asm-x86/geode.h~x86-geode-define-geode_has_vsa2-even-if-config_mgeode_lx-is-not-set include/asm-x86/geode.h
--- a/include/asm-x86/geode.h~x86-geode-define-geode_has_vsa2-even-if-config_mgeode_lx-is-not-set
+++ a/include/asm-x86/geode.h
@@ -185,7 +185,14 @@ static inline int is_geode(void)
 	return (is_geode_gx() || is_geode_lx());
 }
 
+#ifdef CONFIG_MGEODE_LX
 extern int geode_has_vsa2(void);
+#else
+static inline int geode_has_vsa2(void)
+{
+	return 0;
+}
+#endif
 
 /* MFGPTs */
 
_

Patches currently in -mm which might be from dilinger@queued.net are

revert-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch
git-x86.patch
git-input.patch
git-battery.patch

