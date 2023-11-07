Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209FDC4332F
	for <mm-commits@archiver.kernel.org>; Tue,  7 Nov 2023 15:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbjKGPjS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Nov 2023 10:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344205AbjKGPjD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Nov 2023 10:39:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FBD1731
        for <mm-commits@vger.kernel.org>; Tue,  7 Nov 2023 07:37:57 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A942C433C8;
        Tue,  7 Nov 2023 15:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699371477;
        bh=6bwyM+CEkBcWj/oeeR8ufNxjDHRrEV04tm/26ufwGBA=;
        h=Date:To:From:Subject:From;
        b=DWnCnF3V/mmry5/tlwPPHmckLuQ9XAbNNVVVfvpBPgVGoDfme/mVB05nugt5hWuNO
         V2bjhfuGYe00/uhMUQOoipEk/CnDG74LmcISyQziqEjZ7CWJMlKGUIpGtsJMSC/vIP
         Ei4AzFsfI9raIXX3SlBGLj/BimQshqZDczJPX6MA=
Date:   Tue, 07 Nov 2023 07:37:56 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, duminjie@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-increase-usage-of-folio_next_index-helper.patch added to mm-unstable branch
Message-Id: <20231107153757.6A942C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: increase usage of folio_next_index() helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-increase-usage-of-folio_next_index-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-increase-usage-of-folio_next_index-helper.patch

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
From: Minjie Du <duminjie@vivo.com>
Subject: mm/filemap: increase usage of folio_next_index() helper
Date: Tue, 7 Nov 2023 10:46:34 +0800

Simplify code pattern of 'folio->index + folio_nr_pages(folio)' by using
the existing helper folio_next_index() in filemap_get_folios_contig().

Link: https://lkml.kernel.org/r/20231107024635.4512-1-duminjie@vivo.com
Signed-off-by: Minjie Du <duminjie@vivo.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-increase-usage-of-folio_next_index-helper
+++ a/mm/filemap.c
@@ -2173,7 +2173,7 @@ update_start:
 
 	if (nr) {
 		folio = fbatch->folios[nr - 1];
-		*start = folio->index + folio_nr_pages(folio);
+		*start = folio_next_index(folio);
 	}
 out:
 	rcu_read_unlock();
_

Patches currently in -mm which might be from duminjie@vivo.com are

mm-filemap-increase-usage-of-folio_next_index-helper.patch

