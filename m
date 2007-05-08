From: akpm@linux-foundation.org
Subject: - uml-delete-host_frame_size.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:55 -0700
Message-ID: <200705080006.l4806tce009236@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967261AbXEHAHP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:07:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: delete HOST_FRAME_SIZE
has been removed from the -mm tree.  Its filename was
     uml-delete-host_frame_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: delete HOST_FRAME_SIZE
From: Jeff Dike <jdike@addtoit.com>

HOST_FRAME_SIZE isn't used any more.  It has been replaced with MAX_REG_NR.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/user-offsets.c   |    1 -
 arch/um/sys-x86_64/user-offsets.c |    1 -
 2 files changed, 2 deletions(-)

diff -puN arch/um/sys-i386/user-offsets.c~uml-delete-host_frame_size arch/um/sys-i386/user-offsets.c
--- a/arch/um/sys-i386/user-offsets.c~uml-delete-host_frame_size
+++ a/arch/um/sys-i386/user-offsets.c
@@ -47,7 +47,6 @@ void foo(void)
 	OFFSET(HOST_SC_FP_ST, _fpstate, _st);
 	OFFSET(HOST_SC_FXSR_ENV, _fpstate, _fxsr_env);
 
-	DEFINE(HOST_FRAME_SIZE, FRAME_SIZE);
 	DEFINE_LONGS(HOST_FP_SIZE, sizeof(struct user_i387_struct));
 	DEFINE_LONGS(HOST_XFP_SIZE, sizeof(struct user_fxsr_struct));
 
diff -puN arch/um/sys-x86_64/user-offsets.c~uml-delete-host_frame_size arch/um/sys-x86_64/user-offsets.c
--- a/arch/um/sys-x86_64/user-offsets.c~uml-delete-host_frame_size
+++ a/arch/um/sys-x86_64/user-offsets.c
@@ -57,7 +57,6 @@ void foo(void)
 	OFFSET(HOST_SC_SS, sigcontext, ss);
 #endif
 
-	DEFINE_LONGS(HOST_FRAME_SIZE, FRAME_SIZE);
 	DEFINE(HOST_FP_SIZE, sizeof(struct _fpstate) / sizeof(unsigned long));
 	DEFINE(HOST_XFP_SIZE, 0);
 	DEFINE_LONGS(HOST_RBX, RBX);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
