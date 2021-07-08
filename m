Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E58C07E9C
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ADED61CB0
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhGHAe7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 20:34:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhGHAe7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 20:34:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F46E61CAC;
        Thu,  8 Jul 2021 00:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625704338;
        bh=30+PwOkCZFWh8k/j2yv5NqfY38XPRf7U7hs+AZiOtD8=;
        h=Date:From:To:Subject:From;
        b=TpW1iPf+AFAL+6dROkdpnx5QspZBAfMYvj9S0rklh3snxI2yqMc1cLCFqhPTCEhFj
         jaYSlGcNWJt/ZVq3V8bNTuB6KshbDANYOnHv5lFYFVd67ZEj4+OHCRb2D2VtaQtE5g
         RKssBuGOZSwIoItftw+sboTK73XGCVx1a1KA6qW8=
Date:   Wed, 07 Jul 2021 17:32:17 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, swboyd@chromium.org,
        akpm@linux-foundation.org
Subject:  [folded-merged]
 module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
 removed from -mm tree
Message-ID: <20210708003217.tEPZK%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix
has been removed from the -mm tree.  Its filename was
     module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch

This patch was dropped because it was folded into module-add-printk-formats-to-add-module-build-id-to-stacktraces.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix

make kallsyms_lookup_buildid() static

warning: no previous prototype for 'kallsyms_lookup_buildid' [-Wmissing-prototypes]

Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/kallsyms.c~module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix
+++ a/kernel/kallsyms.c
@@ -311,9 +311,10 @@ int kallsyms_lookup_size_offset(unsigned
 	       !!__bpf_address_lookup(addr, symbolsize, offset, namebuf);
 }
 
-const char *kallsyms_lookup_buildid(unsigned long addr, unsigned long *symbolsize,
-				    unsigned long *offset, char **modname,
-				    const unsigned char **modbuildid, char *namebuf)
+static const char *kallsyms_lookup_buildid(unsigned long addr,
+			unsigned long *symbolsize,
+			unsigned long *offset, char **modname,
+			const unsigned char **modbuildid, char *namebuf)
 {
 	const char *ret;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

module-add-printk-formats-to-add-module-build-id-to-stacktraces.patch
mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

