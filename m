Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1583DC4363A
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3955221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709321;
	bh=smamflaV5j9K56MX078TLS+/4S6i956/g/UHTRB/nMc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=EYbKZqCHH0+oT+LA9aStCXCZ7rCQojEFjFqstW+owmcvRz5lnymKGpPWMsmhWxPsC
	 FkOZy6zY29yX5D5bLJuRfJ+bGFSp5aC6v9UKsHjGC9K93T/vogDjh1rD66/1n4QYLB
	 VkKSlkD0M9f5MRCNVuwYM3ki8A2UGLNIbYoAAjgw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730678AbgJNVCB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728330AbgJNVCB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:02:01 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8300D2224D;
        Wed, 14 Oct 2020 21:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709320;
        bh=smamflaV5j9K56MX078TLS+/4S6i956/g/UHTRB/nMc=;
        h=Date:From:To:Subject:From;
        b=FDpdHuL8sujoe6ygl9xd1+uKzkCcJPLvbPyY+4mszP7K7yaQuuBGlnyZPi/7OdzCi
         B83uXjsG85SWO5n29q8ytqWa+cQydTql/W4gQej6JtTqoi2VG0UJ2XwKSZWaUFAg0b
         aKSau8WVcggNVud1tTZMqqnBBf1rHIZy/aRvEPKE=
Date:   Wed, 14 Oct 2020 14:02:00 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        sh_def@163.com
Subject:  [merged]
 mm-vmallocc-fix-the-comment-of-find_vm_area.patch removed from -mm tree
Message-ID: <20201014210200.xajunNLJp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: fix the comment of find_vm_area
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-fix-the-comment-of-find_vm_area.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm/vmalloc.c: fix the comment of find_vm_area

Fix the comment of find_vm_area() and get_vm_area()

Link: https://lkml.kernel.org/r/20200927153034.GA199877@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmallocc-fix-the-comment-of-find_vm_area
+++ a/mm/vmalloc.c
@@ -2133,7 +2133,7 @@ struct vm_struct *get_vm_area_caller(uns
  * It is up to the caller to do all required locking to keep the returned
  * pointer valid.
  *
- * Return: pointer to the found area or %NULL on faulure
+ * Return: the area descriptor on success or %NULL on failure.
  */
 struct vm_struct *find_vm_area(const void *addr)
 {
@@ -2154,7 +2154,7 @@ struct vm_struct *find_vm_area(const voi
  * This function returns the found VM area, but using it is NOT safe
  * on SMP machines, except for its size or flags.
  *
- * Return: pointer to the found area or %NULL on faulure
+ * Return: the area descriptor on success or %NULL on failure.
  */
 struct vm_struct *remove_vm_area(const void *addr)
 {
_

Patches currently in -mm which might be from sh_def@163.com are


