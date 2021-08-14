Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24492C432BE
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 22:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DA6260F4B
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 22:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbhHNWSZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Aug 2021 18:18:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233549AbhHNWSX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 14 Aug 2021 18:18:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9700960F48;
        Sat, 14 Aug 2021 22:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628979474;
        bh=ysGvDCDbogO3RDH0MfENq9rHfImMUb2dhe/1rS8HYcQ=;
        h=Date:From:To:Subject:From;
        b=pVbGImnsQCaMhGOzkCAuX55oXwstdgAaICZNuphAPc3b8ebZvmuKQu38rsGoM2fP/
         uAxJYZlX0HuHc6sZiUipS/HFjVzteEHkbKbigmK90sO1uFeNBSqGZSu5/9R68r3rP2
         Df5V7973aOSh92Q+eHAiBBZWIDzRUBC2pBBDD1zU=
Date:   Sat, 14 Aug 2021 15:17:54 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wsa+renesas@sang-engineering.com,
        will@kernel.org, ulf.hansson@linaro.org, lkp@intel.com,
        jolsa@redhat.com, dennis@kernel.org,
        andriy.shevchenko@linux.intel.com, alobakin@pm.me,
        aklimov@redhat.com, yury.norov@gmail.com
Subject:  + vsprintf-rework-bitmap_list_string.patch added to -mm
 tree
Message-ID: <20210814221754.Cpdtv%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vsprintf: rework bitmap_list_string
has been added to the -mm tree.  Its filename is
     vsprintf-rework-bitmap_list_string.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/vsprintf-rework-bitmap_list_string.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/vsprintf-rework-bitmap_list_string.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: vsprintf: rework bitmap_list_string

bitmap_list_string() is very ineffective when printing bitmaps with long
ranges of set bits because it calls find_next_bit for each bit in the
bitmap.  We can do better by detecting ranges of set bits.

In my environment, before/after is 943008/31008 ns.

Link: https://lkml.kernel.org/r/20210814211713.180533-18-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

--- a/lib/vsprintf.c~vsprintf-rework-bitmap_list_string
+++ a/lib/vsprintf.c
@@ -1241,20 +1241,13 @@ char *bitmap_list_string(char *buf, char
 			 struct printf_spec spec, const char *fmt)
 {
 	int nr_bits = max_t(int, spec.field_width, 0);
-	/* current bit is 'cur', most recently seen range is [rbot, rtop] */
-	int cur, rbot, rtop;
 	bool first = true;
+	int rbot, rtop;
 
 	if (check_pointer(&buf, end, bitmap, spec))
 		return buf;
 
-	rbot = cur = find_first_bit(bitmap, nr_bits);
-	while (cur < nr_bits) {
-		rtop = cur;
-		cur = find_next_bit(bitmap, nr_bits, cur + 1);
-		if (cur < nr_bits && cur <= rtop + 1)
-			continue;
-
+	for_each_set_bitrange(rbot, rtop, bitmap, nr_bits) {
 		if (!first) {
 			if (buf < end)
 				*buf = ',';
@@ -1263,15 +1256,12 @@ char *bitmap_list_string(char *buf, char
 		first = false;
 
 		buf = number(buf, end, rbot, default_dec_spec);
-		if (rbot < rtop) {
-			if (buf < end)
-				*buf = '-';
-			buf++;
-
-			buf = number(buf, end, rtop, default_dec_spec);
-		}
+		if (rtop == rbot + 1)
+			continue;
 
-		rbot = cur;
+		if (buf < end)
+			*buf = '-';
+		buf = number(++buf, end, rtop - 1, default_dec_spec);
 	}
 	return buf;
 }
_

Patches currently in -mm which might be from yury.norov@gmail.com are

bitops-protect-find_first_zero_bit-properly.patch
bitops-move-find_bit__le-functions-from-leh-to-findh.patch
include-move-findh-from-asm_generic-to-linux.patch
arch-remove-generic_find_first_bit-entirely.patch
lib-add-find_first_and_bit.patch
cpumask-use-find_first_and_bit.patch
all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate.patch
tools-sync-tools-bitmap-with-mother-linux.patch
cpumask-replace-cpumask_next_-with-cpumask_first_-where-appropriate.patch
include-linux-move-for_each_bit-macros-from-bitopsh-to-findh.patch
find-micro-optimize-for_each_setclear_bit.patch
replace-for_each__bit_from-with-for_each__bit-where-appropriate.patch
mm-percpu-micro-optimize-pcpu_is_populated.patch
bitmap-unify-find_bit-operations.patch
lib-bitmap-add-performance-test-for-bitmap_print_to_pagebuf.patch
vsprintf-rework-bitmap_list_string.patch

