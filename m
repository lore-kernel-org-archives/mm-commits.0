Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E46F9C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 22:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B641960FC0
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 22:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhIOWzj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Sep 2021 18:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbhIOWzh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Sep 2021 18:55:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBC4560FC0;
        Wed, 15 Sep 2021 22:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631746457;
        bh=c40iNPEYL6jU3C2Y+9MMWZ2++H6psfRr73oEmC1iKAg=;
        h=Date:From:To:Subject:From;
        b=q234xaFVBZE/Kx5pmZSsJH6z49J6JdlWBLvHvxUWqDguw5/Fe2nZqzX863FRnr7mm
         Q+jGExuBZh8otqlB/nxnD7uCTJHQ4mo4EbZM6yxGOlz/sXRhxW6R+Ks6zZtHUVb5jP
         nyspThCC137F5nNVDZW0IxjAMiq42PXc01ISVCF8=
Date:   Wed, 15 Sep 2021 15:54:16 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, edumazet@google.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com
Subject:  +
 =?US-ASCII?Q?mm-large-system-hash-avoid-possible-null-deref-in-alloc?=
 =?US-ASCII?Q?=5Flarge=5Fsystem=5Fhash.patch?= added to -mm tree
Message-ID: <20210915225416.Qyb6zCz_p%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/large system hash: avoid possible NULL deref in alloc_large_system_hash
has been added to the -mm tree.  Its filename is
     mm-large-system-hash-avoid-possible-null-deref-in-alloc_large_system_hash.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-large-system-hash-avoid-possible-null-deref-in-alloc_large_system_hash.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-large-system-hash-avoid-possible-null-deref-in-alloc_large_system_hash.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: mm/large system hash: avoid possible NULL deref in alloc_large_system_hash

If __vmalloc() returned NULL, is_vm_area_hugepages(NULL) will fault if
CONFIG_HAVE_ARCH_HUGE_VMALLOC=y

Link: https://lkml.kernel.org/r/20210915212530.2321545-1-eric.dumazet@gmail.com
Fixes: 121e6f3258fe ("mm/vmalloc: hugepage vmalloc mappings")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-large-system-hash-avoid-possible-null-deref-in-alloc_large_system_hash
+++ a/mm/page_alloc.c
@@ -8756,7 +8756,8 @@ void *__init alloc_large_system_hash(con
 		} else if (get_order(size) >= MAX_ORDER || hashdist) {
 			table = __vmalloc(size, gfp_flags);
 			virt = true;
-			huge = is_vm_area_hugepages(table);
+			if (table)
+				huge = is_vm_area_hugepages(table);
 		} else {
 			/*
 			 * If bucketsize is not a power-of-two, we may free
_

Patches currently in -mm which might be from edumazet@google.com are

mm-large-system-hash-avoid-possible-null-deref-in-alloc_large_system_hash.patch

