From: akpm@linux-foundation.org
Subject: [merged] list-remove-__list_for_each.patch removed from -mm tree
Date: Wed, 17 Jul 2013 12:42:19 -0700
Message-ID: <51e6f39b.Pre6LBOxx6chA4xe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098Ab3GQTmU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Jul 2013 15:42:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yamanetoshi@gmail.com, vyasevich@gmail.com, tiwai@suse.de, stas.yakovlev@gmail.com, snsehahn@cip.cs.fau.de, perex@perex.cz, nhorman@tuxdriver.com, linville@tuxdriver.com, gregkh@linuxfoundation.org, davem@davemloft.net, clemens@ladisch.de, airlied@linux.ie, Jennifer.Naumann@informatik.stud.uni-erlangen.de, davej@redhat.com

Subject: [merged] list-remove-__list_for_each.patch removed from -mm tree
To: davej@redhat.com,Jennifer.Naumann@informatik.stud.uni-erlangen.de,airlied@linux.ie,clemens@ladisch.de,davem@davemloft.net,gregkh@linuxfoundation.org,linville@tuxdriver.com,nhorman@tuxdriver.com,perex@perex.cz,snsehahn@cip.cs.fau.de,stas.yakovlev@gmail.com,tiwai@suse.de,vyasevich@gmail.com,yamanetoshi@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 17 Jul 2013 12:42:19 -0700


The patch titled
     Subject: list: remove __list_for_each()
has been removed from the -mm tree.  Its filename was
     list-remove-__list_for_each.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
