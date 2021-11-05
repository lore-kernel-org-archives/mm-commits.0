Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2887FC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1814361373
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbhKEUsp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:48:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233724AbhKEUso (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:48:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D12861288;
        Fri,  5 Nov 2021 20:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145164;
        bh=1hDB9nfGh9/MCnfFpWEWPrr61S0fnTZleNIJlYsPn/E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wAF7Dtnb60hWUbTbWrxbDeXc6ruxcGj58CiJApHLh1g9F+h/KAj7hS/WZtNiwde3b
         WUgWA1A8+/UmZIQF/ptKaMO+6TfSo8bgDJvjsgGE7BEO6jAFRHlGOmGzNDY4RFwW5u
         v649Au/IV/xJKRYlWq68ZepqGyMyM34zrdGqD6GU=
Date:   Fri, 05 Nov 2021 13:46:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sjpark@amazon.de,
        torvalds@linux-foundation.org
Subject:  [patch 218/262] include/linux/damon.h: fix kernel-doc
 comments for 'damon_callback'
Message-ID: <20211105204604.SNmwZ955x%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
