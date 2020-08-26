Return-Path: <SRS0=fsxA=CE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053CCC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 01:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D10242075E
	for <mm-commits@archiver.kernel.org>; Wed, 26 Aug 2020 01:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598405916;
	bh=g9EXZ4djuzoxArOrxaQ4IFqBpGZocWv7PsykQRyxeVs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ZRBXQGsPcDyaUj4U6/CtQF3aeIHRcY0/cbTgY0gIVPKy3wtLe9bDPSXMZhGQhW2IH
	 rUI7s8/nVWWcVjqbJ6kXY2Z4FaqzHZQxZjKu1C8EhvVZeCW5JsYpBcKu03T1xF16GT
	 8Kig0Gdu2AXreYzY4eQGMKkPZ+Ljpxo5trJK1np4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgHZBig (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Aug 2020 21:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbgHZBig (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 Aug 2020 21:38:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FBD12072D;
        Wed, 26 Aug 2020 01:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598405915;
        bh=g9EXZ4djuzoxArOrxaQ4IFqBpGZocWv7PsykQRyxeVs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZZfCqIzEMh4yJXoUsjlm35Cj0DR89TNc59wGLdEQu4C8sQSYiuW9OKdG0xVtgfxEu
         V/2rVKVtc6mTZweFSR3OtlOQ/8jwyycuNYvEFYzK7CGUqCQHSoIubFq7PAWUJjXyis
         oZ/J8ygNK79SqTwYlUjbq4lOGNf1FC5aR9fgnkXg=
Date:   Tue, 25 Aug 2020 18:38:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     dan.j.williams@intel.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  + x86-numa-add-nohmat-option-fix.patch added to -mm tree
Message-ID: <20200826013835.xlIl--_gC%akpm@linux-foundation.org>
In-Reply-To: <20200820174132.67fd4a7a9359048f807a533b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/numa: fix build when CONFIG_ACPI is not set
has been added to the -mm tree.  Its filename is
     x86-numa-add-nohmat-option-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-numa-add-nohmat-option-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-numa-add-nohmat-option-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: x86/numa: fix build when CONFIG_ACPI is not set

Fix build errors when CONFIG_ACPI is not set/enabled by adding
<acpi/acpi_numa.h> in the #else (!CONFIG_ACPI) block.

../arch/x86/mm/numa.c: In function `numa_setup':
../arch/x86/mm/numa.c:43:3: error: implicit declaration of function `disable_srat'; did you mean `disable_irq'? [-Werror=implicit-function-declaration]
   disable_srat();
   ^~~~~~~~~~~~
../arch/x86/mm/numa.c:45:3: error: implicit declaration of function `disable_hmat'; did you mean `disable_dma'? [-Werror=implicit-function-declaration]
   disable_hmat();
   ^~~~~~~~~~~~

Link: https://lkml.kernel.org/r/70e5ee34-9809-a997-7b49-499e4be61307@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/acpi.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/acpi.h~x86-numa-add-nohmat-option-fix
+++ a/include/linux/acpi.h
@@ -709,6 +709,8 @@ static inline u64 acpi_arch_get_root_poi
 #define ACPI_HANDLE_FWNODE(fwnode)	(NULL)
 #define ACPI_DEVICE_CLASS(_cls, _msk)	.cls = (0), .cls_msk = (0),
 
+#include <acpi/acpi_numa.h>
+
 struct fwnode_handle;
 
 static inline bool acpi_dev_found(const char *hid)
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-ocfs2-delete-repeated-words-in-comments.patch
x86-numa-add-nohmat-option-fix.patch
fs-configfs-delete-repeated-words-in-comments.patch
lib-bitmap-delete-duplicated-words.patch
lib-libcrc32c-delete-duplicated-words.patch
lib-decompress_bunzip2-delete-duplicated-words.patch
lib-devres-delete-duplicated-words.patch
lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch
lib-earlycpio-delete-duplicated-words.patch
lib-radix-tree-delete-duplicated-words.patch
lib-syscall-delete-duplicated-words.patch
lib-test_sysctl-delete-duplicated-words.patch

