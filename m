Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CFBC2D0A8
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 00:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD19A216C4
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 00:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601338457;
	bh=McFFMvXHNQ3uSqjIavSOS5B4fVhMP2V2tXc1TdDeadY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0WhGem7tcHm55qazBerOECP+iFW+jh6tVwVErFVtNH9TSZSEk0QvJYEE+0MiqpfE5
	 uh9GVNjaHNZUD3yAkX6j1KWCVwMEjicJWOrA97qBxsou0vOwtoVDRbnlA/War+jDvS
	 9zrBOoQGeI20peCHVW57bL0OSAs6sZns9s5A5zCA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgI2AOR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Sep 2020 20:14:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727242AbgI2AOR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Sep 2020 20:14:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0AFE208FE;
        Tue, 29 Sep 2020 00:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601338456;
        bh=McFFMvXHNQ3uSqjIavSOS5B4fVhMP2V2tXc1TdDeadY=;
        h=Date:From:To:Subject:From;
        b=Ej3YYf25GrpYsGiXVaI/xDNFDSfqTVHUc+knWVedACNzkdxTQ+eG35EU42wIq3NRu
         yzr0yB31RqlNiEmxD/2NgG9Z9FChgY3CPwHmm6yYAXrNEA6ABfy6GwLkIE8z91xJYx
         swDrFE3k1NVvN+vNLI45Zt/jTQa+b+iYW10iILLY=
Date:   Mon, 28 Sep 2020 17:14:16 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        sh_def@163.com
Subject:  + mm-vmscan-fix-comments-for-isolate_lru_page.patch added
 to -mm tree
Message-ID: <20200929001416.9jAJCD1xf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: fix comments for isolate_lru_page()
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-comments-for-isolate_lru_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-fix-comments-for-isolate_lru_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-fix-comments-for-isolate_lru_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm/vmscan: fix comments for isolate_lru_page()

fix comments for isolate_lru_page():
s/fundamentnal/fundamental

Link: https://lkml.kernel.org/r/20200927173923.GA8058@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-fix-comments-for-isolate_lru_page
+++ a/mm/vmscan.c
@@ -1757,7 +1757,7 @@ static unsigned long isolate_lru_pages(u
  * Restrictions:
  *
  * (1) Must be called with an elevated refcount on the page. This is a
- *     fundamentnal difference from isolate_lru_pages (which is called
+ *     fundamental difference from isolate_lru_pages (which is called
  *     without a stable reference).
  * (2) the lru_lock must not be held.
  * (3) interrupts must be enabled.
_

Patches currently in -mm which might be from sh_def@163.com are

mmkmemleak-testc-move-kmemleak-testc-to-samples-dir.patch
mm-vmscan-fix-comments-for-isolate_lru_page.patch
mm-fix-some-comments-in-page_allocc-and-mempolicyc.patch

