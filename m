Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4BF5C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  7 Apr 2021 03:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B175613BD
	for <mm-commits@archiver.kernel.org>; Wed,  7 Apr 2021 03:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbhDGD4N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Apr 2021 23:56:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233392AbhDGD4M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Apr 2021 23:56:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C75646139E;
        Wed,  7 Apr 2021 03:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617767764;
        bh=ilh/WYXmRqLq3bUATeC14/Yq+jP82C0SkdN2mQjo3Cg=;
        h=Date:From:To:Subject:From;
        b=PXfJQqcQsrCIED7eVCo6jou51Dht9hLt+2kMbH/QfxC77b4K0wvaHo0kywQCaikpz
         y6iIQ+gcUKhOiFstYJUBrbuJa6Fy2bjBdJHhJQDnBrJoq/BZNjjRdnDSPEV0zCi2ta
         WrTX8VuchZkJrmw2cDu4o0t+xyvIUbjzgYkfKmEA=
Date:   Tue, 06 Apr 2021 20:56:03 -0700
From:   akpm@linux-foundation.org
To:     dhowells@redhat.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, viro@zeniv.linux.org.uk
Subject:  + lib-parser-clean-up-kernel-doc.patch added to -mm tree
Message-ID: <20210407035603.tVx0S6Vdd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: parser: clean up kernel-doc
has been added to the -mm tree.  Its filename is
     lib-parser-clean-up-kernel-doc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-parser-clean-up-kernel-doc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-parser-clean-up-kernel-doc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: parser: clean up kernel-doc

Mark match_uint() as kernel-doc notation since it is already fully
annotated as such.  Use % prefix on constants in kernel-doc comments. 
Convert function return descriptions to use the "Return:" kernel-doc
notation.

Link: https://lkml.kernel.org/r/20210407034514.5651-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/parser.c |   61 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 23 deletions(-)

--- a/lib/parser.c~lib-parser-clean-up-kernel-doc
+++ a/lib/parser.c
@@ -98,7 +98,7 @@ static int match_one(char *s, const char
  * locations.
  *
  * Description: Detects which if any of a set of token strings has been passed
- * to it. Tokens can include up to MAX_OPT_ARGS instances of basic c-style
+ * to it. Tokens can include up to %MAX_OPT_ARGS instances of basic c-style
  * format identifiers which will be taken into account when matching the
  * tokens, and whose locations will be returned in the @args array.
  */
@@ -120,8 +120,10 @@ EXPORT_SYMBOL(match_token);
  * @base: base to use when converting string
  *
  * Description: Given a &substring_t and a base, attempts to parse the substring
- * as a number in that base. On success, sets @result to the integer represented
- * by the string and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
+ * as a number in that base.
+ *
+ * Return: On success, sets @result to the integer represented by the
+ * string and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
  */
 static int match_number(substring_t *s, int *result, int base)
 {
@@ -153,8 +155,10 @@ static int match_number(substring_t *s,
  * @base: base to use when converting string
  *
  * Description: Given a &substring_t and a base, attempts to parse the substring
- * as a number in that base. On success, sets @result to the integer represented
- * by the string and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
+ * as a number in that base.
+ *
+ * Return: On success, sets @result to the integer represented by the
+ * string and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
  */
 static int match_u64int(substring_t *s, u64 *result, int base)
 {
@@ -178,9 +182,10 @@ static int match_u64int(substring_t *s,
  * @s: substring_t to be scanned
  * @result: resulting integer on success
  *
- * Description: Attempts to parse the &substring_t @s as a decimal integer. On
- * success, sets @result to the integer represented by the string and returns 0.
- * Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
+ * Description: Attempts to parse the &substring_t @s as a decimal integer.
+ *
+ * Return: On success, sets @result to the integer represented by the string
+ * and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
  */
 int match_int(substring_t *s, int *result)
 {
@@ -188,14 +193,15 @@ int match_int(substring_t *s, int *resul
 }
 EXPORT_SYMBOL(match_int);
 
-/*
+/**
  * match_uint - scan a decimal representation of an integer from a substring_t
  * @s: substring_t to be scanned
  * @result: resulting integer on success
  *
- * Description: Attempts to parse the &substring_t @s as a decimal integer. On
- * success, sets @result to the integer represented by the string and returns 0.
- * Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
+ * Description: Attempts to parse the &substring_t @s as a decimal integer.
+ *
+ * Return: On success, sets @result to the integer represented by the string
+ * and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
  */
 int match_uint(substring_t *s, unsigned int *result)
 {
@@ -217,9 +223,10 @@ EXPORT_SYMBOL(match_uint);
  * @result: resulting unsigned long long on success
  *
  * Description: Attempts to parse the &substring_t @s as a long decimal
- * integer. On success, sets @result to the integer represented by the
- * string and returns 0.
- * Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
+ * integer.
+ *
+ * Return: On success, sets @result to the integer represented by the string
+ * and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
  */
 int match_u64(substring_t *s, u64 *result)
 {
@@ -232,9 +239,10 @@ EXPORT_SYMBOL(match_u64);
  * @s: substring_t to be scanned
  * @result: resulting integer on success
  *
- * Description: Attempts to parse the &substring_t @s as an octal integer. On
- * success, sets @result to the integer represented by the string and returns
- * 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
+ * Description: Attempts to parse the &substring_t @s as an octal integer.
+ *
+ * Return: On success, sets @result to the integer represented by the string
+ * and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
  */
 int match_octal(substring_t *s, int *result)
 {
@@ -248,8 +256,9 @@ EXPORT_SYMBOL(match_octal);
  * @result: resulting integer on success
  *
  * Description: Attempts to parse the &substring_t @s as a hexadecimal integer.
- * On success, sets @result to the integer represented by the string and
- * returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
+ *
+ * Return: On success, sets @result to the integer represented by the string
+ * and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
  */
 int match_hex(substring_t *s, int *result)
 {
@@ -263,10 +272,11 @@ EXPORT_SYMBOL(match_hex);
  * @str: the string to be parsed
  *
  * Description: Parse the string @str to check if matches wildcard
- * pattern @pattern. The pattern may contain two type wildcardes:
+ * pattern @pattern. The pattern may contain two types of wildcards:
  *   '*' - matches zero or more characters
  *   '?' - matches one character
- * If it's matched, return true, else return false.
+ *
+ * Return: If the @str matches the @pattern, return true, else return false.
  */
 bool match_wildcard(const char *pattern, const char *str)
 {
@@ -316,7 +326,9 @@ EXPORT_SYMBOL(match_wildcard);
  *
  * Description: Copy the characters in &substring_t @src to the
  * c-style string @dest.  Copy no more than @size - 1 characters, plus
- * the terminating NUL.  Return length of @src.
+ * the terminating NUL.
+ *
+ * Return: length of @src.
  */
 size_t match_strlcpy(char *dest, const substring_t *src, size_t size)
 {
@@ -338,6 +350,9 @@ EXPORT_SYMBOL(match_strlcpy);
  * Description: Allocates and returns a string filled with the contents of
  * the &substring_t @s. The caller is responsible for freeing the returned
  * string with kfree().
+ *
+ * Return: the address of the newly allocated NUL-terminated string or
+ * %NULL on error.
  */
 char *match_strdup(const substring_t *s)
 {
_

Patches currently in -mm which might be from rdunlap@infradead.org are

lib-parser-clean-up-kernel-doc.patch

