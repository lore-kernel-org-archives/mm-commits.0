From: akpm@linux-foundation.org
Subject: +
 efi-bgrt-add-error-handling-inform-the-user-when-ignoring-the-bgrt.patch
 added to -mm tree
Date: Wed, 30 Jul 2014 14:11:56 -0700
Message-ID: <53d95f9c.jYzdzfOoKQA4o2jP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:40089 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaG3VL5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Jul 2014 17:11:57 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so544169oig.3
        for <mm-commits@vger.kernel.org>; Wed, 30 Jul 2014 14:11:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@joshtriplett.org, hpa@zytor.com, linux.bug.reporting@gmail.com, matt.fleming@intel.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: efi-bgrt: add error handling; inform the user when ignoring the BGRT
has been added to the -mm tree.  Its filename is
     efi-bgrt-add-error-handling-inform-the-user-when-ignoring-the-bgrt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/efi-bgrt-add-error-handling-inform-the-user-when-ignoring-the-bgrt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/efi-bgrt-add-error-handling-inform-the-user-when-ignoring-the-bgrt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: efi-bgrt: add error handling; inform the user when ignoring the BGRT

Gracefully handle failures to allocate memory for the image, which might
be arbitrarily large.

efi_bgrt_init can fail in various ways as well, usually because the
BIOS-provided BGRT structure does not match expectations.  Add appropriate
error messages rather than failing silently.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=81321

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Reported-by: Srihari Vijayaraghavan <linux.bug.reporting@gmail.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/efi/efi-bgrt.c |   36 ++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 6 deletions(-)

diff -puN arch/x86/platform/efi/efi-bgrt.c~efi-bgrt-add-error-handling-inform-the-user-when-ignoring-the-bgrt arch/x86/platform/efi/efi-bgrt.c
--- a/arch/x86/platform/efi/efi-bgrt.c~efi-bgrt-add-error-handling-inform-the-user-when-ignoring-the-bgrt
+++ a/arch/x86/platform/efi/efi-bgrt.c
@@ -40,20 +40,40 @@ void __init efi_bgrt_init(void)
 	if (ACPI_FAILURE(status))
 		return;
 
-	if (bgrt_tab->header.length < sizeof(*bgrt_tab))
+	if (bgrt_tab->header.length < sizeof(*bgrt_tab)) {
+		pr_err("Ignoring BGRT: invalid length %u (expected %zu)\n",
+		       bgrt_tab->header.length, sizeof(*bgrt_tab));
 		return;
-	if (bgrt_tab->version != 1 || bgrt_tab->status != 1)
+	}
+	if (bgrt_tab->version != 1) {
+		pr_err("Ignoring BGRT: invalid version %u (expected 1)\n",
+		       bgrt_tab->version);
 		return;
-	if (bgrt_tab->image_type != 0 || !bgrt_tab->image_address)
+	}
+	if (bgrt_tab->status != 1) {
+		pr_err("Ignoring BGRT: invalid status %u (expected 1)\n",
+		       bgrt_tab->status);
 		return;
+	}
+	if (bgrt_tab->image_type != 0) {
+		pr_err("Ignoring BGRT: invalid image type %u (expected 0)\n",
+		       bgrt_tab->image_type);
+		return;
+	}
+	if (!bgrt_tab->image_address) {
+		pr_err("Ignoring BGRT: null image address\n");
+		return;
+	}
 
 	image = efi_lookup_mapped_addr(bgrt_tab->image_address);
 	if (!image) {
 		image = early_memremap(bgrt_tab->image_address,
 				       sizeof(bmp_header));
 		ioremapped = true;
-		if (!image)
+		if (!image) {
+			pr_err("Ignoring BGRT: failed to map image header memory\n");
 			return;
+		}
 	}
 
 	memcpy_fromio(&bmp_header, image, sizeof(bmp_header));
@@ -61,14 +81,18 @@ void __init efi_bgrt_init(void)
 		early_iounmap(image, sizeof(bmp_header));
 	bgrt_image_size = bmp_header.size;
 
-	bgrt_image = kmalloc(bgrt_image_size, GFP_KERNEL);
-	if (!bgrt_image)
+	bgrt_image = kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN);
+	if (!bgrt_image) {
+		pr_err("Ignoring BGRT: failed to allocate memory for image (wanted %zu bytes)\n",
+		       bgrt_image_size);
 		return;
+	}
 
 	if (ioremapped) {
 		image = early_memremap(bgrt_tab->image_address,
 				       bmp_header.size);
 		if (!image) {
+			pr_err("Ignoring BGRT: failed to map image memory\n");
 			kfree(bgrt_image);
 			bgrt_image = NULL;
 			return;
_

Patches currently in -mm which might be from josh@joshtriplett.org are

update-my-email-addresses-and-related-info.patch
efi-bgrt-add-error-handling-inform-the-user-when-ignoring-the-bgrt.patch
checkpatch-add-an-index-variable-for-fixed-lines.patch
checkpatch-add-ability-to-insert-and-delete-lines-to-patch-file.patch
initramfs-support-initramfs-that-is-bigger-than-2gib.patch
linux-next.patch

