From: akpm@linux-foundation.org
Subject: + drivers-md-mdc-use-strreplace.patch added to -mm tree
Date: Tue, 09 Jun 2015 14:03:04 -0700
Message-ID: <55775488.6UTYbpt7XoAPF4Ea%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964811AbbFIVDF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2015 17:03:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/md/md.c: use strreplace()
has been added to the -mm tree.  Its filename is
     drivers-md-mdc-use-strreplace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-md-mdc-use-strreplace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-md-mdc-use-strreplace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: drivers/md/md.c: use strreplace()

There's no point in starting over when we meet a '/'.  This also
eliminates a stack variable and a little .text.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/md/md.c~drivers-md-mdc-use-strreplace drivers/md/md.c
--- a/drivers/md/md.c~drivers-md-mdc-use-strreplace
+++ a/drivers/md/md.c
@@ -2024,7 +2024,6 @@ static int bind_rdev_to_array(struct md_
 {
 	char b[BDEVNAME_SIZE];
 	struct kobject *ko;
-	char *s;
 	int err;
 
 	/* prevent duplicates */
@@ -2070,8 +2069,7 @@ static int bind_rdev_to_array(struct md_
 		return -EBUSY;
 	}
 	bdevname(rdev->bdev,b);
-	while ( (s=strchr(b, '/')) != NULL)
-		*s = '!';
+	strreplace(b, '/', '!');
 
 	rdev->mddev = mddev;
 	printk(KERN_INFO "md: bind<%s>\n", b);
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

linux-slabh-fix-three-off-by-one-typos-in-comment.patch
mm-only-define-hashdist-variable-when-needed.patch
__bitmap_parselist-fix-bug-in-empty-string-handling.patch
lib-sort-add-64-bit-swap-function.patch
lib-sort-add-64-bit-swap-function-v2.patch
lib-sort-add-64-bit-swap-function-v2-fix.patch
lib-string-introduce-strreplace.patch
kernel-trace-trace_events_filterc-use-strreplace.patch
blktrace-use-strreplace-in-do_blk_trace_setup.patch
lib-kobjectc-use-strreplace.patch
drivers-base-corec-use-strreplace.patch
drivers-md-mdc-use-strreplace.patch
fs-jbd2-journalc-use-strreplace.patch
fs-ext4-superc-use-strreplace-in-ext4_fill_super.patch
checkpatch-avoid-not_unified_diff-errors-on-cover-letterpatch-files.patch
linux-next.patch

