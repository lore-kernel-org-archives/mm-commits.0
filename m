From: akpm@linux-foundation.org
Subject: +
 radeon-remove-redundant-__list_for_each-definition-from-mkregtablec.patch
 added to -mm tree
Date: Tue, 18 Jun 2013 13:37:12 -0700
Message-ID: <51c0c4f8.INoybHoZVio5LIDF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab3FRUhN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jun 2013 16:37:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, airlied@linux.ie, davej@redhat.com

Subject: + radeon-remove-redundant-__list_for_each-definition-from-mkregtablec.patch added to -mm tree
To: davej@redhat.com,airlied@linux.ie
From: akpm@linux-foundation.org
Date: Tue, 18 Jun 2013 13:37:12 -0700


The patch titled
     Subject: radeon: remove redundant __list_for_each definition from mkregtable.c
has been added to the -mm tree.  Its filename is
     radeon-remove-redundant-__list_for_each-definition-from-mkregtablec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Jones <davej@redhat.com>
Subject: radeon: remove redundant __list_for_each definition from mkregtable.c

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/radeon/mkregtable.c |   13 -------------
 1 file changed, 13 deletions(-)

diff -puN drivers/gpu/drm/radeon/mkregtable.c~radeon-remove-redundant-__list_for_each-definition-from-mkregtablec drivers/gpu/drm/radeon/mkregtable.c
--- a/drivers/gpu/drm/radeon/mkregtable.c~radeon-remove-redundant-__list_for_each-definition-from-mkregtablec
+++ a/drivers/gpu/drm/radeon/mkregtable.c
@@ -373,19 +373,6 @@ static inline void list_splice_tail_init
 		pos = pos->next)
 
 /**
- * __list_for_each	-	iterate over a list
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- *
- * This variant differs from list_for_each() in that it's the
- * simplest possible list iteration code, no prefetching is done.
- * Use this for code that knows the list to be very short (empty
- * or 1 entry) most of the time.
- */
-#define __list_for_each(pos, head) \
-	for (pos = (head)->next; pos != (head); pos = pos->next)
