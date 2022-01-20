Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36ABC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358178AbiATCI6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358177AbiATCI5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:08:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A532C061574
        for <mm-commits@vger.kernel.org>; Wed, 19 Jan 2022 18:08:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 348AEB81C96
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC9BC004E1;
        Thu, 20 Jan 2022 02:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644534;
        bh=pof/tUI6vWMm2RTfh4WdraUzs3sV/t+UBe1SdDilCHA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mHSNkNiDzeI8UF/NedoGVEXUfKVWqMsT1qOw0fyhByUgKOcQDVdJc3BhYMYy4PYRa
         K38CWVRLdxdzpv4zFrvIspOB4GkpjFSXPfJeWElbmOQfylgvYx685YLPjpxQhzjFbD
         6nkyHM2D8BNZnHgxnmecTPylztkedmHj2bUY8sBk=
Date:   Wed, 19 Jan 2022 18:08:53 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 22/55] kstrtox: uninline everything
Message-ID: <20220120020853.wkWskYFu7%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: kstrtox: uninline everything

I've made a mistake of looking into lib/kstrtox.o code generation.

The only function remotely performance critical is _parse_integer()
(via /proc/*/map_files/*), everything else is not.

Uninline everything, shrink lib/kstrtox.o by ~20 % !

Space savings on x86_64:

	add/remove: 0/0 grow/shrink: 0/23 up/down: 0/-1269 (-1269 !!!)
	Function                                     old     new   delta
	kstrtoull                                     16      13      -3
	kstrtouint                                    59      48     -11
	kstrtou8                                      60      49     -11
	kstrtou16                                     61      50     -11
	_kstrtoul                                     46      35     -11
	kstrtoull_from_user                           95      83     -12
	kstrtoul_from_user                            95      83     -12
	kstrtoll                                      93      80     -13
	kstrtouint_from_user                         124      83     -41
	kstrtou8_from_user                           125      83     -42
	kstrtou16_from_user                          126      83     -43
	kstrtos8                                     101      50     -51
	kstrtos16                                    102      51     -51
	kstrtoint                                    100      49     -51
	_kstrtol                                      93      35     -58
	kstrtobool_from_user                         156      75     -81
	kstrtoll_from_user                           165      83     -82
	kstrtol_from_user                            165      83     -82
	kstrtoint_from_user                          172      83     -89
	kstrtos8_from_user                           173      83     -90
	kstrtos16_from_user                          174      83     -91
	_parse_integer                               136      10    -126
	_kstrtoull                                   308     101    -207
	Total: Before=3421236, After=3419967, chg -0.04%

Link: https://lkml.kernel.org/r/YZDsFDhHst4m2Pnt@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/lib/kstrtox.c~kstrtox-uninline-everything
+++ a/lib/kstrtox.c
@@ -22,6 +22,7 @@
 
 #include "kstrtox.h"
 
+noinline
 const char *_parse_integer_fixup_radix(const char *s, unsigned int *base)
 {
 	if (*base == 0) {
@@ -47,6 +48,7 @@ const char *_parse_integer_fixup_radix(c
  *
  * Don't you dare use this function.
  */
+noinline
 unsigned int _parse_integer_limit(const char *s, unsigned int base, unsigned long long *p,
 				  size_t max_chars)
 {
@@ -85,6 +87,7 @@ unsigned int _parse_integer_limit(const
 	return rv;
 }
 
+noinline
 unsigned int _parse_integer(const char *s, unsigned int base, unsigned long long *p)
 {
 	return _parse_integer_limit(s, base, p, INT_MAX);
@@ -125,6 +128,7 @@ static int _kstrtoull(const char *s, uns
  * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
  * Preferred over simple_strtoull(). Return code must be checked.
  */
+noinline
 int kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 {
 	if (s[0] == '+')
@@ -148,6 +152,7 @@ EXPORT_SYMBOL(kstrtoull);
  * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
  * Preferred over simple_strtoll(). Return code must be checked.
  */
+noinline
 int kstrtoll(const char *s, unsigned int base, long long *res)
 {
 	unsigned long long tmp;
@@ -219,6 +224,7 @@ EXPORT_SYMBOL(_kstrtol);
  * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
  * Preferred over simple_strtoul(). Return code must be checked.
  */
+noinline
 int kstrtouint(const char *s, unsigned int base, unsigned int *res)
 {
 	unsigned long long tmp;
@@ -249,6 +255,7 @@ EXPORT_SYMBOL(kstrtouint);
  * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
  * Preferred over simple_strtol(). Return code must be checked.
  */
+noinline
 int kstrtoint(const char *s, unsigned int base, int *res)
 {
 	long long tmp;
@@ -264,6 +271,7 @@ int kstrtoint(const char *s, unsigned in
 }
 EXPORT_SYMBOL(kstrtoint);
 
+noinline
 int kstrtou16(const char *s, unsigned int base, u16 *res)
 {
 	unsigned long long tmp;
@@ -279,6 +287,7 @@ int kstrtou16(const char *s, unsigned in
 }
 EXPORT_SYMBOL(kstrtou16);
 
+noinline
 int kstrtos16(const char *s, unsigned int base, s16 *res)
 {
 	long long tmp;
@@ -294,6 +303,7 @@ int kstrtos16(const char *s, unsigned in
 }
 EXPORT_SYMBOL(kstrtos16);
 
+noinline
 int kstrtou8(const char *s, unsigned int base, u8 *res)
 {
 	unsigned long long tmp;
@@ -309,6 +319,7 @@ int kstrtou8(const char *s, unsigned int
 }
 EXPORT_SYMBOL(kstrtou8);
 
+noinline
 int kstrtos8(const char *s, unsigned int base, s8 *res)
 {
 	long long tmp;
@@ -333,6 +344,7 @@ EXPORT_SYMBOL(kstrtos8);
  * [oO][NnFf] for "on" and "off". Otherwise it will return -EINVAL.  Value
  * pointed to by res is updated upon finding a match.
  */
+noinline
 int kstrtobool(const char *s, bool *res)
 {
 	if (!s)
_
