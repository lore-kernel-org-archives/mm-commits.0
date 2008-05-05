From: akpm@linux-foundation.org
Subject: + x86-geode-define-geode_has_vsa2-even-if-config_mgeode_lx-is-not-set.patch added to -mm tree
Date: Mon, 05 May 2008 16:03:21 -0700
Message-ID: <200805052303.m45N3Loq009876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582AbYEEXEI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 19:04:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, dilinger@debian.org, jordan.crouse@amd.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: geode: define geode_has_vsa2() even if CONFIG_MGEODE_LX is not set
has been added to the -mm tree.  Its filename is
     x86-geode-define-geode_has_vsa2-even-if-config_mgeode_lx-is-not-set.patch

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

x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
x86-geode-define-geode_has_vsa2-even-if-config_mgeode_lx-is-not-set.patch
git-battery.patch

