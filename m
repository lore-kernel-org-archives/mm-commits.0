Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80DBFC4338F
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 20:35:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B1F460D07
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 20:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhHBUfv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Aug 2021 16:35:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhHBUfv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Aug 2021 16:35:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B69EC60F93;
        Mon,  2 Aug 2021 20:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627936540;
        bh=Y1P/YySYuTQrPGSKLo6QrsFENJbPh9vx1hBdKkg04PQ=;
        h=Date:From:To:Subject:From;
        b=lMLq2a3h1KyfOdVedP8LYqk/KPExt0WphLXfxf+aG5LVvbJckZ7kNnrotDq5AihOM
         P/ghV/li1oJbyAR1iMFoejwH2caPGhRqjAEE9B6bymZhSG8LknHquNm0ckmQ4o6Au5
         o1kpjHp+y9UrlyHdE0R5l4HCc30xP/ycBcnSUjhI=
Date:   Mon, 02 Aug 2021 13:35:39 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        tsbogend@alpha.franken.de, shuah@kernel.org, rth@twiddle.net,
        riel@surriel.com, peterx@redhat.com, osalvador@suse.de,
        mst@redhat.com, minchan@kernel.org, mike.kravetz@oracle.com,
        mhocko@suse.com, mattst88@gmail.com, linuxram@us.ibm.com,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca, jcmvbkbc@gmail.com,
        jannh@google.com, James.Bottomley@HansenPartnership.com,
        ink@jurassic.park.msu.ru, hughd@google.com, eike-kernel@sf-tec.de,
        deller@gmx.de, dave.hansen@intel.com, chris@zankel.net,
        arnd@arndb.de, aarcange@redhat.com, david@redhat.com
Subject:  +
 mm-madvise-report-sigbus-as-efault-for-madv_populate_readwrite.patch added to
 -mm tree
Message-ID: <20210802203539.cz1P7%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: report SIGBUS as -EFAULT for MADV_POPULATE_(READ|WRITE)
has been added to the -mm tree.  Its filename is
     mm-madvise-report-sigbus-as-efault-for-madv_populate_readwrite.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-report-sigbus-as-efault-for-madv_populate_readwrite.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-report-sigbus-as-efault-for-madv_populate_readwrite.patch

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
Subject: mm/madvise: report SIGBUS as -EFAULT for MADV_POPULATE_(READ|WRITE)

Doing some extended tests and polishing the man page update for
MADV_POPULATE_(READ|WRITE), I realized that we end up converting also
SIGBUS (via -EFAULT) to -EINVAL, making it look like yet another madvise()
user error.

We want to report only problematic mappings and permission problems that
the user could have know as -EINVAL.

Let's not convert -EFAULT arising due to SIGBUS (or SIGSEGV) to -EINVAL,
but instead indicate -EFAULT to user space.  While we could also convert
it to -ENOMEM, using -EFAULT looks more helpful when user space might want
to troubleshoot what's going wrong: MADV_POPULATE_(READ|WRITE) is not part
of an final Linux release and we can still adjust the behavio= r.

Link: https://lkml.kernel.org/r/20210726154932.102880-1-david@redhat.com
Fixes: 4ca9b3859dac ("mm/madvise: introduce MADV_POPULATE_(READ|WRITE) to prefault page tables")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c     |    7 +++++--
 mm/madvise.c |    4 +++-
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-madvise-report-sigbus-as-efault-for-madv_populate_readwrite
+++ a/mm/gup.c
@@ -1558,9 +1558,12 @@ long faultin_vma_page_range(struct vm_ar
 		gup_flags |= FOLL_WRITE;
 
 	/*
-	 * See check_vma_flags(): Will return -EFAULT on incompatible mappings
-	 * or with insufficient permissions.
+	 * We want to report -EINVAL instead of -EFAULT for any permission
+	 * problems or incompatible mappings.
 	 */
+	if (check_vma_flags(vma, gup_flags))
+		return -EINVAL;
+
 	return __get_user_pages(mm, start, nr_pages, gup_flags,
 				NULL, NULL, locked);
 }
--- a/mm/madvise.c~mm-madvise-report-sigbus-as-efault-for-madv_populate_readwrite
+++ a/mm/madvise.c
@@ -862,10 +862,12 @@ static long madvise_populate(struct vm_a
 			switch (pages) {
 			case -EINTR:
 				return -EINTR;
-			case -EFAULT: /* Incompatible mappings / permissions. */
+			case -EINVAL: /* Incompatible mappings / permissions. */
 				return -EINVAL;
 			case -EHWPOISON:
 				return -EHWPOISON;
+			case -EFAULT: /* VM_FAULT_SIGBUS or VM_FAULT_SIGSEGV */
+				return -EFAULT;
 			default:
 				pr_warn_once("%s: unhandled return value: %ld\n",
 					     __func__, pages);
_

Patches currently in -mm which might be from david@redhat.com are

mm-madvise-report-sigbus-as-efault-for-madv_populate_readwrite.patch
memory-hotplugrst-remove-locking-details-from-admin-guide.patch
memory-hotplugrst-complete-admin-guide-overhaul.patch
mm-memory_hotplug-use-unsigned-long-for-pfn-in-zone_for_pfn_range.patch
mm-memory_hotplug-remove-nid-parameter-from-arch_remove_memory.patch
mm-memory_hotplug-remove-nid-parameter-from-remove_memory-and-friends.patch
acpi-memhotplug-memory-resources-cannot-be-enabled-yet.patch
mm-track-present-early-pages-per-zone.patch
mm-memory_hotplug-introduce-auto-movable-online-policy.patch
drivers-base-memory-introduce-memory-groups-to-logically-group-memory-blocks.patch
mm-memory_hotplug-track-present-pages-in-memory-groups.patch
acpi-memhotplug-use-a-single-static-memory-group-for-a-single-memory-device.patch
dax-kmem-use-a-single-static-memory-group-for-a-single-probed-unit.patch
virtio-mem-use-a-single-dynamic-memory-group-for-a-single-virtio-mem-device.patch
mm-memory_hotplug-memory-group-aware-auto-movable-online-policy.patch
mm-memory_hotplug-memory-group-aware-auto-movable-online-policy-fix.patch
mm-memory_hotplug-improved-dynamic-memory-group-aware-auto-movable-online-policy.patch

