Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45466C77B73
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 00:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbjDUA2L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Apr 2023 20:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbjDUA2H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Apr 2023 20:28:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189AC46A4
        for <mm-commits@vger.kernel.org>; Thu, 20 Apr 2023 17:28:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 959F264966
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 00:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9141C433EF;
        Fri, 21 Apr 2023 00:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682036881;
        bh=Or1KGHP4sf9ZoV+SCuwM83OuKsnPFecujj+Bqlpfgwo=;
        h=Date:To:From:Subject:From;
        b=0Em1bQji7v1ZPaACa/BFh6DEV0azuAVJEI2reKsikqCGJfBJKXNGq1G8mepCUaptY
         LgNjgLcnJ5UMOm2ldkeiOe4uhEXhOhYVaGK732DQLJVZclsOP0IhIgN29C0P7fQr9r
         nujQ03KbA5YRYTWMREV04Kf7OY4tSkY7FsNpUB2o=
Date:   Thu, 20 Apr 2023 17:28:00 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        shakeelb@google.com, rientjes@google.com,
        quic_pkondeti@quicinc.com, markhemm@googlemail.com,
        hughd@google.com, quic_charante@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-shmem-implement-posix_fadv_need-for-shmem.patch removed from -mm tree
Message-Id: <20230421002800.E9141C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: shmem: implement POSIX_FADV_[WILL|DONT]NEED for shmem
has been removed from the -mm tree.  Its filename was
     mm-shmem-implement-posix_fadv_need-for-shmem.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm: shmem: implement POSIX_FADV_[WILL|DONT]NEED for shmem
Date: Tue, 14 Feb 2023 18:21:50 +0530

Currently fadvise(2) is supported only for the files that doesn't
associated with noop_backing_dev_info thus for the files, like shmem,
fadvise results into NOP.  But then there is file_operations->fadvise()
that lets the file systems to implement their own fadvise
implementation.  Use this support to implement some of the
POSIX_FADV_XXX functionality for shmem files.

This patch aims to implement POSIX_FADV_WILLNEED and
POSIX_FADV_DONTNEED advises to shmem files which can be helpful for the
clients who may want to manage the shmem pages of the files that are
created through shmem_file_setup[_with_mnt]().  One usecase is
implemented on the Snapdragon SoC's running Android where the graphics
client is allocating lot of shmem pages per process and pinning them. 
When this process is put to background, the instantaneous reclaim is
performed on those shmem pages using the logic implemented
downstream[3][4].  With this patch, the client can now issue the
fadvise calls on the shmem files that does the instantaneous reclaim
which can aid the use cases like mentioned above.  Application that
does require the reclaimed pages, say when the app put to foreground,
can issue the POSIX_FADV_WILLNEED to bring back them from the swap
area.  Alternatively the drivers can also use
shmem_read_mapping_page_gfp() to bring back the reclaimed shmem pages.

This usecase leads to ~2% reduction in average launch latencies of the
apps and 10% in total number of kills by the low memory killer running
on Android.

Some questions asked while reviewing this patch:

  Q) Can the same thing be achieved with FD mapped to user and use
     madvise?

  A) All drivers are not mapping all the shmem fd's to user space
     and want to manage them with in the kernel.  Ex: shmem memory can
     be mapped to the other subsystems and they fill in the data and
     then give it to other subsystem for further processing, where, the
     user mapping is not at all required.  A simple example, memory
     that is given for gpu subsystem which can be filled directly and
     give to display subsystem.  And the respective drivers know well
     about when to keep that memory in ram or swap based on may be a
     user activity.

  Q) Should we add the documentation section in Manual pages?

  A) The man[1] pages for the fadvise() whatever says is also
     applicable for shmem files.  so couldn't feel it correct to add
     specific to shmem files separately.

  Q) The proposed semantics of POSIX_FADV_DONTNEED is actually
     similar to MADV_PAGEOUT and different from MADV_DONTNEED.  This is
     a user facing API and this difference will cause confusion?

  A) man pages [2] says that "POSIX_FADV_DONTNEED attempts to free
     cached pages associated with the specified region." This means on
     issuing this FADV, it is expected to free the file cache pages. 
     And it is implementation defined If the dirty pages may be
     attempted to writeback.  And the unwritten dirty pages will not be
     freed.  So, FADV_DONTNEED also covers the semantics of
     MADV_PAGEOUT for file pages and there is no purpose of PAGEOUT for
     file pages.

[1] https://linux.die.net/man/2/fadvise
[2] https://man7.org/linux/man-pages/man2/posix_fadvise.2.html
[3]
https://git.codelinaro.org/clo/la/platform/vendor/qcom/opensource/graphics-kernel/-/blob/gfx-kernel.lnx.1.0.r3-rel/kgsl_reclaim.c#L289
[4]
https://android.googlesource.com/kernel/common/+/refs/heads/android12-5.10/mm/shmem.c#4310

