Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE559C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbjFIX3G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbjFIX2H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761573C17
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10AA865CF1
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1F6C433D2;
        Fri,  9 Jun 2023 23:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353271;
        bh=hdLUZmQQx6Mi38csvuFSRtNkUJq+zUaof/mF7XlRZoY=;
        h=Date:To:From:Subject:From;
        b=u6i8gb/0fE5aGfnz6iUik8N/hMXC0+qUdOSunPP+8Tga+znLqRMCXRDqNgR5CT38D
         6z3oJ8y7tiKcf6/v7KH6Oz/LxqgZrymk2CpqLk2FbLw3bAJ4FLL3pJx2a/H/MAhfvr
         rwbXCOykL2MZ5ZmV0WTWBle7pTcdhycMFWiLQvQA=
Date:   Fri, 09 Jun 2023 16:27:50 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        ying.huang@intel.com, rppt@kernel.org, rafael@kernel.org,
        pavel@ucw.cz, osalvador@suse.de, mcgrof@kernel.org,
        len.brown@intel.com, keescook@chromium.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-move-is_check_pages_enabled-into-page_allocc.patch removed from -mm tree
Message-Id: <20230609232751.5E1F6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: move is_check_pages_enabled() into page_alloc.c
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-is_check_pages_enabled-into-page_allocc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page_alloc: move is_check_pages_enabled() into page_alloc.c
Date: Tue, 16 May 2023 14:38:21 +0800

The is_check_pages_enabled() only used in page_alloc.c, move it into
page_alloc.c, also use it in free_tail_page_prepare().

Link: https://lkml.kernel.org/r/20230516063821.121844-14-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    5 -----
 mm/page_alloc.c |    7 ++++++-
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/internal.h~mm-page_alloc-move-is_check_pages_enabled-into-page_allocc
+++ a/mm/internal.h
@@ -208,11 +208,6 @@ extern char * const zone_names[MAX_NR_ZO
 /* perform sanity checks on struct pages being allocated or freed */
 DECLARE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
 
-static inline bool is_check_pages_enabled(void)
-{
-	return static_branch_unlikely(&check_pages_enabled);
-}
-
 extern int min_free_kbytes;
 
 void setup_per_zone_wmarks(void);
--- a/mm/page_alloc.c~mm-page_alloc-move-is_check_pages_enabled-into-page_allocc
+++ a/mm/page_alloc.c
@@ -983,6 +983,11 @@ static inline bool free_page_is_bad(stru
 	return true;
 }
 
+static inline bool is_check_pages_enabled(void)
+{
+	return static_branch_unlikely(&check_pages_enabled);
+}
+
 static int free_tail_page_prepare(struct page *head_page, struct page *page)
 {
 	struct folio *folio = (struct folio *)head_page;
@@ -994,7 +999,7 @@ static int free_tail_page_prepare(struct
 	 */
 	BUILD_BUG_ON((unsigned long)LIST_POISON1 & 1);
 
-	if (!static_branch_unlikely(&check_pages_enabled)) {
+	if (!is_check_pages_enabled()) {
 		ret = 0;
 		goto out;
 	}
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


