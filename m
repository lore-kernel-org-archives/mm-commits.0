From: akpm@linux-foundation.org
Subject: +
 mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix.patch
 added to -mm tree
Date: Thu, 10 Dec 2015 14:08:44 -0800
Message-ID: <5669f7ec.vkoNxyfp+GLDCl5s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbbLJWIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Dec 2015 17:08:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix
has been added to the -mm tree.  Its filename is
     mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@kernel.org>
Subject: mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix

Dohh, forgot to git add after s@PageCoumpound@PageTransCompound@

Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix
+++ a/mm/memcontrol.c
@@ -4874,7 +4874,7 @@ retry:
 			 * ignore such a partial THP and keep it in original
 			 * memcg. There should be somebody mapping the head.
 			 */
-			if (PageCompound(page))
+			if (PageTransCompound(page))
 				goto put;
 			if (isolate_lru_page(page))
 				goto put;
_

Patches currently in -mm which might be from mhocko@kernel.org are

mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-5-fix.patch

