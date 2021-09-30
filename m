Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD60CC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 22:33:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3EE961A51
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 22:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346103AbhI3Wfh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 18:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345719AbhI3Wfg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 18:35:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16955619E7;
        Thu, 30 Sep 2021 22:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633041233;
        bh=jJ031KhRcmsjdrlokUiO/1l58q2NIcxy6Euhqngn5EA=;
        h=Date:From:To:Subject:From;
        b=cbEqzC2Wy7COL3/vxkUInewTvAJMHiZV4m6yAS5EIPnupoJJMuo7PcPySXPRtUAHl
         4hbf7iHBuQPXEBjNVFUEmwcZDYixbxyoof+hIMGqOrjkDGy7K2t3XhYmrvqi2iKfV5
         /i53LrhXivzk7rlNkwRw4hOnoUdNuzsg8/G+ADJE=
Date:   Thu, 30 Sep 2021 15:33:52 -0700
From:   akpm@linux-foundation.org
To:     alexs@kernel.org, benh@kernel.crashing.org, bp@alien8.de,
        corbet@lwn.net, dave.hansen@linux.intel.com, david@redhat.com,
        gregkh@linuxfoundation.org, hpa@zytor.com, jasowang@redhat.com,
        luto@kernel.org, mhocko@suse.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, mst@redhat.com,
        osalvador@suse.de, paulus@samba.org, peterz@infradead.org,
        rafael@kernel.org, rppt@kernel.org, shuah@kernel.org,
        tglx@linutronix.de
Subject:  +
 mm-memory_hotplug-remove-stale-function-declarations.patch added to -mm
 tree
Message-ID: <20210930223352.C6XtDW5Da%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: remove stale function declarations
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-remove-stale-function-declarations.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-remove-stale-function-declarations.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-remove-stale-function-declarations.patch

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
Subject: mm/memory_hotplug: remove stale function declarations

These functions no longer exist.

Link: https://lkml.kernel.org/r/20210929143600.49379-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-remove-stale-function-declarations
+++ a/include/linux/memory_hotplug.h
@@ -98,9 +98,6 @@ static inline void zone_seqlock_init(str
 {
 	seqlock_init(&zone->span_seqlock);
 }
-extern int zone_grow_free_lists(struct zone *zone, unsigned long new_nr_pages);
-extern int zone_grow_waitqueues(struct zone *zone, unsigned long nr_pages);
-extern int add_one_highpage(struct page *page, int pfn, int bad_ppro);
 extern void adjust_present_page_count(struct page *page,
 				      struct memory_group *group,
 				      long nr_pages);
_

Patches currently in -mm which might be from david@redhat.com are

memory-hotplugrst-fix-two-instances-of-movablecore-that-should-be-movable_node.patch
memory-hotplugrst-fix-wrong-sys-module-memory_hotplug-parameters-path.patch
memory-hotplugrst-document-the-auto-movable-online-policy.patch
mm-memory_hotplug-remove-config_x86_64_acpi_numa-dependency-from-config_memory_hotplug.patch
mm-memory_hotplug-remove-config_memory_hotplug_sparse.patch
mm-memory_hotplug-restrict-config_memory_hotplug-to-64-bit.patch
mm-memory_hotplug-remove-highmem-leftovers.patch
mm-memory_hotplug-remove-stale-function-declarations.patch
x86-remove-memory-hotplug-support-on-x86_32.patch
kernel-resource-clean-up-and-optimize-iomem_is_exclusive.patch
kernel-resource-disallow-access-to-exclusive-system-ram-regions.patch
virtio-mem-disallow-mapping-virtio-mem-memory-via-dev-mem.patch

