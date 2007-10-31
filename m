From: akpm@linux-foundation.org
Subject: - ia64-check-segrellds-vs-build-id.patch removed from -mm tree
Date: Wed, 31 Oct 2007 16:21:52 -0700
Message-ID: <200710312321.l9VNLqVd001906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39782 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753484AbXJaXWe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 19:22:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, dchapman@redhat.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: check-segrel.lds vs --build-id
has been removed from the -mm tree.  Its filename was
     ia64-check-segrellds-vs-build-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: check-segrel.lds vs --build-id
From: Roland McGrath <roland@redhat.com>

Some versions of ld with --build-id support will crash when using the flag
with a linker script that discards notes.  This bites ia64's
check-segrel.lds.  The bug is easy to avoid.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Doug Chapman <dchapman@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/scripts/check-segrel.lds |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/ia64/scripts/check-segrel.lds~ia64-check-segrellds-vs-build-id arch/ia64/scripts/check-segrel.lds
--- a/arch/ia64/scripts/check-segrel.lds~ia64-check-segrellds-vs-build-id
+++ a/arch/ia64/scripts/check-segrel.lds
@@ -1,6 +1,7 @@
 SECTIONS {
 	. = SIZEOF_HEADERS;
 	.rodata : { *(.rodata) } :ro
+	.note : { *(.note*) }
 	. = 0xa0000;
 	.data : { *(.data) } :dat
 	/DISCARD/ : { *(*) }
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
i386-and-x86_64-randomize-brk.patch
i386-and-x86_64-randomize-brk-fix.patch
i386-and-x86_64-randomize-brk-fix-2.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
