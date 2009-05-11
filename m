From: akpm@linux-foundation.org
Subject: [merged] kexec-fix-crashdump-panic-with-config_kexec_jump.patch removed from -mm tree
Date: Mon, 11 May 2009 11:54:15 -0700
Message-ID: <200905111854.n4BIsFYm032714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754202AbZEKTC2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 15:02:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, ebiederm@xmission.com, nhorman@tuxdriver.com, stable@kernel.org, tstarling@wikimedia.org, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kexec: fix crashdump panic with CONFIG_KEXEC_JUMP
has been removed from the -mm tree.  Its filename was
     kexec-fix-crashdump-panic-with-config_kexec_jump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec: fix crashdump panic with CONFIG_KEXEC_JUMP
From: Huang Ying <ying.huang@intel.com>

Content-Transfer-Encoding: quoted-printable
Tim Starling reported that crashdump will panic with kernel compiled
with CONFIG_KEXEC_JUMP due to null pointer deference in
machine_kexec_32.c: machine_kexec(), when deferencing
kexec_image.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=3D13265

This patch fixes the BUG by replacing global variable reference:
kexec_image in machine_kexec() with local variable reference: image, which
is more appropriate, and will not be null.

The same BUG is in machine_kexec_64.c too, and is fixed in the same way.

Reported-by: Tim Starling <tstarling@wikimedia.org>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: <stable@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/machine_kexec_32.c |    4 ++--
 arch/x86/kernel/machine_kexec_64.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/machine_kexec_32.c~kexec-fix-crashdump-panic-with-config_kexec_jump arch/x86/kernel/machine_kexec_32.c
--- a/arch/x86/kernel/machine_kexec_32.c~kexec-fix-crashdump-panic-with-config_kexec_jump
+++ a/arch/x86/kernel/machine_kexec_32.c
@@ -194,7 +194,7 @@ void machine_kexec(struct kimage *image)
 				       unsigned int preserve_context);
 
 #ifdef CONFIG_KEXEC_JUMP
-	if (kexec_image->preserve_context)
+	if (image->preserve_context)
 		save_processor_state();
 #endif
 
@@ -253,7 +253,7 @@ void machine_kexec(struct kimage *image)
 					   image->preserve_context);
 
 #ifdef CONFIG_KEXEC_JUMP
-	if (kexec_image->preserve_context)
+	if (image->preserve_context)
 		restore_processor_state();
 #endif
 
diff -puN arch/x86/kernel/machine_kexec_64.c~kexec-fix-crashdump-panic-with-config_kexec_jump arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~kexec-fix-crashdump-panic-with-config_kexec_jump
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -274,7 +274,7 @@ void machine_kexec(struct kimage *image)
 	int save_ftrace_enabled;
 
 #ifdef CONFIG_KEXEC_JUMP
-	if (kexec_image->preserve_context)
+	if (image->preserve_context)
 		save_processor_state();
 #endif
 
@@ -333,7 +333,7 @@ void machine_kexec(struct kimage *image)
 				       image->preserve_context);
 
 #ifdef CONFIG_KEXEC_JUMP
-	if (kexec_image->preserve_context)
+	if (image->preserve_context)
 		restore_processor_state();
 #endif
 
_

Patches currently in -mm which might be from ying.huang@intel.com are

linux-next.patch

