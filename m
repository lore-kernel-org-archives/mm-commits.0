Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF6CC2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5D2522473
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgLODPv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:15:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:42868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727803AbgLODOx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:14:53 -0500
Date:   Mon, 14 Dec 2020 19:14:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002052;
        bh=wIkPoD36GcSJb5Ud5S3w8UOcmGV9y/RPIDT15O+94IA=;
        h=From:To:Subject:In-Reply-To:From;
        b=E4pBaICFYxi3ETiyglAEj7jsWha8j+TKL6D+vSA1gDI6Nbewn1es5QNumwmaBWwCu
         WCHnrYQNuK2ImJNpAF3HNv1HcHtmLfBz12AskW8llXLAyE6fqjfmgUcsZSVe02BapW
         JWM1QlxqU4uHzaLpVaMbSsKrQexFQcb2DzYZlXxw=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.carpenter@oracle.com,
        ddstreet@ieee.org, joe@perches.com, linux-mm@kvack.org,
        mail@maciej.szmigiero.name, mm-commits@vger.kernel.org,
        sjenning@redhat.com, torvalds@linux-foundation.org,
        vitaly.wool@konsulko.com
Subject:  [patch 185/200] mm/zswap: make struct kernel_param_ops
 definitions const
Message-ID: <20201215031411.m4TRPfRc7%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: mm/zswap: make struct kernel_param_ops definitions const

These should be const, so make it so.

Link: https://lkml.kernel.org/r/1791535ee0b00f4a5c68cc4a8adada06593ad8f1.1601770305.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/zswap.c~mm-zswap-make-struct-kernel_param_ops-definitions-const
+++ a/mm/zswap.c
@@ -81,7 +81,7 @@ static bool zswap_pool_reached_full;
 static bool zswap_enabled = IS_ENABLED(CONFIG_ZSWAP_DEFAULT_ON);
 static int zswap_enabled_param_set(const char *,
 				   const struct kernel_param *);
-static struct kernel_param_ops zswap_enabled_param_ops = {
+static const struct kernel_param_ops zswap_enabled_param_ops = {
 	.set =		zswap_enabled_param_set,
 	.get =		param_get_bool,
 };
@@ -91,7 +91,7 @@ module_param_cb(enabled, &zswap_enabled_
 static char *zswap_compressor = CONFIG_ZSWAP_COMPRESSOR_DEFAULT;
 static int zswap_compressor_param_set(const char *,
 				      const struct kernel_param *);
-static struct kernel_param_ops zswap_compressor_param_ops = {
+static const struct kernel_param_ops zswap_compressor_param_ops = {
 	.set =		zswap_compressor_param_set,
 	.get =		param_get_charp,
 	.free =		param_free_charp,
@@ -102,7 +102,7 @@ module_param_cb(compressor, &zswap_compr
 /* Compressed storage zpool to use */
 static char *zswap_zpool_type = CONFIG_ZSWAP_ZPOOL_DEFAULT;
 static int zswap_zpool_param_set(const char *, const struct kernel_param *);
-static struct kernel_param_ops zswap_zpool_param_ops = {
+static const struct kernel_param_ops zswap_zpool_param_ops = {
 	.set =		zswap_zpool_param_set,
 	.get =		param_get_charp,
 	.free =		param_free_charp,
_
