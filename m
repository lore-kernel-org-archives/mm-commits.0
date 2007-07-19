From: akpm@linux-foundation.org
Subject: - aio-sparse-fix-type-of-ki_flags.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:59 -0700
Message-ID: <200707192000.l6JK0xv2019495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42147 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760834AbXGSUSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:18:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, bcrl@kvack.org, mm-commits@vger.kernel.org


The patch titled
     AIO sparse fix (type of ki_flags)
has been removed from the -mm tree.  Its filename was
     aio-sparse-fix-type-of-ki_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 1 insertion(+), 1 deletion(-)

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
