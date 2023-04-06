Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 366BDC7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbjDFCpW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbjDFCov (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D7E76B0
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16208642AB
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4D4C433D2;
        Thu,  6 Apr 2023 02:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749089;
        bh=9EtIXagOlzlAA5rTRoihMHpcIwGHb/3Pp5dCOjLs11g=;
        h=Date:To:From:Subject:From;
        b=qns7VOh8HSY0PSphsTFzvrpQDyZya+KmaQ9cng+/QcN651vsoWAxsIfUs3/azFD3z
         ABMUptruvZ24+mZ8W621PwC6lLnAd491AGL7R1dSDwpo9urG77Y4Ne/deB8O37UF+X
         FNFojnrnZx/fTd/UA0dLmaxYw80+2Fgv8iMRGm5I=
Date:   Wed, 05 Apr 2023 19:44:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-3.patch removed from -mm tree
Message-Id: <20230406024449.6D4D4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap/vma_merge: use the proper vma pointer in case 3
has been removed from the -mm tree.  Its filename was
     mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-3.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/mmap/vma_merge: use the proper vma pointer in case 3
Date: Thu, 9 Mar 2023 12:12:50 +0100

In case 3 we we use 'next' for everything but vma_pgoff.  So use 'next'
for that as well, instead of 'mid', for consistency.  Then in case 8 we
have to use 'mid' explicitly, which should also make the intent more
obvious.

Adjust the diagram for cases 1-3 in the comment to match the code - we are
using 'next' for case 3 so mark the range with XXXX instead of NNNN.  For
case 2 that's a no-op as the code doesn't touch 'next' or 'mid'.  For case
1 it's now wrong but that will be fixed next.

No functional change.

Link: https://lkml.kernel.org/r/20230309111258.24079-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/mmap.c~mm-mmap-vma_merge-use-the-proper-vma-pointer-in-case-3
+++ a/mm/mmap.c
@@ -857,11 +857,11 @@ can_vma_merge_after(struct vm_area_struc
  *    mmap, brk or    case 4 below       case 5 below
  *    mremap move:
  *                        AAAA               AAAA
- *                    PPPP    NNNN       PPPPNNNNXXXX
+ *                    PPPP    XXXX       PPPPNNNNXXXX
  *                    might become       might become
  *                    PPPPPPPPPPPP 1 or  PPPPPPPPPPPP 6 or
- *                    PPPPPPPPNNNN 2 or  PPPPPPPPXXXX 7 or
- *                    PPPPNNNNNNNN 3     PPPPXXXXXXXX 8
+ *                    PPPPPPPPXXXX 2 or  PPPPPPPPXXXX 7 or
+ *                    PPPPXXXXXXXX 3     PPPPXXXXXXXX 8
  *
  * It is important for case 8 that the vma NNNN overlapping the
  * region AAAA is never going to extended over XXXX. Instead XXXX must
@@ -978,9 +978,10 @@ struct vm_area_struct *vma_merge(struct
 			vma = next;			/* case 3 */
 			vma_start = addr;
 			vma_end = next->vm_end;
-			vma_pgoff = mid->vm_pgoff;
+			vma_pgoff = next->vm_pgoff;
 			err = 0;
 			if (mid != next) {		/* case 8 */
+				vma_pgoff = mid->vm_pgoff;
 				remove = mid;
 				err = dup_anon_vma(next, mid);
 			}
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-use-check_pages_enabled-static-key-to-check-tail-pages.patch

