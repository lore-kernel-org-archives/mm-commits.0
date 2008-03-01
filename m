From: akpm@linux-foundation.org
Subject: - mm-use-__dec_zone_state-in-__dec_zone_page_state.patch removed from -mm tree
Date: Fri, 29 Feb 2008 16:46:21 -0800
Message-ID: <200803010046.m210kLme029036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933406AbYCAAqZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 19:46:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Uwe.Kleine-Koenig@digi.com, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mm: use __dec_zone_state() in __dec_zone_page_state()
has been removed from the -mm tree.  Its filename was
     mm-use-__dec_zone_state-in-__dec_zone_page_state.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mm: use __dec_zone_state() in __dec_zone_page_state()
=46rom: Uwe Kleine-K=F6nig <Uwe.Kleine-Koenig@digi.com>

This removes code duplication and makes __dec_zone_page_state look like
__inc_zone_page_state.

Signed-off-by: Uwe Kleine-K=F6nig <Uwe.Kleine-Koenig@digi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/vmstat.h~mm-use-__dec_zone_state-in-__dec_zone_=
page_state include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-use-__dec_zone_state-in-__dec_zone_page=
_state
+++ a/include/linux/vmstat.h
@@ -246,8 +246,7 @@ static inline void __dec_zone_state(stru
 static inline void __dec_zone_page_state(struct page *page,
 			enum zone_stat_item item)
 {
-	atomic_long_dec(&page_zone(page)->vm_stat[item]);
-	atomic_long_dec(&vm_stat[item]);
+	__dec_zone_state(page_zone(page), item);
 }
=20
 /*
_

Patches currently in -mm which might be from Uwe.Kleine-Koenig@digi.com=
 are

origin.patch
arm-fix-freeing-of-page-tables-in-free_pgd_slow.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
