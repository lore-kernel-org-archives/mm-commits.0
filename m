Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 964CEC2D0A3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 02:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42CE9223BD
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 02:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604458060;
	bh=XGq/mZEva6LuEVBWprMZnGrP2TVy5stv4QR65Ng/tsM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=hbuar+HjF5qxqy2ftweHJJMiBBmkdMITk3DEhrB/SYQ/PKnOLpLLWBWKyW5jMAb4s
	 05bpnbdPhp4/ygr2NKj6Fb3dGbFXtNDbwkAEQ3L99cb9599zNnFEQAU0rpfQ3ZjSoz
	 zdl5GLzwBeItbsI7sIm9cV5nTWBguMEe3OY0JDXo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729772AbgKDCrj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 21:47:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729745AbgKDCrj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 21:47:39 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4E3C2236F;
        Wed,  4 Nov 2020 02:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604458059;
        bh=XGq/mZEva6LuEVBWprMZnGrP2TVy5stv4QR65Ng/tsM=;
        h=Date:From:To:Subject:From;
        b=JP/2OddzYNpHJubewYbl4CNiD0kkUim4lNyDLM8mUt73uZcMQ0M5l0lo1eObjICUI
         EIZxn/3co/RBm1Wxe12YMk4HDCwkx+Ep1am8lv4knEDaWwF8UXcIt6Tz2CNpRmqQ5a
         7rcpsciwYzSR5/8BlIlbuOJfnqYbGSyPS9RM1v4k=
Date:   Tue, 03 Nov 2020 18:47:38 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        colin.king@canonical.com
Subject:  +
 mm-process_vm_access-remove-redundant-initialization-of-iov_r.patch added to
 -mm tree
Message-ID: <20201104024738.5WZMy%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/process_vm_access: remove redundant initialization of iov_r
has been added to the -mm tree.  Its filename is
     mm-process_vm_access-remove-redundant-initialization-of-iov_r.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-process_vm_access-remove-redundant-initialization-of-iov_r.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-process_vm_access-remove-redundant-initialization-of-iov_r.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: mm/process_vm_access: remove redundant initialization of iov_r

The pointer iov_r is being initialized with a value that is never read and
it is being updated later with a new value.  The initialization is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Link: https://lkml.kernel.org/r/20201102120614.694917-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/process_vm_access.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/process_vm_access.c~mm-process_vm_access-remove-redundant-initialization-of-iov_r
+++ a/mm/process_vm_access.c
@@ -260,7 +260,7 @@ static ssize_t process_vm_rw(pid_t pid,
 	struct iovec iovstack_l[UIO_FASTIOV];
 	struct iovec iovstack_r[UIO_FASTIOV];
 	struct iovec *iov_l = iovstack_l;
-	struct iovec *iov_r = iovstack_r;
+	struct iovec *iov_r;
 	struct iov_iter iter;
 	ssize_t rc;
 	int dir = vm_write ? WRITE : READ;
_

Patches currently in -mm which might be from colin.king@canonical.com are

mm-process_vm_access-remove-redundant-initialization-of-iov_r.patch

