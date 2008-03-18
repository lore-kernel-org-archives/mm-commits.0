From: akpm@linux-foundation.org
Subject: + listh-add-list_singleton-fix.patch added to -mm tree
Date: Mon, 17 Mar 2008 22:13:09 -0700
Message-ID: <200803180513.m2I5D9TM015661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752241AbYCRFOj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 01:14:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, a.p.zijlstra@chello.nl


The patch titled
     list.h: rename list_singleton to list_is_singular
has been added to the -mm tree.  Its filename is
     listh-add-list_singleton-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: list.h: rename list_singleton to list_is_singular
From: Masami Hiramatsu <mhiramat@redhat.com>

Rename list_singleton to list_is_singular.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/list.h~listh-add-list_singleton-fix include/linux/list.h
--- a/include/linux/list.h~listh-add-list_singleton-fix
+++ a/include/linux/list.h
@@ -212,10 +212,10 @@ static inline int list_empty_careful(con
 }
 
 /**
- * list_singleton - tests whether a list has just one entry.
+ * list_is_singular - tests whether a list has just one entry.
  * @head: the list to test.
  */
-static inline int list_singleton(const struct list_head *head)
+static inline int list_is_singular(const struct list_head *head)
 {
 	return !list_empty(head) && (head->next == head->prev);
 }
_

Patches currently in -mm which might be from mhiramat@redhat.com are

kprobes-kprobe-booster-for-ia64.patch
kprobes-kprobe-booster-for-ia64-fix.patch
listh-add-list_singleton.patch
listh-add-list_singleton-fix.patch
kprobes-add-unregister_kprobes-for-batch-registration.patch
kprobes-add-unregister_kprobes-for-batch-registration-fix.patch
kprobes-add-unregister_kretprobes-for-batch-registration.patch
kprobes-add-unregister_jprobes-for-batch-registration.patch
kprobes-update-document-about-batch-registration.patch

