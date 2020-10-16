Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F3C2C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FB0220E65
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816605;
	bh=XcQvWTejN+lCBG0TETX9FiiE6U9N+R/DWeORU8x1ASU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=hQhp0enh346ldnTDrkO+VNT32gjlJLkER3ab8BJUHaUi7J2O1pKJu4BjocxxbUvt5
	 y+hU1JITtUC8t3V2Jj2cv+n9L1TW4Wm5xUJI8jgIhLH1URKkdKFnF9s/0SJsFrNtyQ
	 fQDK13gAAE2yB7NxdqT7xc21SYKkbw0x4rONIPnI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404394AbgJPCuE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:50:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404125AbgJPCuE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:50:04 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F19C8208C7;
        Fri, 16 Oct 2020 02:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816604;
        bh=XcQvWTejN+lCBG0TETX9FiiE6U9N+R/DWeORU8x1ASU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=k4Av33K4cXgqBbRdDoc4oE79nDIekwmzp0uSbCZEVyr/NDYBLecFUUYpr5UABzrI4
         pb85gNQ9iP+TgUs6TBHNqPscQxilmZj960oOLD5DOUFmPMbWMMs8IZcO/HMCrClJo7
         fZyrov9W27UAXHGR4Axb/9NNO75Z90fasgbEAlpw=
Date:   Thu, 15 Oct 2020 19:50:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, raven@themaw.net,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 144/156] autofs: harden ioctl table
Message-ID: <20201016025003.otAbjz8xU%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Matthew Wilcox <willy@infradead.org>
Subject: autofs: harden ioctl table

The table of ioctl functions should be marked const in order to put them
in read-only memory, and we should use array_index_nospec() to avoid
speculation disclosing the contents of kernel memory to userspace.

Link: https://lkml.kernel.org/r/20200818122203.GO17456@casper.infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs/dev-ioctl.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/autofs/dev-ioctl.c~harden-autofs-ioctl-table
+++ a/fs/autofs/dev-ioctl.c
@@ -8,6 +8,7 @@
 #include <linux/compat.h>
 #include <linux/syscalls.h>
 #include <linux/magic.h>
+#include <linux/nospec.h>
 
 #include "autofs_i.h"
 
@@ -563,7 +564,7 @@ out:
 
 static ioctl_fn lookup_dev_ioctl(unsigned int cmd)
 {
-	static ioctl_fn _ioctls[] = {
+	static const ioctl_fn _ioctls[] = {
 		autofs_dev_ioctl_version,
 		autofs_dev_ioctl_protover,
 		autofs_dev_ioctl_protosubver,
@@ -581,7 +582,10 @@ static ioctl_fn lookup_dev_ioctl(unsigne
 	};
 	unsigned int idx = cmd_idx(cmd);
 
-	return (idx >= ARRAY_SIZE(_ioctls)) ? NULL : _ioctls[idx];
+	if (idx >= ARRAY_SIZE(_ioctls))
+		return NULL;
+	idx = array_index_nospec(idx, ARRAY_SIZE(_ioctls));
+	return _ioctls[idx];
 }
 
 /* ioctl dispatcher */
_
