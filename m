Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBBE1C433E1
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D6952073E
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026835;
	bh=z+PaZ5DT4BP/8kKYec2ZHgl/ubitk0Y+KlYOnkQ6imY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=EjcS9TdO2AMPg57coSd6joWBtyVBtMCJ6ilNNdBRnXIeo9voBGMbUGEWHtMJH8HLL
	 Viy7Ep0Q9lYZ8nKZGtCPFhR4gmkaorLDbNwSa8Lc+N4U8HzgSyKCd73Y932VFzCJEJ
	 FabF8Dp3FPYqje0Xu8QhDTD7uAxPiZxlG1+zC6Ko=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgHJCdz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:33:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCdz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:33:55 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C23CD206E9;
        Mon, 10 Aug 2020 02:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026834;
        bh=z+PaZ5DT4BP/8kKYec2ZHgl/ubitk0Y+KlYOnkQ6imY=;
        h=Date:From:To:Subject:From;
        b=qT4Z3fram7V80geGFdjUAAi+382eD4p3DnWKqcC65mENHmzM+bFJ8WY7RZoZsHvLF
         hIlcCsNYni283yLgLYd3sh9TfUb8JUU2B/roPCyXPVzjKnE73aQmd6QEsFjlDUuceR
         NvBUlQr2cHgrNTfUNiBuzCy/q3TwJYLulstuZSJQ=
Date:   Sun, 09 Aug 2020 19:33:54 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, pmladek@suse.com,
        stamatis.iliass@gmail.com
Subject:  [merged]
 kthread-remove-incorrect-comment-in-kthread_create_on_cpu.patch removed
 from -mm tree
Message-ID: <20200810023354.UKkiwySnZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kthread: remove incorrect comment in kthread_create_on_cpu()
has been removed from the -mm tree.  Its filename was
     kthread-remove-incorrect-comment-in-kthread_create_on_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ilias Stamatis <stamatis.iliass@gmail.com>
Subject: kthread: remove incorrect comment in kthread_create_on_cpu()

Originally kthread_create_on_cpu() parked and woke up the new thread. 
However, since commit a65d40961dc7 ("kthread/smpboot: do not park in
kthread_create_on_cpu()") this is no longer the case.  This patch removes
the comment that has been left behind and is now incorrect / stale.

Link: http://lkml.kernel.org/r/20200611135920.240551-1-stamatis.iliass@gmail.com
Fixes: a65d40961dc7 ("kthread/smpboot: do not park in kthread_create_on_cpu()")
Signed-off-by: Ilias Stamatis <stamatis.iliass@gmail.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/kthread.c~kthread-remove-incorrect-comment-in-kthread_create_on_cpu
+++ a/kernel/kthread.c
@@ -480,7 +480,6 @@ EXPORT_SYMBOL(kthread_bind);
  *	     to "name.*%u". Code fills in cpu number.
  *
  * Description: This helper function creates and names a kernel thread
- * The thread will be woken and put into park mode.
  */
 struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
 					  void *data, unsigned int cpu,
_

Patches currently in -mm which might be from stamatis.iliass@gmail.com are


