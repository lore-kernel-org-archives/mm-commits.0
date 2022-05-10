Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA62C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbiEJEXY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236380AbiEJEWX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:22:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37871BDAFB
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FC2261773
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76153C385C8;
        Tue, 10 May 2022 04:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156258;
        bh=zbP1RmN865P0DYFBmgbPz9EYpDX0DURKLilQ/es2D7Y=;
        h=Date:To:From:Subject:From;
        b=v48RK9vlgPmSyTL4rfKzqk58479sQa2ujv574G4vdYBhscoPTECMUVj3WLUXzpJ87
         iAv3RQWpuRt29tJ4C8r8/Ah+0y2oriA99kMjVaMFIwnVeavQm62qdFsyhNRjHBFmf4
         ZkpSQsVykiPyOStZhvwnscxfcLB2lU2CPE24Byco=
Date:   Mon, 09 May 2022 21:17:37 -0700
To:     mm-commits@vger.kernel.org, baihaowen@meizu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-pid_namespace-use-null-instead-of-using-plain-integer-as-pointer.patch removed from -mm tree
Message-Id: <20220510041738.76153C385C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel: pid_namespace: use NULL instead of using plain integer as pointer
has been removed from the -mm tree.  Its filename was
     kernel-pid_namespace-use-null-instead-of-using-plain-integer-as-pointer.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


