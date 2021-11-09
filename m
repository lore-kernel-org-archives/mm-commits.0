Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FBB0C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A10961207
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235807AbhKICgF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:36:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235794AbhKICgF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:36:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0C98611CC;
        Tue,  9 Nov 2021 02:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425200;
        bh=DP7jpW2Z2cHRutlvrZHNm8kBYrWJ63VXs1EuvhaehhQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=epqHlfO6aQtI9Au9E9RTIoi9Yi2hE5hkhqyPP4IFgJN4o2JKA0p/iozsGVXolrGo1
         0r0Un8gUvY/CkdeFDcb8CXPBFK1r1giUe0ZGFCxAu5qfvyCGz9L65ozmYg39xKRV+S
         VCxzoDj/hyc/hfSRUHEJqfVtJIMl00qrWdcwZ7/8=
Date:   Mon, 08 Nov 2021 18:33:19 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        lucas.demarchi@intel.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 36/87] include/linux/string_helpers.h: add
 linux/string.h for strlen()
Message-ID: <20211109023319.m1yKzvr0s%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Lucas De Marchi <lucas.demarchi@intel.com>
Subject: include/linux/string_helpers.h: add linux/string.h for strlen()

linux/string_helpers.h uses strlen(), so include the correponding header. 
Otherwise we get a compilation error if it's not also included by whoever
included the helper.

Link: https://lkml.kernel.org/r/20211005212634.3223113-1-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string_helpers.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/string_helpers.h~lib-string_helpers-add-linux-stringh-for-strlen
+++ a/include/linux/string_helpers.h
@@ -4,6 +4,7 @@
 
 #include <linux/bits.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
 #include <linux/types.h>
 
 struct file;
_
