From: akpm@linux-foundation.org
Subject: + string-introduce-memweight-fix.patch added to -mm tree
Date: Mon, 11 Jun 2012 16:17:37 -0700
Message-ID: <20120611231737.D6A82A0137@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:42548 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779Ab2FKXRk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2012 19:17:40 -0400
Received: by lagr15 with SMTP id r15so252541lag.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 16:17:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, akinobu.mita@gmail.com


The patch titled
     Subject: string-introduce-memweight-fix
has been added to the -mm tree.  Its filename is
     string-introduce-memweight-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: string-introduce-memweight-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
string-introduce-memweight-fix.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

