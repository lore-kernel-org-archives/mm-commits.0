From: akpm@linux-foundation.org
Subject: + list-debugging-warn-when-deleting-a-deleted-entry.patch added to -mm tree
Date: Wed, 21 Jul 2010 15:18:44 -0700
Message-ID: <201007212218.o6LMIi8Z018341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753120Ab0GUWT1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 18:19:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: baruch@tkos.co.il, davej@codemonkey.org.uk


The patch titled
     list debugging: warn when deleting a deleted entry
has been added to the -mm tree.  Its filename is
     list-debugging-warn-when-deleting-a-deleted-entry.patch

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
Subject: list debugging: warn when deleting a deleted entry
From: Baruch Siach <baruch@tkos.co.il>

Use the magic LIST_POISON* values to detect an incorrect use of list_del
on a deleted entry.  This DEBUG_LIST specific warning is easier to
understand than the generic Oops message caused by LIST_POISON
dereference.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_debug.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN lib/list_debug.c~list-debugging-warn-when-deleting-a-deleted-entry lib/list_debug.c
--- a/lib/list_debug.c~list-debugging-warn-when-deleting-a-deleted-entry
+++ a/lib/list_debug.c
@@ -43,6 +43,12 @@ EXPORT_SYMBOL(__list_add);
  */
 void list_del(struct list_head *entry)
 {
+	WARN(entry->next == LIST_POISON1,
+		"list_del corruption, next is LIST_POISON1 (%p)\n",
+		LIST_POISON1);
+	WARN(entry->next != LIST_POISON1 && entry->prev == LIST_POISON2,
+		"list_del corruption, prev is LIST_POISON2 (%p)\n",
+		LIST_POISON2);
 	WARN(entry->prev->next != entry,
 		"list_del corruption. prev->next should be %p, "
 		"but was %p\n", entry, entry->prev->next);
_

Patches currently in -mm which might be from baruch@tkos.co.il are

linux-next.patch
list-debugging-warn-when-deleting-a-deleted-entry.patch
rtc-driver-for-the-dryice-block-found-in-imx25-chips.patch

