Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFEA8C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CC8722B3F
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596228582;
	bh=2W9RrKkmgCMnfw6MZWVv2b/G3INjBbRFOUpygmuh3ZE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=NCYW1IgIyGZLk33mgEIp1nQB7I10Qfz1qjDhdE8+K/0CQs4Pt7pjocI+7vP6DnWYp
	 71lbYBzDtMiBNeOEYVsdH5y9V4lZGUh0cv1kSBmxmCKYass2OEMbzoJMBJY7Z27f6j
	 zPCqxxcA43X4yj9SvZLXhdiRbxcTHFHRCnVJhF80=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgGaUtm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 16:49:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbgGaUtm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 16:49:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFF8121744;
        Fri, 31 Jul 2020 20:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596228581;
        bh=2W9RrKkmgCMnfw6MZWVv2b/G3INjBbRFOUpygmuh3ZE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PC9BmInj4nEWHGNSt9XYyIJZ924biA57+tIfRsoADp/UDuv8q7E2Wgrd/JB/N5bOb
         zIbc3Jas6mEo4JngyQNSUGO+CYS86UiYTGsaY84Uo48dYTTcHmhtakDn6i75DuLx9+
         GK2mi9220HIb4Acy9yNWpUa1evKbheWGY1b/fncQ=
Date:   Fri, 31 Jul 2020 13:49:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     andriy.shevchenko@linux.intel.com, eldad@fogrefinery.com,
        geert+renesas@glider.be, kerneldev@karsmulder.nl, mans@mansr.com,
        miguel.ojeda.sandonis@gmail.com, mm-commits@vger.kernel.org,
        pmladek@suse.com
Subject:  +
 kstrto-correct-documentation-references-to-simple_strto.patch added to -mm
 tree
Message-ID: <20200731204940.YFZdNFPHn%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kstrto*: correct  documentation references to simple_strto*()
has been added to the -mm tree.  Its filename is
     kstrto-correct-documentation-references-to-simple_strto.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kstrto-correct-documentation-references-to-simple_strto.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kstrto-correct-documentation-references-to-simple_strto.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kars Mulder" <kerneldev@karsmulder.nl>
Subject: kstrto*: correct  documentation references to simple_strto*()

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
@@ -345,7 +345,7 @@ int __must_check kstrtoll(const char *s,
  * @res: Where to write the result of the conversion on success.
  *
  * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the simple_strtoull. Return code must be checked.
+ * Used as a replacement for the simple_strtoul(). Return code must be checked.
 */
 static inline int __must_check kstrtoul(const char *s, unsigned int base, unsigned long *res)
 {
@@ -373,7 +373,7 @@ static inline int __must_check kstrtoul(
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

Patches currently in -mm which might be from kerneldev@karsmulder.nl are

kstrto-correct-documentation-references-to-simple_strto.patch
kstrto-do-not-describe-simple_strto-as-obsolete-replaced.patch

