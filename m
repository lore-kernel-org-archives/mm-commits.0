Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B67C433DF
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 00:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAA57207DA
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 00:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597450290;
	bh=xFHuI8s7zRdNay95QdaRSuQWZ528CsnHy8oY9AkJiGY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ML9CBsdF+0ZkH0eMnfZIhVuBTo4jWZeq1U1zfHph2K3Tks/Zscrnz0FUD4oUQyo96
	 HqedQQtbdHzlOlfAJrkAVOBV0/Nm5Yv6dUnL4YX8SFBN9cETU3Z1WABZEbokoxVQO3
	 Qwn9cOZVz7lNeD22LAhEY6hwgFAZxSKCjTwI6/j8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgHOALa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Aug 2020 20:11:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgHOALa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 Aug 2020 20:11:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A451820781;
        Sat, 15 Aug 2020 00:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597450289;
        bh=xFHuI8s7zRdNay95QdaRSuQWZ528CsnHy8oY9AkJiGY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EOLYsKghMAvJibKQGR5zE/Kgg40XWptyK+ym6PwWSr/uhAIFGu9sL+SbemECKYjqw
         glp1EMX+IpTCkBPtQTI74i3E6lKlNbzkb6QzDC2JGWbtyTEuTTaUNDpnOBbxI2Zdo3
         WnejNtF0t4gru43+xyazZPWKoO8nsLD6l4ooT0pQ=
Date:   Fri, 14 Aug 2020 17:11:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  + mm-replace-hpage_nr_pages-with-thp_nr_pages-fix.patch
 added to -mm tree
Message-ID: <20200815001129.-woHDIvNR%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-replace-hpage_nr_pages-with-thp_nr_pages-fix
has been added to the -mm tree.  Its filename is
     mm-replace-hpage_nr_pages-with-thp_nr_pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-replace-hpage_nr_pages-with-thp_nr_pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-replace-hpage_nr_pages-with-thp_nr_pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-replace-hpage_nr_pages-with-thp_nr_pages-fix

fix mm/migrate.c

Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-replace-hpage_nr_pages-with-thp_nr_pages-fix
+++ a/mm/migrate.c
@@ -1446,7 +1446,7 @@ retry:
 			 * during migration.
 			 */
 			is_thp = PageTransHuge(page);
-			nr_subpages = hpage_nr_pages(page);
+			nr_subpages = thp_nr_pages(page);
 			cond_resched();
 
 			if (PageHuge(page))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mm-replace-hpage_nr_pages-with-thp_nr_pages-fix.patch

