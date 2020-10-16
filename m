Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7AEEC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FF822065D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881563;
	bh=v9hjbZoM/umUieV7AJEWntSQsAAp9Zoe7KM3tNhgADA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1Ciua5v3SlCMIrPfrp2rIX0NnHKQ70ok0i0/BZHaf6ccFCpe/9a1sDBg+tDdnB96c
	 ODeMrPDrBJHYv7K7pqMapypigRDG1vrzEDcs0jks6e+Btyl+bMEZQ/LQJ3A8LXw1H3
	 HPFGMsg/+28hYtNuMkD54YERkg1txAHqG6wLiNWs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408934AbgJPUwn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:52:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408456AbgJPUwk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:52:40 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B01820658;
        Fri, 16 Oct 2020 20:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881559;
        bh=v9hjbZoM/umUieV7AJEWntSQsAAp9Zoe7KM3tNhgADA=;
        h=Date:From:To:Subject:From;
        b=szyuB4fuOgaWH2+WGNj/9MdkzFrQLxfXT7F8leDyT/dx9NzmflGixROLl2GVq2cKF
         MAwCqgn5aPbKOjQbmbsgJf9M50CFU0rwP4/mhVUrCq1Xg8GO/8VATrUcJvTrtcWJGg
         fjTyMrdF7FXf+Gljd0kvwcUq0ZTa0R2ZP01wkR8Y=
Date:   Fri, 16 Oct 2020 13:52:39 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        viro@zeniv.linux.org.uk
Subject:  [merged] kernel-acctc-fix-some-kernel-doc-nits.patch
 removed from -mm tree
Message-ID: <20201016205239.JGb4sH8OT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: acct.c: fix some kernel-doc nits
has been removed from the -mm tree.  Its filename was
     kernel-acctc-fix-some-kernel-doc-nits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rdunlap@infradead.org are


