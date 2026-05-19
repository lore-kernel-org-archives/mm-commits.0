Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A14367F40
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 19:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779217304; cv=none; b=iwVLfgVcXX9sz572UJZdraNY3Wa73eOTZY0CmthAp7NNdRC4jrFsnhH/MLFTnpwqC4xX6WcfcMcf9GDltm4SamgczxnF116ICKt0xOOnSHsH4BEObhpKJyP7P8fikuIf7K+poIk246zo7xsYjuc4Qtyo4VPhuMJa4oC44T0cZJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779217304; c=relaxed/simple;
	bh=4RDdbQYB/lBDtg4dyNsvruD98D2fPwXaLVRSknJZlaI=;
	h=Date:To:From:Subject:Message-Id; b=iJaGQUOONZYjEGjqFC/+JptENxvvY28ZwIAJj1q5I11ZGlDUOJllA/yVgKUlqEyjZ7JqXNkuXAry3b3D6cn+9ih+eTlg4UvK3HfbLqktbetZfX9o9QOWRDIryAkxEVIFM/1lOWcaPIBbEfWHrtFE0df9FgHnRhshyhJnQbJ4U3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xRu/kxQh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xRu/kxQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B276B1F000E9;
	Tue, 19 May 2026 19:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779217302;
	bh=gml1zWOsu0XCszp1AYHcUHYoi1P8sScZfdThcqDV7HE=;
	h=Date:To:From:Subject;
	b=xRu/kxQh0xklvM6QZMk5QXP3prhJu5+LH7G27MEQoKh6ufE+K6qMo1hHPm0B6KWd2
	 agfo/sbo1e7Jptt25BOWuWUadb4CotXHY1JPDRs+bnurMciCpuOWMP4T/jpYnhyaUr
	 /fSyJEURALWXjLm8BdcCTPxph1hFeVUIx+deMnKI=
Date: Tue, 19 May 2026 12:01:42 -0700
To: mm-commits@vger.kernel.org,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch removed from -mm tree
Message-Id: <20260519190142.B276B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/cmdline: adjust a few comments to fix kernel-doc -Wreturn warnings
has been removed from the -mm tree.  Its filename was
     lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: lib/cmdline: adjust a few comments to fix kernel-doc -Wreturn warnings
Date: Wed, 13 May 2026 16:44:04 +0300

Fix 'get_option()', 'memparse()' and 'parse_option_str()' comments to
match the commonly used style as suggested by kernel-doc -Wreturn.

Link: https://lore.kernel.org/20260513134407.884033-6-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Charlie Jenkins <thecharlesjenkins@gmail.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cmdline.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/lib/cmdline.c~lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings
+++ a/lib/cmdline.c
@@ -43,7 +43,7 @@ static int get_range(char **str, int *pi
  *	When @pint is NULL the function can be used as a validator of
  *	the current option in the string.
  *
- *	Return values:
+ *	Return:
  *	0 - no int in string
  *	1 - int found, no subsequent comma
  *	2 - int found including a subsequent comma
@@ -145,6 +145,9 @@ EXPORT_SYMBOL(get_options);
  *
  *	Parses a string into a number.  The number stored at @ptr is
  *	potentially suffixed with K, M, G, T, P, E.
+ *
+ *	Return: The value as recognized by simple_strtoull() multiplied
+ *	by the value as specified by suffix, if any.
  */
 
 unsigned long long memparse(const char *ptr, char **retptr)
@@ -205,7 +208,7 @@ EXPORT_SYMBOL(memparse);
  *	This function parses a string containing a comma-separated list of
  *	strings like a=b,c.
  *
- *	Return true if there's such option in the string, or return false.
+ *	Return: True if there's such option in the string or false otherwise.
  */
 bool parse_option_str(const char *str, const char *option)
 {
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

lib-free-pagelist-on-error-in-iov_iter_extract_pages.patch
riscv-add-platform-specific-double-word-shifts-for-riscv32.patch
lib-kunit-add-tests-for-__ashldi3-__ashrdi3-and-__lshrdi3.patch
riscv-fix-building-compressed-efi-image.patch

