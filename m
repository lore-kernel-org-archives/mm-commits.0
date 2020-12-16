Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51407C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E69523340
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgLPErb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:47:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgLPErb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:47:31 -0500
Date:   Tue, 15 Dec 2020 20:46:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608094011;
        bh=GDn8UShgmCndh421fMh0S5m1dt1+1jtyS5ca+1fdiiY=;
        h=From:To:Subject:In-Reply-To:From;
        b=kUcoQ/FvpgO3SmolWsqoItUzpxDFW4hdawA9i1zBJWz6mNZvEWcFKZlkpJT5m+oZz
         pm0WOYZEq1qQYhTGXQ11atK5BiXt5eH9LDXHUZeWOI4s1bp/m+YL/oqEpK4BNlZOwV
         8fYDqm57ZxiSxKTMbuCkuW2BEu4sPRt9D6ugEEAk=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, keescook@chromium.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, zou_wei@huawei.com
Subject:  [patch 82/95] lib/ubsan.c: mark type_check_kinds with
 static keyword
Message-ID: <20201216044650.PyMy-4Hw_%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>
Subject: lib/ubsan.c: mark type_check_kinds with static keyword

Fix the following sparse warning:

lib/ubsan.c:20:12: warning: symbol 'type_check_kinds' was not declared. Should it be static?

[akpm@linux-foundation.org: make it `static const char * const' while we're in there]
Link: https://lkml.kernel.org/r/1607602638-79584-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/ubsan.c~lib-ubsanc-mark-type_check_kinds-with-static-keyword
+++ a/lib/ubsan.c
@@ -17,7 +17,7 @@
 
 #include "ubsan.h"
 
-const char *type_check_kinds[] = {
+static const char * const type_check_kinds[] = {
 	"load of",
 	"store to",
 	"reference binding to",
_
