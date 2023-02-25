Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFBBC7EE30
	for <mm-commits@archiver.kernel.org>; Sat, 25 Feb 2023 21:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjBYVCq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Feb 2023 16:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBYVCp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 25 Feb 2023 16:02:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27B314EA4
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 13:02:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B2CB60B7B
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 21:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1C5C433EF;
        Sat, 25 Feb 2023 21:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677358963;
        bh=9i0JPWJtsT8HuXb8nsQUOgXmHOxtTzuObnJh4ecRpjI=;
        h=Date:To:From:Subject:From;
        b=TYfB+PHX1jJgwxBQnreLjXOWFq0o5FE1E6XFRM/LLgugMEDI2aBH/PvZWIufDNohD
         PYkojJPvWXo3sdmhDO7vN4YTM24DTkHJbml9m7aUIRi4J07UGyVUxpZActrt4A4eIB
         jdEah8HRLXuOBfjW6QIgKQAvA2BaEpVTSjWIip4c=
Date:   Sat, 25 Feb 2023 13:02:43 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, lkp@intel.com, keescook@chromium.org,
        halbuer@sra.uni-hannover.de, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch added to mm-unstable branch
Message-Id: <20230225210243.BF1C5C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix
Date: Sat Feb 25 01:00:30 PM PST 2023

make check_pages_enabled static

Reported-by: kernel test robot <lkp@intel.com>
  Link: https://lkml.kernel.org/r/63fa411f.ZvVOisJt5OlLzGYF%25lkp@intel.com
Cc: Alexander Halbuer <halbuer@sra.uni-hannover.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_alloc.c~mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix
+++ b/mm/page_alloc.c
@@ -254,7 +254,7 @@ DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_FREE_DEFAULT_ON, init_on_free);
 EXPORT_SYMBOL(init_on_free);
 
 /* perform sanity checks on struct pages being allocated or freed */
-DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
+static DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
 
 static bool _init_on_alloc_enabled_early __read_mostly
 				= IS_ENABLED(CONFIG_INIT_ON_ALLOC_DEFAULT_ON);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch

