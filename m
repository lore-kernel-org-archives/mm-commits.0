Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8BC0C47082
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 21:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF3876135B
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 21:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhEaVp1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 17:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231240AbhEaVp0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 17:45:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D8326101C;
        Mon, 31 May 2021 21:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622497425;
        bh=KjT9TMavFhX0NJTAYIRUf/GR40tXO9H2IvdAOwLbhRk=;
        h=Date:From:To:Subject:From;
        b=QH/fA4cRQvuYsPxqXfUUuOVYXNfBuAJ5Il7I33NYm8yhKm0YW15ahtrrZGI8g6muc
         F0RmOnP0FbnCkYoFDIcLL3/TIW2RWG+zuxoYDCksFRHZ6z4CKwSrbNY+D3b52hxImA
         LrsXbKAnALQ89xnhdMtYWeqYrZrxS3S+piwm74Dw=
Date:   Mon, 31 May 2021 14:43:45 -0700
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, dancol@google.com, glebfm@altlinux.org,
        lokeshgidra@google.com, mm-commits@vger.kernel.org,
        peterx@redhat.com
Subject:  +
 userfaultfd-fix-uffdio_continue-ioctl-request-definition.patch added to -mm
 tree
Message-ID: <20210531214345.aukBO7sFR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: fix UFFDIO_CONTINUE ioctl request definition
has been added to the -mm tree.  Its filename is
     userfaultfd-fix-uffdio_continue-ioctl-request-definition.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-fix-uffdio_continue-ioctl-request-definition.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-fix-uffdio_continue-ioctl-request-definition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Subject: userfaultfd: fix UFFDIO_CONTINUE ioctl request definition

This ioctl request writes to uffdio_continue structure which justifies
_IOC_WRITE flag.  See NOTEs in include/uapi/asm-generic/ioctl.h for more
information.

Link: https://lkml.kernel.org/r/20210531140146.481553-1-glebfm@altlinux.org
Fixes: f619147104c8 ("userfaultfd: add UFFDIO_CONTINUE ioctl")
Signed-off-by: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Daniel Colascione <dancol@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/userfaultfd.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/userfaultfd.h~userfaultfd-fix-uffdio_continue-ioctl-request-definition
+++ a/include/uapi/linux/userfaultfd.h
@@ -81,8 +81,8 @@
 				      struct uffdio_zeropage)
 #define UFFDIO_WRITEPROTECT	_IOWR(UFFDIO, _UFFDIO_WRITEPROTECT, \
 				      struct uffdio_writeprotect)
-#define UFFDIO_CONTINUE		_IOR(UFFDIO, _UFFDIO_CONTINUE,	\
-				     struct uffdio_continue)
+#define UFFDIO_CONTINUE		_IOWR(UFFDIO, _UFFDIO_CONTINUE,	\
+				      struct uffdio_continue)
 
 /* read() structure */
 struct uffd_msg {
_

Patches currently in -mm which might be from glebfm@altlinux.org are

userfaultfd-fix-uffdio_continue-ioctl-request-definition.patch

