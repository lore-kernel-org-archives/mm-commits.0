Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E213FC001DE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 17:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbjHDRLK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbjHDRKy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 13:10:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF03F5269
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 10:10:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F225620BC
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 17:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD288C433C8;
        Fri,  4 Aug 2023 17:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691169031;
        bh=mqHzbCYcPCZH0atVlNVuzJigRocTH/qbbYGIPFbpDV4=;
        h=Date:To:From:Subject:From;
        b=GWYeFyS8itjrB1jqYZLhBfoWOqdlrunWss2Rpl2tkC2i3DMCDGJXHS+FpKcSRiCEC
         sL7ZHg0iLkuRRgnx2OJdu1df3E3YmNMb4SEQJKd1SfTM1iba0IrHKIrZfzEasJtmLF
         tUThJeWfIxaiwLh9VL0/DTp0DmUwHlVgNfd5Yyrc=
Date:   Fri, 04 Aug 2023 10:10:31 -0700
To:     mm-commits@vger.kernel.org, tvrtko.ursulin@linux.intel.com,
        rodrigo.vivi@intel.com, rdunlap@infradead.org,
        p.zabel@pengutronix.de, linux@rasmusvillemoes.dk,
        joonas.lahtinen@linux.intel.com, jirislaby@kernel.org,
        jani.nikula@linux.intel.com, jani.nikula@intel.com,
        imre.deak@intel.com, gregkh@linuxfoundation.org, deller@gmx.de,
        daniel@ffwll.ch, andriy.shevchenko@linux.intel.com,
        andi.shyti@linux.intel.com, airlied@gmail.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-i915-move-abs_diff-to-mathh-fix-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230804171031.AD288C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm-i915-move-abs_diff-to-mathh-fix-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     drm-i915-move-abs_diff-to-mathh-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-i915-move-abs_diff-to-mathh-fix-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drm-i915-move-abs_diff-to-mathh-fix-fix
Date: Fri Aug  4 10:09:40 AM PDT 2023

fix comment, per Randy

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/math.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/math.h~drm-i915-move-abs_diff-to-mathh-fix-fix
+++ a/include/linux/math.h
@@ -160,7 +160,7 @@ __STRUCT_FRACT(u32)
  * @a: the first argument
  * @b: the second argument
  *
- * @a and @b has to be of the same type. With this restriction we compare
+ * @a and @b have to be of the same type. With this restriction we compare
  * signed to signed and unsigned to unsigned. The result is the subtraction
  * the smaller of the two from the bigger, hence result is always a positive
  * value.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
fs-buffer-clean-up-block_commit_write-fix.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
mm-make-pte_marker_swapin_error-more-general-fix.patch
mm-kfence-allocate-kfence_metadata-at-runtime-fix.patch
acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch
mm-mm_init-ignore-kernelcore=mirror-boot-option-when-no-mirror-memory-presents-fix.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch
drm-i915-move-abs_diff-to-mathh-fix-fix.patch

