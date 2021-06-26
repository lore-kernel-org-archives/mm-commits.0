Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A2C8C2B9F4
	for <mm-commits@archiver.kernel.org>; Sat, 26 Jun 2021 01:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8F5C6196E
	for <mm-commits@archiver.kernel.org>; Sat, 26 Jun 2021 01:01:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhFZBD5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Jun 2021 21:03:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229831AbhFZBD5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Jun 2021 21:03:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F96161925;
        Sat, 26 Jun 2021 01:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624669295;
        bh=5Cr+X6Sl9prtfmCZdvT7dPa25I7O3UXWDaRNi7ZLrR4=;
        h=Date:From:To:Subject:From;
        b=oVDBduADtGltOZ6clZApv8XpDPZGsQ54gw31sztylEpRMdIY5mcCu9aETTuihoocv
         y7U2+2tIusWufrWPUbGxQPcrlDrE/qyWcYq0PWe7qfgrBNNo4/DzI+A7RGuDpcPXxL
         h9Hc0m7s41jrnd9Jbgx0Ym9um65HkRqJ3IH5pj+Y=
Date:   Fri, 25 Jun 2021 18:01:34 -0700
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, dancol@google.com, glebfm@altlinux.org,
        ldv@altlinux.org, lokeshgidra@google.com,
        mm-commits@vger.kernel.org, peterx@redhat.com
Subject:  [alternative-merged]
 userfaultfd-fix-uffdio_continue-ioctl-request-definition.patch removed from
 -mm tree
Message-ID: <20210626010134.2BYO8_I4W%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: fix UFFDIO_CONTINUE ioctl request definition
has been removed from the -mm tree.  Its filename was
     userfaultfd-fix-uffdio_continue-ioctl-request-definition.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Subject: userfaultfd: fix UFFDIO_CONTINUE ioctl request definition

This ioctl request reads from uffdio_continue structure which justifies
_IOC_READ flag.  See NOTEs in include/uapi/asm-generic/ioctl.h for more
information.

Link: https://lkml.kernel.org/r/20210601143432.1002481-1-glebfm@altlinux.org
Link: https://lkml.kernel.org/r/20210531140146.481553-1-glebfm@altlinux.org
Fixes: f619147104c8 ("userfaultfd: add UFFDIO_CONTINUE ioctl")
Signed-off-by: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Acked-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Dmitry V. Levin <ldv@altlinux.org>
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


