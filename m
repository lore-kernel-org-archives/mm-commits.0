Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A164C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CCE721744
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596228585;
	bh=g0vHIYxaF6Z8m2SOfIg0YgMTmVHZ+V7/WkXyUXqGnTc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=2eyD7Zz1zoWaKz1sDTJs9EPATyxknHzlt3bxW+7Aw2ZooS9dytsbuGMCrZEB3rmrU
	 3qwSXllgEXNNIIGm4XpS6JS9OedqjedKweABgYZ/dqlE2iaEE/TshEq7wQCoYYBzoO
	 5/l/hxoSYFug4fFlZBqoaRtCxE9Qm8kOKS9i2MqM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgGaUtp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 16:49:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbgGaUto (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 16:49:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0D4722B3F;
        Fri, 31 Jul 2020 20:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596228584;
        bh=g0vHIYxaF6Z8m2SOfIg0YgMTmVHZ+V7/WkXyUXqGnTc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=srsEIeTY6dEJ1BgieC+12K2EHSXTSznzqqsvniFtuPrMLLxn6MmVWIG4drUzoeG/2
         2YfntWFzGNzxuGWdYI6fdo8d8n5XVgaMQzW94AV1ODQYsQIt64xB8QYdBdMBFzAGPM
         b/zaI2KDH5u6Hm0t+iOQ7qAMdMfteGzP49PzkkeI=
Date:   Fri, 31 Jul 2020 13:49:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     andriy.shevchenko@linux.intel.com, eldad@fogrefinery.com,
        geert+renesas@glider.be, kerneldev@karsmulder.nl, mans@mansr.com,
        miguel.ojeda.sandonis@gmail.com, mm-commits@vger.kernel.org,
        pmladek@suse.com
Subject:  +
 kstrto-do-not-describe-simple_strto-as-obsolete-replaced.patch added to -mm
 tree
Message-ID: <20200731204943.O1mBHFjSH%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kstrto*: do not  describe simple_strto*() as  obsolete/replaced
has been added to the -mm tree.  Its filename is
     kstrto-do-not-describe-simple_strto-as-obsolete-replaced.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kstrto-do-not-describe-simple_strto-as-obsolete-replaced.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kstrto-do-not-describe-simple_strto-as-obsolete-replaced.patch

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
Subject: kstrto*: do not  describe simple_strto*() as  obsolete/replaced

The documentation of the kstrto*() functions describes kstrto*() as
"replacements" of the "obsolete" simple_strto*() functions.  Both of these
terms are inaccurate: they're not replacements because they have different
behaviour, and the simple_strto*() are not obsolete because there are
cases where they have benefits over kstrto*().

Remove usage of the terms "replacement" and "obsolete" in reference to
simple_strto*(), and instead use the term "preferred over".

Link: http://lkml.kernel.org/r/29b9-5f234c80-13-4e3aa200@244003027
Fixes: 4c925d6031f71 ("kstrto*: add documentation")
Fixes: 885e68e8b7b13 ("kernel.h: update comment about simple_strto<foo>() functions")
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
 lib/kstrtox.c          |   12 ++++--------
 2 files changed, 6 insertions(+), 10 deletions(-)

--- a/include/linux/kernel.h~kstrto-do-not-describe-simple_strto-as-obsolete-replaced
+++ a/include/linux/kernel.h
@@ -345,7 +345,7 @@ int __must_check kstrtoll(const char *s,
  * @res: Where to write the result of the conversion on success.
  *
  * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the simple_strtoul(). Return code must be checked.
+ * Preferred over simple_strtoul(). Return code must be checked.
 */
 static inline int __must_check kstrtoul(const char *s, unsigned int base, unsigned long *res)
 {
@@ -373,7 +373,7 @@ static inline int __must_check kstrtoul(
  * @res: Where to write the result of the conversion on success.
  *
  * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the simple_strtol(). Return code must be checked.
+ * Preferred over simple_strtol(). Return code must be checked.
  */
 static inline int __must_check kstrtol(const char *s, unsigned int base, long *res)
 {
--- a/lib/kstrtox.c~kstrto-do-not-describe-simple_strto-as-obsolete-replaced
+++ a/lib/kstrtox.c
@@ -115,8 +115,7 @@ static int _kstrtoull(const char *s, uns
  * @res: Where to write the result of the conversion on success.
  *
  * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the obsolete simple_strtoull(). Return code must
- * be checked.
+ * Preferred over simple_strtoull(). Return code must be checked.
  */
 int kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 {
@@ -139,8 +138,7 @@ EXPORT_SYMBOL(kstrtoull);
  * @res: Where to write the result of the conversion on success.
  *
  * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the obsolete simple_strtoll(). Return code must
- * be checked.
+ * Preferred over simple_strtoll(). Return code must be checked.
  */
 int kstrtoll(const char *s, unsigned int base, long long *res)
 {
@@ -211,8 +209,7 @@ EXPORT_SYMBOL(_kstrtol);
  * @res: Where to write the result of the conversion on success.
  *
  * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the obsolete simple_strtoul(). Return code must
- * be checked.
+ * Preferred over simple_strtoul(). Return code must be checked.
  */
 int kstrtouint(const char *s, unsigned int base, unsigned int *res)
 {
@@ -242,8 +239,7 @@ EXPORT_SYMBOL(kstrtouint);
  * @res: Where to write the result of the conversion on success.
  *
  * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the obsolete simple_strtol(). Return code must
- * be checked.
+ * Preferred over simple_strtol(). Return code must be checked.
  */
 int kstrtoint(const char *s, unsigned int base, int *res)
 {
_

Patches currently in -mm which might be from kerneldev@karsmulder.nl are

kstrto-correct-documentation-references-to-simple_strto.patch
kstrto-do-not-describe-simple_strto-as-obsolete-replaced.patch

