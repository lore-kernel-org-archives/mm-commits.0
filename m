Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E76C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36A3C2076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196095;
	bh=j6ZEIeWrbIgKIFXNJraz3kaCQlEUOk4n/4tEkuH13fQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=SVsgzo2HEv9R1/uKKErceZfd7PNpTpIB0QiIuIaJ/pjuSUQxIBEWV0CCrItpgLWMi
	 HRwN+Z641Sb/j4XxIGNH8w8RYsjiILh2Cco6I9FGk3L7ltkb3IBXwt1uRjuIAExcHg
	 bgh8ZMFr0Vem4J3PAI+2I44pTTKYhBH7WL0XhKwk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgHLBez (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:34:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBey (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:34:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8B7A207DA;
        Wed, 12 Aug 2020 01:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196094;
        bh=j6ZEIeWrbIgKIFXNJraz3kaCQlEUOk4n/4tEkuH13fQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ubOsADVVld4cZsLGJWWFA9PUtG9cmISHEwSpnyGw96sLVGZIfkQ6Ai5hHAXqtCEy/
         MSDkKnFmsBoKQcWU/0cYB6ZxS1EdItciXQkrtnQcLcezb70Ijtb5bZ1Qm4BRp4B2PL
         Z0hoSJTHt+BiHByrOlhawUqm4dCwd5ul1FsijKpY=
Date:   Tue, 11 Aug 2020 18:34:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        eldad@fogrefinery.com, geert+renesas@glider.be,
        kerneldev@karsmulder.nl, linux-mm@kvack.org, mans@mansr.com,
        miguel.ojeda.sandonis@gmail.com, mm-commits@vger.kernel.org,
        pmladek@suse.com, torvalds@linux-foundation.org
Subject:  [patch 088/165] kstrto*: correct documentation references
 to simple_strto*()
Message-ID: <20200812013453.nvffuciLN%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Kars Mulder" <kerneldev@karsmulder.nl>
Subject: kstrto*: correct documentation references to simple_strto*()

The documentation of the kstrto*() functions reference the simple_strtoull
function by "used as a replacement for [the obsolete] simple_strtoull". 
All these functions describes themselves as replacements for the function
simple_strtoull, even though a function like kstrtol() would be more aptly
described as a replacement of simple_strtol().

Fix these references by making the documentation of kstrto*() reference
the closest simple_strto*() equivalent available.  The functions
kstrto[u]int() do not have direct simple_strto[u]int() equivalences, so
these are made to refer to simple_strto[u]l() instead.

Furthermore, add parentheses after function names, as is standard in
kernel documentation.

Link: http://lkml.kernel.org/r/1ee1-5f234c00-f3-165a6440@234394593
Fixes: 4c925d6031f71 ("kstrto*: add documentation")
Signed-off-by: Kars Mulder <kerneldev@karsmulder.nl>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Eldad Zack <eldad@fogrefinery.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Mans Rullgard <mans@mansr.com>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    4 ++--
 lib/kstrtox.c          |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/kernel.h~kstrto-correct-documentation-references-to-simple_strto
+++ a/include/linux/kernel.h
@@ -346,7 +346,7 @@ int __must_check kstrtoll(const char *s,
  * @res: Where to write the result of the conversion on success.
  *
  * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the simple_strtoull. Return code must be checked.
+ * Used as a replacement for the simple_strtoul(). Return code must be checked.
 */
 static inline int __must_check kstrtoul(const char *s, unsigned int base, unsigned long *res)
 {
@@ -374,7 +374,7 @@ static inline int __must_check kstrtoul(
  * @res: Where to write the result of the conversion on success.
  *
  * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the simple_strtoull. Return code must be checked.
+ * Used as a replacement for the simple_strtol(). Return code must be checked.
  */
 static inline int __must_check kstrtol(const char *s, unsigned int base, long *res)
 {
--- a/lib/kstrtox.c~kstrto-correct-documentation-references-to-simple_strto
+++ a/lib/kstrtox.c
@@ -115,7 +115,7 @@ static int _kstrtoull(const char *s, uns
  * @res: Where to write the result of the conversion on success.
  *
  * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the obsolete simple_strtoull. Return code must
+ * Used as a replacement for the obsolete simple_strtoull(). Return code must
  * be checked.
  */
 int kstrtoull(const char *s, unsigned int base, unsigned long long *res)
@@ -139,7 +139,7 @@ EXPORT_SYMBOL(kstrtoull);
  * @res: Where to write the result of the conversion on success.
  *
  * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the obsolete simple_strtoull. Return code must
+ * Used as a replacement for the obsolete simple_strtoll(). Return code must
  * be checked.
  */
 int kstrtoll(const char *s, unsigned int base, long long *res)
@@ -211,7 +211,7 @@ EXPORT_SYMBOL(_kstrtol);
  * @res: Where to write the result of the conversion on success.
  *
  * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the obsolete simple_strtoull. Return code must
+ * Used as a replacement for the obsolete simple_strtoul(). Return code must
  * be checked.
  */
 int kstrtouint(const char *s, unsigned int base, unsigned int *res)
@@ -242,7 +242,7 @@ EXPORT_SYMBOL(kstrtouint);
  * @res: Where to write the result of the conversion on success.
  *
  * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the obsolete simple_strtoull. Return code must
+ * Used as a replacement for the obsolete simple_strtol(). Return code must
  * be checked.
  */
 int kstrtoint(const char *s, unsigned int base, int *res)
_
