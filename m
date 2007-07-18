From: akpm@linux-foundation.org
Subject: + aio-sparse-fix-type-of-ki_flags.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:40:22 -0700
Message-ID: <200707180040.l6I0eMvL015924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56950 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934682AbXGRAkp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:40:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, bcrl@kvack.org


The patch titled
     AIO sparse fix (type of ki_flags)
has been added to the -mm tree.  Its filename is
     aio-sparse-fix-type-of-ki_flags.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: AIO sparse fix (type of ki_flags)
From: David Brownell <dbrownell@users.sourceforge.net>

Fix type issue reported by latest 'sparse': kiocb.ki_flags should be
"unsigned long" (not "long"), to match bitop type signature.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/aio.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/aio.h~aio-sparse-fix-type-of-ki_flags include/linux/aio.h
--- a/include/linux/aio.h~aio-sparse-fix-type-of-ki_flags
+++ a/include/linux/aio.h
@@ -86,7 +86,7 @@ struct kioctx;
  */
 struct kiocb {
 	struct list_head	ki_run_list;
-	long			ki_flags;
+	unsigned long		ki_flags;
 	int			ki_users;
 	unsigned		ki_key;		/* id of this request */
 
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
git-input.patch
git-leds.patch
git-mtd.patch
git-backlight.patch
gpio-calls-dont-need-i-o-barriers.patch
dev_vdbg-available-with-dverbose_debug.patch
dev_vdbg-available-with-dverbose_debug-docs.patch
aio-sparse-fix-type-of-ki_flags.patch
