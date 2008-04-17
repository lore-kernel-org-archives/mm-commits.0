From: akpm@linux-foundation.org
Subject: + thinkpad-acpi-fix-possible-null-pointer-dereference.patch added to -mm tree
Date: Thu, 17 Apr 2008 14:47:17 -0700
Message-ID: <200804172147.m3HLlH1q029493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753263AbYDQVrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Apr 2008 17:47:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, hmh@hmh.eng.br


The patch titled
     ThinkPad ACPI: fix possible NULL pointer dereference
has been added to the -mm tree.  Its filename is
     thinkpad-acpi-fix-possible-null-pointer-dereference.patch

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
Subject: ThinkPad ACPI: fix possible NULL pointer dereference
From: Cyrill Gorcunov <gorcunov@gmail.com>

Fix potential NULL pointer dereference if kstrdup failed

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/thinkpad_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/thinkpad_acpi.c~thinkpad-acpi-fix-possible-null-pointer-dereference drivers/misc/thinkpad_acpi.c
--- a/drivers/misc/thinkpad_acpi.c~thinkpad-acpi-fix-possible-null-pointer-dereference
+++ a/drivers/misc/thinkpad_acpi.c
@@ -5826,7 +5826,7 @@ static void __init get_thinkpad_model_da
 
 	tp->model_str = kstrdup(dmi_get_system_info(DMI_PRODUCT_VERSION),
 					GFP_KERNEL);
-	if (strnicmp(tp->model_str, "ThinkPad", 8) != 0) {
+	if (tp->model_str && strnicmp(tp->model_str, "ThinkPad", 8) != 0) {
 		kfree(tp->model_str);
 		tp->model_str = NULL;
 	}
_

Patches currently in -mm which might be from gorcunov@gmail.com are

thinkpad-acpi-fix-possible-null-pointer-dereference.patch
git-x86.patch
git-avr32.patch
git-dvb.patch
git-gfs2-nmw.patch
m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch
nfs-fix-potential-null-pointer-dereference-v2.patch
elf-use-ei_nident-instead-of-numeric-value.patch
binfmt-fill_elf_header-cleanup-use-straight-memset-first.patch

