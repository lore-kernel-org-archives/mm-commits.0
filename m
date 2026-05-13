Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8507376BDE
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 03:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778644773; cv=none; b=dFVTw9ch6PWMwqHLbYlKzTAbKJC9MpZ1TRI2hVCtmEzR0RDfhu6FWuNlDcZmcsU/98Z16krCz6zCeoRrxpJ11YlnlzAA+YIrK/c8TisDbN8FWWknurY+kow8CTmP2FKe3dum7VPR4rM5nHmmRzORAFrqiceQyV3vt76WkdLN5SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778644773; c=relaxed/simple;
	bh=aD+jA4UeLztJaiXZgf/oWhOqbJTFUEALucVHIxW8hEQ=;
	h=Date:To:From:Subject:Message-Id; b=OY6E9gxDPj1A5sL/mDMExfzYEKF9SFdVtP4sKl04Mm9DWufwHNHStMBqPWfSq6mMVQC4sBXcjOl9/RJzWlpsc3PIwSsUFFGPsrXAbERp9kYCcyRput67s3E/SNWa4hcLhTP4hwFtAeQ5SKFGy17SJHnvx2LWbfDEYF+7aBIZ/AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PhqJjIz1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PhqJjIz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2D3C2BCC7;
	Wed, 13 May 2026 03:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778644773;
	bh=aD+jA4UeLztJaiXZgf/oWhOqbJTFUEALucVHIxW8hEQ=;
	h=Date:To:From:Subject:From;
	b=PhqJjIz12wopm8AjqqR+kyUIe6D/IzbCklf7B22pqmN7piPEsEpa9npeN+hSco65G
	 Met4lhhpzruDVsb88HAPXqitUxHNBtKl7YxL9zcArNL1qcjeWOE0rdvr3fQAXsztDl
	 eFSgVE8jSkmoQpE9fBIAnXhqxbB32DEuOOqjUObI=
Date: Tue, 12 May 2026 20:59:32 -0700
To: mm-commits@vger.kernel.org,pjw@kernel.org,palmer@dabbelt.com,nathan@kernel.org,kees@kernel.org,djwong@kernel.org,ardb@kernel.org,aou@eecs.berkeley.edu,andriy.shevchenko@intel.com,alex@ghiti.fr,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-cmdline-adjust-a-few-comments-to-fix-kernel-doc-wreturn-warnings.patch removed from -mm tree
Message-Id: <20260513035933.7A2D3C2BCC7@smtp.kernel.org>
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
Date: Fri, 3 Apr 2026 13:33:37 +0300

Fix 'get_option()', 'memparse()' and 'parse_option_str()' comments to
match the commonly used style as suggested by kernel-doc -Wreturn.

Link: https://lore.kernel.org/20260403103338.1122415-6-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <pjw@kernel.org>
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
riscv-export-symbols-needed-for-riscv32-efi-stub.patch

