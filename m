From: akpm@linux-foundation.org
Subject: [merged] x86-define-arch_want_frame_pointers.patch removed from -mm tree
Date: Wed, 11 Feb 2009 14:19:17 -0800
Message-ID: <200902112219.n1BMJIwc007002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755241AbZBKWTv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 17:19:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     x86: define ARCH_WANT_FRAME_POINTERS
has been removed from the -mm tree.  Its filename was
     x86-define-arch_want_frame_pointers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: define ARCH_WANT_FRAME_POINTERS
From: Jeff Mahoney <jeffm@suse.com>

Commit da4276b8299a6544dc41ac2485d3ffca5811b3fb changed a dependency for
FRAME_POINTER from X86 to ARCH_WANT_FRAME_POINTERS, but didn't actually
define it.

This patch adds the definition for ARCH_WANT_FRAME_POINTERS.  Without it,
FRAME_POINTER can't be enabled on x86.

[akpm@linux-foundation.org: unbust the whitespace]
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN lib/Kconfig.debug~x86-define-arch_want_frame_pointers lib/Kconfig.debug
--- a/lib/Kconfig.debug~x86-define-arch_want_frame_pointers
+++ a/lib/Kconfig.debug
@@ -670,6 +670,12 @@ config ARCH_WANT_FRAME_POINTERS
 	bool
 	help
 
+config ARCH_WANT_FRAME_POINTERS
+	bool
+	help
+	  Select this config option from the architecture Kconfig, if it
+	  it is preferred to always enable frame pointers on the architecture.
+
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
 	depends on DEBUG_KERNEL && \
_

Patches currently in -mm which might be from jeffm@suse.com are

x86-define-arch_want_frame_pointers.patch

