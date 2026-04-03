Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C6031D730
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 17:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775235767; cv=none; b=HuIbMoKXq3RypiCaU31hR5A6bdesHuACYfbc96cheYsWiU0LEkXtUYk+7dAg4uQS2hLqTPqwzWVacu+kVhWNty0BOrDWf/rQwrDY0K/ZO2S1T0CbhBwqcnLL2YazXGH8m3bwiYh21cXxVFJFg+UFzgIc+tlj9R4TUOEvUH/aUOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775235767; c=relaxed/simple;
	bh=gjcPaK2vFLna+EPygLs0aGzDPylOALf9vb1CvfZ/7CY=;
	h=Date:To:From:Subject:Message-Id; b=t+ZLIqpf9WAyUJpBFc9DBFH2I4qudLu8HbLKB//UKhNeluhQfwCPMCxeqBRDDVdmj1HQCuTqeFqYTQ7ufj+Y3RCdMRJKEWSH/qvRJSe/uUPJmvMwLx0EC3DfRIRMhc4qcmqMgqPwKCYqCok8oTGwv2Pi1VX1sCVrzvMztluYu5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1p6WCNV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1p6WCNV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F97C4CEF7;
	Fri,  3 Apr 2026 17:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775235767;
	bh=gjcPaK2vFLna+EPygLs0aGzDPylOALf9vb1CvfZ/7CY=;
	h=Date:To:From:Subject:From;
	b=1p6WCNV5hPWWuUjfts2u4Mpd4CJSCr2TINLlpfpcgWDD+Lk16mZTavgPxe5uJhCAL
	 J1ne+in8KNtbL5zsKYBP5buOLWbKR0L8sG3siCKzZGcc1Dwp70GmjLIrALNVK/Pcr7
	 IXh8cI54TkDf0maOjWE8RXLi7NLlHakDWFsKFi6E=
Date: Fri, 03 Apr 2026 10:02:46 -0700
To: mm-commits@vger.kernel.org,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch removed from -mm tree
Message-Id: <20260403170247.55F97C4CEF7@smtp.kernel.org>
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
Date: Thu, 12 Feb 2026 19:44:13 +0300

Fix 'get_option()', 'memparse()' and 'parse_option_str()' comments to
match the commonly used style as suggested by kernel-doc -Wreturn.

Link: https://lkml.kernel.org/r/20260212164413.889625-6-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kees Cook <kees@kernel.org>
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


