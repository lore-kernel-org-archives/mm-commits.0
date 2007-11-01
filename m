From: akpm@linux-foundation.org
Subject: + fix-bitmap_scnlistprintf-for-empty-masks.patch added to -mm tree
Date: Thu, 01 Nov 2007 13:52:29 -0700
Message-ID: <200711012052.lA1KqTqX014956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32973 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753121AbXKAUwj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 16:52:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@suse.de, pj@sgi.com


The patch titled
     Fix bitmap_scnlistprintf for empty masks
has been added to the -mm tree.  Its filename is
     fix-bitmap_scnlistprintf-for-empty-masks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix bitmap_scnlistprintf for empty masks
From: Andi Kleen <ak@suse.de>

When a bitmap is empty bitmap_scnlistprintf() would leave the buffer
uninitialized.  Set it to an empty string in this case.

I didn't see any in normal kernel callers hitting this, but some custom
debug code of mine did.

Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN lib/bitmap.c~fix-bitmap_scnlistprintf-for-empty-masks lib/bitmap.c
--- a/lib/bitmap.c~fix-bitmap_scnlistprintf-for-empty-masks
+++ a/lib/bitmap.c
@@ -469,6 +469,10 @@ int bitmap_scnlistprintf(char *buf, unsi
 	/* current bit is 'cur', most recently seen range is [rbot, rtop] */
 	int cur, rbot, rtop;
 
+	if (buflen == 0)
+		return 0;
+	buf[0] = 0;
+
 	rbot = cur = find_first_bit(maskp, nmaskbits);
 	while (cur < nmaskbits) {
 		rtop = cur;
_

Patches currently in -mm which might be from ak@suse.de are

origin.patch
fix-bitmap_scnlistprintf-for-empty-masks.patch
acpi-add-reboot-mechanism.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch
x86_64-do-not-clear-cpu_index-set-by-store_cpu_info.patch
x86-typo-about-sequence-of-cpu_index-and-cpu_online-in.patch
x86_64-efi-boot-support-efi-frame-buffer.patch
x86_64-efi-boot-support-efi-boot-document.patch
x86_64-add-acpi-reboot-option.patch
pci-use-pci=bfsort-for-hp-dl385-g2-dl585-g2.patch
swapin_readahead-excise-numa-bogosity.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
fall-back-on-interrupt-disable-in-cmpxchg8b-on-80386-and-80486.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
