Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8673EC0015E
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 20:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjHLU6L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 16:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjHLU6L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 16:58:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6381709
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 13:58:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD62B60F85
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 20:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8D8C433C7;
        Sat, 12 Aug 2023 20:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691873893;
        bh=Oh7FBS/lAHqhIZJSCSPkVcFaix+DYlR4vl3DsJwA3sc=;
        h=Date:To:From:Subject:From;
        b=LTC8j+vkGvkQ5iQLoXKC6O8AV3vWSJfxtX/UeLBEQR9U4KWUajFChUPbOhWCTsnmS
         3J6tgM5JmYqTZ9hwF4pobVbF9WLGlyos1Q5WUHUFJGjfgy4Nqm1+wPJ7CDZWLDMGLP
         c9pmNHsq5cAS4cglfg+ttFNQfkREMwsngB4DZqGU=
Date:   Sat, 12 Aug 2023 13:58:12 -0700
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
Subject: [folded-merged] drm-i915-move-abs_diff-to-mathh-fix-fix.patch removed from -mm tree
Message-Id: <20230812205813.2A8D8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: drm-i915-move-abs_diff-to-mathh-fix-fix
has been removed from the -mm tree.  Its filename was
     drm-i915-move-abs_diff-to-mathh-fix-fix.patch

This patch was dropped because it was folded into drm-i915-move-abs_diff-to-mathh.patch

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
acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch
mm-remove-redundant-k-macro-definition-fix.patch
drm-i915-move-abs_diff-to-mathh.patch
nmi_backtrace-allow-excluding-an-arbitrary-cpu-fix.patch

