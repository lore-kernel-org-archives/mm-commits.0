From: akpm@linux-foundation.org
Subject: + mm-vmallocc-clean-up-map_vm_area-third-argument-v2.patch added
 to -mm tree
Date: Thu, 10 Jul 2014 13:38:19 -0700
Message-ID: <53bef9bb.em6DFcSyImAC/OlE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:55052 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaGJUiU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Jul 2014 16:38:20 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so32152obb.4
        for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2014 13:38:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chaowang@redhat.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmallocc-clean-up-map_vm_area-third-argument-v2
has been added to the -mm tree.  Its filename is
     mm-vmallocc-clean-up-map_vm_area-third-argument-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmallocc-clean-up-map_vm_area-third-argument-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmallocc-clean-up-map_vm_area-third-argument-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: WANG Chao <chaowang@redhat.com>
Subject: mm-vmallocc-clean-up-map_vm_area-third-argument-v2

v2: Fix arch/tile/kernel/module.c::module_alloc().

Signed-off-by: WANG Chao <chaowang@redhat.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/kernel/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/tile/kernel/module.c~mm-vmallocc-clean-up-map_vm_area-third-argument-v2 arch/tile/kernel/module.c
--- a/arch/tile/kernel/module.c~mm-vmallocc-clean-up-map_vm_area-third-argument-v2
+++ a/arch/tile/kernel/module.c
@@ -58,7 +58,7 @@ void *module_alloc(unsigned long size)
 	area->nr_pages = npages;
 	area->pages = pages;
 
-	if (map_vm_area(area, prot_rwx, &pages)) {
+	if (map_vm_area(area, prot_rwx, pages)) {
 		vunmap(area->addr);
 		goto error;
 	}
_

Patches currently in -mm which might be from chaowang@redhat.com are

mm-vmallocc-clean-up-map_vm_area-third-argument.patch
mm-vmallocc-clean-up-map_vm_area-third-argument-v2.patch
bin2c-move-bin2c-in-scripts-basic.patch
kernel-build-bin2c-based-on-config-option-config_build_bin2c.patch
kexec-rename-unusebale_pages-to-unusable_pages.patch
kexec-move-segment-verification-code-in-a-separate-function.patch
kexec-use-common-function-for-kimage_normal_alloc-and-kimage_crash_alloc.patch
resource-provide-new-functions-to-walk-through-resources.patch
kexec-make-kexec_segment-user-buffer-pointer-a-union.patch
kexec-new-syscall-kexec_file_load-declaration.patch
kexec-implementation-of-new-syscall-kexec_file_load.patch
purgatory-sha256-provide-implementation-of-sha256-in-purgaotory-context.patch
purgatory-core-purgatory-functionality.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time.patch
kexec-load-and-relocate-purgatory-at-kernel-load-time-fix.patch
kexec-bzimage64-support-for-loading-bzimage-using-64bit-entry.patch
kexec-support-for-kexec-on-panic-using-new-system-call.patch
kexec-support-kexec-kdump-on-efi-systems.patch

