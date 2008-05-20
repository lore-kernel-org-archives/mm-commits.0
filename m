From: akpm@linux-foundation.org
Subject: + list-debugging-use-warn_on-instead-of-bug.patch added to -mm tree
Date: Tue, 20 May 2008 02:13:14 -0700
Message-ID: <200805200913.m4K9DEww014979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908AbYETJUX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 05:20:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, arjan@infradead.org, matthew@wil.cx


The patch titled
     list debugging: use WARN_ON() instead of BUG()
has been added to the -mm tree.  Its filename is
     list-debugging-use-warn_on-instead-of-bug.patch

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
Subject: list debugging: use WARN_ON() instead of BUG()
From: Dave Jones <davej@redhat.com>

Arjan noted that the list_head debugging is BUG'ing when it detects
corruption.  By causing the box to panic immediately, we're possibly
losing some bug reports.  Changing this to a WARN_ON should mean we at the
least start seeing reports collected at kerneloops.org

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_debug.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/list_debug.c~list-debugging-use-warn_on-instead-of-bug lib/list_debug.c
--- a/lib/list_debug.c~list-debugging-use-warn_on-instead-of-bug
+++ a/lib/list_debug.c
@@ -24,13 +24,13 @@ void __list_add(struct list_head *new,
 		printk(KERN_ERR "list_add corruption. next->prev should be "
 			"prev (%p), but was %p. (next=%p).\n",
 			prev, next->prev, next);
-		BUG();
+		WARN_ON(1);
 	}
 	if (unlikely(prev->next != next)) {
 		printk(KERN_ERR "list_add corruption. prev->next should be "
 			"next (%p), but was %p. (prev=%p).\n",
 			next, prev->next, prev);
-		BUG();
+		WARN_ON(1);
 	}
 	next->prev = new;
 	new->next = next;
@@ -50,12 +50,12 @@ void list_del(struct list_head *entry)
 	if (unlikely(entry->prev->next != entry)) {
 		printk(KERN_ERR "list_del corruption. prev->next should be %p, "
 				"but was %p\n", entry, entry->prev->next);
-		BUG();
+		WARN_ON(1);
 	}
 	if (unlikely(entry->next->prev != entry)) {
 		printk(KERN_ERR "list_del corruption. next->prev should be %p, "
 				"but was %p\n", entry, entry->next->prev);
-		BUG();
+		WARN_ON(1);
 	}
 	__list_del(entry->prev, entry->next);
 	entry->next = LIST_POISON1;
_

Patches currently in -mm which might be from davej@redhat.com are

linux-next.patch
list-debugging-use-warn_on-instead-of-bug.patch

