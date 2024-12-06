Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C59C1BC3C
	for <mm-commits@vger.kernel.org>; Fri,  6 Dec 2024 01:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733448716; cv=none; b=cP3D5PLVnmWy/8++fpVbu5DQGF3ghdvjDMPnOaD+q8MzSZPL4b7H8Nc+tvP6yAIQ8cZWd4zSNY9IXNGbYoDZ8fTW0w2MYNelHEqctuaJmdZj1foz6Fm1pRh9omwcHXAsTU+HmM3PyW8YUr4sx2rxnlMK2Ris8TmywfsGgNJwnTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733448716; c=relaxed/simple;
	bh=w7CZQFJWvAxkp9pKNplzhXUmYkiau5B7lnPeYkvyuEg=;
	h=Date:To:From:Subject:Message-Id; b=OOmZjoha2IGhOId3FJl1g1DagHKGgJP6xXfcwhdb6MO2y39PlGUxsIElCQCXUG9ioMVB9SltOhVbzEypL3rIjt1YKMjyio4hOPJB++1GG0RVY/n9guRejRKFBL6EHshBXZ80LizW075AuZiowh9ZoWhTQAjg8xNENIYj/EXJPSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pk6vma+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pk6vma+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A0DC4CED1;
	Fri,  6 Dec 2024 01:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733448715;
	bh=w7CZQFJWvAxkp9pKNplzhXUmYkiau5B7lnPeYkvyuEg=;
	h=Date:To:From:Subject:From;
	b=pk6vma+Hf91MOlfoRQZ07F718vxi49PU0a+0PYOW3J9WI2YXyijeEzYyXM3xEsZ15
	 IeqJlDvgbNLNxWqf6FzT+BRcIs75w9cZaGZM4e6s4umOt66QKCVLt6iIB4A1gWSRA0
	 XmKQfWVpPrfFjJRyP/XC5TT926aTL9j/LoyktR0I=
Date: Thu, 05 Dec 2024 17:31:55 -0800
To: mm-commits@vger.kernel.org,hughd@google.com,amir73il@gmail.com,guoweikang.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-refactor-to-reuse-vfs_parse_monolithic_sep-for-option-parsing.patch added to mm-unstable branch
Message-Id: <20241206013155.94A0DC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: refactor to reuse vfs_parse_monolithic_sep for option parsing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-refactor-to-reuse-vfs_parse_monolithic_sep-for-option-parsing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-refactor-to-reuse-vfs_parse_monolithic_sep-for-option-parsing.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Guo Weikang <guoweikang.kernel@gmail.com>
Subject: mm/shmem: refactor to reuse vfs_parse_monolithic_sep for option parsing
Date: Thu, 5 Dec 2024 17:45:21 +0800

shmem_parse_options() is refactored to use vfs_parse_monolithic_sep() with
a custom separator function, shmem_next_opt().  This eliminates redundant
logic for parsing comma-separated options and ensures consistency with
other kernel code that uses the same interface.

The vfs_parse_monolithic_sep() helper was introduced in commit
e001d1447cd4 ("fs: factor out vfs_parse_monolithic_sep() helper").

Link: https://lkml.kernel.org/r/20241205094521.1244678-1-guoweikang.kernel@gmail.com
Signed-off-by: Guo Weikang <guoweikang.kernel@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   67 +++++++++++++++++++++------------------------------
 1 file changed, 28 insertions(+), 39 deletions(-)

--- a/mm/shmem.c~mm-shmem-refactor-to-reuse-vfs_parse_monolithic_sep-for-option-parsing
+++ a/mm/shmem.c
@@ -4644,48 +4644,37 @@ bad_value:
 	return invalfc(fc, "Bad value for '%s'", param->key);
 }
 
-static int shmem_parse_options(struct fs_context *fc, void *data)
+static char *shmem_next_opt(char **s)
 {
-	char *options = data;
+	char *sbegin = *s;
+	char *p;
 
-	if (options) {
-		int err = security_sb_eat_lsm_opts(options, &fc->security);
-		if (err)
-			return err;
-	}
-
-	while (options != NULL) {
-		char *this_char = options;
-		for (;;) {
-			/*
-			 * NUL-terminate this option: unfortunately,
-			 * mount options form a comma-separated list,
-			 * but mpol's nodelist may also contain commas.
-			 */
-			options = strchr(options, ',');
-			if (options == NULL)
-				break;
-			options++;
-			if (!isdigit(*options)) {
-				options[-1] = '\0';
-				break;
-			}
-		}
-		if (*this_char) {
-			char *value = strchr(this_char, '=');
-			size_t len = 0;
-			int err;
-
-			if (value) {
-				*value++ = '\0';
-				len = strlen(value);
-			}
-			err = vfs_parse_fs_string(fc, this_char, value, len);
-			if (err < 0)
-				return err;
+	if (sbegin == NULL)
+		return NULL;
+
+	/*
+	 * NUL-terminate this option: unfortunately,
+	 * mount options form a comma-separated list,
+	 * but mpol's nodelist may also contain commas.
+	 */
+	for (;;) {
+		p = strchr(*s, ',');
+		if (p == NULL)
+			break;
+		*s = p + 1;
+		if (!isdigit(*(p+1))) {
+			*p = '\0';
+			return sbegin;
 		}
 	}
-	return 0;
+
+	*s = NULL;
+	return sbegin;
+}
+
+static int shmem_parse_monolithic(struct fs_context *fc, void *data)
+{
+	return vfs_parse_monolithic_sep(fc, data, shmem_next_opt);
 }
 
 /*
@@ -5035,7 +5024,7 @@ static const struct fs_context_operation
 	.free			= shmem_free_fc,
 	.get_tree		= shmem_get_tree,
 #ifdef CONFIG_TMPFS
-	.parse_monolithic	= shmem_parse_options,
+	.parse_monolithic	= shmem_parse_monolithic,
 	.parse_param		= shmem_parse_one,
 	.reconfigure		= shmem_reconfigure,
 #endif
_

Patches currently in -mm which might be from guoweikang.kernel@gmail.com are

mm-shmem-refactor-to-reuse-vfs_parse_monolithic_sep-for-option-parsing.patch

