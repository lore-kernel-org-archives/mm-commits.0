Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DBEEC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 135BC60F9B
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbhKICfV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:35:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICfU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:35:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABE9460F9B;
        Tue,  9 Nov 2021 02:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425155;
        bh=Jjiz47gaZy2W8DFDVNE2wapcuedjrzjOiz0iFSyNZso=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YjwhvqiLTLtXuZYpYB2lauTR/8Mqz/34SGDghKuYVPCUddqdnq/Lk7e5OE40+0eGQ
         OhSmiIkLOjK1j004jRVvRY+2TQEHVUV2RWL8Ahhf28wAcvmZk5FnraR2hIM7s/YTjO
         yQlBDJ8ITCeE/75Q0FDVfgS9otvDclwaNiMKRJiI=
Date:   Mon, 08 Nov 2021 18:32:35 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 22/87] include/linux/sbitmap.h: replace kernel.h
 with the necessary inclusions
Message-ID: <20211109023235.tWKKZ_7nR%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/sbitmap.h: replace kernel.h with the necessary inclusions

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

Link: https://lkml.kernel.org/r/20211027150437.79921-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sbitmap.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/include/linux/sbitmap.h~sbitmap-replace-kernelh-with-the-necessary-inclusions
+++ a/include/linux/sbitmap.h
@@ -9,8 +9,17 @@
 #ifndef __LINUX_SCALE_BITMAP_H
 #define __LINUX_SCALE_BITMAP_H
 
-#include <linux/kernel.h>
+#include <linux/atomic.h>
+#include <linux/bitops.h>
+#include <linux/cache.h>
+#include <linux/list.h>
+#include <linux/log2.h>
+#include <linux/minmax.h>
+#include <linux/percpu.h>
 #include <linux/slab.h>
+#include <linux/smp.h>
+#include <linux/types.h>
+#include <linux/wait.h>
 
 struct seq_file;
 
_
