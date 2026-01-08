Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8364277026
	for <mm-commits@vger.kernel.org>; Thu,  8 Jan 2026 17:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767894177; cv=none; b=NNMgJzSKKxRLae241OMSRGYrvP8Rp35r6+gM5WbVG28WlyhOW8PIHVM5bybwQOwbMU++hfXel5iLvfVMhtYwr6vUXI6jSJWLABQAyZai/QOkOC4hzQgOb/ppqvyrNT89+CHYIyt08spmy1IyuyR8Gdl0q+ZuduNcBPB5XbknYgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767894177; c=relaxed/simple;
	bh=wsYsF4lacK5/IfiqdD/kKpu3FRuMjDPbRtRCaBJ0s3w=;
	h=Date:To:From:Subject:Message-Id; b=CqlR+xodctxi6Uev2qCnP1GNmUiyjJKsTCk2O7KTGxbmB86SA4oZEo3k3WRqycv8hGjsxMMxVydpZ+j8GsjQKaSa6vQr5CH0teJ0CejGb4Oye/3z5uvNgWx+/1o3KYfuXet5bqAgkrilivkNd1vlD4qWv3zOJFe765sijRguUVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L/LTrICL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L/LTrICL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224F5C116D0;
	Thu,  8 Jan 2026 17:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767894177;
	bh=wsYsF4lacK5/IfiqdD/kKpu3FRuMjDPbRtRCaBJ0s3w=;
	h=Date:To:From:Subject:From;
	b=L/LTrICLnqw5J4NClyZZJgGlNsBHHcJFgV//6xFIu+Xz62wm8MTEj1UDKDxDjCZ72
	 qDtVR6IaKH2U321VB9+0vv+q0DzvlJMT0HiirY12bLthl3mrYWNIlxFhM7PCFVwDOE
	 HtYe+NILXfGmbuP1FbYOLCTwbmgXzCIptpWB2zGg=
Date: Thu, 08 Jan 2026 09:42:56 -0800
To: mm-commits@vger.kernel.org,kees@kernel.org,hch@infradead.org,cem@kernel.org,andy@kernel.org,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-introduce-simple-error-checking-wrapper-for-memparse.patch added to mm-nonmm-unstable branch
Message-Id: <20260108174257.224F5C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: introduce simple error-checking wrapper for memparse()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-introduce-simple-error-checking-wrapper-for-memparse.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-introduce-simple-error-checking-wrapper-for-memparse.patch

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
Subject: lib: introduce simple error-checking wrapper for memparse()
Date: Thu, 8 Jan 2026 19:52:15 +0300

Introduce 'memvalue()' which uses 'memparse()' to parse a string with
optional memory suffix into a non-negative number.  If parsing has
succeeded, returns 0 and stores the result at the location specified by
the second argument.  Otherwise returns -EINVAL and leaves the location
untouched.

Link: https://lkml.kernel.org/r/20260108165216.1054625-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Kees Cook <kees@kernel.org>
Reviewed-by: Kees Cook <kees@kernel.org>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |    1 +
 lib/cmdline.c          |   26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

--- a/include/linux/string.h~lib-introduce-simple-error-checking-wrapper-for-memparse
+++ a/include/linux/string.h
@@ -319,6 +319,7 @@ DEFINE_FREE(argv_free, char **, if (!IS_
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
+extern int __must_check memvalue(const char *ptr, unsigned long long *valptr);
 extern bool parse_option_str(const char *str, const char *option);
 extern char *next_arg(char *args, char **param, char **val);
 
--- a/lib/cmdline.c~lib-introduce-simple-error-checking-wrapper-for-memparse
+++ a/lib/cmdline.c
@@ -191,6 +191,32 @@ unsigned long long memparse(const char *
 EXPORT_SYMBOL(memparse);
 
 /**
+ *	memvalue -  Wrap memparse() with simple error detection
+ *	@ptr: Where parse begins
+ *	@valptr: Where to store result
+ *
+ *	Unconditionally returns -EINVAL for a presumably negative value.
+ *	Otherwise uses memparse() to parse a string into a number stored
+ *	at @valptr and returns 0 or -EINVAL if an unrecognized character
+ *	was encountered. For a non-zero return value, memory at @valptr
+ *	is left untouched.
+ */
+int __must_check memvalue(const char *ptr, unsigned long long *valptr)
+{
+	unsigned long long ret;
+	char *end;
+
+	if (*ptr == '-')
+		return -EINVAL;
+	ret = memparse(ptr, &end);
+	if (*end)
+		return -EINVAL;
+	*valptr = ret;
+	return 0;
+}
+EXPORT_SYMBOL(memvalue);
+
+/**
  *	parse_option_str - Parse a string and check an option is set or not
  *	@str: String to be parsed
  *	@option: option name
_

Patches currently in -mm which might be from dmantipov@yandex.ru are

ocfs2-adjust-ocfs2_xa_remove_entry-to-match-ubsan-boundary-checks.patch
ocfs2-annotate-more-flexible-array-members-with-__counted_by_le.patch
lib-introduce-simple-error-checking-wrapper-for-memparse.patch
xfs-adjust-handling-of-a-few-numerical-mount-options.patch

