From: akpm@linux-foundation.org
Subject: - add-werror-implicit-function-declaration.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:58:37 -0700
Message-ID: <200707162058.l6GKwbfx002358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45707 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751459AbXGPVMY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:12:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Add -Werror-implicit-function-declaration
has been removed from the -mm tree.  Its filename was
     add-werror-implicit-function-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add -Werror-implicit-function-declaration
From: Dave Jones <davej@redhat.com>

Add -Werror-implicit-function-declaration
This makes builds fail sooner if something is implicitly defined instead
of having to wait half an hour for it to fail at the linking stage.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Makefile~add-werror-implicit-function-declaration Makefile
--- a/Makefile~add-werror-implicit-function-declaration
+++ a/Makefile
@@ -313,7 +313,8 @@ LINUXINCLUDE    := -Iinclude \
 CPPFLAGS        := -D__KERNEL__ $(LINUXINCLUDE)
 
 CFLAGS          := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
-                   -fno-strict-aliasing -fno-common
+		   -fno-strict-aliasing -fno-common \
+		   -Werror-implicit-function-declaration
 AFLAGS          := -D__ASSEMBLY__
 
 # Read KERNELRELEASE from include/config/kernel.release (if it exists)
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
fix-empty-macros-in-acpi.patch
git-alsa.patch
i386-remove-support-for-the-rise-cpu.patch
slow-down-printk-during-boot.patch
