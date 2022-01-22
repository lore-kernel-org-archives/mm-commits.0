Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8791BC433FE
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbiAVGOg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbiAVGOf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:14:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B977EC06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:14:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80568B82100
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7DCC004E1;
        Sat, 22 Jan 2022 06:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832072;
        bh=vk/WCRVUJd+XseqasCnM09H5je/SZYYhZZ+X9RJbT8g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EVIFVCNZydbVMDLudZx8d7on0XGEMQouFrbXY+Sv33x3yu7GJL0HBasKkneMzEka5
         MqZU7TtZd1OBhtnvU/5ZquFsnoGWF+PSNOkWbJZ6v76DCCJz0PPKyjjJQkwHSBrtBU
         dt9uzeBZLH27zgP2lD0C+mFCzxT3dl4hJUF6NVJA=
Date:   Fri, 21 Jan 2022 22:14:31 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        chris@chris-wilson.co.uk, dvyukov@google.com, elver@google.com,
        glider@google.com, gustavoars@kernel.org, imran.f.khan@oracle.com,
        jani.nikula@intel.com, linux-mm@kvack.org,
        mika.kuoppala@linux.intel.com, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, torvalds@linux-foundation.org,
        vbabka@suse.cz, vjitta@codeaurora.org
Subject:  [patch 56/69] lib/stackdepot: always do
 filter_irq_stacks() in stack_depot_save()
Message-ID: <20220122061431.v8uZXLZ1J%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: lib/stackdepot: always do filter_irq_stacks() in stack_depot_save()

The non-interrupt portion of interrupt stack traces before interrupt entry
is usually arbitrary.  Therefore, saving stack traces of interrupts (that
include entries before interrupt entry) to stack depot leads to unbounded
stackdepot growth.

As such, use of filter_irq_stacks() is a requirement to ensure stackdepot
can efficiently deduplicate interrupt stacks.

Looking through all current users of stack_depot_save(), none (except
KASAN) pass the stack trace through filter_irq_stacks() before passing it
on to stack_depot_save().

Rather than adding filter_irq_stacks() to all current users of
stack_depot_save(), it became clear that stack_depot_save() should simply
do filter_irq_stacks().

Link: https://lkml.kernel.org/r/20211130095727.2378739-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c  |   13 +++++++++++++
 mm/kasan/common.c |    1 -
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/lib/stackdepot.c~lib-stackdepot-always-do-filter_irq_stacks-in-stack_depot_save
+++ a/lib/stackdepot.c
@@ -328,6 +328,9 @@ EXPORT_SYMBOL_GPL(stack_depot_fetch);
  * (allocates using GFP flags of @alloc_flags). If @can_alloc is %false, avoids
  * any allocations and will fail if no space is left to store the stack trace.
  *
+ * If the stack trace in @entries is from an interrupt, only the portion up to
+ * interrupt entry is saved.
+ *
  * Context: Any context, but setting @can_alloc to %false is required if
  *          alloc_pages() cannot be used from the current context. Currently
  *          this is the case from contexts where neither %GFP_ATOMIC nor
@@ -346,6 +349,16 @@ depot_stack_handle_t __stack_depot_save(
 	unsigned long flags;
 	u32 hash;
 
+	/*
+	 * If this stack trace is from an interrupt, including anything before
+	 * interrupt entry usually leads to unbounded stackdepot growth.
+	 *
+	 * Because use of filter_irq_stacks() is a requirement to ensure
+	 * stackdepot can efficiently deduplicate interrupt stacks, always
+	 * filter_irq_stacks() to simplify all callers' use of stackdepot.
+	 */
+	nr_entries = filter_irq_stacks(entries, nr_entries);
+
 	if (unlikely(nr_entries == 0) || stack_depot_disable)
 		goto fast_exit;
 
--- a/mm/kasan/common.c~lib-stackdepot-always-do-filter_irq_stacks-in-stack_depot_save
+++ a/mm/kasan/common.c
@@ -36,7 +36,6 @@ depot_stack_handle_t kasan_save_stack(gf
 	unsigned int nr_entries;
 
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 0);
-	nr_entries = filter_irq_stacks(entries, nr_entries);
 	return __stack_depot_save(entries, nr_entries, flags, can_alloc);
 }
 
_
