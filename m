From: akpm@linux-foundation.org
Subject: + drivers-base-corec-use-strreplace.patch added to -mm tree
Date: Tue, 09 Jun 2015 14:03:02 -0700
Message-ID: <55775486.r4EZiu9PH0arl9z6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33974 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964792AbbFIVDD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2015 17:03:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base/core.c: use strreplace()
has been added to the -mm tree.  Its filename is
     drivers-base-corec-use-strreplace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-base-corec-use-strreplace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-base-corec-use-strreplace.patch

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
Subject: drivers/base/core.c: use strreplace()

This eliminates a little .text and avoids repeating the strchr call when
we meet a '!' (which will happen at least once).

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/base/core.c~drivers-base-corec-use-strreplace drivers/base/core.c
--- a/drivers/base/core.c~drivers-base-corec-use-strreplace
+++ a/drivers/base/core.c
@@ -1303,12 +1303,11 @@ const char *device_get_devnode(struct de
 		return dev_name(dev);
 
 	/* replace '!' in the name with '/' */
-	*tmp = kstrdup(dev_name(dev), GFP_KERNEL);
-	if (!*tmp)
+	s = kstrdup(dev_name(dev), GFP_KERNEL);
+	if (!s)
 		return NULL;
-	while ((s = strchr(*tmp, '!')))
-		s[0] = '/';
-	return *tmp;
+	strreplace(s, '!', '/');
+	return *tmp = s;
 }
 
 /**
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

