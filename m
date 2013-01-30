From: akpm@linux-foundation.org
Subject: + mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix.patch added to -mm tree
Date: Tue, 29 Jan 2013 16:03:45 -0800
Message-ID: <20130130000345.922C831C1F5@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:34026 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3A3ADq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Jan 2013 19:03:46 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so16488ves.5
        for <mm-commits@vger.kernel.org>; Tue, 29 Jan 2013 16:03:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, mhocko@suse.cz


The patch titled
     Subject: mmotm: memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch fix
has been added to the -mm tree.  Its filename is
     mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ying Han <yinghan@google.com>
Subject: mmotm: memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch fix

We should break out of the hierarchy loop only if nr_reclaimed exceeded
nr_to_reclaim and not vice-versa. This patch fixes the condition.

Signed-off-by: Ying Han <yinghan@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix mm/vmscan.c
--- a/mm/vmscan.c~mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix
+++ a/mm/vmscan.c
@@ -1983,7 +1983,7 @@ static void shrink_zone(struct zone *zon
 			 * whole hierarchy is not sufficient.
 			 */
 			if (!global_reclaim(sc) &&
-					sc->nr_to_reclaim >= sc->nr_reclaimed) {
+					sc->nr_to_reclaim <= sc->nr_reclaimed) {
 				mem_cgroup_iter_break(root, memcg);
 				break;
 			}
_

Patches currently in -mm which might be from yinghan@google.com are

memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch

