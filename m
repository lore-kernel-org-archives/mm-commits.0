Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660D7C67871
	for <mm-commits@archiver.kernel.org>; Tue, 25 Oct 2022 00:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiJYAFb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 20:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiJYAFM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 20:05:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F8E13E9C
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 15:22:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E834B80EE4
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 22:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA82CC433C1;
        Mon, 24 Oct 2022 22:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666650119;
        bh=Aeg7SmmzeNE3fvyc/UP5xFc7e7WvDSfhbl9PKqiHl+8=;
        h=Date:To:From:Subject:From;
        b=mpyirXdaLgEWu95LuAq+zcT9BblUPq552/lKg1MCn1YpomQIGP9rh6h7YioqPF6ha
         JevYavDtUrntTs5zI34SfEQigVWiPDxshdwyrq/WGD0HcnWWYHIFmkd2cIbv/6xX98
         /bCBGlKGB9/HcWvYUecUo+9ytjDFlhxyQY4QGaqg=
Date:   Mon, 24 Oct 2022 15:21:58 -0700
To:     mm-commits@vger.kernel.org, glider@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmsan-export-kmsan_copy_page_meta.patch added to mm-hotfixes-unstable branch
Message-Id: <20221024222159.BA82CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmsan: export kmsan_copy_page_meta()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kmsan-export-kmsan_copy_page_meta.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmsan-export-kmsan_copy_page_meta.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Alexander Potapenko <glider@google.com>
Subject: mm: kmsan: export kmsan_copy_page_meta()
Date: Mon, 24 Oct 2022 23:21:40 +0200

Certain modules call copy_user_highpage(), which calls
kmsan_copy_page_meta() under KMSAN, so we need to export the latter.

Link: https://lkml.kernel.org/r/20221024212144.2852069-1-glider@google.com
Link: https://github.com/google/kmsan/issues/89
Fixes: b073d7f8aee4 ("mm: kmsan: maintain KMSAN metadata for page operations")
Signed-off-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/shadow.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kmsan/shadow.c~mm-kmsan-export-kmsan_copy_page_meta
+++ a/mm/kmsan/shadow.c
@@ -167,6 +167,7 @@ void kmsan_copy_page_meta(struct page *d
 	__memcpy(origin_ptr_for(dst), origin_ptr_for(src), PAGE_SIZE);
 	kmsan_leave_runtime();
 }
+EXPORT_SYMBOL(kmsan_copy_page_meta);
 
 void kmsan_alloc_page(struct page *page, unsigned int order, gfp_t flags)
 {
_

Patches currently in -mm which might be from glider@google.com are

mm-kmsan-export-kmsan_copy_page_meta.patch
x86-purgatory-disable-kmsan-instrumentation.patch
kconfigdebug-disable-config_frame_warn-for-kmsan-by-default.patch
x86-asm-make-sure-__put_user_size-evaluates-pointer-once.patch
x86-fortify-kmsan-fix-kmsan-fortify-builds.patch

