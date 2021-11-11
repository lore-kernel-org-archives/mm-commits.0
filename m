Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F339C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 638A561247
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbhKKCqe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:46:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:51702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234240AbhKKCqc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:46:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 822C56113B;
        Thu, 11 Nov 2021 02:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598624;
        bh=mWDAO5WbUP+1nB9Eo9GNL3SbHVqwOaiqsIKIF/12FzQ=;
        h=Date:From:To:Subject:From;
        b=Eznt4TUPMEYpd1td2H5NUxqCteicn4a9ld+Dfq0dfM8UzuuwAfDP1t3XPpx6o5sEn
         y9e2MPwbGGpBqj1Gn9r+Q91y0UaUXRavEk9IEqnFj4Gt2QLPwyC0jkflTiMrPoy/Ld
         3CiU5E7SN4KC3Xs4Pit3IDqw/zNi4yB/r7L59ysk=
Date:   Wed, 10 Nov 2021 18:43:44 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, edumazet@google.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com
Subject:  [merged]
 =?US-ASCII?Q?mm-large-system-hash-avoid-possible-null-deref-in-alloc?=
 =?US-ASCII?Q?=5Flarge=5Fsystem=5Fhash.patch?= removed from -mm tree
Message-ID: <20211111024344.lxAqGHWHg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/large system hash: avoid possible NULL deref in alloc_large_system_hash
has been removed from the -mm tree.  Its filename was
     mm-large-system-hash-avoid-possible-null-deref-in-alloc_large_system_hash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -8762,7 +8762,8 @@ void *__init alloc_large_system_hash(con
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


