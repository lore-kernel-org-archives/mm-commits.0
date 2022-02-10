Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB93C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 10 Feb 2022 02:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbiBJCAB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Feb 2022 21:00:01 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234420AbiBJB7S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Feb 2022 20:59:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1B428CF5
        for <mm-commits@vger.kernel.org>; Wed,  9 Feb 2022 17:36:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 549B061206
        for <mm-commits@vger.kernel.org>; Thu, 10 Feb 2022 00:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A530FC340E7;
        Thu, 10 Feb 2022 00:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644452309;
        bh=9OxQrIoVmaITfKe+pto0dvjOFkVugQjL3BrCQ4cOak0=;
        h=Date:To:From:Subject:From;
        b=UF1l0W/VxBI01718wSsLrdXIGniEWlsgiGk9f542BqGLJTkSgjhVKO38zD26hhKL7
         zybq9B+7mRG3GwU0LmHxHVrKDjVU4DiLyV0AJ5muqG9YxMjIXRKQXvDKbLxeq+5Rd9
         5rAm00wDF6rdp3U3cwUUOQPXxhrKIKB8xhtO+WXo=
Date:   Wed, 09 Feb 2022 16:18:29 -0800
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        apopple@nvidia.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gupc-migrate-device-coherent-pages-when-pinning-instead-of-failing-fix.patch added to -mm tree
Message-Id: <20220210001829.A530FC340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: make migrate_device_page() fails always if !CONFIG_DEVICE_PRIVATE
has been added to the -mm tree.  Its filename is
     mm-gupc-migrate-device-coherent-pages-when-pinning-instead-of-failing-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gupc-migrate-device-coherent-pages-when-pinning-instead-of-failing-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gupc-migrate-device-coherent-pages-when-pinning-instead-of-failing-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/gup: make migrate_device_page() fails always if !CONFIG_DEVICE_PRIVATE

Commit 7059ac82be44 ("mm/gup.c: migrate device coherent pages when
pinning instead of failing") in -mm tree[1] introduces
'migrate_device_page()', which uses several functions that defined under
CONFIG_DEVICE_RIVATE.  As a result, build under 'CONFIG_MIGRATION &&
!CONFIG_DEVICE_PRIVATE' fails as below.

      LD      .tmp_vmlinux.kallsyms1
    mm/gup.o: In function `migrate_device_page':
    /linux/mm/gup.c:1856: undefined reference to `migrate_vma_setup'
    /linux/mm/gup.c:1876: undefined reference to `migrate_vma_pages'
    /linux/mm/gup.c:1879: undefined reference to `migrate_vma_finalize'
    /linux/Makefile:1222: recipe for target 'vmlinux' failed
    make[1]: *** [vmlinux] Error 1

This commit fixes it by implementing an always-failing version of the
function for !CONFIG_DEVICE_PRIVATE'.

[1] https://www.ozlabs.org/~akpm/mmotm/broken-out/mm-gupc-migrate-device-coherent-pages-when-pinning-instead-of-failing.patch

Link: https://lkml.kernel.org/r/20220209094158.21941-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/gup.c~mm-gupc-migrate-device-coherent-pages-when-pinning-instead-of-failing-fix
+++ a/mm/gup.c
@@ -1834,6 +1834,7 @@ struct page *get_dump_page(unsigned long
 #endif /* CONFIG_ELF_CORE */
 
 #ifdef CONFIG_MIGRATION
+#ifdef CONFIG_DEVICE_PRIVATE
 /*
  * Migrates a device coherent page back to normal memory. Caller should have a
  * reference on page which will be copied to the new page if migration is
@@ -1887,6 +1888,14 @@ static struct page *migrate_device_page(
 
 	return dpage;
 }
+#else
+static inline struct page *migrate_device_page(struct page *page,
+					unsigned int gup_flags)
+{
+	return NULL;
+}
+#endif /* CONFIG_DEVICE_PRIVATE */
+
 
 /*
  * Check whether all pages are pinnable, if so return number of pages.  If some
_

Patches currently in -mm which might be from sj@kernel.org are

mm-gupc-migrate-device-coherent-pages-when-pinning-instead-of-failing-fix.patch
mm-damon-dbgfs-init_regions-use-target-index-instead-of-target-id.patch
docs-admin-guide-mm-damon-usage-update-for-changed-initail_regions-file-input.patch
mm-damon-core-move-damon_set_targets-into-dbgfs.patch
mm-damon-remove-the-target-id-concept.patch

