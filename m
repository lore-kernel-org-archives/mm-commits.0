Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0790AC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E41E3221E5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781041;
	bh=2BFBHw3XZvwXwNRkBzrcop/NSxWNyJBMp5dQKM4eftE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=BIHSy6aNEgNTP2IZPEb9gd1wqwQ0so2yfRgH7bOBAdTIBjFVMLRXGBR0S5ZRsonYm
	 1PLrhJU+S12T3xEHi16+zoyO0PnK8qeXApa5UmCJab7X3uyPUapLvkhjqjL7sTb0KN
	 v/QwgHdlB8CnNXjWKxDifdMFPA5k6ljdcTotNiw4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgHGGRV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:17:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGRU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:17:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EFAF22C9F;
        Fri,  7 Aug 2020 06:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781040;
        bh=2BFBHw3XZvwXwNRkBzrcop/NSxWNyJBMp5dQKM4eftE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CFFCKCYHzzen0Wiyu6XcPm1JKb8s8bZblQCcMcfnGTtnXuwNSidvQCgaW8MeM3HQ7
         f0cWwr4p0anyuGM9mvO+D3+p73nQxIm16Twv2OJygn/U35ndQBwtc8053nyxwX28By
         O5szumLg89lGiwTE3JPEPvhLiOqR7wSTCK2al11k=
Date:   Thu, 06 Aug 2020 23:17:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pmladek@suse.com,
        stamatis.iliass@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 005/163] kthread: remove incorrect comment in
 kthread_create_on_cpu()
Message-ID: <20200807061719.Bc1q_uR0m%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
