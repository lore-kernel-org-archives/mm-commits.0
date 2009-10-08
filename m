From: akpm@linux-foundation.org
Subject: + strstrip-mark-as-as-must_check.patch added to -mm tree
Date: Thu, 08 Oct 2009 16:02:36 -0700
Message-ID: <200910082302.n98N2aac011466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757772AbZJHXEO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2009 19:04:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com


The patch titled
     strstrip(): mark as as must_check
has been added to the -mm tree.  Its filename is
     strstrip-mark-as-as-must_check.patch

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
Subject: strstrip(): mark as as must_check
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

strstrip() can return a modified value of its input argument, when
removing elading whitesapce.  So it is surely bug for this function's
return value to be ignored.  The caller is probably going to use the
incorrect original pointer.

So mark it __must_check to prevent this frm happening (as it has before).

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/string.h~strstrip-mark-as-as-must_check include/linux/string.h
--- a/include/linux/string.h~strstrip-mark-as-as-must_check
+++ a/include/linux/string.h
@@ -62,7 +62,7 @@ extern char * strnchr(const char *, size
 #ifndef __HAVE_ARCH_STRRCHR
 extern char * strrchr(const char *,int);
 #endif
-extern char * strstrip(char *);
+extern char * __must_check strstrip(char *);
 #ifndef __HAVE_ARCH_STRSTR
 extern char * strstr(const char *,const char *);
 #endif
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
congestion_wait-dont-use-write.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
readahead-add-blk_run_backing_dev.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
strstrip-mark-as-as-must_check.patch
fix-strstrip-abuse-in-elv_iosched_store.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch
cgroup-fix-strstrip-abuse.patch

