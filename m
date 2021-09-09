Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 563AAC4332F
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ECED611C3
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346197AbhIIVGP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346270AbhIIVFo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:05:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78975611CA;
        Thu,  9 Sep 2021 21:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221474;
        bh=dzFu7vH2oui/o8YFZYtYSBmFMeW52b/YpOSLf+w8Xqc=;
        h=Date:From:To:Subject:From;
        b=CBIQjC3HZaAmnherTJ8NPkQzZVyunAOQqbi7EH+azsqd2kWg3K7A0ZHI2jKTsddqo
         BNokGx1vNm5URfnFz9qL+phw+UGsuFhuTVSzxLUFXc7cXfupHeX81cihg91xJh63/y
         0vUqv4RgZ293rHigPy4JTKs72UYOyX4J0uNOUQtU=
Date:   Thu, 09 Sep 2021 14:04:34 -0700
From:   akpm@linux-foundation.org
To:     aklimov@redhat.com, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, mm-commits@vger.kernel.org,
        ulf.hansson@linaro.org, will@kernel.org,
        wsa+renesas@sang-engineering.com, yury.norov@gmail.com
Subject:  [merged]
 include-linux-move-for_each_bit-macros-from-bitopsh-to-findh.patch removed
 from -mm tree
Message-ID: <20210909210434.ytU3Q-hyM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux: move for_each_bit() macros from bitops.h to find.h
has been removed from the -mm tree.  Its filename was
     include-linux-move-for_each_bit-macros-from-bitopsh-to-findh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: include/linux: move for_each_bit() macros from bitops.h to find.h

for_each_bit() macros depend on find_bit() machinery, and so the proper
place for them is the find.h header.

Link: https://lkml.kernel.org/r/20210814211713.180533-11-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
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

 include/linux/bitops.h |   34 ----------------------------------
 include/linux/find.h   |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 34 deletions(-)

--- a/include/linux/bitops.h~include-linux-move-for_each_bit-macros-from-bitopsh-to-findh
+++ a/include/linux/bitops.h
@@ -31,40 +31,6 @@ extern unsigned long __sw_hweight64(__u6
  */
 #include <asm/bitops.h>
 
-#define for_each_set_bit(bit, addr, size) \
-	for ((bit) = find_first_bit((addr), (size));		\
-	     (bit) < (size);					\
-	     (bit) = find_next_bit((addr), (size), (bit) + 1))
-
-/* same as for_each_set_bit() but use bit as value to start with */
-#define for_each_set_bit_from(bit, addr, size) \
-	for ((bit) = find_next_bit((addr), (size), (bit));	\
-	     (bit) < (size);					\
-	     (bit) = find_next_bit((addr), (size), (bit) + 1))
-
-#define for_each_clear_bit(bit, addr, size) \
-	for ((bit) = find_first_zero_bit((addr), (size));	\
-	     (bit) < (size);					\
-	     (bit) = find_next_zero_bit((addr), (size), (bit) + 1))
-
-/* same as for_each_clear_bit() but use bit as value to start with */
-#define for_each_clear_bit_from(bit, addr, size) \
-	for ((bit) = find_next_zero_bit((addr), (size), (bit));	\
-	     (bit) < (size);					\
-	     (bit) = find_next_zero_bit((addr), (size), (bit) + 1))
-
-/**
- * for_each_set_clump8 - iterate over bitmap for each 8-bit clump with set bits
- * @start: bit offset to start search and to store the current iteration offset
- * @clump: location to store copy of current 8-bit clump
- * @bits: bitmap address to base the search on
- * @size: bitmap size in number of bits
- */
-#define for_each_set_clump8(start, clump, bits, size) \
-	for ((start) = find_first_clump8(&(clump), (bits), (size)); \
-	     (start) < (size); \
-	     (start) = find_next_clump8(&(clump), (bits), (size), (start) + 8))
-
 static inline int get_bitmask_order(unsigned int count)
 {
 	int order;
--- a/include/linux/find.h~include-linux-move-for_each_bit-macros-from-bitopsh-to-findh
+++ a/include/linux/find.h
@@ -279,4 +279,38 @@ unsigned long find_next_bit_le(const voi
 #error "Please fix <asm/byteorder.h>"
 #endif
 
+#define for_each_set_bit(bit, addr, size) \
+	for ((bit) = find_first_bit((addr), (size));		\
+	     (bit) < (size);					\
+	     (bit) = find_next_bit((addr), (size), (bit) + 1))
+
+/* same as for_each_set_bit() but use bit as value to start with */
+#define for_each_set_bit_from(bit, addr, size) \
+	for ((bit) = find_next_bit((addr), (size), (bit));	\
+	     (bit) < (size);					\
+	     (bit) = find_next_bit((addr), (size), (bit) + 1))
+
+#define for_each_clear_bit(bit, addr, size) \
+	for ((bit) = find_first_zero_bit((addr), (size));	\
+	     (bit) < (size);					\
+	     (bit) = find_next_zero_bit((addr), (size), (bit) + 1))
+
+/* same as for_each_clear_bit() but use bit as value to start with */
+#define for_each_clear_bit_from(bit, addr, size) \
+	for ((bit) = find_next_zero_bit((addr), (size), (bit));	\
+	     (bit) < (size);					\
+	     (bit) = find_next_zero_bit((addr), (size), (bit) + 1))
+
+/**
+ * for_each_set_clump8 - iterate over bitmap for each 8-bit clump with set bits
+ * @start: bit offset to start search and to store the current iteration offset
+ * @clump: location to store copy of current 8-bit clump
+ * @bits: bitmap address to base the search on
+ * @size: bitmap size in number of bits
+ */
+#define for_each_set_clump8(start, clump, bits, size) \
+	for ((start) = find_first_clump8(&(clump), (bits), (size)); \
+	     (start) < (size); \
+	     (start) = find_next_clump8(&(clump), (bits), (size), (start) + 8))
+
 #endif /*__LINUX_FIND_H_ */
_

Patches currently in -mm which might be from yury.norov@gmail.com are


