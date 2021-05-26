Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889CEC47082
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 22:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C6A5613BF
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 22:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhEZW7H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 May 2021 18:59:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234343AbhEZW7H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 May 2021 18:59:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18E216139A;
        Wed, 26 May 2021 22:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622069854;
        bh=Lo7gSOpHDLa9EPGrJXx0xDztN2vZRo2ky2/9ZRRBwbc=;
        h=Date:From:To:Subject:From;
        b=sBQL45lv2LSGiDYlYjKAlJdOtGqIM+Xp4FoAqYAyeBNHQMLj3/BOTnL/cnTdLPXxZ
         nB9N+Ooaq3HuI+mNFkr9TJ6VKRM+efTv2PRKPL41bR7XotA7f7vXwMoLaCna228eam
         KmgjavJmpsGtt1z6gnK5zIDJ1OwQUXExcommWCC0=
Date:   Wed, 26 May 2021 15:57:33 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, alex.shi@linux.alibaba.com, david@redhat.com,
        guro@fb.com, haiyangz@microsoft.com, jasowang@redhat.com,
        jbohac@suse.cz, kys@microsoft.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        mst@redhat.com, naoya.horiguchi@nec.com, osalvador@suse.de,
        rppt@linux.ibm.com, steven.price@arm.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, willy@infradead.org, yaoaili@kingsoft.com
Subject:  + fs-proc-kcore-use-page_offline_freezethaw.patch added
 to -mm tree
Message-ID: <20210526225733.3jrClc1-G%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/kcore: use page_offline_(freeze|thaw)
has been added to the -mm tree.  Its filename is
     fs-proc-kcore-use-page_offline_freezethaw.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-proc-kcore-use-page_offline_freezethaw.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-kcore-use-page_offline_freezethaw.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/kcore: use page_offline_(freeze|thaw)

Let's properly synchronize with drivers that set PageOffline(). 
Unfreeze/thaw every now and then, so drivers that want to set
PageOffline() can make progress.

Link: https://lkml.kernel.org/r/20210526093041.8800-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Aili Yao <yaoaili@kingsoft.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/proc/kcore.c~fs-proc-kcore-use-page_offline_freezethaw
+++ a/fs/proc/kcore.c
@@ -313,6 +313,7 @@ read_kcore(struct file *file, char __use
 {
 	char *buf = file->private_data;
 	size_t phdrs_offset, notes_offset, data_offset;
+	size_t page_offline_frozen = 1;
 	size_t phdrs_len, notes_len;
 	struct kcore_list *m;
 	size_t tsz;
@@ -322,6 +323,11 @@ read_kcore(struct file *file, char __use
 	int ret = 0;
 
 	down_read(&kclist_lock);
+	/*
+	 * Don't race against drivers that set PageOffline() and expect no
+	 * further page access.
+	 */
+	page_offline_freeze();
 
 	get_kcore_size(&nphdr, &phdrs_len, &notes_len, &data_offset);
 	phdrs_offset = sizeof(struct elfhdr);
@@ -480,6 +486,12 @@ read_kcore(struct file *file, char __use
 			}
 		}
 
+		if (page_offline_frozen++ % MAX_ORDER_NR_PAGES == 0) {
+			page_offline_thaw();
+			cond_resched();
+			page_offline_freeze();
+		}
+
 		if (&m->list == &kclist_head) {
 			if (clear_user(buffer, tsz)) {
 				ret = -EFAULT;
@@ -565,6 +577,7 @@ skip:
 	}
 
 out:
+	page_offline_thaw();
 	up_read(&kclist_lock);
 	if (ret)
 		return ret;
_

Patches currently in -mm which might be from david@redhat.com are

perf-map_executable-does-not-indicate-vm_mayexec.patch
binfmt-remove-in-tree-usage-of-map_executable.patch
mm-ignore-map_executable-in-ksys_mmap_pgoff.patch
fs-proc-kcore-drop-kcore_remap-and-kcore_other.patch
fs-proc-kcore-pfn_is_ram-check-only-applies-to-kcore_ram.patch
fs-proc-kcore-dont-read-offline-sections-logically-offline-pages-and-hwpoisoned-pages.patch
mm-introduce-page_offline_beginendfreezethaw-to-synchronize-setting-pageoffline.patch
virtio-mem-use-page_offline_startend-when-setting-pageoffline.patch
fs-proc-kcore-use-page_offline_freezethaw.patch
mm-make-variable-names-for-populate_vma_page_range-consistent.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables.patch
maintainers-add-tools-testing-selftests-vm-to-memory-management.patch
selftests-vm-add-protection_keys_32-protection_keys_64-to-gitignore.patch
selftests-vm-add-test-for-madv_populate_readwrite.patch
memory-hotplugrst-complete-admin-guide-overhaul.patch

