Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FCBEC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 731FE61425
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238280AbhGABGQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238272AbhGABGQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:06:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A77061424;
        Thu,  1 Jul 2021 01:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625101425;
        bh=BhGf10WFbznZ/sk0FFOLgBK0NRog1DJxTE6hJEsma7o=;
        h=Date:From:To:Subject:From;
        b=dtQcXxS7P5yjBvS+EE8F+JsYZ/hNj0BRSgzOMplp3VUYvSo6jAPdaOhSuqmXmTvvV
         Okt18JJ5LVf8JLU9Hv3SKoLZjYv9cnZNNl0eUhO8h5rw140Hb/TNhsvbUeWWgRC8Od
         SER4UPAPAHUo6mTC55j+3ukZiXdWyLimaUgMGrS4=
Date:   Wed, 30 Jun 2021 18:03:45 -0700
From:   akpm@linux-foundation.org
To:     elver@google.com, mm-commits@vger.kernel.org, ojeda@kernel.org,
        peterz@infradead.org
Subject:  [folded-merged]
 =?US-ASCII?Q?kcov-add-=5F=5Fno=5Fsanitize=5Fcoverage-to-fix-noinstr-fo?=
 =?US-ASCII?Q?r-all-architectures-v3.patch?= removed from -mm tree
Message-ID: <20210701010345.lpAXOAdJ5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: add __no_sanitize_coverage to fix noinstr for all architectures
has been removed from the -mm tree.  Its filename was
     kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures-v3.patch

This patch was dropped because it was folded into kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures.patch

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kcov: add __no_sanitize_coverage to fix noinstr for all architectures

add comment explaining __has_feature() in Clang

Link: https://lkml.kernel.org/r/20210527194448.3470080-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/compiler-clang.h~kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures-v3
+++ a/include/linux/compiler-clang.h
@@ -13,6 +13,12 @@
 /* all clang versions usable with the kernel support KASAN ABI version 5 */
 #define KASAN_ABI_VERSION 5
 
+/*
+ * Note: Checking __has_feature(*_sanitizer) is only true if the feature is
+ * enabled. Therefore it is not required to additionally check defined(CONFIG_*)
+ * to avoid adding redundant attributes in other configurations.
+ */
+
 #if __has_feature(address_sanitizer) || __has_feature(hwaddress_sanitizer)
 /* Emulate GCC's __SANITIZE_ADDRESS__ flag */
 #define __SANITIZE_ADDRESS__
_

Patches currently in -mm which might be from elver@google.com are

kfence-unconditionally-use-unbound-work-queue.patch
kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures.patch

