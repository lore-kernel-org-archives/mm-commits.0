Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B303C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B187A20B1F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817989;
	bh=XcQvWTejN+lCBG0TETX9FiiE6U9N+R/DWeORU8x1ASU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=H+luU4QnyjN168gcu5CQ3t3uYvM3LfNy2mmcu8Y9lYvOBLmwbct46Ah//mrQCvC98
	 3CBTBDxISxyW/TTNtsSxL00dNhaYt2yQ6gaS2F3A+9k1hvJCPfBi9Q4mvVih92JWV5
	 s4hnmN04sRHUiMRHNmhdayM1D4caSzLBS6lN8gr4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393954AbgJPDNJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:13:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393799AbgJPDNJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:13:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 915B12078A;
        Fri, 16 Oct 2020 03:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817988;
        bh=XcQvWTejN+lCBG0TETX9FiiE6U9N+R/DWeORU8x1ASU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=K1MIpRvrZyQ9nUTcxtDiv/nepRNM1ISLhm84zBQOs7xPT7dWOGC1Tam12GPKzd492
         R/WmC1q/O0t+6cqzHG3s9g9VKy3E2G/PWkQEl2O1dH8+rQEzL44Varox8E1TYNIync
         pq89VjZ74zRmmH5Z+WZHJRKaXGd0Wj1HGn9BjGXc=
Date:   Thu, 15 Oct 2020 20:13:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        raven@themaw.net, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 144/156] autofs: harden ioctl table
Message-ID: <20201016031308.Fadu4i3zD%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
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
