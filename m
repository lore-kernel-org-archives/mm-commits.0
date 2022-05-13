Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97EF4C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 02:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357470AbiEMC76 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 22:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359323AbiEMC76 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 22:59:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089C92927A1
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 19:59:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97FF262158
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 02:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD8DC385B8;
        Fri, 13 May 2022 02:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652410796;
        bh=l1eONKQ8+MKZn+6ZnDwRn8Hp+NlFijRLYWsOUYOgtds=;
        h=Date:To:From:Subject:From;
        b=O9R+gmlMXR9A+ic3yzev844xkYWfHryKfv42ZH30NlMwhQr2bU9kSnrI/HhkYyBeF
         V0Zdv0QWvRS2zEwYfNtrEOlr4STk+NeOwwWxklcrJCyii8YeE4lcsHIzXBnt+XB4M8
         Ulu2N0zBTJ/eD3g3QpK8aPzq7UJIT51RIM8oyF40=
Date:   Thu, 12 May 2022 19:59:55 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-update-documentation-v2.patch removed from -mm tree
Message-Id: <20220513025955.EAD8DC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: update documentation
has been removed from the -mm tree.  Its filename was
     kasan-update-documentation-v2.patch

This patch was dropped because it was folded into kasan-update-documentation.patch

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
kasan-move-boot-parameters-section-in-documentation.patch
kasan-clean-up-kconfig-options-descriptions.patch

