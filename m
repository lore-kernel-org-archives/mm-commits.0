From: akpm@linux-foundation.org
Subject: - listh-add-list_singleton.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:56:14 -0700
Message-ID: <200804282156.m3SLuElS018198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936294AbYD1V44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     list.h: add list_is_singular()
has been removed from the -mm tree.  Its filename was
     listh-add-list_singleton.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: list.h: add list_is_singular()
From: Masami Hiramatsu <mhiramat@redhat.com>

Add list_is_singular() to check a list has just one entry.

list_is_singular() is useful to check whether a list_head which have been
temporarily allocated for listing objects can be released or not.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN include/linux/list.h~listh-add-list_singleton include/linux/list.h
--- a/include/linux/list.h~listh-add-list_singleton
+++ a/include/linux/list.h
@@ -319,6 +319,15 @@ static inline int list_empty_careful(con
 	return (next == head) && (next == head->prev);
 }
 
+/**
+ * list_is_singular - tests whether a list has just one entry.
+ * @head: the list to test.
+ */
+static inline int list_is_singular(const struct list_head *head)
+{
+	return !list_empty(head) && (head->next == head->prev);
+}
+
 static inline void __list_splice(struct list_head *list,
 				 struct list_head *head)
 {
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch
relayfs-support-larger-relay-buffer-take-3.patch
relayfs-support-larger-relay-buffer-take-3-cleanup.patch

