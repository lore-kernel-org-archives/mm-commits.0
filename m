Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D62FC7EE24
	for <mm-commits@archiver.kernel.org>; Mon,  5 Jun 2023 21:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjFEVrg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Jun 2023 17:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjFEVrf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2023 17:47:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B5A103
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 14:47:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19760622BC
        for <mm-commits@vger.kernel.org>; Mon,  5 Jun 2023 21:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F769C433EF;
        Mon,  5 Jun 2023 21:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686001653;
        bh=0qYJ6cqm7rJUcinpLfMXoX4gh4CX1S7fmoIIduZ2h7Q=;
        h=Date:To:From:Subject:From;
        b=GIZCaSH8XPRljTIqFxI9yVo7ITO4oynmZFT8I4dBDBRVzxxWv+12q+Wdoix1+KybF
         wLY0RRsXuA4QKL1dOyfBwEW+XxFporXN+lIIgEHUG9nUeX0wQhARn7Z/HmQhLcn33t
         FGjQYZGMvpNu9q8rRFBzxTEwmhGj2Dq9BJ1h1KLk=
Date:   Mon, 05 Jun 2023 14:47:32 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-unneeded-header-files.patch added to mm-unstable branch
Message-Id: <20230605214733.6F769C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: remove unneeded header files
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-unneeded-header-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-unneeded-header-files.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: page_alloc: remove unneeded header files
Date: Sat, 3 Jun 2023 19:25:58 +0800

Remove some unneeded header files. No functional change intended.

Link: https://lkml.kernel.org/r/20230603112558.213694-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-unneeded-header-files
+++ a/mm/page_alloc.c
@@ -26,7 +26,6 @@
 #include <linux/kmsan.h>
 #include <linux/module.h>
 #include <linux/suspend.h>
-#include <linux/pagevec.h>
 #include <linux/ratelimit.h>
 #include <linux/oom.h>
 #include <linux/topology.h>
@@ -36,8 +35,6 @@
 #include <linux/memory_hotplug.h>
 #include <linux/nodemask.h>
 #include <linux/vmstat.h>
-#include <linux/sort.h>
-#include <linux/pfn.h>
 #include <linux/fault-inject.h>
 #include <linux/compaction.h>
 #include <trace/events/kmem.h>
@@ -52,7 +49,6 @@
 #include <linux/memcontrol.h>
 #include <linux/ftrace.h>
 #include <linux/lockdep.h>
-#include <linux/nmi.h>
 #include <linux/psi.h>
 #include <linux/khugepaged.h>
 #include <linux/delayacct.h>
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-remove-obsolete-alloc_migrate_target.patch
mm-page_alloc-remove-unneeded-header-files.patch

