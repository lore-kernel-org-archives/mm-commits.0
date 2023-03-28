Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF512C76196
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjC1XW7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjC1XWE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:22:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B6335B3
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8415EB81F56
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A07EC4339C;
        Tue, 28 Mar 2023 23:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045715;
        bh=/WSGuEQVnoddeWqG42XlhiaesRMA04POD0IoTG9BCPk=;
        h=Date:To:From:Subject:From;
        b=tfsHtnJoCQ4E6XyxdIG+hJKrnDC+3xB6n5FWeCfOSAQ9sBHlGgdQLgLPbU+SBp1SY
         Wp2DEQ02alTLHYEJajBKuNEc8E+jcP8rGnCO8IyWAS1gkeTt+AEVFuUZQXyTLaTlnz
         HSTk4u58recjMAsJ1q4VuERjc9Ma4RInq39kBAtI=
Date:   Tue, 28 Mar 2023 16:21:54 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        piaojun@huawei.com, ocfs2-devel@oss.oracle.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, jiangqi903@gmail.com, jack@suse.cz,
        ghe@suse.com, gechangwei@live.cn, dushistov@mail.ru,
        dave.kleikamp@oracle.com, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch removed from -mm tree
Message-Id: <20230328232155.1A07EC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: don't use write_one_page in ocfs2_duplicate_clusters_by_page
has been removed from the -mm tree.  Its filename was
     ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: ocfs2: don't use write_one_page in ocfs2_duplicate_clusters_by_page
Date: Tue, 7 Mar 2023 15:31:24 +0100

Use filemap_write_and_wait_range to write back the range of the dirty page
instead of write_one_page in preparation of removing write_one_page and
eventually ->writepage.

Link: https://lkml.kernel.org/r/20230307143125.27778-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Gang He <ghe@suse.com>
Cc: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/refcounttree.c~ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page
+++ a/fs/ocfs2/refcounttree.c
@@ -2952,10 +2952,11 @@ retry:
 		 */
 		if (PAGE_SIZE <= OCFS2_SB(sb)->s_clustersize) {
 			if (PageDirty(page)) {
-				/*
-				 * write_on_page will unlock the page on return
-				 */
-				ret = write_one_page(page);
+				unlock_page(page);
+				put_page(page);
+
+				ret = filemap_write_and_wait_range(mapping,
+						offset, map_end - 1);
 				goto retry;
 			}
 		}
_

Patches currently in -mm which might be from hch@lst.de are

mm-dont-look-at-xarray-value-entries-in-split_huge_pages_in_file.patch
mm-make-mapping_get_entry-available-outside-of-filemapc.patch
mm-use-filemap_get_entry-in-filemap_get_incore_folio.patch
shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp.patch
mm-remove-fgp_entry.patch
mm-return-an-err_ptr-from-__filemap_get_folio.patch
mm-return-an-err_ptr-from-__filemap_get_folio-fix.patch

