Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62CC8C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 22:10:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 363C561433
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 22:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbhEMWLM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 18:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhEMWLM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 18:11:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C05D16142E;
        Thu, 13 May 2021 22:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620943801;
        bh=IQRY23szBt+R5qB7IuH6l1yiXpN0BFYLPf6WkYLjncQ=;
        h=Date:From:To:Subject:From;
        b=KjFDJJBPI1SFWkoxG7JnzzXjqcmedRrIlMaDhT1ZOXjF7wNAjXPAqxgWuqD688due
         5BsKyNGcollNKlGkJ8nxi9ATEjA1HwUVoxo20I6zZTO5FbRp9P8KRsgqnw5OKtzYCN
         Mz6de5api18whzRYMqiPNTBDQRWpd8wKbBC6jUM8=
Date:   Thu, 13 May 2021 15:10:01 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        yury.norov@gmail.com
Subject:  [to-be-updated]
 secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch removed from
 -mm tree
Message-ID: <20210513221001.Oon-8-QxS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memfd_secret: use unsigned int rather than long as syscall flags type
has been removed from the -mm tree.  Its filename was
     secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: memfd_secret: use unsigned int rather than long as syscall flags type

Yuri Norov says:

  If parameter size is the same for native and compat ABIs, we may
  wire a syscall made by compat client to native handler. This is
  true for unsigned int, but not true for unsigned long or pointer.

  That's why I suggest using unsigned int and so avoid creating compat
  entry point.

Use unsigned int as the type of the flags parameter in memfd_secret()
system call.

Link: https://lkml.kernel.org/r/20210331142345.27532-1-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/memfd_secret.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/memfd_secret.c~secretmem-test-add-basic-selftest-for-memfd_secret2-fix
+++ a/tools/testing/selftests/vm/memfd_secret.c
@@ -38,7 +38,7 @@ static unsigned long page_size;
 static unsigned long mlock_limit_cur;
 static unsigned long mlock_limit_max;
 
-static int memfd_secret(unsigned long flags)
+static int memfd_secret(unsigned int flags)
 {
 	return syscall(__NR_memfd_secret, flags);
 }
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-mmzoneh-simplify-is_highmem_idx.patch
docs-procrst-meminfo-briefly-describe-gaps-in-memory-accounting.patch
include-linux-mmzoneh-add-documentation-for-pfn_valid.patch
memblock-update-initialization-of-reserved-pages.patch
arm64-decouple-check-whether-pfn-is-in-linear-map-from-pfn_valid.patch
arm64-drop-pfn_valid_within-and-simplify-pfn_valid.patch
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-2.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix-3.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant-fix.patch

