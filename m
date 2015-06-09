From: akpm@linux-foundation.org
Subject: + lib-kobjectc-use-strreplace.patch added to -mm tree
Date: Tue, 09 Jun 2015 14:03:00 -0700
Message-ID: <55775484.XCNjeLMJpLmdVo/p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933189AbbFIVDC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2015 17:03:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/kobject.c: use strreplace()
has been added to the -mm tree.  Its filename is
     lib-kobjectc-use-strreplace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-kobjectc-use-strreplace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-kobjectc-use-strreplace.patch

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
Subject: lib/kobject.c: use strreplace()

There's probably not many slashes in the name, but starting over when
we see one feels wrong.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN lib/kobject.c~lib-kobjectc-use-strreplace lib/kobject.c
--- a/lib/kobject.c~lib-kobjectc-use-strreplace
+++ a/lib/kobject.c
@@ -257,23 +257,20 @@ static int kobject_add_internal(struct k
 int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 				  va_list vargs)
 {
-	const char *old_name = kobj->name;
 	char *s;
 
 	if (kobj->name && !fmt)
 		return 0;
 
-	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
-	if (!kobj->name) {
-		kobj->name = old_name;
+	s = kvasprintf(GFP_KERNEL, fmt, vargs);
+	if (!s)
 		return -ENOMEM;
-	}
 
 	/* ewww... some of these buggers have '/' in the name ... */
-	while ((s = strchr(kobj->name, '/')))
-		s[0] = '!';
+	strreplace(s, '/', '!');
+	kfree(kobj->name);
+	kobj->name = s;
 
-	kfree(old_name);
 	return 0;
 }
 
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

