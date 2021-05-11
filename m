Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01C2DC433B4
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 00:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB8FC61613
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 00:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhEKAhW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 20:37:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230153AbhEKAhV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 20:37:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF78A61464;
        Tue, 11 May 2021 00:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620693376;
        bh=dyKarSDBfOLONuocDzI3ribY4O9ZiEgB9EO02Sfcdos=;
        h=Date:From:To:Subject:From;
        b=VyrZK8c3dkCRYD8o4/O0ST3k6WLYneo/DxfRqYT7Tov8iv4lw555vEycwWXAZ8J4q
         yeoeEz02G1EyOGki9G+pxDT/7IXZuai4Y4wgg/CXlwzFt2zgaCiy6ajPvJ9PwTmn5W
         +xLxoPQdWSFuaR0xjhKya71iuc3i9UOHHvBGu4qI=
Date:   Mon, 10 May 2021 17:36:15 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        osalvador@suse.de, songmuchun@bytedance.com
Subject:  +
 =?US-ASCII?Q?mm-memory=5Fhotplug-disable-memmap=5Fon=5Fmemory-when-hugetl?=
 =?US-ASCII?Q?b=5Ffree=5Fvmemmap-enabled-fix.patch?= added to -mm tree
Message-ID: <20210511003615.QIPkGw1eH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix

remove unneeded include, per Oscar

Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpi_memhotplug.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/acpi/acpi_memhotplug.c~mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -15,7 +15,6 @@
 #include <linux/acpi.h>
 #include <linux/memory.h>
 #include <linux/memory_hotplug.h>
-#include <linux/hugetlb.h>
 
 #include "internal.h"
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch

