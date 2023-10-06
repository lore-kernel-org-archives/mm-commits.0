Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBCDE94104
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbjJFTSL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbjJFTSK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:18:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDE583
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:18:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558ABC433C9;
        Fri,  6 Oct 2023 19:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696619888;
        bh=Z3N7r33LcRBlWd1/9lJgQVoOFuFu4HPCBAOApDVGwd4=;
        h=Date:To:From:Subject:From;
        b=SxzGq52j1zGjnClcS7FQDCbQ3nuUruyK6kMh9ezYANHNaG7/X1PaYSePZakxkDhGk
         xfYkup4AS+0w9VFiFwIxIIZ0v2efz1Zkc2HsPm+YgYtHV0+SYOgV1UXWS8/1MtIiFH
         5ZdFFMD1b/vGZMQ/grTDDFUEOC/et+Bbb4hZ90tU=
Date:   Fri, 06 Oct 2023 12:18:06 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, david@redhat.com,
        m.muzzammilashraf@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmapc-fix-kenrel-doc-warning.patch added to mm-unstable branch
Message-Id: <20231006191808.558ABC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rmap.c: fix kernel-doc warning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmapc-fix-kenrel-doc-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmapc-fix-kenrel-doc-warning.patch

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
From: Muhammad Muzammil <m.muzzammilashraf@gmail.com>
Subject: mm: rmap.c: fix kernel-doc warning
Date: Fri, 6 Oct 2023 17:28:25 +0500

After running make htmldocs, getting this warning
warning: Function parameter or member 'folio' not described in
'folio_move_anon_rmap'
and this patch resolves this warning

Link: https://lkml.kernel.org/r/20231006122825.54840-1-m.muzzammilashraf@gmail.com
Signed-off-by: Muhammad Muzammil <m.muzzammilashraf@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmapc-fix-kenrel-doc-warning
+++ a/mm/rmap.c
@@ -1129,7 +1129,7 @@ int folio_total_mapcount(struct folio *f
 
 /**
  * folio_move_anon_rmap - move a folio to our anon_vma
- * @page:	The folio to move to our anon_vma
+ * @folio:  The folio to move to our anon_vma
  * @vma:	The vma the folio belongs to
  *
  * When a folio belongs exclusively to one process after a COW event,
_

Patches currently in -mm which might be from m.muzzammilashraf@gmail.com are

mm-rmapc-fix-kenrel-doc-warning.patch

