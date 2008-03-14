From: akpm@linux-foundation.org
Subject: + listh-add-list_singleton.patch added to -mm tree
Date: Fri, 14 Mar 2008 14:06:16 -0700
Message-ID: <200803142106.m2EL6GHB019374@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753679AbYCNVHY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 17:07:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com


The patch titled
     list.h: add list_singleton
has been added to the -mm tree.  Its filename is
     listh-add-list_singleton.patch

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
Subject: list.h: add list_singleton
From: Masami Hiramatsu <mhiramat@redhat.com>

Add list_singleton to check a list has just one entry.

list_singleton is useful to check whether a list_head which have been
temporarily allocated for listing objects can be released or not.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN include/linux/list.h~listh-add-list_singleton include/linux/list.h
--- a/include/linux/list.h~listh-add-list_singleton
+++ a/include/linux/list.h
@@ -211,6 +211,15 @@ static inline int list_empty_careful(con
 	return (next == head) && (next == head->prev);
 }
 
+/**
+ * list_singleton - tests whether a list has just one entry.
+ * @head: the list to test.
+ */
+static inline int list_singleton(const struct list_head *head)
+{
+	return !list_empty(head) && (head->next == head->prev);
+}
+
 static inline void __list_splice(struct list_head *list,
 				 struct list_head *head)
 {
_

Patches currently in -mm which might be from mhiramat@redhat.com are

kprobes-kprobe-booster-for-ia64.patch
kprobes-kprobe-booster-for-ia64-fix.patch
listh-add-list_singleton.patch
kprobes-add-unregister_kprobes-for-batch-registration.patch
kprobes-add-unregister_kretprobes-for-batch-registration.patch
kprobes-add-unregister_jprobes-for-batch-registration.patch
kprobes-update-document-about-batch-registration.patch

