Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 335E9C77B7C
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 23:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241176AbjELXvW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 19:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241009AbjELXuu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 19:50:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD872101;
        Fri, 12 May 2023 16:50:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 356FF65962;
        Fri, 12 May 2023 23:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A075C4339B;
        Fri, 12 May 2023 23:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683935441;
        bh=X94aduXp/FtLYskIEWmZMp9JZ9+9IWvfvmeia64//ek=;
        h=Date:To:From:Subject:From;
        b=n00bItGVZ1Ey7Wol7eXSdM0OYD9Ool2pheRbics2bkESEx+tTDefvd2OCv9tl/d12
         Ad1kJwOdK9H2Pfo/YPEicQ0gln0XFEIO1KYEchxc7DKJx5OdiNaYuoITN0tU+t1nQH
         8ZPUHmwfBZhZ5+cMAaxX1yYFIcu3bfFzrKpxGdT8=
Date:   Fri, 12 May 2023 16:50:40 -0700
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        stable@vger.kernel.org, ryabinin.a.a@gmail.com, glider@google.com,
        elver@google.com, dvyukov@google.com, andreyknvl@gmail.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-add-kasan_tag_mismatch-prototype.patch added to mm-unstable branch
Message-Id: <20230512235041.8A075C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add kasan_tag_mismatch prototype
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-add-kasan_tag_mismatch-prototype.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-add-kasan_tag_mismatch-prototype.patch

This patch will later appear in the mm-unstable branch at
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
Subject: kasan: add kasan_tag_mismatch prototype
Date: Tue, 9 May 2023 16:57:20 +0200

The kasan sw-tags implementation contains one function that is only called
from assembler and has no prototype in a header.  This causes a W=1
warning:

mm/kasan/sw_tags.c:171:6: warning: no previous prototype for 'kasan_tag_mismatch' [-Wmissing-prototypes]
  171 | void kasan_tag_mismatch(unsigned long addr, unsigned long access_info,

Add a prototype in the local header to get a clean build.

Link: https://lkml.kernel.org/r/20230509145735.9263-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/kasan/kasan.h~kasan-add-kasan_tag_mismatch-prototype
+++ a/mm/kasan/kasan.h
@@ -646,4 +646,7 @@ void *__hwasan_memset(void *addr, int c,
 void *__hwasan_memmove(void *dest, const void *src, size_t len);
 void *__hwasan_memcpy(void *dest, const void *src, size_t len);
 
+void kasan_tag_mismatch(unsigned long addr, unsigned long access_info,
+			unsigned long ret_ip);
+
 #endif /* __MM_KASAN_KASAN_H */
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-add-kasan_tag_mismatch-prototype.patch
kasan-use-internal-prototypes-matching-gcc-13-builtins.patch

