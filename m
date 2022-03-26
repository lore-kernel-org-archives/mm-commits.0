Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E6BC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 26 Mar 2022 00:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiCZAdH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 20:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiCZAc7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 20:32:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6724620D81B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 17:31:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 93BBACE2C23
        for <mm-commits@vger.kernel.org>; Sat, 26 Mar 2022 00:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D26C2BBE4;
        Sat, 26 Mar 2022 00:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648254680;
        bh=yw/OYuVjhaiRQGGLQpqEO/L7dWDrkM/NTqZVvwLhAKw=;
        h=Date:To:From:Subject:From;
        b=N+bzE1qR6mAsRk9GHkkmW3ifp7L8tAkYRZ+pYRiCVjADIQivdr+0g8JQ8y17i0w3Y
         gBLwDoV/BRU/6Ch4NHdlC07mzQJnUBeO9zgT3AJ34NNG0ppeDalXYTsxl9OzCJuxCQ
         AHOgqMA9gZkwH/BFNo5DEjt3ZJW8xZmvoRT47ebE=
Date:   Fri, 25 Mar 2022 17:31:20 -0700
To:     mm-commits@vger.kernel.org, baihaowen@meizu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-pid_namespace-use-null-instead-of-using-plain-integer-as-pointer.patch added to -mm tree
Message-Id: <20220326003120.C7D26C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: pid_namespace: use NULL instead of using plain integer as pointer
has been added to the -mm tree.  Its filename is
     kernel-pid_namespace-use-null-instead-of-using-plain-integer-as-pointer.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-pid_namespace-use-null-instead-of-using-plain-integer-as-pointer.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-pid_namespace-use-null-instead-of-using-plain-integer-as-pointer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Haowen Bai <baihaowen@meizu.com>
Subject: kernel: pid_namespace: use NULL instead of using plain integer as pointer

This fixes the following sparse warnings:
kernel/pid_namespace.c:55:77: warning: Using plain integer as NULL pointer

Link: https://lkml.kernel.org/r/1647944288-2806-1-git-send-email-baihaowen@meizu.com
Signed-off-by: Haowen Bai <baihaowen@meizu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/pid_namespace.c~kernel-pid_namespace-use-null-instead-of-using-plain-integer-as-pointer
+++ a/kernel/pid_namespace.c
@@ -52,7 +52,7 @@ static struct kmem_cache *create_pid_cac
 	/* Name collision forces to do allocation under mutex. */
 	if (!*pkc)
 		*pkc = kmem_cache_create(name, len, 0,
-					 SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, 0);
+					 SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, NULL);
 	mutex_unlock(&pid_caches_mutex);
 	/* current can fail, but someone else can succeed. */
 	return READ_ONCE(*pkc);
_

Patches currently in -mm which might be from baihaowen@meizu.com are

kernel-pid_namespace-use-null-instead-of-using-plain-integer-as-pointer.patch

