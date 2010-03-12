From: akpm@linux-foundation.org
Subject: + dynamic_debug-small-cleanup-in-ddebug_proc_write.patch added to -mm tree
Date: Fri, 12 Mar 2010 14:10:51 -0800
Message-ID: <201003122210.o2CMApNc010873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758703Ab0CLWLJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Mar 2010 17:11:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, jbaron@redhat.com


The patch titled
     dynamic_debug: small cleanup in ddebug_proc_write()
has been added to the -mm tree.  Its filename is
     dynamic_debug-small-cleanup-in-ddebug_proc_write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dynamic_debug: small cleanup in ddebug_proc_write()
From: Dan Carpenter <error27@gmail.com>

This doesn't change behavior at all.  In the original code, if nwords was
zero then ddebug_parse_query() would return -EINVAL, now we just do it
earlier.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/dynamic_debug.c~dynamic_debug-small-cleanup-in-ddebug_proc_write lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~dynamic_debug-small-cleanup-in-ddebug_proc_write
+++ a/lib/dynamic_debug.c
@@ -455,7 +455,7 @@ static ssize_t ddebug_proc_write(struct 
 			__func__, (int)len);
 
 	nwords = ddebug_tokenize(tmpbuf, words, MAXWORDS);
-	if (nwords < 0)
+	if (nwords <= 0)
 		return -EINVAL;
 	if (ddebug_parse_query(words, nwords-1, &query))
 		return -EINVAL;
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch

