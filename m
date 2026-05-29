Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D663A372677
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028788; cv=none; b=OhW+t5TzFQW/RtB+wMQHNQUit6k4ndxsmnigNiCrDDCAaYzoynIbwpXFc/RSlVRU4o9PXic6JqHpvYcFLnMYYQyu6HOL+hLguF3u/YJ8qm/N5KPqCvY5S970rrRKI4+2n2AsK05GLvDkznMYv/xjm2KcgRwRqh9gWOnwjWrXUXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028788; c=relaxed/simple;
	bh=l08Sl7H3PEP9x/B931plNNHayTxLAYPd0eHPfpUAeFQ=;
	h=Date:To:From:Subject:Message-Id; b=cz8IzS06I8VHgfwoawukfB25rqOVl1DsMoJzKsfk/Xkd1udwj01031B9R16KKRyeShK78fG6cptkF2Juv6We4/D0LbXCZOgTV/OtCCbJexoyj/rgAq5FAa9TiWvSifaLBYvPaYQ9LA5useIgn63DxD4tQ5RsJs/XuDfgabQok5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hJDLq5CC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hJDLq5CC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCD81F00893;
	Fri, 29 May 2026 04:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028786;
	bh=lo8hVyOG4TVnFlCC76uzeGrDKfXuaBA6hlI6bi7K7jk=;
	h=Date:To:From:Subject;
	b=hJDLq5CC4DKEmGEJ7lzVem1KiH6PNDjCv/sRj0uw5arhZlXa3mPBHUK+ukPUDOhgh
	 yq9iInUfwGvFA6R6xrG4b+2aKpt+6kptm6VrizLcp+JrhSVT/jEbeZRJ+6/HtxU1Tt
	 fNqFktvbpVPTnuQQXHHULzNlmtvo5HfQ55lqiEcU=
Date: Thu, 28 May 2026 21:26:26 -0700
To: mm-commits@vger.kernel.org,thecharlesjenkins@gmail.com,palmer@dabbelt.com,ardb@kernel.org,aou@eecs.berkeley.edu,andriy.shevchenko@intel.com,alex@ghiti.fr,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch removed from -mm tree
Message-Id: <20260529042626.6BCD81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/cmdline: adjust a few comments to fix kernel-doc -Wreturn warnings
has been removed from the -mm tree.  Its filename was
     lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

