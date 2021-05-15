Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D578C433ED
	for <mm-commits@archiver.kernel.org>; Sat, 15 May 2021 00:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8522661444
	for <mm-commits@archiver.kernel.org>; Sat, 15 May 2021 00:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbhEOA2t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 20:28:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230022AbhEOA2t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 20:28:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E689061176;
        Sat, 15 May 2021 00:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621038457;
        bh=8jWfvuThSMiwBPc6scSCH0GFUYF/9Od4P2qB6/UbtKU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MYy74eBstDj85VPOmCXRKrPCEPDJOsbPDIriK7lNoTxhu3delKHk6tuP8FszUKl1V
         RyIfl/Gi9CzU4ewd2NOenEy+SuBj/wS1S72lA8CB25xd/ua0BTDs74G70VmZJAitTf
         xolednOnWkWshCrkk2lv55U3N6shQ+3E0whGz5Uk=
Date:   Fri, 14 May 2021 17:27:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net,
        gregkh@linuxfoundation.org, jeyu@kernel.org, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 12/13] docs: admin-guide: update description for
 kernel.modprobe sysctl
Message-ID: <20210515002736.PhTtE5HrL%akpm@linux-foundation.org>
In-Reply-To: <20210514172634.9018621171d5334ceee97e95@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
