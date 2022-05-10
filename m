Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CE1C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbiEJEUD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbiEJESa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:18:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08EE5BE42
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EA2C61753
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEAAC385A6;
        Tue, 10 May 2022 04:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156058;
        bh=zrOxxTWLX/ihdZDISBrxBGtxkhI3HikUmM4PTiwwbEE=;
        h=Date:To:From:Subject:From;
        b=amLvOiF5KWnLAGpDgVLiRuKdviV+njK+rVJm3WAXU/YqSfx1OhaJaIlC7bnYSqu3m
         f6PhTVK3+/bEgI2VwW/AYHN1tPcmCexUiJwEhVFIwfwMXOkW1Ktvl9Z/R6pffCP01B
         2yLeM3rvR562cs36Y9qCa2FyYCAF5/98eDxLSKOo=
Date:   Mon, 09 May 2022 21:14:18 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, lkp@intel.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@gmail.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-mark-kasan_vmalloc-flags-as-kasan_vmalloc_flags_t.patch removed from -mm tree
Message-Id: <20220510041418.AAEAAC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: mark KASAN_VMALLOC flags as kasan_vmalloc_flags_t
has been removed from the -mm tree.  Its filename was
     kasan-mark-kasan_vmalloc-flags-as-kasan_vmalloc_flags_t.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: mark KASAN_VMALLOC flags as kasan_vmalloc_flags_t

Fix sparse warning:

mm/kasan/shadow.c:496:15: warning: restricted kasan_vmalloc_flags_t degrades to integer

Link: https://lkml.kernel.org/r/52d8fccdd3a48d4bdfd0ff522553bac2a13f1579.1649351254.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/kasan.h~kasan-mark-kasan_vmalloc-flags-as-kasan_vmalloc_flags_t
+++ a/include/linux/kasan.h
@@ -23,10 +23,10 @@ struct task_struct;
 
 typedef unsigned int __bitwise kasan_vmalloc_flags_t;
 
-#define KASAN_VMALLOC_NONE		0x00u
-#define KASAN_VMALLOC_INIT		0x01u
-#define KASAN_VMALLOC_VM_ALLOC		0x02u
-#define KASAN_VMALLOC_PROT_NORMAL	0x04u
+#define KASAN_VMALLOC_NONE		((__force kasan_vmalloc_flags_t)0x00u)
+#define KASAN_VMALLOC_INIT		((__force kasan_vmalloc_flags_t)0x01u)
+#define KASAN_VMALLOC_VM_ALLOC		((__force kasan_vmalloc_flags_t)0x02u)
+#define KASAN_VMALLOC_PROT_NORMAL	((__force kasan_vmalloc_flags_t)0x04u)
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-clean-up-comments-in-internal-kasanh.patch
kasan-use-tabs-to-align-shadow-values.patch
kasan-give-better-names-to-shadow-values.patch
kasan-update-documentation.patch
kasan-move-boot-parameters-section-in-documentation.patch
kasan-clean-up-kconfig-options-descriptions.patch

