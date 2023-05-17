Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FCD1C77B7A
	for <mm-commits@archiver.kernel.org>; Wed, 17 May 2023 20:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjEQUuI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 May 2023 16:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbjEQUuH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2023 16:50:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E34D9000
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 13:50:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D43FD60DD7
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 20:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3845EC4339B;
        Wed, 17 May 2023 20:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684356601;
        bh=SoCsicXwjlTGPp1OuT8KngCAWaDAD2sVTP/pqPWRUF0=;
        h=Date:To:From:Subject:From;
        b=o01BeZKp1OiCDAMrIyZb1KGUu/CPNnTgzq+/iKCeF57V5ZIX9kF27eOui8QDE6rFn
         nKE2LGS07AXhjAWdDshzkInI+PxbcrTPJNcU5N95BgSkvzvnSW642bo7wzU6HGnh4i
         b5H56/GfBgeTyAK9VUijEWhEWAat0w41DpEh02FE=
Date:   Wed, 17 May 2023 13:50:00 -0700
To:     mm-commits@vger.kernel.org, terrelln@fb.com, arnd@arndb.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + decompressor-provide-missing-prototypes.patch added to mm-hotfixes-unstable branch
Message-Id: <20230517205001.3845EC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: decompressor: provide missing prototypes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     decompressor-provide-missing-prototypes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/decompressor-provide-missing-prototypes.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Arnd Bergmann <arnd@arndb.de>
Subject: decompressor: provide missing prototypes
Date: Wed, 17 May 2023 15:19:31 +0200

The entry points for the decompressor don't always have a prototype
included in the .c file:

lib/decompress_inflate.c:42:17: error: no previous prototype for '__gunzip' [-Werror=missing-prototypes]
lib/decompress_unxz.c:251:17: error: no previous prototype for 'unxz' [-Werror=missing-prototypes]
lib/decompress_unzstd.c:331:17: error: no previous prototype for 'unzstd' [-Werror=missing-prototypes]

Include the correct headers for unxz and unzstd, and mark the inflate
function above as unconditionally 'static' to avoid these warnings.

Link: https://lkml.kernel.org/r/20230517131936.936840-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_inflate.c |    2 +-
 lib/decompress_unxz.c    |    2 ++
 lib/decompress_unzstd.c  |    2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/lib/decompress_inflate.c~decompressor-provide-missing-prototypes
+++ a/lib/decompress_inflate.c
@@ -39,7 +39,7 @@ static long INIT nofill(void *buffer, un
 }
 
 /* Included from initramfs et al code */
-STATIC int INIT __gunzip(unsigned char *buf, long len,
+static int INIT __gunzip(unsigned char *buf, long len,
 		       long (*fill)(void*, unsigned long),
 		       long (*flush)(void*, unsigned long),
 		       unsigned char *out_buf, long out_len,
--- a/lib/decompress_unxz.c~decompressor-provide-missing-prototypes
+++ a/lib/decompress_unxz.c
@@ -102,6 +102,8 @@
  */
 #ifdef STATIC
 #	define XZ_PREBOOT
+#else
+#include <linux/decompress/unxz.h>
 #endif
 #ifdef __KERNEL__
 #	include <linux/decompress/mm.h>
--- a/lib/decompress_unzstd.c~decompressor-provide-missing-prototypes
+++ a/lib/decompress_unzstd.c
@@ -69,6 +69,8 @@
 # define UNZSTD_PREBOOT
 # include "xxhash.c"
 # include "zstd/decompress_sources.h"
+#else
+#include <linux/decompress/unzstd.h>
 #endif
 
 #include <linux/decompress/mm.h>
_

Patches currently in -mm which might be from arnd@arndb.de are

radix-tree-move-declarations-to-header.patch
decompressor-provide-missing-prototypes.patch
kasan-add-kasan_tag_mismatch-prototype.patch
kasan-use-internal-prototypes-matching-gcc-13-builtins.patch

