Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1BEC7EE32
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 05:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjCCFzp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 00:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjCCFzm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 00:55:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7402B288
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 21:55:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24FC6B8160C
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 05:55:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0E6C433D2;
        Fri,  3 Mar 2023 05:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677822900;
        bh=AJAESOKmQoTK+OQXX+Jg6GrHT2zWqoShS/k9/bXFWv0=;
        h=Date:To:From:Subject:From;
        b=S8qOnGvBS+ssvsJe0VprcyL/08g9HEh21Fp/EKvP0lGKY4127MSrO+/Pt9SZH4Wva
         YqpjyQw+b6SzkbH8uoTz9YGsEa5skMR/sl1IYqURpqgmpEhW4alQJnvpS9eN4ldu/V
         LOAgd2C+OA8/ZhXNrA5S7RNFiXL9fPUfQ6auAzgc=
Date:   Thu, 02 Mar 2023 21:55:00 -0800
To:     mm-commits@vger.kernel.org, yukuai1@huaweicloud.com, tj@kernel.org,
        lilingfeng3@huawei.com, ebiggers@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-parser-update-documentation-for-match_number-functions.patch removed from -mm tree
Message-Id: <20230303055500.AB0E6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib: parser: update documentation for match_NUMBER functions
has been removed from the -mm tree.  Its filename was
     lib-parser-update-documentation-for-match_number-functions.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: lib: parser: update documentation for match_NUMBER functions
Date: Thu, 23 Feb 2023 20:26:18 -0800

commit 67222c4ba8af ("lib: parser: optimize match_NUMBER apis to use local
array") removed -ENOMEM as a possible return value, so update the comments
accordingly.

Link: https://lkml.kernel.org/r/20230224042618.9092-1-ebiggers@kernel.org
Fixes: 67222c4ba8af ("lib: parser: optimize match_NUMBER apis to use local array")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: Li Lingfeng <lilingfeng3@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/parser.c~lib-parser-update-documentation-for-match_number-functions
+++ a/lib/parser.c
@@ -133,7 +133,7 @@ EXPORT_SYMBOL(match_token);
  * as a number in that base.
  *
  * Return: On success, sets @result to the integer represented by the
- * string and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
+ * string and returns 0. Returns -EINVAL or -ERANGE on failure.
  */
 static int match_number(substring_t *s, int *result, int base)
 {
@@ -165,7 +165,7 @@ static int match_number(substring_t *s,
  * as a number in that base.
  *
  * Return: On success, sets @result to the integer represented by the
- * string and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
+ * string and returns 0. Returns -EINVAL or -ERANGE on failure.
  */
 static int match_u64int(substring_t *s, u64 *result, int base)
 {
@@ -189,7 +189,7 @@ static int match_u64int(substring_t *s,
  * Description: Attempts to parse the &substring_t @s as a decimal integer.
  *
  * Return: On success, sets @result to the integer represented by the string
- * and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
+ * and returns 0. Returns -EINVAL or -ERANGE on failure.
  */
 int match_int(substring_t *s, int *result)
 {
@@ -205,7 +205,7 @@ EXPORT_SYMBOL(match_int);
  * Description: Attempts to parse the &substring_t @s as a decimal integer.
  *
  * Return: On success, sets @result to the integer represented by the string
- * and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
+ * and returns 0. Returns -EINVAL or -ERANGE on failure.
  */
 int match_uint(substring_t *s, unsigned int *result)
 {
@@ -228,7 +228,7 @@ EXPORT_SYMBOL(match_uint);
  * integer.
  *
  * Return: On success, sets @result to the integer represented by the string
- * and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
+ * and returns 0. Returns -EINVAL or -ERANGE on failure.
  */
 int match_u64(substring_t *s, u64 *result)
 {
@@ -244,7 +244,7 @@ EXPORT_SYMBOL(match_u64);
  * Description: Attempts to parse the &substring_t @s as an octal integer.
  *
  * Return: On success, sets @result to the integer represented by the string
- * and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
+ * and returns 0. Returns -EINVAL or -ERANGE on failure.
  */
 int match_octal(substring_t *s, int *result)
 {
@@ -260,7 +260,7 @@ EXPORT_SYMBOL(match_octal);
  * Description: Attempts to parse the &substring_t @s as a hexadecimal integer.
  *
  * Return: On success, sets @result to the integer represented by the string
- * and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
+ * and returns 0. Returns -EINVAL or -ERANGE on failure.
  */
 int match_hex(substring_t *s, int *result)
 {
_

Patches currently in -mm which might be from ebiggers@google.com are


