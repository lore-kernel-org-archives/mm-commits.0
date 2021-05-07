Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6748C43460
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 778F661289
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhEGBEt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:04:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230499AbhEGBEt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:04:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19F74610FA;
        Fri,  7 May 2021 01:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349430;
        bh=3f4ck7rVcuaK1FUbu7+7gFcJX+CsZrCtN2rIAwwo9Aw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Go7SxsbbWJ+ISlaWCQGzqUfgtlBR71GT37kHyKV4nQWt5Vw//B+boU+LbyfF1b1qh
         jO72Uunu9yhdmXt+JaHIIscwuRR+wS/ABsLviKE4cGeTXb/CXaaHqh5FEedNs9uKpB
         iK4NKr3wmmUTSjI0bxv62teyB8vf/kKiss6DIGMw=
Date:   Thu, 06 May 2021 18:03:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dhowells@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 34/91] lib: parser: clean up kernel-doc
Message-ID: <20210507010349.bF17Bzuxd%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
