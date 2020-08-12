Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1316AC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1E2B2080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266260;
	bh=D7fudLpAMO+VfZLtMyhlcJZaL6ui7lQTCfXiUcnjkIw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=VY5851EidWHWl2i8vVFoSyAtKIzuv+juzMQpp3pgZDQXPALgm6Jz4zyaCOWu5JtgV
	 nMx1UVslPZgGIncYnS9sR+dnuRpLq8CVrK2mmvMTaWdMjKawGtg6ja1kszkX8rje5M
	 GTpqB1T5GCvkN8bcpVcBqbKc6Oz/PCibacmVEzF4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgHLVET (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:04:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHLVET (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:04:19 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A8FA20838;
        Wed, 12 Aug 2020 21:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266258;
        bh=D7fudLpAMO+VfZLtMyhlcJZaL6ui7lQTCfXiUcnjkIw=;
        h=Date:From:To:Subject:From;
        b=HCfTUI3tfnvVCTjQU+NjGxf6kzPJZM53Ilz0+0d4MrzzRb1g07qFCrHOhcovfwYBy
         oSb1vXu+A3JLqd+M+vpJd23tJ7arFyrdcqK/r8b/TOsUbXE2qthcGI+r8SZOpuKubE
         fLzcsrP9bdAaiozp6nctwoe50Ych6fGj8TWDfcLA=
Date:   Wed, 12 Aug 2020 14:04:18 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, eldad@fogrefinery.com,
        geert+renesas@glider.be, kerneldev@karsmulder.nl, mans@mansr.com,
        miguel.ojeda.sandonis@gmail.com, mm-commits@vger.kernel.org,
        pmladek@suse.com
Subject:  [merged]
 kstrto-do-not-describe-simple_strto-as-obsolete-replaced.patch removed from
 -mm tree
Message-ID: <20200812210418.q04o94H4_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kstrto*: do not describe simple_strto*() as obsolete/replaced
has been removed from the -mm tree.  Its filename was
     kstrto-do-not-describe-simple_strto-as-obsolete-replaced.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kars Mulder" <kerneldev@karsmulder.nl>
Subject: kstrto*: do not describe simple_strto*() as obsolete/replaced

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
@@ -346,7 +346,7 @@ int __must_check kstrtoll(const char *s,
  * @res: Where to write the result of the conversion on success.
  *
  * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
- * Used as a replacement for the simple_strtoul(). Return code must be checked.
+ * Preferred over simple_strtoul(). Return code must be checked.
 */
 static inline int __must_check kstrtoul(const char *s, unsigned int base, unsigned long *res)
 {
@@ -374,7 +374,7 @@ static inline int __must_check kstrtoul(
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


