Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E2DC87FDC
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjFJApo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbjFJAph (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BE63AAA
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6F3F651B5
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B86C433D2;
        Sat, 10 Jun 2023 00:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357929;
        bh=+A8BJniMqGFG076bNapobLDo+iZN6FQGPs3lCt1kjq4=;
        h=Date:To:From:Subject:From;
        b=Aeo7FBi8JfMs/Su5osx+af6xCla27vprQ6UWDEGZQcPKHk5w8mPhlgUTZw1Wp+ijl
         7AuoX73AQCp61jzArEa0TQS5zr9LxplDlxnAVFcPoyy842W+z4DoyhDYIQhSsfIw8L
         HuZ+fawXOPIDskWNcP+Kuggh18MqmISRdXpEGiYs=
Date:   Fri, 09 Jun 2023 17:45:28 -0700
To:     mm-commits@vger.kernel.org, terrelln@fb.com, arnd@arndb.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] decompressor-provide-missing-prototypes.patch removed from -mm tree
Message-Id: <20230610004529.38B86C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: decompressor: provide missing prototypes
has been removed from the -mm tree.  Its filename was
     decompressor-provide-missing-prototypes.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

syscalls-add-sys_ni_posix_timers-prototype.patch

