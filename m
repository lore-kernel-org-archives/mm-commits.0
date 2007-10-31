From: akpm@linux-foundation.org
Subject: - ia64-vdso-vs-build-id.patch removed from -mm tree
Date: Wed, 31 Oct 2007 16:21:54 -0700
Message-ID: <200710312321.l9VNLsd7001909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57048 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753521AbXJaXWh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 19:22:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64 vDSO vs --build-id
has been removed from the -mm tree.  Its filename was
     ia64-vdso-vs-build-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64 vDSO vs --build-id
From: Roland McGrath <roland@redhat.com>

When gcc uses --build-id by default, the gate.lds.S linker script runs
afoul of the new note section and produces a bad DSO image.  This fixes it.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/gate.lds.S |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/ia64/kernel/gate.lds.S~ia64-vdso-vs-build-id arch/ia64/kernel/gate.lds.S
--- a/arch/ia64/kernel/gate.lds.S~ia64-vdso-vs-build-id
+++ a/arch/ia64/kernel/gate.lds.S
@@ -20,6 +20,8 @@ SECTIONS
 	.gnu.version_d		: { *(.gnu.version_d) }
 	.gnu.version_r		: { *(.gnu.version_r) }
 
+	.note			: { *(.note*) }		:readable	:note
+
 	.dynamic		: { *(.dynamic) }	:readable	:dynamic
 
 	/*
@@ -83,6 +85,7 @@ PHDRS
 	epc		PT_LOAD	FILEHDR PHDRS	FLAGS(1);	/* PF_X */
 #endif
 	dynamic		PT_DYNAMIC		FLAGS(4);	/* PF_R */
+	note		PT_NOTE			FLAGS(4);	/* PF_R */
 	unwind		PT_IA_64_UNWIND;
 }
 
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
i386-and-x86_64-randomize-brk.patch
i386-and-x86_64-randomize-brk-fix.patch
i386-and-x86_64-randomize-brk-fix-2.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
