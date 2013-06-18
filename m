From: akpm@linux-foundation.org
Subject: + list-remove-__list_for_each.patch added to -mm tree
Date: Tue, 18 Jun 2013 13:37:18 -0700
Message-ID: <51c0c4fe.WOxYhLXy0XES2lKt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933562Ab3FRUhT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jun 2013 16:37:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yamanetoshi@gmail.com, vyasevich@gmail.com, tiwai@suse.de, stas.yakovlev@gmail.com, snsehahn@cip.cs.fau.de, perex@perex.cz, nhorman@tuxdriver.com, linville@tuxdriver.com, gregkh@linuxfoundation.org, davem@davemloft.net, clemens@ladisch.de, airlied@linux.ie, Jennifer.Naumann@informatik.stud.uni-erlangen.de, davej@redhat.com

Subject: + list-remove-__list_for_each.patch added to -mm tree
To: davej@redhat.com,Jennifer.Naumann@informatik.stud.uni-erlangen.de,airlied@linux.ie,clemens@ladisch.de,davem@davemloft.net,gregkh@linuxfoundation.org,linville@tuxdriver.com,nhorman@tuxdriver.com,perex@perex.cz,snsehahn@cip.cs.fau.de,stas.yakovlev@gmail.com,tiwai@suse.de,vyasevich@gmail.com,yamanetoshi@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 18 Jun 2013 13:37:18 -0700


The patch titled
     Subject: list: remove __list_for_each()
has been added to the -mm tree.  Its filename is
     list-remove-__list_for_each.patch

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
Subject: list: remove __list_for_each()

__list_for_each used to be the non prefetch() aware list walking
primitive.  When we removed the prefetch macros from the list routines, it
became redundant.  Given it does exactly the same thing as list_for_each
now, we might as well remove it and call list_for_each directly.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Jennifer Naumann <Jennifer.Naumann@informatik.stud.uni-erlangen.de>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Sebastian Hahn <snsehahn@cip.cs.fau.de>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN include/linux/list.h~list-remove-__list_for_each include/linux/list.h
--- a/include/linux/list.h~list-remove-__list_for_each
+++ a/include/linux/list.h
@@ -381,17 +381,6 @@ static inline void list_splice_tail_init
 	for (pos = (head)->next; pos != (head); pos = pos->next)
 
 /**
- * __list_for_each	-	iterate over a list
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- *
- * This variant doesn't differ from list_for_each() any more.
- * We don't do prefetching in either case.
- */
-#define __list_for_each(pos, head) \
-	for (pos = (head)->next; pos != (head); pos = pos->next)
