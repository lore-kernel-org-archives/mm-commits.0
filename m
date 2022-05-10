Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED26EC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 18:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348917AbiEJS2i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 14:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244905AbiEJS2i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 14:28:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C4D546AE
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 11:28:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA00661B0D
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 18:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129E8C385A6;
        Tue, 10 May 2022 18:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652207316;
        bh=Ui9TBZ/DYufMqqRMx09tUx870D2IEmUSYaegkZc9rcY=;
        h=Date:To:From:Subject:From;
        b=nzphcx5BoEw8TEkmlNIPGN30yhLVGNhuQyldjZiAhVSOJR0Fpq/ht2MXLc/uFSCBH
         sAdXpO8XHLyzTzVZVA35CdggKUaCJkU1Tdui3CUCclFn+DQCLFst4C7VtYpjNdgErL
         GWveD94uo36VC27KnltlUoybSZHH97VLymU71EOY=
Date:   Tue, 10 May 2022 11:28:35 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-update-documentation-v2.patch added to mm-unstable branch
Message-Id: <20220510182836.129E8C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: update documentation
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-update-documentation-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-update-documentation-v2.patch

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
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: update documentation

rewording, per Marco

Link: https://lkml.kernel.org/r/896b2d914d6b50d677fd7b38f76967cc705c01ba.1652203271.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-update-documentation-v2
+++ a/Documentation/dev-tools/kasan.rst
@@ -453,11 +453,10 @@ for the current task, annotate this part
 ``kasan_disable_current()``/``kasan_enable_current()`` section. This also
 disables the reports for indirect accesses that happen through function calls.
 
-For tag-based KASAN modes (include the Hardware one), to disable access
-checking, use ``kasan_reset_tag()`` or ``page_kasan_tag_reset()``. Note that
-temporarily disabling access checking via ``page_kasan_tag_reset()`` requires
-saving and restoring the per-page KASAN tag via
-``page_kasan_tag``/``page_kasan_tag_set``.
+For tag-based KASAN modes, to disable access checking, use
+``kasan_reset_tag()`` or ``page_kasan_tag_reset()``. Note that temporarily
+disabling access checking via ``page_kasan_tag_reset()`` requires saving and
+restoring the per-page KASAN tag via ``page_kasan_tag``/``page_kasan_tag_set``.
 
 Tests
 ~~~~~
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-clean-up-comments-in-internal-kasanh.patch
kasan-use-tabs-to-align-shadow-values.patch
kasan-give-better-names-to-shadow-values.patch
kasan-update-documentation.patch
kasan-update-documentation-v2.patch
kasan-move-boot-parameters-section-in-documentation.patch
kasan-clean-up-kconfig-options-descriptions.patch

