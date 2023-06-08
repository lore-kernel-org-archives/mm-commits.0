Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F407C7EE25
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jun 2023 23:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbjFHXWo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Jun 2023 19:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjFHXWn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jun 2023 19:22:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E0430D3;
        Thu,  8 Jun 2023 16:22:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6988065151;
        Thu,  8 Jun 2023 23:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE00FC433EF;
        Thu,  8 Jun 2023 23:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686266560;
        bh=ezGSn0pt9JH0LfMXdjLiiqiussi0F9HljhD3YA9Y0Lc=;
        h=Date:To:From:Subject:From;
        b=LBGyL6XaTC/0nPkuD7cl3qVLb2CPjQ96zzShnfQ3U/1RbGTOWTkklU3gZ1ApwgLPJ
         7WW0UqzU06+/hctupnOE0NfL30uwZQCP7O4Wxaoz5YsSuUy/xpAX1aYBnW+3usRWgD
         rwsaTFGLT+bbM5O/YvNubDdlHpzpE41vHinazSu0=
Date:   Thu, 08 Jun 2023 16:22:39 -0700
To:     mm-commits@vger.kernel.org, vivek.kasireddy@intel.com,
        stable@vger.kernel.org, muchun.song@linux.dev, mhocko@suse.com,
        kraxel@redhat.com, kirill.shutemov@linux.intel.com,
        junxiao.chang@intel.com, jthoughton@google.com,
        jmarchan@redhat.com, gregkh@linuxfoundation.org,
        dongwon.kim@intel.com, david@redhat.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + udmabuf-revert-add-support-for-mapping-hugepages-v4.patch added to mm-hotfixes-unstable branch
Message-Id: <20230608232240.AE00FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: udmabuf: revert 'Add support for mapping hugepages (v4)'
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     udmabuf-revert-add-support-for-mapping-hugepages-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/udmabuf-revert-add-support-for-mapping-hugepages-v4.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: udmabuf: revert 'Add support for mapping hugepages (v4)'
Date: Thu, 8 Jun 2023 13:49:27 -0700

This effectively reverts commit 16c243e99d33 ("udmabuf: Add support for
mapping hugepages (v4)").  Recently, Junxiao Chang found a BUG with page
map counting as described here [1].  This issue pointed out that the
udmabuf driver was making direct use of subpages of hugetlb pages.  This
is not a good idea, and no other mm code attempts such use.  In addition
to the mapcount issue, this also causes issues with hugetlb vmemmap
optimization and page poisoning.

For now, remove hugetlb support.

If udmabuf wants to be used on hugetlb mappings, it should be changed to
only use complete hugetlb pages.  This will require different alignment
and size requirements on the UDMABUF_CREATE API.

[1] https://lore.kernel.org/linux-mm/20230512072036.1027784-1-junxiao.chang@intel.com/

Link: https://lkml.kernel.org/r/20230608204927.88711-1-mike.kravetz@oracle.com
Fixes: 16c243e99d33 ("udmabuf: Add support for mapping hugepages (v4)")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: James Houghton <jthoughton@google.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma-buf/udmabuf.c |   47 ++++--------------------------------
 1 file changed, 6 insertions(+), 41 deletions(-)

--- a/drivers/dma-buf/udmabuf.c~udmabuf-revert-add-support-for-mapping-hugepages-v4
+++ a/drivers/dma-buf/udmabuf.c
@@ -12,7 +12,6 @@
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
 #include <linux/udmabuf.h>
-#include <linux/hugetlb.h>
 #include <linux/vmalloc.h>
 #include <linux/iosys-map.h>
 
@@ -207,9 +206,7 @@ static long udmabuf_create(struct miscde
 	struct udmabuf *ubuf;
 	struct dma_buf *buf;
 	pgoff_t pgoff, pgcnt, pgidx, pgbuf = 0, pglimit;
-	struct page *page, *hpage = NULL;
-	pgoff_t subpgoff, maxsubpgs;
-	struct hstate *hpstate;
+	struct page *page;
 	int seals, ret = -EINVAL;
 	u32 i, flags;
 
@@ -245,7 +242,7 @@ static long udmabuf_create(struct miscde
 		if (!memfd)
 			goto err;
 		mapping = memfd->f_mapping;
-		if (!shmem_mapping(mapping) && !is_file_hugepages(memfd))
+		if (!shmem_mapping(mapping))
 			goto err;
 		seals = memfd_fcntl(memfd, F_GET_SEALS, 0);
 		if (seals == -EINVAL)
@@ -256,48 +253,16 @@ static long udmabuf_create(struct miscde
 			goto err;
 		pgoff = list[i].offset >> PAGE_SHIFT;
 		pgcnt = list[i].size   >> PAGE_SHIFT;
-		if (is_file_hugepages(memfd)) {
-			hpstate = hstate_file(memfd);
-			pgoff = list[i].offset >> huge_page_shift(hpstate);
-			subpgoff = (list[i].offset &
-				    ~huge_page_mask(hpstate)) >> PAGE_SHIFT;
-			maxsubpgs = huge_page_size(hpstate) >> PAGE_SHIFT;
-		}
 		for (pgidx = 0; pgidx < pgcnt; pgidx++) {
-			if (is_file_hugepages(memfd)) {
-				if (!hpage) {
-					hpage = find_get_page_flags(mapping, pgoff,
-								    FGP_ACCESSED);
-					if (!hpage) {
-						ret = -EINVAL;
-						goto err;
-					}
-				}
-				page = hpage + subpgoff;
-				get_page(page);
-				subpgoff++;
-				if (subpgoff == maxsubpgs) {
-					put_page(hpage);
-					hpage = NULL;
-					subpgoff = 0;
-					pgoff++;
-				}
-			} else {
-				page = shmem_read_mapping_page(mapping,
-							       pgoff + pgidx);
-				if (IS_ERR(page)) {
-					ret = PTR_ERR(page);
-					goto err;
-				}
+			page = shmem_read_mapping_page(mapping, pgoff + pgidx);
+			if (IS_ERR(page)) {
+				ret = PTR_ERR(page);
+				goto err;
 			}
 			ubuf->pages[pgbuf++] = page;
 		}
 		fput(memfd);
 		memfd = NULL;
-		if (hpage) {
-			put_page(hpage);
-			hpage = NULL;
-		}
 	}
 
 	exp_info.ops  = &udmabuf_ops;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

udmabuf-revert-add-support-for-mapping-hugepages-v4.patch

