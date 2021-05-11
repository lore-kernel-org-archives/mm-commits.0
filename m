Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4E7C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55F226162D
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 01:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhEKBqY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 21:46:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230251AbhEKBqY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 21:46:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7CE2613B6;
        Tue, 11 May 2021 01:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620697518;
        bh=fL2OxM22KtrgcuGY6qhAZcZwb2ZyE3fzbn4POmB1BQo=;
        h=Date:From:To:Subject:From;
        b=dZeADWYkriTV4eEWlgcd+p9hnn8p0U5vJiNRKnE7A/5W4bpPy8qYUemZRgs3pzsrM
         wscoTCwDDPimghOP2FDAhFBuOM1Q2RviXIIcgSi9IB2vhO41TNsaQ+WT+RQo7qNsxe
         w0ZaRHXNbE66quOEamzHXPcorVMYh1ZyJSt0TZqc=
Date:   Mon, 10 May 2021 18:45:18 -0700
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, gregkh@linuxfoundation.org, jeyu@kernel.org,
        linux@rasmusvillemoes.dk, mcgrof@kernel.org,
        mm-commits@vger.kernel.org
Subject:  +
 docs-admin-guide-update-description-for-kernelmodprobe-sysctl.patch added
 to -mm tree
Message-ID: <20210511014518.LfVe9EkS_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: admin-guide: update description for kernel.modprobe sysctl
has been added to the -mm tree.  Its filename is
     docs-admin-guide-update-description-for-kernelmodprobe-sysctl.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-admin-guide-update-description-for-kernelmodprobe-sysctl.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-admin-guide-update-description-for-kernelmodprobe-sysctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: docs: admin-guide: update description for kernel.modprobe sysctl

When I added CONFIG_MODPROBE_PATH, I neglected to update Documentation/. 
It's still true that this defaults to /sbin/modprobe, but now via a level
of indirection.  So document that the kernel might have been built with
something other than /sbin/modprobe as the initial value.

Link: https://lkml.kernel.org/r/20210420125324.1246826-1-linux@rasmusvillemoes.dk
Fixes: 17652f4240f7a ("modules: add CONFIG_MODPROBE_PATH")
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~docs-admin-guide-update-description-for-kernelmodprobe-sysctl
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -483,10 +483,11 @@ modprobe
 ========
 
 The full path to the usermode helper for autoloading kernel modules,
-by default "/sbin/modprobe".  This binary is executed when the kernel
-requests a module.  For example, if userspace passes an unknown
-filesystem type to mount(), then the kernel will automatically request
-the corresponding filesystem module by executing this usermode helper.
+by default ``CONFIG_MODPROBE_PATH``, which in turn defaults to
+"/sbin/modprobe".  This binary is executed when the kernel requests a
+module.  For example, if userspace passes an unknown filesystem type
+to mount(), then the kernel will automatically request the
+corresponding filesystem module by executing this usermode helper.
 This usermode helper should insert the needed module into the kernel.
 
 This sysctl only affects module autoloading.  It has no effect on the
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

docs-admin-guide-update-description-for-kernelmodprobe-sysctl.patch
mm-page_alloc-__alloc_pages_bulk-do-bounds-check-before-accessing-array.patch

