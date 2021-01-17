Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C45E4C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 20:00:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96C7F224D3
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 20:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730193AbhAQUAa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 15:00:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730181AbhAQUA3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 15:00:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8C7322516;
        Sun, 17 Jan 2021 19:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610913572;
        bh=/FXTlmwpWL9s4tRk+rm9FYPQmo0Rnu8q4xwZIlEO03I=;
        h=Date:From:To:Subject:From;
        b=yuhga6LV1G2hPSGMRfMu9npmmZvmAQ1ZC6xLmBbKzqZhEUXt4G6DYkbBhQc0vipzp
         yec5ntwcPOfyPVIYof1PflkvOZhL0KZE+5GqRGcemSUsaBqMcKmCZ8SrHfKCf02uXd
         IvQ1BaRIHYHuamGB3vTR70J/JO+3mEUPj36WFZNo=
Date:   Sun, 17 Jan 2021 11:59:30 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, kevin.brodsky@arm.com,
        lkp@intel.com, mm-commits@vger.kernel.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [to-be-updated]
 kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix.patch removed from
 -mm tree
Message-ID: <20210117195930._22VslLBn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix
has been removed from the -mm tree.  Its filename was
     kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix

fix kasan_check_byte() return

Reported-by: kernel test robot <lkp@intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/kasan.h~kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix
+++ a/include/linux/kasan.h
@@ -315,7 +315,10 @@ static inline void *kasan_krealloc(const
 	return (void *)object;
 }
 static inline void kasan_kfree_large(void *ptr, unsigned long ip) {}
-static inline bool kasan_check_byte(const void *address, unsigned long ip) {}
+static inline bool kasan_check_byte(const void *address, unsigned long ip)
+{
+	return true;
+}
 
 #endif /* CONFIG_KASAN */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
mm-compaction-return-proper-state-in-should_proactive_compact_node-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
linux-next-git-rejects.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

