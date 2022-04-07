Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96008C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  7 Apr 2022 21:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiDGVYo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Apr 2022 17:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbiDGVYn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2022 17:24:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3033176643
        for <mm-commits@vger.kernel.org>; Thu,  7 Apr 2022 14:22:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D5DF61FAE
        for <mm-commits@vger.kernel.org>; Thu,  7 Apr 2022 21:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81BAC385A0;
        Thu,  7 Apr 2022 21:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649366560;
        bh=UBjbuYsVfVzTo6x2iCSfLb9WsRQeyh8MUmxW5/CWPDU=;
        h=Date:To:From:Subject:From;
        b=eS8OIWm1mzs7TeCSqiG6gUsRANUSk0Om64XaJ/HPDeqaFjYmIGaDf0xctWFh/pK58
         58+QmJDy1J+mQt2hj5rQhRWdYtAH6pMYBOgqc19PWQAmxQ4wp1dYkaDgEN/oU6a1YX
         PVRQNNbAbLPEfERMYy2+asn+uJwUUwG6IpmrjkaA=
Date:   Thu, 07 Apr 2022 14:22:39 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, lkp@intel.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@gmail.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-mark-kasan_vmalloc-flags-as-kasan_vmalloc_flags_t.patch added to -mm tree
Message-Id: <20220407212240.A81BAC385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: mark KASAN_VMALLOC flags as kasan_vmalloc_flags_t
has been added to the -mm tree.  Its filename is
     kasan-mark-kasan_vmalloc-flags-as-kasan_vmalloc_flags_t.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kasan-mark-kasan_vmalloc-flags-as-kasan_vmalloc_flags_t.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kasan-mark-kasan_vmalloc-flags-as-kasan_vmalloc_flags_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kasan-mark-kasan_vmalloc-flags-as-kasan_vmalloc_flags_t.patch