Link: https://lkml.kernel.org/r/631e42b6dffdcc4b4b24f5be715c37f78bf903db.1676378702.git.quic_charante@quicinc.com
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mark Hemment <markhemm@googlemail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |  116 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

--- a/mm/shmem.c~mm-shmem-implement-posix_fadv_need-for-shmem
+++ a/mm/shmem.c
@@ -40,6 +40,9 @@
 #include <linux/fs_parser.h>
 #include <linux/swapfile.h>
 #include <linux/iversion.h>
+#include <linux/mm_inline.h>
+#include <linux/fadvise.h>
+#include <linux/page_idle.h>
 #include "swap.h"
 
 static struct vfsmount *shm_mnt;
@@ -2370,6 +2373,118 @@ static void shmem_set_inode_flags(struct
 #define shmem_initxattrs NULL
 #endif
 
+static void shmem_isolate_pages_range(struct address_space *mapping, loff_t start,
+				loff_t end, struct list_head *list)
+{
+	XA_STATE(xas, &mapping->i_pages, start);
+	struct folio *folio;
+
+	rcu_read_lock();
+	xas_for_each(&xas, folio, end) {
+		if (xas_retry(&xas, folio))
+			continue;
+		if (xa_is_value(folio))
+			continue;
+
+		if (!folio_try_get(folio))
+			continue;
+		if (folio_test_unevictable(folio) || folio_mapped(folio) ||
+				folio_isolate_lru(folio)) {
+			folio_put(folio);
+			continue;
+		}
+		folio_put(folio);
+
+		/*
+		 * Prepare the folios to be passed to reclaim_pages().
+		 * VM can't reclaim a folio unless young bit is
+		 * cleared in its flags.
+		 */
+		folio_clear_referenced(folio);
+		folio_test_clear_young(folio);
+		list_add(&folio->lru, list);
+		if (need_resched()) {
+			xas_pause(&xas);
+			cond_resched_rcu();
+		}
+	}
+	rcu_read_unlock();
+}
+
+static int shmem_fadvise_dontneed(struct address_space *mapping, loff_t start,
+				loff_t end)
+{
+	LIST_HEAD(folio_list);
+
+	if (!total_swap_pages || mapping_unevictable(mapping))
+		return 0;
+
+	lru_add_drain();
+	shmem_isolate_pages_range(mapping, start, end, &folio_list);
+	reclaim_pages(&folio_list);
+
+	return 0;
+}
+
+static int shmem_fadvise_willneed(struct address_space *mapping,
+				 pgoff_t start, pgoff_t long end)
+{
+	struct folio *folio;
+	pgoff_t index;
+
+	xa_for_each_range(&mapping->i_pages, index, folio, start, end) {
+		if (!xa_is_value(folio))
+			continue;
+		folio = shmem_read_folio(mapping, index);
+		if (!IS_ERR(folio))
+			folio_put(folio);
+	}
+
+	return 0;
+}
+
+static int shmem_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
+{
+	loff_t endbyte;
+	pgoff_t start_index;
+	pgoff_t end_index;
+	struct address_space *mapping;
+	struct inode *inode = file_inode(file);
+	int ret = 0;
+
+	if (S_ISFIFO(inode->i_mode))
+		return -ESPIPE;
+
+	mapping = file->f_mapping;
+	if (!mapping || len < 0 || !shmem_mapping(mapping))
+		return -EINVAL;
+
+	endbyte = fadvise_calc_endbyte(offset, len);
+
+	start_index = offset >> PAGE_SHIFT;
+	end_index   = endbyte >> PAGE_SHIFT;
+	switch (advice) {
+	case POSIX_FADV_DONTNEED:
+		ret = shmem_fadvise_dontneed(mapping, start_index, end_index);
+		break;
+	case POSIX_FADV_WILLNEED:
+		ret = shmem_fadvise_willneed(mapping, start_index, end_index);
+		break;
+	case POSIX_FADV_NORMAL:
+	case POSIX_FADV_RANDOM:
+	case POSIX_FADV_SEQUENTIAL:
+	case POSIX_FADV_NOREUSE:
+		/*
+		 * No bad return value, but ignore advice.
+		 */
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
 static struct inode *shmem_get_inode(struct mnt_idmap *idmap, struct super_block *sb,
 				     struct inode *dir, umode_t mode, dev_t dev,
 				     unsigned long flags)
@@ -3990,6 +4105,7 @@ static const struct file_operations shme
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= shmem_fallocate,
 #endif
+	.fadvise	= shmem_fadvise,
 };
 
 static const struct inode_operations shmem_inode_operations = {
_

Patches currently in -mm which might be from quic_charante@quicinc.com are


