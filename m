Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E18C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 21:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CFF561440
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 21:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhENVSQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 17:18:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231945AbhENVSQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 17:18:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F3326134F;
        Fri, 14 May 2021 21:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621027024;
        bh=ievarCcDJVpy9w7Tv2Ylp9h7CEWEPTJoxHLe5+SgCHE=;
        h=Date:From:To:Subject:From;
        b=q6WMl4YrNz20spsVCSKMaJpjzbpgS1HJFkYWcBlrpxaAwWOcaFp32LSApIyQma6I5
         FkX+zVVwjdR6q+p4YVHZPNFyV1PxfvG/nW2T6DVWrpLzMvVtVzSHMhyECDvUJlGufe
         v9bSx0+sxJjQEqiQsyXbxNT1wUYJ7PHLJZv1h5KY=
Date:   Fri, 14 May 2021 14:17:03 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, alex.shi@linux.alibaba.com, david@redhat.com,
        guro@fb.com, haiyangz@microsoft.com, jasowang@redhat.com,
        jbohac@suse.cz, kys@microsoft.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        mst@redhat.com, naoya.horiguchi@nec.com, osalvador@suse.de,
        rppt@linux.ibm.com, steven.price@arm.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, willy@infradead.org, yaoaili@kingsoft.com
Subject:  +
 fs-proc-kcore-pfn_is_ram-check-only-applies-to-kcore_ram.patch added to -mm
 tree
Message-ID: <20210514211703.5Vpa4V2Zl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/kcore: pfn_is_ram check only applies to KCORE_RAM
has been added to the -mm tree.  Its filename is
     fs-proc-kcore-pfn_is_ram-check-only-applies-to-kcore_ram.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-proc-kcore-pfn_is_ram-check-only-applies-to-kcore_ram.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-kcore-pfn_is_ram-check-only-applies-to-kcore_ram.patch

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
Subject: fs/proc/kcore: pfn_is_ram check only applies to KCORE_RAM

Let's resturcture the code, using switch-case, and checking pfn_is_ram()
only when we are dealing with KCORE_RAM.

Link: https://lkml.kernel.org/r/20210514172247.176750-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
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
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Roman Gushchin <guro@fb.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

--- a/fs/proc/kcore.c~fs-proc-kcore-pfn_is_ram-check-only-applies-to-kcore_ram
+++ a/fs/proc/kcore.c
@@ -483,25 +483,36 @@ read_kcore(struct file *file, char __use
 				goto out;
 			}
 			m = NULL;	/* skip the list anchor */
-		} else if (!pfn_is_ram(__pa(start) >> PAGE_SHIFT)) {
-			if (clear_user(buffer, tsz)) {
-				ret = -EFAULT;
-				goto out;
-			}
-		} else if (m->type == KCORE_VMALLOC) {
+			goto skip;
+		}
+
+		switch (m->type) {
+		case KCORE_VMALLOC:
 			vread(buf, (char *)start, tsz);
 			/* we have to zero-fill user buffer even if no read */
 			if (copy_to_user(buffer, buf, tsz)) {
 				ret = -EFAULT;
 				goto out;
 			}
-		} else if (m->type == KCORE_USER) {
+			break;
+		case KCORE_USER:
 			/* User page is handled prior to normal kernel page: */
 			if (copy_to_user(buffer, (char *)start, tsz)) {
 				ret = -EFAULT;
 				goto out;
 			}
-		} else {
+			break;
+		case KCORE_RAM:
+			if (!pfn_is_ram(__pa(start) >> PAGE_SHIFT)) {
+				if (clear_user(buffer, tsz)) {
+					ret = -EFAULT;
+					goto out;
+				}
+				break;
+			}
+			fallthrough;
+		case KCORE_VMEMMAP:
+		case KCORE_TEXT:
 			if (kern_addr_valid(start)) {
 				/*
 				 * Using bounce buffer to bypass the
@@ -525,7 +536,15 @@ read_kcore(struct file *file, char __use
 					goto out;
 				}
 			}
+			break;
+		default:
+			pr_warn_once("Unhandled KCORE type: %d\n", m->type);
+			if (clear_user(buffer, tsz)) {
+				ret = -EFAULT;
+				goto out;
+			}
 		}
+skip:
 		buflen -= tsz;
 		*fpos += tsz;
 		buffer += tsz;
_

Patches currently in -mm which might be from david@redhat.com are

perf-map_executable-does-not-indicate-vm_mayexec.patch
binfmt-remove-in-tree-usage-of-map_executable.patch
mm-ignore-map_executable-in-ksys_mmap_pgoff.patch
mm-make-variable-names-for-populate_vma_page_range-consistent.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables.patch
maintainers-add-tools-testing-selftests-vm-to-memory-management.patch
selftests-vm-add-protection_keys_32-protection_keys_64-to-gitignore.patch
selftests-vm-add-test-for-madv_populate_readwrite.patch
fs-proc-kcore-drop-kcore_remap-and-kcore_other.patch
fs-proc-kcore-pfn_is_ram-check-only-applies-to-kcore_ram.patch
fs-proc-kcore-dont-read-offline-sections-logically-offline-pages-and-hwpoisoned-pages.patch
mm-introduce-page_offline_beginendfreezethaw-to-synchronize-setting-pageoffline.patch
virtio-mem-use-page_offline_startend-when-setting-pageoffline.patch
fs-proc-kcore-use-page_offline_freezethaw.patch

