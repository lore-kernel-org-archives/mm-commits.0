Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F361C8300C
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbjFIX1u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjFIX1V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4AE3580;
        Fri,  9 Jun 2023 16:27:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B8236169F;
        Fri,  9 Jun 2023 23:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6F1C433D2;
        Fri,  9 Jun 2023 23:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353239;
        bh=wcpgS4BhXxkkc0EnWiDsUM8T/ueNzlVaspWjGRhmh+c=;
        h=Date:To:From:Subject:From;
        b=ucoBK+kVi8jIjVIFF/r3MYYZRgdfWPfeCb3HhImKcd01rV/sMp3JICigd6sbhMzyg
         aTe8c811QDPJtN4njYxKYg61KndCmpyXVcTzl+9PPmaHDoIvaFhDTzLLPoqo1q2u0d
         XboKqC7BFIP2wcUO+KANXNWbwrP6naGkIRH3HODs=
Date:   Fri, 09 Jun 2023 16:27:19 -0700
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        stable@vger.kernel.org, ryabinin.a.a@gmail.com, glider@google.com,
        elver@google.com, dvyukov@google.com, andreyknvl@gmail.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-add-kasan_tag_mismatch-prototype.patch removed from -mm tree
Message-Id: <20230609232719.9F6F1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: add kasan_tag_mismatch prototype
has been removed from the -mm tree.  Its filename was
     kasan-add-kasan_tag_mismatch-prototype.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-percpu-unhide-pcpu_embed_first_chunk-prototype.patch
mm-page_poison-always-declare-__kernel_map_pages-function.patch
mm-sparse-mark-populate_section_memmap-static.patch
lib-devmem_is_allowed-include-linux-ioh.patch
locking-add-lockevent_read-prototype.patch
panic-hide-unused-global-functions.patch
panic-make-function-declarations-visible.patch
kunit-include-debugfs-header-file.patch
init-consolidate-prototypes-in-linux-inith.patch
init-move-cifs_root_data-prototype-into-linux-mounth.patch
thread_info-move-function-declarations-to-linux-thread_infoh.patch
time_namespace-always-provide-arch_get_vdso_data-prototype-for-vdso.patch
kcov-add-prototypes-for-helper-functions.patch
decompressor-provide-missing-prototypes.patch
syscalls-add-sys_ni_posix_timers-prototype.patch

