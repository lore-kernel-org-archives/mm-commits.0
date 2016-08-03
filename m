From: akpm@linux-foundation.org
Subject: [merged] ubsan-fix-typo-in-format-string.patch removed from -mm
 tree
Date: Wed, 03 Aug 2016 11:11:24 -0700
Message-ID: <57a233cc.S7v81zGkoTf3G6WO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbcHCSN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.iooss_linux@m4x.org, aryabinin@virtuozzo.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: UBSAN: fix typo in format string
has been removed from the -mm tree.  Its filename was
     ubsan-fix-typo-in-format-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: UBSAN: fix typo in format string

handle_object_size_mismatch() used %pk to format a kernel pointer with
pr_err().  This seemed to be a misspelling for %pK, but using this to
format a kernel pointer does not make much sence here.

Therefore use %p instead, like in handle_missaligned_access().

Link: http://lkml.kernel.org/r/20160730083010.11569-1-nicolas.iooss_linux@m4x.org
Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/ubsan.c~ubsan-fix-typo-in-format-string lib/ubsan.c
--- a/lib/ubsan.c~ubsan-fix-typo-in-format-string
+++ a/lib/ubsan.c
@@ -308,7 +308,7 @@ static void handle_object_size_mismatch(
 		return;
 
 	ubsan_prologue(&data->location, &flags);
-	pr_err("%s address %pk with insufficient space\n",
+	pr_err("%s address %p with insufficient space\n",
 		type_check_kinds[data->type_check_kind],
 		(void *) ptr);
 	pr_err("for an object of type %s\n", data->type->type_name);
_

Patches currently in -mm which might be from nicolas.iooss_linux@m4x.org are


