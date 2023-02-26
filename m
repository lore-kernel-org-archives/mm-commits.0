Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13582C6FA8E
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 05:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjBZFSU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 00:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBZFST (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 00:18:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE8FFF26
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 21:18:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BEA4B80884
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 05:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F19C433EF;
        Sun, 26 Feb 2023 05:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677388695;
        bh=AQVNzN6/kzP4DvWdHllXdxjMhkFWbXYyHIlbnQWpnjA=;
        h=Date:To:From:Subject:From;
        b=LFIu2rfm3dNXAlrxnJ0AfY8PDoz0cLau3z5eeFGxR7fQyQsyzN213ndcyHAa6I3k3
         sPvGRmI3kP7l58U9FWw47CCSleK+3jFAWZKuO8a618TcXWVHMMQpK8d2h0mbLw1Olf
         MNZvj7dS2N9Y6pJNHGZEtHBj2oqJ7Gioj9u21vME=
Date:   Sat, 25 Feb 2023 21:18:15 -0800
To:     mm-commits@vger.kernel.org, yukuai1@huaweicloud.com, tj@kernel.org,
        lilingfeng3@huawei.com, ebiggers@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-parser-update-documentation-for-match_number-functions.patch added to mm-hotfixes-unstable branch
Message-Id: <20230226051815.C3F19C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: parser: update documentation for match_NUMBER functions
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-parser-update-documentation-for-match_number-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-parser-update-documentation-for-match_number-functions.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
+++ b/lib/parser.c
@@ -133,7 +133,7 @@ EXPORT_SYMBOL(match_token);
  * as a number in that base.
  *
  * Return: On success, sets @result to the integer represented by the
- * string and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
+ * string and returns 0. Returns -EINVAL or -ERANGE on failure.
  */
 static int match_number(substring_t *s, int *result, int base)
 {
@@ -165,7 +165,7 @@ static int match_number(substring_t *s, int *result, int base)
  * as a number in that base.
  *
  * Return: On success, sets @result to the integer represented by the
- * string and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
+ * string and returns 0. Returns -EINVAL or -ERANGE on failure.
  */
 static int match_u64int(substring_t *s, u64 *result, int base)
 {
@@ -189,7 +189,7 @@ static int match_u64int(substring_t *s, u64 *result, int base)
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

lib-parser-update-documentation-for-match_number-functions.patch

