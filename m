Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C531C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED85F216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881330;
	bh=B1JWZAPKU0+TrjmCRsClXmh0ShHEXzWtcCYH5+IgWzM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=z6A+i+4AWiZHHceGW1rXT5kuuvbrLf2XxmjcYykPZFfY/ZuWlI4FoqgzG2CmTbTQh
	 Yq+Do/hmIVAQ9aYysehUhcsX6Pt97ivHqzopSdLQ/hTEqYB/k5o2p3WJ6tzjbKjom3
	 IRisQ/MVT9xloANf2g4OklNltHo5DcvKSzRJhbKw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392706AbgJPUst (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:48:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391060AbgJPUst (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:48:49 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFEF820878;
        Fri, 16 Oct 2020 20:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881326;
        bh=B1JWZAPKU0+TrjmCRsClXmh0ShHEXzWtcCYH5+IgWzM=;
        h=Date:From:To:Subject:From;
        b=toC8sW7GseIIjuRyrmdP4OVMusiDPDmzxO37tEGOXkSG3tJQJ0Y/h7rAV+kS/SUVx
         J7ozngKD40KxQBc7986y+5olmO01OEd44ASRi6Zmc/MWtt0wg9DmC6Pkyam/vxIN6F
         HtFK8J6lYTBrQuUPcej/UUZzbpx6EytvG4f1/tMs=
Date:   Fri, 16 Oct 2020 13:48:45 -0700
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@infradead.org,
        hughd@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, riel@surriel.com,
        songliubraving@fb.com, viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [merged]
 fs-do-not-update-nr_thps-for-mappings-which-support-thps.patch removed from
 -mm tree
Message-ID: <20201016204845.Mr4O9UG3Y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: do not update nr_thps for mappings which support THPs
has been removed from the -mm tree.  Its filename was
     fs-do-not-update-nr_thps-for-mappings-which-support-thps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fs: do not update nr_thps for mappings which support THPs

The nr_thps counter is to support THPs in the page cache when the
filesystem doesn't understand THPs.  Eventually it will be removed, but we
should still support filesystems which do not understand THPs yet.  Move
the nr_thp manipulation functions to filemap.h since they're page-cache
specific.

Link: https://lkml.kernel.org/r/20200916032717.22917-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h      |   27 ---------------------------
 include/linux/pagemap.h |   29 +++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 27 deletions(-)

--- a/include/linux/fs.h~fs-do-not-update-nr_thps-for-mappings-which-support-thps
+++ a/include/linux/fs.h
@@ -2697,33 +2697,6 @@ static inline errseq_t file_sample_sb_er
 	return errseq_sample(&file->f_path.dentry->d_sb->s_wb_err);
 }
 
-static inline int filemap_nr_thps(struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	return atomic_read(&mapping->nr_thps);
-#else
-	return 0;
-#endif
-}
-
-static inline void filemap_nr_thps_inc(struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	atomic_inc(&mapping->nr_thps);
-#else
-	WARN_ON_ONCE(1);
-#endif
-}
-
-static inline void filemap_nr_thps_dec(struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	atomic_dec(&mapping->nr_thps);
-#else
-	WARN_ON_ONCE(1);
-#endif
-}
-
 extern int vfs_fsync_range(struct file *file, loff_t start, loff_t end,
 			   int datasync);
 extern int vfs_fsync(struct file *file, int datasync);
--- a/include/linux/pagemap.h~fs-do-not-update-nr_thps-for-mappings-which-support-thps
+++ a/include/linux/pagemap.h
@@ -126,6 +126,35 @@ static inline bool mapping_thp_support(s
 	return test_bit(AS_THP_SUPPORT, &mapping->flags);
 }
 
+static inline int filemap_nr_thps(struct address_space *mapping)
+{
+#ifdef CONFIG_READ_ONLY_THP_FOR_FS
+	return atomic_read(&mapping->nr_thps);
+#else
+	return 0;
+#endif
+}
+
+static inline void filemap_nr_thps_inc(struct address_space *mapping)
+{
+#ifdef CONFIG_READ_ONLY_THP_FOR_FS
+	if (!mapping_thp_support(mapping))
+		atomic_inc(&mapping->nr_thps);
+#else
+	WARN_ON_ONCE(1);
+#endif
+}
+
+static inline void filemap_nr_thps_dec(struct address_space *mapping)
+{
+#ifdef CONFIG_READ_ONLY_THP_FOR_FS
+	if (!mapping_thp_support(mapping))
+		atomic_dec(&mapping->nr_thps);
+#else
+	WARN_ON_ONCE(1);
+#endif
+}
+
 void release_pages(struct page **pages, int nr);
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are

mm-update-the-documentation-for-vfree.patch

