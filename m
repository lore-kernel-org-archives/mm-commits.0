Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77775C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B3722087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817833;
	bh=l/GZAK+3k9LksY1bJmOlcuvY/9ubeEzmFrU4XQoM8aY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=nDJ9nlYnf2yvniFsplL/b2YdA7tIyaFIhsOtfWnKRfpfnO5d7DtKxZk5vsU1NTGHA
	 YyQEcBoCa0E7VWkWbQvOW/AeBQtwoTOP7mkTYV3pmJC6ETXzC5gO1a01UupRYZc3zN
	 CYe5++Rv7ehLzyQDf9Ez5yum5XHwV8mV6tAIgsTw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733114AbgJPDKc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732461AbgJPDKc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:10:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32CEC208C7;
        Fri, 16 Oct 2020 03:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817832;
        bh=l/GZAK+3k9LksY1bJmOlcuvY/9ubeEzmFrU4XQoM8aY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wMA/efkvKvrcjdksGCE87UnLq/F70VnoOe3tq2jJqF1iIL/9awZqCeSEiqaKBb7jM
         KfVGKSVW2aJlKcxCKJfKpaKlM96//8bunA50qHUi9p5Sbk0ZmEBGurfC/aEcitjE8Y
         gXBF0sfqFhuBVK/sFOZvJGXhF/s7UgPvRwL1/EdY=
Date:   Thu, 15 Oct 2020 20:10:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 099/156] kernel: acct.c: fix some kernel-doc nits
Message-ID: <20201016031031.7o4yy2CNf%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: kernel: acct.c: fix some kernel-doc nits

Fix kernel-doc notation to use the documented Returns: syntax and place
the function description for acct_process() on the first line where it
should be.

Link: https://lkml.kernel.org/r/b4c33e5d-98e8-0c47-77b6-ac1859f94d7f@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/kernel/acct.c~kernel-acctc-fix-some-kernel-doc-nits
+++ a/kernel/acct.c
@@ -263,12 +263,12 @@ static DEFINE_MUTEX(acct_on_mutex);
  * sys_acct - enable/disable process accounting
  * @name: file name for accounting records or NULL to shutdown accounting
  *
- * Returns 0 for success or negative errno values for failure.
- *
  * sys_acct() is the only system call needed to implement process
  * accounting. It takes the name of the file where accounting records
  * should be written. If the filename is NULL, accounting will be
  * shutdown.
+ *
+ * Returns: 0 for success or negative errno values for failure.
  */
 SYSCALL_DEFINE1(acct, const char __user *, name)
 {
@@ -586,9 +586,7 @@ static void slow_acct_process(struct pid
 }
 
 /**
- * acct_process
- *
- * handles process accounting for an exiting task
+ * acct_process - handles process accounting for an exiting task
  */
 void acct_process(void)
 {
_
