Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F8CC38A2D
	for <mm-commits@archiver.kernel.org>; Tue, 25 Oct 2022 00:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJYAwB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 20:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiJYAvo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 20:51:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62179160232
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 16:32:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 890BA6162C
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 23:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D294FC433C1;
        Mon, 24 Oct 2022 23:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666654328;
        bh=uiOXgiNkw8iHxD4S3GjXOGINJ8B6yz5PYvHe64ybJj8=;
        h=Date:To:From:Subject:From;
        b=DviZJ7QoKed7Nf6H8NQwZs3U/gC8g+b8fGEAn1X/xOBv/ZlRTDln+wXLNBdlGRbqC
         SMEZXZS2Jx8zQXNGjYA+MJ7WLf+TlUojXUC1Mn6w/jlHT0oYvMupfpuAKjGCSCijsF
         zD0SiVK0+1Yj6iEpu1JhxN+KImmvDC+Hk3wejSf8=
Date:   Mon, 24 Oct 2022 16:32:08 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-size-class-equals-check-into-recompression-fix.patch added to mm-unstable branch
Message-Id: <20221024233208.D294FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram-add-size-class-equals-check-into-recompression-fix
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-size-class-equals-check-into-recompression-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-size-class-equals-check-into-recompression-fix.patch

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
Subject: zram-add-size-class-equals-check-into-recompression-fix
Date: Mon Oct 24 04:30:52 PM PDT 2022

fix it for "zsmalloc: turn zspage order into runtime variable".

Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/zsmalloc.c~zram-add-size-class-equals-check-into-recompression-fix
+++ a/mm/zsmalloc.c
@@ -1223,7 +1223,9 @@ static bool zspage_full(struct size_clas
  */
 unsigned int zs_get_class_size(struct zs_pool *pool, unsigned int size)
 {
-	struct size_class *class = pool->size_class[get_size_class_index(size)];
+	struct size_class *class;
+
+	class = pool->size_class[get_size_class_index(pool, size)];
 
 	return class->size;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ipc-msgc-fix-percpu_counter-use-after-free.patch
fs-ext4-superc-remove-unused-deprecated_msg.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-hugetlb-convert-free_huge_page-to-folios-fix.patch
vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-gup-remove-foll_migration-fix.patch
zram-add-size-class-equals-check-into-recompression-fix.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

