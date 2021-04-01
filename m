Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5FFBC433B4
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 00:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89F1D60FEC
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 00:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhDAAeg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 20:34:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230073AbhDAAeY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 20:34:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79B5B60FEC;
        Thu,  1 Apr 2021 00:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617237263;
        bh=Y8+WFrifcZjaiU2jj56fVoC6N6Y9kdHxM5y71O6nvNE=;
        h=Date:From:To:Subject:From;
        b=TFvFrSrHhEeuZieDap7LDD8fQ+6IMrP4mvd0Qo0R8T096yTbqTXblgDV5RMqlsm+z
         +dlxt6e2jYA2hPTOpgM7fQsZLRy+9wwN9TCI2CSzk4+ZdrBdwdzY5SXJwikCjEZK9T
         O8d6QtSvHlxhPFZYLis0RY5ocsx9EYDXjJHqwaz0=
Date:   Wed, 31 Mar 2021 17:34:22 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        yury.norov@gmail.com
Subject:  +
 secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch added to -mm
 tree
Message-ID: <20210401003422.yq-AM2F_U%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memfd_secret: use unsigned int rather than long as syscall flags type
has been added to the -mm tree.  Its filename is
     secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

nds32-flush_dcache_page-use-page_mapping_file-to-avoid-races-with-swapoff.patch
mm-cma-rename-pf_memalloc_nocma-to-pf_memalloc_pin-fix.patch
mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant-fix.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch
secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch

