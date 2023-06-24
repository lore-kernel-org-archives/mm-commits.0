Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0D7EB64D7
	for <mm-commits@archiver.kernel.org>; Sat, 24 Jun 2023 00:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbjFXABB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jun 2023 20:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbjFXAAe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2023 20:00:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7081E272A
        for <mm-commits@vger.kernel.org>; Fri, 23 Jun 2023 17:00:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52FB8615DE
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 00:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA192C433C8;
        Sat, 24 Jun 2023 00:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687564828;
        bh=UHqRNlDQrlP8qbDXQBsVVe301SpMwXi0O2UtYzcZYIk=;
        h=Date:To:From:Subject:From;
        b=z6No2HgYU6+2BW9eRw1ljcYJbFnUl9PeUop/OsZ0Kbd1pT25oLJ6TQmG4p4uJDKIU
         33YyoGJw/2naEubPA60SvSS/6q7O+y+RTlZPuo0UStQgeXnmcRLEB9esDVWbvYDAn1
         GvXYdxl27sSI6VWAO/bJw6DYA2qLOfktFWxsDDFU=
Date:   Fri, 23 Jun 2023 17:00:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unnecessary-pagevec-includes.patch removed from -mm tree
Message-Id: <20230624000028.AA192C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove unnecessary pagevec includes
has been removed from the -mm tree.  Its filename was
     mm-remove-unnecessary-pagevec-includes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove unnecessary pagevec includes
Date: Wed, 21 Jun 2023 17:45:57 +0100

These files no longer need pagevec.h, mostly due to function declarations
being moved out of it.

Link: https://lkml.kernel.org/r/20230621164557.3510324-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c        |    1 -
 mm/memory_hotplug.c |    1 -
 mm/migrate.c        |    1 -
 mm/readahead.c      |    1 -
 mm/swap_state.c     |    1 -
 5 files changed, 5 deletions(-)

--- a/mm/fadvise.c~mm-remove-unnecessary-pagevec-includes
+++ a/mm/fadvise.c
@@ -14,7 +14,6 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/backing-dev.h>
-#include <linux/pagevec.h>
 #include <linux/fadvise.h>
 #include <linux/writeback.h>
 #include <linux/syscalls.h>
--- a/mm/memory_hotplug.c~mm-remove-unnecessary-pagevec-includes
+++ a/mm/memory_hotplug.c
@@ -13,7 +13,6 @@
 #include <linux/pagemap.h>
 #include <linux/compiler.h>
 #include <linux/export.h>
-#include <linux/pagevec.h>
 #include <linux/writeback.h>
 #include <linux/slab.h>
 #include <linux/sysctl.h>
--- a/mm/migrate.c~mm-remove-unnecessary-pagevec-includes
+++ a/mm/migrate.c
@@ -21,7 +21,6 @@
 #include <linux/buffer_head.h>
 #include <linux/mm_inline.h>
 #include <linux/nsproxy.h>
-#include <linux/pagevec.h>
 #include <linux/ksm.h>
 #include <linux/rmap.h>
 #include <linux/topology.h>
--- a/mm/readahead.c~mm-remove-unnecessary-pagevec-includes
+++ a/mm/readahead.c
@@ -120,7 +120,6 @@
 #include <linux/export.h>
 #include <linux/backing-dev.h>
 #include <linux/task_io_accounting_ops.h>
-#include <linux/pagevec.h>
 #include <linux/pagemap.h>
 #include <linux/psi.h>
 #include <linux/syscalls.h>
--- a/mm/swap_state.c~mm-remove-unnecessary-pagevec-includes
+++ a/mm/swap_state.c
@@ -16,7 +16,6 @@
 #include <linux/pagemap.h>
 #include <linux/backing-dev.h>
 #include <linux/blkdev.h>
-#include <linux/pagevec.h>
 #include <linux/migrate.h>
 #include <linux/vmalloc.h>
 #include <linux/swap_slots.h>
_

Patches currently in -mm which might be from willy@infradead.org are


