Return-Path: <SRS0=09mD=BO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 867F8C433E0
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85AB0206DA
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 03:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596511282;
	bh=1YqtkIzguavvhSsMDbX/4s/HKo+bEsTFxIs+s6Ew7y8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=dNMIeqMy+1m0oGbvilcXAo1qGEwdmt/PuTYoZvGi25+FigQo/8I8ZJOFoL9ExXZc/
	 Txhbq0Wbt01K8/ZNmU47MzjlEdgIGlB9O1NWI3dgB7krGZonczRJk73yM6Fc9Vo5sx
	 psuNLaRnm6F8/c+2tcXE4JPCvLcd4NgknR84QBHs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbgHDDVW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Aug 2020 23:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729636AbgHDDVV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Aug 2020 23:21:21 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1709C2068F;
        Tue,  4 Aug 2020 03:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596511281;
        bh=1YqtkIzguavvhSsMDbX/4s/HKo+bEsTFxIs+s6Ew7y8=;
        h=Date:From:To:Subject:From;
        b=VCqJp1HxGifHWDW//8/hkOW1sRzvs8o1GeoieP85sW9Ngs1lZx+DnNX6K8x5WhiGl
         uMTqJO8Q68HTe+2qRKOP5SDXoNUgmG3tH2aC0lRq+tDOlB6ZD6oMj/YBzol70VLwUN
         ZwMEFFtkXbYeGNUUoHqUQFSsmHvvVIJVz2aFfhBY=
Date:   Mon, 03 Aug 2020 20:21:20 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  + mm-compactionc-delete-duplicated-word.patch added to
 -mm tree
Message-ID: <20200804032120.GmDHi6gK0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction.c: delete duplicated word
has been added to the -mm tree.  Its filename is
     mm-compactionc-delete-duplicated-word.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compactionc-delete-duplicated-word.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compactionc-delete-duplicated-word.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/compaction.c: delete duplicated word

Drop the repeated word "a".

Link: http://lkml.kernel.org/r/20200801173822.14973-2-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compactionc-delete-duplicated-word
+++ a/mm/compaction.c
@@ -1477,7 +1477,7 @@ static void isolate_freepages(struct com
 	 * this pfn aligned down to the pageblock boundary, because we do
 	 * block_start_pfn -= pageblock_nr_pages in the for loop.
 	 * For ending point, take care when isolating in last pageblock of a
-	 * a zone which ends in the middle of a pageblock.
+	 * zone which ends in the middle of a pageblock.
 	 * The low boundary is the end of the pageblock the migration scanner
 	 * is using.
 	 */
_

Patches currently in -mm which might be from rdunlap@infradead.org are

ocfs2-suballoch-delete-a-duplicated-word.patch
mm-drop-duplicated-words-in-linux-pgtableh.patch
mm-drop-duplicated-words-in-linux-mmh.patch
highmem-linux-highmemh-fix-duplicated-words-in-a-comment.patch
frontswap-linux-frontswaph-drop-duplicated-word-in-a-comment.patch
memcontrol-drop-duplicate-word-and-fix-spello-in-linux-memcontrolh.patch
mm-compactionc-delete-duplicated-word.patch
mm-filemapc-delete-duplicated-word.patch
mm-hmmc-delete-duplicated-word.patch
mm-hugetlbc-delete-duplicated-words.patch
mm-memcontrolc-delete-duplicated-words.patch
mm-memoryc-delete-duplicated-words.patch
mm-migratec-delete-duplicated-word.patch
mm-nommuc-delete-duplicated-words.patch
mm-page_allocc-delete-or-fix-duplicated-words.patch
mm-shmemc-delete-duplicated-word.patch
mm-slab_commonc-delete-duplicated-word.patch
mm-usercopyc-delete-duplicated-word.patch
mm-vmscanc-delete-or-fix-duplicated-words.patch
mm-zpoolc-delete-duplicated-word-and-fix-grammar.patch
mm-zsmallocc-fix-duplicated-words.patch
clang-linux-compiler-clangh-drop-duplicated-word-in-a-comment.patch
linux-exportfsh-drop-duplicated-word-in-a-comment.patch
linux-async_txh-drop-duplicated-word-in-a-comment.patch
xz-drop-duplicated-word-in-linux-xzh.patch
autofs-fix-doubled-word.patch

