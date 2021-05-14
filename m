Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D44CC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 21:17:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C84A6135F
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 21:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbhENVSN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 17:18:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231945AbhENVSM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 17:18:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BFB161152;
        Fri, 14 May 2021 21:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621027021;
        bh=EsA7yZg//m3hFis5j6DGRXH7rSCIOiKxUhIY7ynEWtQ=;
        h=Date:From:To:Subject:From;
        b=vCKD2FMPCH9Yq7kBkMZuvw8iCWTUckxUyOwSwIXFC6hxwNQRCoE9BqTznKkn3ukNU
         0Ua/yj9x8ZV/llinJ0SWCZzKZGe2MF3YmTtFBg6GUBwNafWGM3iUOSCi1zJ0Dl6JLR
         00vfGj8pfR+S4fohXFPZmJNCaUjjCrpBNXCbaw/M=
Date:   Fri, 14 May 2021 14:16:59 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, alex.shi@linux.alibaba.com, david@redhat.com,
        guro@fb.com, haiyangz@microsoft.com, jasowang@redhat.com,
        jbohac@suse.cz, kys@microsoft.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        mst@redhat.com, naoya.horiguchi@nec.com, osalvador@suse.de,
        rppt@linux.ibm.com, steven.price@arm.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, willy@infradead.org, yaoaili@kingsoft.com
Subject:  + fs-proc-kcore-drop-kcore_remap-and-kcore_other.patch
 added to -mm tree
Message-ID: <20210514211659.TM8DsMKg8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/kcore: drop KCORE_REMAP and KCORE_OTHER
has been added to the -mm tree.  Its filename is
     fs-proc-kcore-drop-kcore_remap-and-kcore_other.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-proc-kcore-drop-kcore_remap-and-kcore_other.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-kcore-drop-kcore_remap-and-kcore_other.patch

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
Subject: fs/proc/kcore: drop KCORE_REMAP and KCORE_OTHER

Patch series "fs/proc/kcore: don't read offline sections, logically offline pages and hwpoisoned pages", v2.

Looking for places where the kernel might unconditionally read
PageOffline() pages, I stumbled over /proc/kcore; turns out /proc/kcore
needs some more love to not touch some other pages we really don't want to
read -- i.e., hwpoisoned ones.

Examples for PageOffline() pages are pages inflated in a balloon, memory
unplugged via virtio-mem, and partially-present sections in memory added
by the Hyper-V balloon.

When reading pages inflated in a balloon, we essentially produce
unnecessary load in the hypervisor; holes in partially present sections in
case of Hyper-V are not accessible and already were a problem for
/proc/vmcore, fixed in makedumpfile by detecting PageOffline() pages.  In
the future, virtio-mem might disallow reading unplugged memory -- marked
as PageOffline() -- in some environments, resulting in undefined behavior
when accessed; therefore, I'm trying to identify and rework all these
(corner) cases.

With this series, there is really only access via /dev/mem, /proc/vmcore
and kdb left after I ripped out /dev/kmem.  kdb is an advanced corner-case
use case -- we won't care for now if someone explicitly tries to do nasty
things by reading from/writing to physical addresses we better not touch. 
/dev/mem is a use case we won't support for virtio-mem, at least for now,
so we'll simply disallow mapping any virtio-mem memory via /dev/mem next. 
/proc/vmcore is really only a problem when dumping the old kernel via
something that's not makedumpfile (read: basically never), however, we'll
try sanitizing that as well in the second kernel in the future.

Tested via kcore_dump:
	https://github.com/schlafwandler/kcore_dump


This patch (of 6):

Commit db779ef67ffe ("proc/kcore: Remove unused kclist_add_remap()")
removed the last user of KCORE_REMAP.

Commit 595dd46ebfc1 ("vfs/proc/kcore, x86/mm/kcore: Fix SMAP fault when
dumping vsyscall user page") removed the last user of KCORE_OTHER.

Let's drop both types.  While at it, also drop vaddr in "struct
kcore_list", used by KCORE_REMAP only.

Link: https://lkml.kernel.org/r/20210514172247.176750-1-david@redhat.com
Link: https://lkml.kernel.org/r/20210514172247.176750-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Aili Yao <yaoaili@kingsoft.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c       |    7 ++-----
 include/linux/kcore.h |    3 ---
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/fs/proc/kcore.c~fs-proc-kcore-drop-kcore_remap-and-kcore_other
+++ a/fs/proc/kcore.c
@@ -380,11 +380,8 @@ read_kcore(struct file *file, char __use
 			phdr->p_type = PT_LOAD;
 			phdr->p_flags = PF_R | PF_W | PF_X;
 			phdr->p_offset = kc_vaddr_to_offset(m->addr) + data_offset;
-			if (m->type == KCORE_REMAP)
-				phdr->p_vaddr = (size_t)m->vaddr;
-			else
-				phdr->p_vaddr = (size_t)m->addr;
-			if (m->type == KCORE_RAM || m->type == KCORE_REMAP)
+			phdr->p_vaddr = (size_t)m->addr;
+			if (m->type == KCORE_RAM)
 				phdr->p_paddr = __pa(m->addr);
 			else if (m->type == KCORE_TEXT)
 				phdr->p_paddr = __pa_symbol(m->addr);
--- a/include/linux/kcore.h~fs-proc-kcore-drop-kcore_remap-and-kcore_other
+++ a/include/linux/kcore.h
@@ -11,14 +11,11 @@ enum kcore_type {
 	KCORE_RAM,
 	KCORE_VMEMMAP,
 	KCORE_USER,
-	KCORE_OTHER,
-	KCORE_REMAP,
 };
 
 struct kcore_list {
 	struct list_head list;
 	unsigned long addr;
-	unsigned long vaddr;
 	size_t size;
 	int type;
 };
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

