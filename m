From: akpm@linux-foundation.org
Subject: + ubsan-fix-typo-in-format-string.patch added to -mm tree
Date: Mon, 01 Aug 2016 15:59:44 -0700
Message-ID: <579fd460.0Rc0dRUxGnwLMrVP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbcHAXRn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 19:17:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.iooss_linux@m4x.org, aryabinin@virtuozzo.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: UBSAN: fix typo in format string
has been added to the -mm tree.  Its filename is
     ubsan-fix-typo-in-format-string.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ubsan-fix-typo-in-format-string.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ubsan-fix-typo-in-format-string.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ubsan-fix-typo-in-format-string.patch

