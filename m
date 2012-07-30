From: akpm@linux-foundation.org
Subject: [folded] string-introduce-memweight-fix.patch removed from -mm tree
Date: Mon, 30 Jul 2012 14:24:26 -0700
Message-ID: <20120730212427.22D53100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:43258 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2G3VY2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jul 2012 17:24:28 -0400
Received: by obbwc20 with SMTP id wc20so4008747obb.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jul 2012 14:24:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: string-introduce-memweight-fix
has been removed from the -mm tree.  Its filename was
     string-introduce-memweight-fix.patch

This patch was dropped because it was folded into string-introduce-memweight.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: string-introduce-memweight-fix

rename `w' to `ret'

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN lib/string.c~string-introduce-memweight-fix lib/string.c
--- a/lib/string.c~string-introduce-memweight-fix
+++ a/lib/string.c
@@ -833,18 +833,18 @@ EXPORT_SYMBOL(memchr_inv);
  */
 size_t memweight(const void *ptr, size_t bytes)
 {
-	size_t w = 0;
+	size_t ret = 0;
 	size_t longs;
 	const unsigned char *bitmap = ptr;
 
 	for (; bytes > 0 && ((unsigned long)bitmap) % sizeof(long);
 			bytes--, bitmap++)
-		w += hweight8(*bitmap);
+		ret += hweight8(*bitmap);
 
 	longs = bytes / sizeof(long);
 	if (longs) {
 		BUG_ON(longs >= INT_MAX / BITS_PER_LONG);
-		w += bitmap_weight((unsigned long *)bitmap,
+		ret += bitmap_weight((unsigned long *)bitmap,
 				longs * BITS_PER_LONG);
 		bytes -= longs * sizeof(long);
 		bitmap += longs * sizeof(long);
@@ -855,8 +855,8 @@ size_t memweight(const void *ptr, size_t
 	 * than sizeof(long) properly on big-endian systems.
 	 */
 	for (; bytes > 0; bytes--, bitmap++)
-		w += hweight8(*bitmap);
+		ret += hweight8(*bitmap);
 
-	return w;
+	return ret;
 }
 EXPORT_SYMBOL(memweight);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kernel-sysc-avoid-argv_freenull.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight.patch
firmware_map-make-firmware_map_add_early-argument-consistent-with-firmware_map_add_hotplug-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
minixfs-fix-block-limit-check-fix.patch
kernel-kmodc-document-call_usermodehelper_fns-a-bit.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch
include-linux-aioh-cpp-c-conversions.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch

