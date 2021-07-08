Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3059FC07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01EF361CAC
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhGHAez (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 20:34:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhGHAez (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 20:34:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 389CD61CAA;
        Thu,  8 Jul 2021 00:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625704334;
        bh=uic9/5jbZtkvtbZABE4mcCaVrozFH/TFhbfU1tmUjIU=;
        h=Date:From:To:Subject:From;
        b=NF06DCksAomUVwTWkNibXhza42mV0zaXiZpoNWED5kW66UmdiomIQ9eaFpvO9PhPb
         eS3bIJuLRB6ThdR6d7l/JtqSU0iOCqaGiIfonCGACGJPfQHHiksbY+ZF/EJ7kF3UWA
         9f6j+RDtXVaBoYmqIBKo2iiF5v+1iqk0vI3nadOM=
Date:   Wed, 07 Jul 2021 17:32:13 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, swboyd@chromium.org,
        akpm@linux-foundation.org
Subject:  [folded-merged]
 module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
 removed from -mm tree
Message-ID: <20210708003213.8sLC4%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix
has been removed from the -mm tree.  Its filename was
     module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch

This patch was dropped because it was folded into module-add-printk-formats-to-add-module-build-id-to-stacktraces.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix

fix build with CONFIG_MODULES=n, tweak code layout

Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |    1 +
 kernel/module.c        |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/module.h~module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix
+++ a/include/linux/module.h
@@ -746,6 +746,7 @@ static inline const char *module_address
 					  unsigned long *symbolsize,
 					  unsigned long *offset,
 					  char **modname,
+					  const unsigned char **modbuildid,
 					  char *namebuf)
 {
 	return NULL;
--- a/kernel/module.c~module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix
+++ a/kernel/module.c
@@ -4275,7 +4275,8 @@ void * __weak dereference_module_functio
 const char *module_address_lookup(unsigned long addr,
 			    unsigned long *size,
 			    unsigned long *offset,
-			    char **modname, const unsigned char **modbuildid,
+			    char **modname,
+			    const unsigned char **modbuildid,
 			    char *namebuf)
 {
 	const char *ret = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

module-add-printk-formats-to-add-module-build-id-to-stacktraces.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

