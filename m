Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715B9217F33
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 00:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768955213; cv=none; b=aIYu2d9+5Qx7U2QJFpQOYvnL/FwHv6A8VcGHYAz0/Q1pOS6qNZIki7fojMWL7Wo6OCdsPscBBp5zuYXQ+hh+G2UuFYXsfcyHKOaPzYPMG3izrkBfmEN6Yh8j5ke/B9qt1uQrOmoEU7PHBCPoS+mM4taK3t7UnwMfnE3P7kDdCLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768955213; c=relaxed/simple;
	bh=p1R2Q946JsDrJHJEMnODCa+OfR8meL7aBQAeMXYTEeA=;
	h=Date:To:From:Subject:Message-Id; b=P++P40k6COY158h6b1eR+D6iANmme5g/U4d6gb+fNqxu1w4OkvuwiWcQCpTlxDf5LtEspyWMWz1HnQmnR7v4LDg+jD3Hj2QxPOgr/UhXiP8lN62sQMozM8xWYdoKgTAW+rPcUF1jC9TeavWDBTmDN0sY3TzI7EoRLtwPmJbO53M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FeDrjkaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FeDrjkaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BEDC19424;
	Wed, 21 Jan 2026 00:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768955213;
	bh=p1R2Q946JsDrJHJEMnODCa+OfR8meL7aBQAeMXYTEeA=;
	h=Date:To:From:Subject:From;
	b=FeDrjkaqLksalvnHsDmnLKhlISDntIImnQR/4i63iMsq4Btpx7NvWw+4ecgxY7zW6
	 qx/yNPAuRhdL4ymQgu3D8on3y3Wz+lUz9hlfoI1rtA7YQpCNdCpi3aFIEW6VBzgMT1
	 Kgo5AShPe8dKQJpjX/wqvglMcrwNQZsCMsXPRKDI=
Date: Tue, 20 Jan 2026 16:26:52 -0800
To: mm-commits@vger.kernel.org,kees@kernel.org,hch@infradead.org,cem@kernel.org,andy@kernel.org,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-introduce-simple-error-checking-wrapper-for-memparse.patch removed from -mm tree
Message-Id: <20260121002652.F2BEDC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: introduce simple error-checking wrapper for memparse()
has been removed from the -mm tree.  Its filename was
     lib-introduce-simple-error-checking-wrapper-for-memparse.patch

This patch was dropped because an updated version will be issued

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
xfs-adjust-handling-of-a-few-numerical-mount-options.patch

