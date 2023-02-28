Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8412C64ED6
	for <mm-commits@archiver.kernel.org>; Tue, 28 Feb 2023 01:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjB1BAv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 20:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjB1BAv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 20:00:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CB22943F;
        Mon, 27 Feb 2023 17:00:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F03B060EF6;
        Tue, 28 Feb 2023 01:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561F8C4339B;
        Tue, 28 Feb 2023 01:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677546049;
        bh=B3e9P1F/MnyxDMRlFiZFD814LT0EgrcuCfOYSdfYlPw=;
        h=Date:To:From:Subject:From;
        b=XnmEa7ryHfXXC2cH+IWEK8qVXXT0AS8gGoOP0AUxzly+HbIgjLXbI5g0R6QhnwuDa
         kgoxsJRYcianmi5xCZOE38ctJDLoGQYwthws8VaJvavo1uyBy9iAJo52hehf09Inhg
         nb9phfvCnLnjt1NUczIWyrmppSvoljWWwL4UZPME=
Date:   Mon, 27 Feb 2023 17:00:48 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        andrew.yang@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-paddr-fix-missing-folio_put.patch removed from -mm tree
Message-Id: <20230228010049.561F8C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/paddr: fix missing folio_put()
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-fix-missing-folio_put.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "andrew.yang" <andrew.yang@mediatek.com>
Subject: mm/damon/paddr: fix missing folio_put()
Date: Wed, 22 Feb 2023 14:42:20 +0800

damon_get_folio() would always increase folio _refcount and
folio_isolate_lru() would increase folio _refcount if the folio's lru flag
is set.

If an unevictable folio isolated successfully, there will be two more
_refcount.  The one from folio_isolate_lru() will be decreased in
folio_puback_lru(), but the other one from damon_get_folio() will be left
behind.  This causes a pin page.

Whatever the case, the _refcount from damon_get_folio() should be
decreased.

Link: https://lkml.kernel.org/r/20230222064223.6735-1-andrew.yang@mediatek.com
Fixes: 57223ac29584 ("mm/damon/paddr: support the pageout scheme")
Signed-off-by: andrew.yang <andrew.yang@mediatek.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.16.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/paddr.c~mm-damon-paddr-fix-missing-folio_put
+++ a/mm/damon/paddr.c
@@ -250,12 +250,11 @@ static unsigned long damon_pa_pageout(st
 			folio_put(folio);
 			continue;
 		}
-		if (folio_test_unevictable(folio)) {
+		if (folio_test_unevictable(folio))
 			folio_putback_lru(folio);
-		} else {
+		else
 			list_add(&folio->lru, &folio_list);
-			folio_put(folio);
-		}
+		folio_put(folio);
 	}
 	applied = reclaim_pages(&folio_list);
 	cond_resched();
_

Patches currently in -mm which might be from andrew.yang@mediatek.com are


