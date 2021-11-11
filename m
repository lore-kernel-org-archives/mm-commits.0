Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF29C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7C9961241
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbhKKCvc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:51:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234443AbhKKCvb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:51:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C5CF60F26;
        Thu, 11 Nov 2021 02:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598923;
        bh=v82qQFpe6a/JGW1HsisHS+Ze4auz/W35+/Ylx9wvT6E=;
        h=Date:From:To:Subject:From;
        b=RUfvArRwfhy14xHDy0Y124xP3V2juYg6AewQUy63bbdeNzhF2R2Dmj9nwmk4Akkgb
         /WWfySN7WW8jtAmfSapl8pywUSlQlnzq1RdrsB0rAMPx4XGmThDoDRh2nc4GcXwrir
         Nyzxyg14bw2WPwWc/CSyy+b/eWcZGQncTR0NJxgc=
Date:   Wed, 10 Nov 2021 18:48:43 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, sjpark@amazon.de
Subject:  [merged]
 include-linux-damonh-fix-kernel-doc-comments-for-damon_callback.patch
 removed from -mm tree
Message-ID: <20211111024843.erZ8kRa5n%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/damon.h: fix kernel-doc comments for 'damon_callback'
has been removed from the -mm tree.  Its filename was
     include-linux-damonh-fix-kernel-doc-comments-for-damon_callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


