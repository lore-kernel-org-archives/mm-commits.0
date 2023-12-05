Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4797C4167B
	for <mm-commits@archiver.kernel.org>; Tue,  5 Dec 2023 19:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjLET4S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Dec 2023 14:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjLET4R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2023 14:56:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47887196
        for <mm-commits@vger.kernel.org>; Tue,  5 Dec 2023 11:56:23 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB79FC433C7;
        Tue,  5 Dec 2023 19:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701806182;
        bh=hTO1f/LMTEORYcyjmt6zsZVuLFulGdYXNkLqNW3qhi8=;
        h=Date:To:From:Subject:From;
        b=cGIwncmo1J+mueLt0/wvMV8GqNVOqurwmfdLcmyHAVPdboetq/giD8QntlTYo5zfN
         ALl5oDKj6y5XSjJN3cNeBgBnAB5BI3eb3e8VLJZi94VR0b35sT7lkfU2kd4FZkLAQ0
         835GQ6iZSUaigeovkjdVIthCnjDoHf8DaXF6PnO0=
Date:   Tue, 05 Dec 2023 11:56:21 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        zeming@nfschina.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + =utf-8qmm-=20filemap-=20remove=20unnecessary=20=-=utf-8q=e2=80=980=e2=80=99=20values=20from=20ret=.patch added to mm-unstable branch
Message-Id: <20231205195622.DB79FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: filemap: remove unnecessary iitialization of ret
has been added to the -mm mm-unstable branch.  Its filename is
     =utf-8qmm-=20filemap-=20remove=20unnecessary=20=-=utf-8q=e2=80=980=e2=80=99=20values=20from=20ret=.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/=utf-8qmm-=20filemap-=20remove=20unnecessary=20=-=utf-8q=e2=80=980=e2=80=99=20values=20from=20ret=.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Li zeming <zeming@nfschina.com>
Subject: mm: filemap: remove unnecessary iitialization of ret
Date: Tue, 5 Dec 2023 10:29:54 +0800

The ret variable can be defined without assigning a value, as it is
assigned before use.

Link: https://lkml.kernel.org/r/20231205022954.101045-1-zeming@nfschina.com
Signed-off-by: Li zeming <zeming@nfschina.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~=utf-8qmm-=20filemap-=20remove=20unnecessary=20=-=utf-8q=e2=80=980=e2=80=99=20values=20from=20ret=
+++ a/mm/filemap.c
@@ -1623,7 +1623,7 @@ EXPORT_SYMBOL_GPL(__folio_lock_killable)
 static int __folio_lock_async(struct folio *folio, struct wait_page_queue *wait)
 {
 	struct wait_queue_head *q = folio_waitqueue(folio);
-	int ret = 0;
+	int ret;
 
 	wait->folio = folio;
 	wait->bit_nr = PG_locked;
_

Patches currently in -mm which might be from zeming@nfschina.com are

=utf-8qmm-=20filemap-=20remove=20unnecessary=20=-=utf-8q=e2=80=980=e2=80=99=20values=20from=20ret=.patch

