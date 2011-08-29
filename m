From: akpm@linux-foundation.org
Subject: + um-disable-cmpxchg_double-as-it-breaks-uml-build.patch added to -mm tree
Date: Mon, 29 Aug 2011 14:35:31 -0700
Message-ID: <201108292135.p7TLZV5O030251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755180Ab1H2Vg2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 17:36:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cascardo@holoscopio.com, cl@linux.com, jdike@addtoit.com, richard@nod.at


The patch titled
     um: disable CMPXCHG_DOUBLE as it breaks UML build
has been added to the -mm tree.  Its filename is
     um-disable-cmpxchg_double-as-it-breaks-uml-build.patch

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
Subject: um: disable CMPXCHG_DOUBLE as it breaks UML build
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Commit b789ef518b2 ("slub: Add cmpxchg_double_slab()") tests for
cmpxchg_double support in the SLUB code and it breaks UML builds with
SLUB.  Since UML does not support checking for CPU features, disable
CMPXCHG_DOUBLE just like CMPXCHG_LOCAL is disabled for UML.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.x86 |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/um/Kconfig.x86~um-disable-cmpxchg_double-as-it-breaks-uml-build arch/um/Kconfig.x86
--- a/arch/um/Kconfig.x86~um-disable-cmpxchg_double-as-it-breaks-uml-build
+++ a/arch/um/Kconfig.x86
@@ -10,6 +10,10 @@ config CMPXCHG_LOCAL
 	bool
 	default n
 
+config CMPXCHG_DOUBLE
+	bool
+	default n
+
 source "arch/x86/Kconfig.cpu"
 
 endmenu
_

Patches currently in -mm which might be from cascardo@holoscopio.com are

um-disable-cmpxchg_double-as-it-breaks-uml-build.patch
lis3lv02d-avoid-divide-by-zero-due-to-unchecked.patch
lis3-update-maintainer-information.patch
lis3-add-support-for-hp-elitebook-2730p.patch
lis3-add-support-for-hp-elitebook-8540w.patch
hp_accel-add-hp-probook-655x.patch
config_hp_accel-fix-help-text.patch
lis3-free-regulators-if-probe-fails.patch
lis3-change-naming-to-consistent.patch
lis3-change-exported-function-to-use-given.patch
lis3-remove-the-references-to-the-global-variable-in-core-driver.patch

