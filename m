Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15077C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 21:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiDVVjJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 17:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiDVVjF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 17:39:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F993303F7F
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 13:44:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF423B83262
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 20:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B1FC385A4;
        Fri, 22 Apr 2022 20:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650659841;
        bh=5oILcxL/pzVpR3mWNpfGGOXX+saFAosutZNMEK66Xe8=;
        h=Date:To:From:Subject:From;
        b=Sq80pCN3Mpy44iNMixtKDN7vN5fVbMFXn7vLl+qU9yne39XPgPIxWwqp7iXQcYkRc
         5HDRLtZzf0LZ2u15/oDSOI+GmhbZmeBoFY7JoSZDDwALvsLOc2whKxQV5k6lev3aUz
         VKx3BMzTuw0IAgH/O445aQ65F/mVOmc6WBnKDGWo=
Date:   Fri, 22 Apr 2022 13:37:20 -0700
To:     mm-commits@vger.kernel.org, tvrtko.ursulin@linux.intel.com,
        rodrigo.vivi@intel.com, michal.winiarski@intel.com,
        matthew.d.roper@intel.com, matthew.auld@intel.com,
        joonas.lahtinen@linux.intel.com,
        janusz.krzysztofik@linux.intel.com, jani.nikula@linux.intel.com,
        daniel@ffwll.ch, andi.shyti@linux.intel.com, airlied@linux.ie,
        wangqing@vivo.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + gpu-drm-i915-use-time_is_after_jiffies-instead-of-open-coding-it.patch added to -mm tree
Message-Id: <20220422203721.70B1FC385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gpu: drm: i915: use time_is_after_jiffies() instead of open coding it
has been added to the -mm tree.  Its filename is
     gpu-drm-i915-use-time_is_after_jiffies-instead-of-open-coding-it.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/gpu-drm-i915-use-time_is_after_jiffies-instead-of-open-coding-it.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/gpu-drm-i915-use-time_is_after_jiffies-instead-of-open-coding-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Qing <wangqing@vivo.com>
Subject: gpu: drm: i915: use time_is_after_jiffies() instead of open coding it

Use the helper function time_is_{before,after}_jiffies() to improve code
readability.

Link: https://lkml.kernel.org/r/1650621172-66967-3-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: "Michał Winiarski" <michal.winiarski@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gt/intel_gt_buffer_pool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/intel_gt_buffer_pool.c~gpu-drm-i915-use-time_is_after_jiffies-instead-of-open-coding-it
+++ a/drivers/gpu/drm/i915/gt/intel_gt_buffer_pool.c
@@ -57,7 +57,7 @@ static bool pool_free_older_than(struct
 				node = list_entry(pos, typeof(*node), link);
 
 				age = READ_ONCE(node->age);
-				if (!age || jiffies - age < keep)
+				if (!age || time_is_after_jiffies(age + keep))
 					break;
 
 				/* Check we are the first to claim this node */
_

Patches currently in -mm which might be from wangqing@vivo.com are

block-xen-use-time_is_before_eq_jiffies-instead-of-open-coding-it.patch
gpu-drm-i915-use-time_is_after_jiffies-instead-of-open-coding-it.patch
gpu-drm-radeon-use-time_is_before_jiffies-instead-of-open-coding-it.patch
hid-use-time_is_after_jiffies-instead-of-open-coding-it.patch
md-use-time_is_before_eq_jiffies-instead-of-open-coding-it.patch
net-wireless-marvell-use-time_is_before_jiffies-instead-of-open-coding-it.patch
scsi-bfa-use-time_is_before_jiffies-instead-of-open-coding-it.patch
timekeeping-use-time_is_before_jiffies-instead-of-open-coding-it.patch
net-decnet-use-time_is_before_jiffies-instead-of-open-coding-it.patch

