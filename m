Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B25CC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 20:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 201C161179
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 20:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241083AbhIIU6U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 16:58:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233573AbhIIU6T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 16:58:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B8C96103D;
        Thu,  9 Sep 2021 20:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221030;
        bh=1OkR7TmKvH4yL6MnevOkOl8b4PmMAadbhr/lwmy6CxQ=;
        h=Date:From:To:Subject:From;
        b=1N+zt3U6ip67QYdcM9BlIae4zwobG2iZH8ZjwsPxjHQa/OyIGJS4FxdID7Iu5T8Np
         P7G49ATbFa9VGl58kSO6Rt/gzg0TRErsVwvU1J+mDyHVa614qog3fl2MYUH5gVYgiN
         efMqgDam8WEOL07XCmmDvVcTyQy+NHcwicGagwkQ=
Date:   Thu, 09 Sep 2021 13:57:09 -0700
From:   akpm@linux-foundation.org
To:     aklimov@redhat.com, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, lkp@intel.com, mm-commits@vger.kernel.org,
        ulf.hansson@linaro.org, will@kernel.org,
        wsa+renesas@sang-engineering.com, yury.norov@gmail.com
Subject:  [to-be-updated]
 bitops-protect-find_first_zero_bit-properly.patch removed from -mm tree
Message-ID: <20210909205709.bekI9CNv9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bitops: protect find_first_{,zero}_bit properly
has been removed from the -mm tree.  Its filename was
     bitops-protect-find_first_zero_bit-properly.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: bitops: protect find_first_{,zero}_bit properly

Patch series "Resend bitmap patches".


This patch (of 17):

find_first_bit() and find_first_zero_bit() are not protected with ifdefs
as other functions in find.h.  It causes build errors on some platforms if
CONFIG_GENERIC_FIND_FIRST_BIT is enabled.

Link: https://lkml.kernel.org/r/20210814211713.180533-1-yury.norov@gmail.com
Link: https://lkml.kernel.org/r/20210814211713.180533-2-yury.norov@gmail.com
Fixes: 2cc7b6a44ac2 ("lib: add fast path for find_first_*_bit() and find_last_bit()")
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitops/find.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/asm-generic/bitops/find.h~bitops-protect-find_first_zero_bit-properly
+++ a/include/asm-generic/bitops/find.h
@@ -97,6 +97,7 @@ unsigned long find_next_zero_bit(const u
 
 #ifdef CONFIG_GENERIC_FIND_FIRST_BIT
 
+#ifndef find_first_bit
 /**
  * find_first_bit - find the first set bit in a memory region
  * @addr: The address to start the search at
@@ -116,7 +117,9 @@ unsigned long find_first_bit(const unsig
 
 	return _find_first_bit(addr, size);
 }
+#endif
 
+#ifndef find_first_zero_bit
 /**
  * find_first_zero_bit - find the first cleared bit in a memory region
  * @addr: The address to start the search at
@@ -136,6 +139,8 @@ unsigned long find_first_zero_bit(const
 
 	return _find_first_zero_bit(addr, size);
 }
+#endif
+
 #else /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
 #ifndef find_first_bit
_

Patches currently in -mm which might be from yury.norov@gmail.com are

bitops-move-find_bit__le-functions-from-leh-to-findh.patch
cpumask-use-find_first_and_bit.patch
tools-sync-tools-bitmap-with-mother-linux.patch
cpumask-replace-cpumask_next_-with-cpumask_first_-where-appropriate.patch
replace-for_each__bit_from-with-for_each__bit-where-appropriate.patch
mm-percpu-micro-optimize-pcpu_is_populated.patch
lib-bitmap-add-performance-test-for-bitmap_print_to_pagebuf.patch
vsprintf-rework-bitmap_list_string.patch

