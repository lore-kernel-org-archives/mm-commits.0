From: akpm@linux-foundation.org
Subject: + x86-define-arch_want_frame_pointers.patch added to -mm tree
Date: Fri, 16 Jan 2009 14:45:15 -0800
Message-ID: <200901162245.n0GMjFLC000551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761344AbZAPWpy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 17:45:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.com, mingo@elte.hu


The patch titled
     x86: define ARCH_WANT_FRAME_POINTERS
has been added to the -mm tree.  Its filename is
     x86-define-arch_want_frame_pointers.patch

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
Subject: x86: define ARCH_WANT_FRAME_POINTERS
From: Jeff Mahoney <jeffm@suse.com>

Commit da4276b8299a6544dc41ac2485d3ffca5811b3fb changed a dependency for
FRAME_POINTER from X86 to ARCH_WANT_FRAME_POINTERS, but didn't actually
define it.

This patch adds the definition for ARCH_WANT_FRAME_POINTERS.  Without it,
FRAME_POINTER can't be enabled on x86.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN lib/Kconfig.debug~x86-define-arch_want_frame_pointers lib/Kconfig.debug
--- a/lib/Kconfig.debug~x86-define-arch_want_frame_pointers
+++ a/lib/Kconfig.debug
@@ -603,6 +603,12 @@ config DEBUG_NOTIFIERS
 	  This is a relatively cheap check but if you care about maximum
 	  performance, say N.
 
+config ARCH_WANT_FRAME_POINTERS
+	bool
+       help
+        Select this config option from the architecture Kconfig, if it
+        it is preferred to always enable frame pointers on the architecture.
+
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
 	depends on DEBUG_KERNEL && \
_

Patches currently in -mm which might be from jeffm@suse.com are

x86-define-arch_want_frame_pointers.patch

