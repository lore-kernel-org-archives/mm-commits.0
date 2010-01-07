From: akpm@linux-foundation.org
Subject: + mn10300-use-kern_err-not-kern_error.patch added to -mm tree
Date: Wed, 06 Jan 2010 16:28:29 -0800
Message-ID: <201001070028.o070STIo027658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932384Ab0AGA2s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jan 2010 19:28:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     mn10300: use KERN_ERR not KERN_ERROR
has been added to the -mm tree.  Its filename is
     mn10300-use-kern_err-not-kern_error.patch

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
Subject: mn10300: use KERN_ERR not KERN_ERROR
From: David Howells <dhowells@redhat.com>

Use KERN_ERR not KERN_ERROR in the ASB2305 platform code.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/unit-asb2305/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mn10300/unit-asb2305/pci.c~mn10300-use-kern_err-not-kern_error arch/mn10300/unit-asb2305/pci.c
--- a/arch/mn10300/unit-asb2305/pci.c~mn10300-use-kern_err-not-kern_error
+++ a/arch/mn10300/unit-asb2305/pci.c
@@ -279,7 +279,7 @@ static int __init pci_sanity_check(struc
 	     (x == PCI_VENDOR_ID_INTEL || x == PCI_VENDOR_ID_COMPAQ)))
 		return 1;
 
-	printk(KERN_ERROR "PCI: Sanity check failed\n");
+	printk(KERN_ERR "PCI: Sanity check failed\n");
 	return 0;
 }
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

mm-make-totalhigh_pages-unsigned-long.patch
fdpic-respect-pt_gnu_stack-exec-protection-markings-when-creating-nommu-stack.patch
nommu-avoiding-duplicate-icache-flushes-of-shared-maps.patch
nommu-use-copy__user_page-in-access_process_vm.patch
mn10300-signal-stack-fix.patch
mn10300-objcopy-flags-fix.patch
mn10300-add-cc-clobbers-to-asm-statements.patch
mn10300-wire-up-missing-new-syscalls.patch
fix-several-bogus-includes-on-mn10300-abs2305.patch
mn10300-use-kern_err-not-kern_error.patch
mn10300-use-generic-pci_enable_resources.patch
mn10300-insert-pci-root-bus-resources-for-the-asb2305-devel-motherboard.patch
mn10300-make-the-asb2305s-pcnet32-nic-work-by-using-the-pci-bridges-sram.patch
mn10300-update-the-asb2303-defconfig.patch
kernel-credc-use-kmem_cache_free.patch
frv-duplicate-output_buffer-of-e03.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

