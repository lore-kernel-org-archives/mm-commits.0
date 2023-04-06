Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C4FAC77B71
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbjDFCpH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234960AbjDFCoe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0591D8A63
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB1BE64272
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E0BC433D2;
        Thu,  6 Apr 2023 02:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749073;
        bh=3WlgMCdcVbqNuZ68BkBeln5t/YcTjS7+5xXgMpNz2pk=;
        h=Date:To:From:Subject:From;
        b=Ltn3z0+f2lxgPYjSxtg5B+wZPe3k7p5I6VwNxN2Iag06qQp0g9A4MU8YXIMefud63
         C8zqIpLzjTyiDph/4oUe0tgnN9wdEE+ynnHgyqORzHR+83ZjlzvrRkIooo7MhPZb5n
         R9rECJ/lcx9EE2uRgWcQrwGueAjjzeExPsFT7syY=
Date:   Wed, 05 Apr 2023 19:44:32 -0700
To:     mm-commits@vger.kernel.org, tvrtko.ursulin@intel.com,
        rodrigo.vivi@intel.com, joonas.lahtinen@linux.intel.com,
        jani.nikula@linux.intel.com, kirill.shutemov@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drm-i915-fix-max_order-usage-in-i915_gem_object_get_pages_internal.patch removed from -mm tree
Message-Id: <20230406024433.41E0BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: drm/i915: fix MAX_ORDER usage in i915_gem_object_get_pages_internal()
has been removed from the -mm tree.  Its filename was
     drm-i915-fix-max_order-usage-in-i915_gem_object_get_pages_internal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: drm/i915: fix MAX_ORDER usage in i915_gem_object_get_pages_internal()
Date: Wed, 15 Mar 2023 14:31:27 +0300

MAX_ORDER is not inclusive: the maximum allocation order buddy allocator
can deliver is MAX_ORDER-1.

Fix MAX_ORDER usage in i915_gem_object_get_pages_internal().

Link: https://lkml.kernel.org/r/20230315113133.11326-5-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/i915_gem_internal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_internal.c~drm-i915-fix-max_order-usage-in-i915_gem_object_get_pages_internal
+++ a/drivers/gpu/drm/i915/gem/i915_gem_internal.c
@@ -36,7 +36,7 @@ static int i915_gem_object_get_pages_int
 	struct sg_table *st;
 	struct scatterlist *sg;
 	unsigned int npages; /* restricted by sg_alloc_table */
-	int max_order = MAX_ORDER;
+	int max_order = MAX_ORDER - 1;
 	unsigned int max_segment;
 	gfp_t gfp;
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


