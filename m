Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94807C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79A3960F36
	for <mm-commits@archiver.kernel.org>; Sun, 19 Sep 2021 23:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbhISXYV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 19 Sep 2021 19:24:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhISXYV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 19 Sep 2021 19:24:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CFD060F9C;
        Sun, 19 Sep 2021 23:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632093775;
        bh=7NtX+L719SfOI4n5id8jPuOpLzeWMTrU7IQZ0GQ+lj8=;
        h=Date:From:To:Subject:From;
        b=RR8d06WcvUum3bkODKI9rF/LydNI3D6IlM7kGgNaK9amgX/gX/UD0F5L1AUCOXxXS
         jx5lF4XiQtYEFZsiSyzn3MnVKPH7aRRYtCkogT0pxvO0qQ/Xz+JGz8Xe5Navf0qrpz
         WhqVcvzrMBiVrmpKyhRVzPkxe3k5HyrnKnLwqJZg=
Date:   Sun, 19 Sep 2021 16:22:54 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sjpark@amazon.de
Subject:  +
 include-linux-damonh-fix-kernel-doc-comments-for-damon_callback.patch added
 to -mm tree
Message-ID: <20210919232254.e7Bxp%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/damon.h: fix kernel-doc comments for 'damon_callback'
has been added to the -mm tree.  Its filename is
     include-linux-damonh-fix-kernel-doc-comments-for-damon_callback.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/include-linux-damonh-fix-kernel-doc-comments-for-damon_callback.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/include-linux-damonh-fix-kernel-doc-comments-for-damon_callback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: include/linux/damon.h: fix kernel-doc comments for 'damon_callback'

A few Kernel-doc comments in 'damon.h' are broken.  This commit fixes
those.

Link: https://lkml.kernel.org/r/20210917123958.3819-5-sj@kernel.org
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/damon.h~include-linux-damonh-fix-kernel-doc-comments-for-damon_callback
+++ a/include/linux/damon.h
@@ -62,7 +62,7 @@ struct damon_target {
 struct damon_ctx;
 
 /**
- * struct damon_primitive	Monitoring primitives for given use cases.
+ * struct damon_primitive - Monitoring primitives for given use cases.
  *
  * @init:			Initialize primitive-internal data structures.
  * @update:			Update primitive-internal data structures.
@@ -108,8 +108,8 @@ struct damon_primitive {
 	void (*cleanup)(struct damon_ctx *context);
 };
 
-/*
- * struct damon_callback	Monitoring events notification callbacks.
+/**
+ * struct damon_callback - Monitoring events notification callbacks.
  *
  * @before_start:	Called before starting the monitoring.
  * @after_sampling:	Called after each sampling.
_

Patches currently in -mm which might be from sjpark@amazon.de are

documentation-vm-move-user-guides-to-admin-guide-mm.patch
docs-vm-damon-remove-broken-reference.patch
include-linux-damonh-fix-kernel-doc-comments-for-damon_callback.patch

