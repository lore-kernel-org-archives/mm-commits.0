Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9460C77B7A
	for <mm-commits@archiver.kernel.org>; Tue, 16 May 2023 22:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjEPWXR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 May 2023 18:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbjEPWXJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2023 18:23:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363886A66
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 15:23:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 997DA63F27
        for <mm-commits@vger.kernel.org>; Tue, 16 May 2023 22:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00984C433D2;
        Tue, 16 May 2023 22:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684275781;
        bh=cs5O9b/ufDMxsq8bV8v4mHvN3RlBetctsbbgx76cx/s=;
        h=Date:To:From:Subject:From;
        b=GL+oIfk4U8NnVH7yIEOSW/kCcRrvr/p+bXlNwo0R+1+rWNCi+gxkHClDqcoMk0xx4
         YJo7Dsmn5YQTqM5DPCjv8AoyeGC339mvHvx9i3ck4bJ4+ulcq+tP8sdBe9VqU2kvm7
         vbv7+seqs9vWXv5X32NbLhgb6nTECgznkMVB3XCk=
Date:   Tue, 16 May 2023 15:23:00 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        ying.huang@intel.com, rppt@kernel.org, rafael@kernel.org,
        pavel@ucw.cz, osalvador@suse.de, mcgrof@kernel.org,
        len.brown@intel.com, keescook@chromium.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-move-is_check_pages_enabled-into-page_allocc.patch added to mm-unstable branch
Message-Id: <20230516222301.00984C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: move is_check_pages_enabled() into page_alloc.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-move-is_check_pages_enabled-into-page_allocc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-move-is_check_pages_enabled-into-page_allocc.patch

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

mm-memory_failure-move-memory_failure_attr_group-under-memory_failure.patch
mm-memory-failure-move-sysctl-register-in-memory_failure_init.patch
mm-page_alloc-move-mirrored_kernelcore-into-mm_initc.patch
mm-page_alloc-move-init_on_alloc-free-into-mm_initc.patch
mm-page_alloc-move-set_zone_contiguous-into-mm_initc.patch
mm-page_alloc-collect-mem-statistic-into-show_memc.patch
mm-page_alloc-squash-page_is_consistent.patch
mm-page_alloc-remove-alloc_contig_dump_pages-stub.patch
mm-page_alloc-split-out-fail_page_alloc.patch
mm-page_alloc-split-out-debug_pagealloc.patch
mm-page_alloc-move-mark_free_page-into-snapshotc.patch
mm-page_alloc-move-pm_-function-into-power.patch
mm-vmscan-use-gfp_has_io_fs.patch
mm-page_alloc-move-sysctls-into-it-own-fils.patch
mm-page_alloc-move-is_check_pages_enabled-into-page_allocc.patch

