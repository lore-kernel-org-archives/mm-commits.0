Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FBEC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFC3A21744
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596779245;
	bh=nytIREH12tYH5V30eGU6EcEqUiVh9trWCCIgGdxphCE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=V7CI3GzDraSrBt1rlqWXS00h8utYP+gGMlpCGdcJ79S7/zWjYwOF6/tvIYj/N1i4c
	 i2vfLLzLLHtWDJyq4D74oo/3MQkiBw8ykaUcPa1nHhAe8mHLvhGb8L4zyF9qAG1f0P
	 xeooCWOHlCk081ofZWXEZQlNuEvLlyMTfTQdi6cQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgHGFrZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgHGFrZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:47:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BE9920866;
        Fri,  7 Aug 2020 05:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596779244;
        bh=nytIREH12tYH5V30eGU6EcEqUiVh9trWCCIgGdxphCE=;
        h=Date:From:To:Subject:From;
        b=M8Hz78cS2w87ucTUHBygOFu6xuerunmHNKUBw1oxoD1rxR/3RD9daw7n/qq+h3jm3
         b2HvbOwkUIR0N1o8rIPscjEim+poSWSt81xFZdD+TVH7aeYCzkWNiV0ojT6i5GFMlm
         ziadN+uqj5tTxhlvzW1/I7Y+XcbcMr+SjE56pUw8=
Date:   Thu, 06 Aug 2020 22:47:23 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        jannh@google.com, keescook@chromium.org, mjg59@google.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, rong.a.chen@intel.com, vbabka@suse.cz,
        vinmenon@codeaurora.org, vjitta@codeaurora.org
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-slab-slub-improve-error-reporting-and-overhead-of-cach?=
 =?US-ASCII?Q?e=5Ffrom=5Fobj-fix.patch?= removed from -mm tree
Message-ID: <20200807054723.uaglucOXY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slab/slub: improve error reporting and overhead of cache_from_obj()-fix
has been removed from the -mm tree.  Its filename was
     mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj-fix.patch

This patch was dropped because it was folded into mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slab/slub: improve error reporting and overhead of cache_from_obj()-fix

The added VM_WARN_ON_ONCE triggers [1] with CONFIG_SLAB, as
SLAB_DEBUG_FLAGS doesn't include SLAB_CONSISTENCY_CHECKS.  Move the check
under #ifdef SLUB_DEBUG.

[1] https://lore.kernel.org/r/20200623090213.GW5535@shao2-debian

Link: http://lkml.kernel.org/r/b33e0fa7-cd28-4788-9e54-5927846329ef@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: kernel test robot <rong.a.chen@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Garrett <mjg59@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab.h~mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj-fix
+++ a/mm/slab.h
@@ -296,8 +296,8 @@ static inline void print_tracking(struct
  */
 static inline bool kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t flags)
 {
-	VM_WARN_ON_ONCE(!(flags & SLAB_DEBUG_FLAGS));
 #ifdef CONFIG_SLUB_DEBUG
+	VM_WARN_ON_ONCE(!(flags & SLAB_DEBUG_FLAGS));
 	if (static_branch_unlikely(&slub_debug_enabled))
 		return s->flags & flags;
 #endif
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-extend-slub_debug-syntax-for-multiple-blocks.patch
mm-slub-make-some-slub_debug-related-attributes-read-only.patch
mm-slub-remove-runtime-allocation-order-changes.patch
mm-slub-make-remaining-slub_debug-related-attributes-read-only.patch
mm-slub-make-reclaim_account-attribute-read-only.patch
mm-slub-introduce-static-key-for-slub_debug.patch
mm-slub-introduce-kmem_cache_debug_flags.patch
mm-slub-extend-checks-guarded-by-slub_debug-static-key.patch
mm-slab-slub-move-and-improve-cache_from_obj.patch
mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj.patch
mm-page_alloc-use-unlikely-in-task_capc.patch

