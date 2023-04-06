Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31238C761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbjDFDET (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235132AbjDFDEE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:04:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0EF93E1
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF7926403D
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A37C433D2;
        Thu,  6 Apr 2023 03:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750225;
        bh=p361Bxg+LbBFUgGwqt5K66aVb+9j+jhPVUgFcXcpGnQ=;
        h=Date:To:From:Subject:From;
        b=DDYVTH0h0Bln73B2E7A0MahB0fkTRQiOF4iRSgNTeGmQVIV9e/WcpqSFO9XNe5yKF
         n4kxFCQ0jjtzLpiESkK882LdOiomKWQKJjo+QPF+hG7cV/pQ9wSjpiGzsxe1KSBmtI
         u9409zPhZN4l3yWZqDserSpbRfbbfeq1HokO5BKw=
Date:   Wed, 05 Apr 2023 20:03:44 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kernel-fork-assert-no-vma-readers-during-its-destruction.patch removed from -mm tree
Message-Id: <20230406030345.54A37C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel/fork: assert no VMA readers during its destruction
has been removed from the -mm tree.  Its filename was
     kernel-fork-assert-no-vma-readers-during-its-destruction.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: kernel/fork: assert no VMA readers during its destruction
Date: Mon, 27 Feb 2023 09:36:19 -0800

Assert there are no holders of VMA lock for reading when it is about to be
destroyed.

Link: https://lkml.kernel.org/r/20230227173632.3292573-21-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/fork.c~kernel-fork-assert-no-vma-readers-during-its-destruction
+++ a/kernel/fork.c
@@ -491,6 +491,9 @@ static void vm_area_free_rcu_cb(struct r
 {
 	struct vm_area_struct *vma = container_of(head, struct vm_area_struct,
 						  vm_rcu);
+
+	/* The vma should not be locked while being destroyed. */
+	VM_BUG_ON_VMA(rwsem_is_locked(&vma->lock), vma);
 	__vm_area_free(vma);
 }
 #endif
_

Patches currently in -mm which might be from surenb@google.com are


