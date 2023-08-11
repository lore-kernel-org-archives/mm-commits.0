Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68632C001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbjHKXBq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235592AbjHKXA1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF4D3A87
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EA036784A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C23C433C8;
        Fri, 11 Aug 2023 23:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794804;
        bh=j2Zxtwc0sSi8txPJIdACYkWwV2KbYAoJeehIirY/hP4=;
        h=Date:To:From:Subject:From;
        b=nP8/PehDqnEO1XlNPcYoPW8wW9uDZF7hhmmTrAPUNTfSh+aB6hKcuX9ny4pgKfM8A
         8c2b2npmMkV3PK8BckqDE2btOYHkm87VBm0BFuQ5n5yUj17Ry28e22nn9tnswGa3CK
         I/6pGqy/oLY1abpVQfjcyBQcfvFMQX8eR+yRRf/k=
Date:   Fri, 11 Aug 2023 16:00:04 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de, mhocko@suse.com,
        corbet@lwn.net, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-document-the-signal_pending-check-in-offline_pages.patch removed from -mm tree
Message-Id: <20230811230004.88C23C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memory_hotplug: document the signal_pending() check in offline_pages()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-document-the-signal_pending-check-in-offline_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: document the signal_pending() check in offline_pages()
Date: Tue, 11 Jul 2023 19:40:50 +0200

Let's update the documentation that any signal is sufficient, and add a
comment that not only checking for fatal signals is historical baggage:
changing it now could break existing user space.  although unlikely.

For example, when an app provides a custom SIGALRM handler and triggers
memory offlining, the timeout cmd would no longer stop memory offlining,
because SIGALRM would no longer be considered a fatal signal.

Note that using signal_pending() instead of fatal_signal_pending() is
an anti-pattern, but slowly deprecating that behavior to eventually
change it in the far future is probably not worth the effort.  If this
ever becomes relevant for user-space, we might want to rethink.

Link: https://lkml.kernel.org/r/20230711174050.603820-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/memory-hotplug.rst |    2 +-
 mm/memory_hotplug.c                             |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/memory-hotplug.rst~mm-memory_hotplug-document-the-signal_pending-check-in-offline_pages
+++ a/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -669,7 +669,7 @@ when still encountering permanently unmo
 (-> BUG), memory offlining will keep retrying until it eventually succeeds.
 
 When offlining is triggered from user space, the offlining context can be
-terminated by sending a fatal signal. A timeout based offlining can easily be
+terminated by sending a signal. A timeout based offlining can easily be
 implemented via::
 
 	% timeout $TIMEOUT offline_block | failure_handling
--- a/mm/memory_hotplug.c~mm-memory_hotplug-document-the-signal_pending-check-in-offline_pages
+++ a/mm/memory_hotplug.c
@@ -1843,6 +1843,11 @@ int __ref offline_pages(unsigned long st
 	do {
 		pfn = start_pfn;
 		do {
+			/*
+			 * Historically we always checked for any signal and
+			 * can't limit it to fatal signals without eventually
+			 * breaking user space.
+			 */
 			if (signal_pending(current)) {
 				ret = -EINTR;
 				reason = "signal backoff";
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-reintroduce-foll_numa-as-foll_honor_numa_fault.patch
smaps-use-vm_normal_page_pmd-instead-of-follow_trans_huge_pmd.patch
mm-gup-handle-cont-pte-hugetlb-pages-correctly-in-gup_must_unshare-via-gup-fast.patch
kvm-explicitly-set-foll_honor_numa_fault-in-hva_to_pfn_slow.patch
mm-gup-dont-implicitly-set-foll_honor_numa_fault.patch
pgtable-improve-pte_protnone-comment.patch
selftest-mm-ksm_functional_tests-test-in-mmap_and_merge_range-if-anything-got-merged.patch
selftest-mm-ksm_functional_tests-add-prot_none-test.patch
selftest-mm-ksm_functional_tests-add-prot_none-test-fix.patch

