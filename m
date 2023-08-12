Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F66C0015E
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 20:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjHLU6J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 16:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjHLU6I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 16:58:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9D21709
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 13:58:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 758BB60ADD
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 20:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED4EC433C8;
        Sat, 12 Aug 2023 20:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691873890;
        bh=P+x5RlBj7hyEjytFNkRAbJniyTANKMkGYuWX/tcvfgI=;
        h=Date:To:From:Subject:From;
        b=A826RzmwEPC4HyflRsuLFeerqkPEH/hYSGSdMqsGmwR7F/cIrvDOGCr5gm8TXBkHr
         xWcaGlPcb64VcFUK/czhYYXBvguUfSggrfmlrxDBts8EEuelSimYp5xRk/E9hcb3IY
         uWhmEGrLpzmpUbu6JiHS6EHjGhqWD8uObcmeU9Ls=
Date:   Sat, 12 Aug 2023 13:58:09 -0700
To:     mm-commits@vger.kernel.org, tvrtko.ursulin@linux.intel.com,
        rodrigo.vivi@intel.com, rdunlap@infradead.org,
        p.zabel@pengutronix.de, linux@rasmusvillemoes.dk,
        joonas.lahtinen@linux.intel.com, jirislaby@kernel.org,
        jani.nikula@linux.intel.com, jani.nikula@intel.com,
        imre.deak@intel.com, gregkh@linuxfoundation.org, deller@gmx.de,
        daniel@ffwll.ch, andi.shyti@linux.intel.com,
        akpm@linux-foundation.org, airlied@gmail.com, adobriyan@gmail.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] drm-i915-move-abs_diff-to-mathh-fix.patch removed from -mm tree
Message-Id: <20230812205810.BED4EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: math.h: document abs_diff()
has been removed from the -mm tree.  Its filename was
     drm-i915-move-abs_diff-to-mathh-fix.patch

This patch was dropped because it was folded into drm-i915-move-abs_diff-to-mathh.patch

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: math.h: document abs_diff()
Date: Fri, 4 Aug 2023 08:09:34 +0300

Initially abs_diff() has lack of documentation. Add it.

Link: https://lkml.kernel.org/r/20230804050934.83223-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
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

 include/linux/math.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/include/linux/math.h~drm-i915-move-abs_diff-to-mathh-fix
+++ a/include/linux/math.h
@@ -155,6 +155,18 @@ __STRUCT_FRACT(u32)
 	__builtin_types_compatible_p(typeof(x), unsigned type),		\
 	({ signed type __x = (x); __x < 0 ? -__x : __x; }), other)
 
+/**
+ * abs_diff - return absolute value of the difference between the arguments
+ * @a: the first argument
+ * @b: the second argument
+ *
+ * @a and @b has to be of the same type. With this restriction we compare
+ * signed to signed and unsigned to unsigned. The result is the subtraction
+ * the smaller of the two from the bigger, hence result is always a positive
+ * value.
+ *
+ * Return: an absolute value of the difference between the @a and @b.
+ */
 #define abs_diff(a, b) ({			\
 	typeof(a) __a = (a);			\
 	typeof(b) __b = (b);			\
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

kernelh-split-out-count_args-and-concatenate-to-argsh.patch
x86-asm-replace-custom-count_args-concatenate-implementations.patch
arm64-smccc-replace-custom-count_args-concatenate-implementations.patch
genetlink-replace-custom-concatenate-implementation.patch
drm-i915-move-abs_diff-to-mathh.patch
rangeh-move-resource-api-and-constant-to-respective-files.patch

