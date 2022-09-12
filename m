Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B23ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 00:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiILAno (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 20:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiILAno (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 20:43:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F78927CE5
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 17:43:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 301676115B
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 00:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82176C433D6;
        Mon, 12 Sep 2022 00:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662943422;
        bh=i7bHLpw0KUZJ2T7ePVzx+EO41ZlTkSEuSsSTY3a0CDY=;
        h=Date:To:From:Subject:From;
        b=I1aLxA6/t31IEbBSaiVv73xGeGOXoTW9JmfU24krXMtyn4UEY4n6y07IMeuc3o48r
         /FkEKdFB+QJqOjbUDSmOH+ifcW01Pi2+3b02oX1hCvLNwvB/vSaM3Yqmb6SQsgRdK6
         7p8ufn5PcjtgQXZKUNOqHgoZ4yN2vWLV/D1TgH7c=
Date:   Sun, 11 Sep 2022 17:43:41 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rostedt@goodmis.org,
        mhocko@suse.com, mhiramat@kernel.org, mark-pk.tsai@mediatek.com,
        lizhe.67@bytedance.com, keescook@chromium.org, Jason@zx2c4.com,
        corbet@lwn.net, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] page_ext-introduce-boot-parameter-early_page_ext-fix.patch removed from -mm tree
Message-Id: <20220912004342.82176C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: page_ext-introduce-boot-parameter-early_page_ext-fix
has been removed from the -mm tree.  Its filename was
     page_ext-introduce-boot-parameter-early_page_ext-fix.patch

This patch was dropped because it was folded into page_ext-introduce-boot-parameter-early_page_ext.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: page_ext-introduce-boot-parameter-early_page_ext-fix
Date: Thu Aug 25 09:17:22 PM PDT 2022

fix section issue by removing __meminitdata

Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_ext.c~page_ext-introduce-boot-parameter-early_page_ext-fix
+++ a/mm/page_ext.c
@@ -91,7 +91,7 @@ unsigned long page_ext_size = sizeof(str
 static unsigned long total_usage;
 static struct page_ext *lookup_page_ext(const struct page *page);
 
-bool early_page_ext __meminitdata;
+bool early_page_ext;
 static int __init setup_early_page_ext(char *str)
 {
 	early_page_ext = true;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

page_ext-introduce-boot-parameter-early_page_ext.patch
mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
swap-add-swap_cache_get_folio-fix.patch
memcg-reduce-size-of-memcg-vmstats-structures-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch
fs-uninline-inode_maybe_inc_iversion.patch

