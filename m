Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEDA9C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EE1C2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816166;
	bh=fbrnRWCulCOo9PFrTbqPvrHXUA+a9XCwS9AOKH7I/7U=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Fp1k6u3tYlfcXfe0x17U0U9MZLdYqqtJVQJnjONhOnO26N5NyCRvOxC++xsY8na0n
	 YSpIqnzg9IOSnKGFO1IAZMPUYIcLP/w9rbZUm6/WArdLRUEkUJObsmau9Af5w8cL9r
	 9uwAwPMGlVioNdkKat22PPyT3kEzQsGQrlxGhvME=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389581AbgJPCmq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:42:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730617AbgJPCmp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:42:45 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98C9820897;
        Fri, 16 Oct 2020 02:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816165;
        bh=fbrnRWCulCOo9PFrTbqPvrHXUA+a9XCwS9AOKH7I/7U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cmeeDV6nqNJYVDUe+jIwxtQqTrGoUftpvnPu6GfV/5E7VZUYKmLq15t1uxLLGVfCF
         2Nu5LZDARKK7dL1qcipb454aBPIXeSePBgUkZ3zRq+M9ZIrz9DNHuqntpFbEoPxrXU
         kXasJ1IIcDI9sfwxNS5hmvr3S2U/6ozOQTOed58k=
Date:   Thu, 15 Oct 2020 19:42:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dchinner@redhat.com, hannes@cmpxchg.org,
        hch@infradead.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, riel@surriel.com,
        songliubraving@fb.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, willy@infradead.org
Subject:  [patch 031/156] fs: do not update nr_thps for mappings
 which support THPs
Message-ID: <20201016024244.XCjaDkO6Z%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
