Return-Path: <SRS0=L/bp=EB=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 903D3C388F9
	for <mm-commits@archiver.kernel.org>; Mon, 26 Oct 2020 19:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3524B2085B
	for <mm-commits@archiver.kernel.org>; Mon, 26 Oct 2020 19:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603739621;
	bh=Tg7SoFsnmfY0qRnWoOMnxdUs37i/uVgWoUndMdlAzvc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=W8PNOZUU6DYSQf0bT2Bu1PmjzEQEmeUTEhgr24REg/sp71U+J6lWWjwkk06evnnbY
	 MZ45gIPc7a9TmiX/aG7eJYHqssyfsXX/PdPQqyZTID0PjnKOElpfQ6acqN+xfqJYB6
	 MBIZQbck9vL0AQv53YrPsDOVBeeMo/CW87k6B35E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731649AbgJZTNj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Oct 2020 15:13:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405924AbgJZTHA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 26 Oct 2020 15:07:00 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F04FB20720;
        Mon, 26 Oct 2020 19:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603739218;
        bh=Tg7SoFsnmfY0qRnWoOMnxdUs37i/uVgWoUndMdlAzvc=;
        h=Date:From:To:Subject:From;
        b=BeLSMYWZP/Fjw8v4ueHYRF92pKm6o4wDRF5i3+9s2Arz5T8SsDSHCIu68hwcxvTtK
         U+4iF8aqdIp0P5G+mV3znPbiyDjYM6dIjNXL3efTeXibUGrTYqRI80K5luyBCGS7Mh
         bqnMMQrHWHFztAJo+Fl0B2gtlPn22ZEm1t+EwpDI=
Date:   Mon, 26 Oct 2020 12:06:57 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, mail@maciej.szmigiero.name, ddstreet@ieee.org,
        dan.carpenter@oracle.com, joe@perches.com
Subject:  +
 mm-zswap-make-struct-kernel_param_ops-definitions-const.patch added to -mm
 tree
Message-ID: <20201026190657.Rx6wT%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: make struct kernel_param_ops definitions const
has been added to the -mm tree.  Its filename is
     mm-zswap-make-struct-kernel_param_ops-definitions-const.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-make-struct-kernel_param_ops-definitions-const.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-make-struct-kernel_param_ops-definitions-const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from joe@perches.com are

mm-zswap-make-struct-kernel_param_ops-definitions-const.patch
checkpatch-prefer-static-const-declarations.patch
checkpatch-allow-fix-removal-of-unnecessary-break-statements.patch

