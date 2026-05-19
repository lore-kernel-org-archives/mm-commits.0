Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65FF3FC5DE
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 19:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779217987; cv=none; b=uzSjLJplOI62o301YZcjo0g8F+gcJzVgOjtdLdwHpdckA5tfRST5zVVlNWbqmaHjVcixvfQ/OpyopPqP++Wd74/ekqQZT+QPjrJVI2WCXp68a7mxnnuC+5Nvvfsv4okW1sU6pvtyFalyk6SP79TV54AJc/zx9sY0HQpRVqCY6K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779217987; c=relaxed/simple;
	bh=GEiwJYtOLAKRwO6R9BrS4tbrOey2zAYLg9aNZl65E04=;
	h=Date:To:From:Subject:Message-Id; b=FBeLSnabX+AzEx2naTYsGMdThGmK3punPbBBuXOvaC/HgnIMVWXKINMjBpPLo6jDzJ26v150aRvWBx+la1k+MQlMIxypljKcFKEOrWVnWDz/l//SFk9Mxjru8E3xaz1BsHDV10qsELy3nrFmGh9RGQr5qi9CHT/4JTmzD3TlGsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ekuUmcQo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ekuUmcQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC811F000E9;
	Tue, 19 May 2026 19:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779217986;
	bh=UZNJfSyKtGGPbk7uGPCxx1R2GsZJj0b9i72kg9vD3/I=;
	h=Date:To:From:Subject;
	b=ekuUmcQoLTgC45Kt0j2Xmc3XRKFIo9s3XriiQ6WYgWooHOsBjUbdqQ1znDVasc9kw
	 WRJMnc3jF10NUZ+d5tAnx0AFmdUtHPZRBDZo1+svxXEEtFiWi+hnSZ1OAyo6RGqO2u
	 7gkXEwTHldsmn8HhF3zx+nAyJRT3FktyMMUAgnAM=
Date: Tue, 19 May 2026 12:13:05 -0700
To: mm-commits@vger.kernel.org,thecharlesjenkins@gmail.com,palmer@dabbelt.com,ardb@kernel.org,aou@eecs.berkeley.edu,andriy.shevchenko@intel.com,alex@ghiti.fr,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch added to mm-nonmm-unstable branch
Message-Id: <20260519191306.4CC811F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/cmdline: adjust a few comments to fix kernel-doc -Wreturn warnings
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: lib/cmdline: adjust a few comments to fix kernel-doc -Wreturn warnings
Date: Tue, 19 May 2026 20:22:56 +0300

Fix 'get_option()', 'memparse()' and 'parse_option_str()' comments to
match the commonly used style as suggested by kernel-doc -Wreturn.

Link: https://lore.kernel.org/20260519172259.908980-6-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Charlie Jenkins <thecharlesjenkins@gmail.com>
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
lib-fix-_parse_integer_limit-to-handle-overflow.patch
lib-fix-memparse-to-handle-overflow.patch
lib-add-more-string-to-64-bit-integer-conversion-overflow-tests.patch
lib-cmdline_kunit-add-test-case-for-memparse.patch
lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch
riscv-add-platform-specific-double-word-shifts-for-riscv32.patch
lib-kunit-add-tests-for-__ashldi3-__ashrdi3-and-__lshrdi3.patch
riscv-fix-building-compressed-efi-image.patch

