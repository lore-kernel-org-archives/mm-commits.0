Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401ED23C6F6
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837017; cv=none; b=Y+jji6O8VTXmzyyhyTGMvMlBMgIHERygIVpvIaPBwiNKql3a+QNC4lXi5vn+6Anle/sOcnS5aoAgoLYhn8kL+s20GdA8UfET71Dt5qsiYISxMM++X0sHJp4EeVrop2t6kFcsBN3vy13nx82J1PenlgiLMAE0SWsrc5xb4uBFZvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837017; c=relaxed/simple;
	bh=OJ8CcV617SxOaX/RnkWYYntcdqoERVMzXCefEG3xLdE=;
	h=Date:To:From:Subject:Message-Id; b=ggyBPjnJkhL1ujKtWfRWp5vjASZGDagl8njSgvJo7WDaqOxTOABcslw//I9krpMfUuFVf/GzJ946oSTc9l0IPnYegiezOcQJfiIOMApuuKpLG4OoiQHjGk323QupuSjkj9q6zGOC376AvspETUwYdcWp85nAIbybzv5wpgfgChw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v29PIFI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v29PIFI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1450CC4CEDD;
	Tue, 14 Jan 2025 06:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837017;
	bh=OJ8CcV617SxOaX/RnkWYYntcdqoERVMzXCefEG3xLdE=;
	h=Date:To:From:Subject:From;
	b=v29PIFI7NTqYOyjb/+RKQy4DKFDTy6FAvY4NKr4Eb7fbNcw5YP2EVSyAqNjx3GTDn
	 tKeBgnCmoS7k106iruF1jWW6n44+FyCHpY6MCBy38UKYc7U+1rDPqM04HSMRhUz/Cg
	 H1UlIf19VawON+oNH9CjCVPpkVvzrRWkxLdwMx18=
Date: Mon, 13 Jan 2025 22:43:36 -0800
To: mm-commits@vger.kernel.org,hughd@google.com,amir73il@gmail.com,guoweikang.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-refactor-to-reuse-vfs_parse_monolithic_sep-for-option-parsing.patch removed from -mm tree
Message-Id: <20250114064337.1450CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: refactor to reuse vfs_parse_monolithic_sep for option parsing
has been removed from the -mm tree.  Its filename was
     mm-shmem-refactor-to-reuse-vfs_parse_monolithic_sep-for-option-parsing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4647,48 +4647,37 @@ bad_value:
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
@@ -5038,7 +5027,7 @@ static const struct fs_context_operation
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

mm-memblock-add-memblock_alloc_or_panic-interface.patch
arch-s390-save_area_alloc-default-failure-behavior-changed-to-panic.patch

