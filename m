From: akpm@linux-foundation.org
Subject: [folded-merged] drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:47:30 -0800
Message-ID: <20130228004730.E205131C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:32805 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3B1Arf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:47:35 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so139819qea.5
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:47:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, dae@velatum.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix
has been removed from the -mm tree.  Its filename was
     drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch

This patch was dropped because it was folded into drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix

reduce scope of local `c'

Cc: "Dae S. Kim" <dae@velatum.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dae S. Kim <dae@velatum.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/misc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/misc.c~drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix drivers/char/misc.c
--- a/drivers/char/misc.c~drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix
+++ a/drivers/char/misc.c
@@ -183,7 +183,6 @@ static const struct file_operations misc
  
 int misc_register(struct miscdevice * misc)
 {
-	struct miscdevice *c;
 	dev_t dev;
 	int err = 0;
 
@@ -200,6 +199,8 @@ int misc_register(struct miscdevice * mi
 		misc->minor = DYNAMIC_MINORS - i - 1;
 		set_bit(i, misc_minors);
 	} else {
+		struct miscdevice *c;
+
 		list_for_each_entry(c, &misc_list, list) {
 			if (c->minor == misc->minor) {
 				mutex_unlock(&misc_mtx);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
backlight-add-new-lp8788-backlight-driver.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
fs-proc-clean-up-printks.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
idr-remove-length-restriction-from-idr_layer-bitmap.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

