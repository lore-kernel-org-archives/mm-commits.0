Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B522248AF;
	Fri,  2 Oct 2026 22:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980329; cv=none; b=gJhN35cV+ygYhISz5mHNz2oo5hsUa2PbooQIsm4g5vsaFQvAnI4uv0b4jZNLQJwEV28ROu1Ad1ruioA6BYSezzbSFE/hsYRAE1DfRlJp41ldlL6WzCaRORsRfADmgzKqrKaDK5FUusFfcwIe5udTHY+ELLKi5AS6+4Z9wWcMmVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980329; c=relaxed/simple;
	bh=jzGmoAS4Eg9CHqDftxXdr+IUKosDaKFrNxKxm8DZm0U=;
	h=Date:To:From:Subject:Message-Id; b=qFFABygMPdpACiJxPoABcO0bjU0lRw3Rhygf2BCnFeqiVnqhyusLNIp37PJJXaUq/FqYf79o1qNVzB3BDgE11kXgMglOzXKnkvt47o/k8atotH5sBIavMnlzhIcWnyx17rIWGx9J5N2XUbR750J/T9aq+aDXCV+ZQGRTvtZnsmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ouFyhc/U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ouFyhc/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA491F000FF;
	Fri,  2 Oct 2026 22:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790980328;
	bh=7PI87bD7N3/V7sqlgot59pXkhkFZBzxJmB5o4YMnAQc=;
	h=Date:To:From:Subject;
	b=ouFyhc/U5IEbj2hruf9okIuL/0/BUk/XtN8ayrZGlfq4MXClHC093BC+2Q84nBIhR
	 4m42PrQPiMJHogj47inLLAzMF05TV2G6AB0o2IIZi3yFRDem0kjUosTjQY3HgEqHg7
	 pMJ6jA83aYTQtWdvmGl4Mnawui+Q5LDizVPQyQk4=
Date: Fri, 02 Oct 2026 15:32:07 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hughd@google.com,gabriel@krisman.be,brauner@kernel.org,baolin.wang@linux.alibaba.com,andrealmeid@igalia.com,hnkz.64@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tmpfs-fix-unicode_map-leaks-in-casefold-option-handling.patch added to mm-nonmm-unstable branch
Message-Id: <20261002223207.DAA491F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tmpfs: fix unicode_map leaks in casefold option handling
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tmpfs-fix-unicode_map-leaks-in-casefold-option-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tmpfs-fix-unicode_map-leaks-in-casefold-option-handling.patch

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
From: Kazuki Hanai <hnkz.64@gmail.com>
Subject: tmpfs: fix unicode_map leaks in casefold option handling
Date: Fri,  2 Oct 2026 17:13:03 +0900

shmem_parse_opt_casefold() stores the unicode_map returned by utf8_load()
in ctx->encoding.  A filesystem context can receive the casefold parameter
more than once, and a second successful parse overwrites the stored map
without releasing it.

The map is also leaked when an unmounted filesystem context is freed. 
This includes the temporary context used for remount, because
shmem_reconfigure() does not take ownership of ctx->encoding.

Reject a second casefold setting, clear ctx->encoding after transferring
ownership to the superblock, and release any remaining map from
shmem_free_fc().

An unprivileged user can repeatedly create tmpfs filesystem contexts, set
the casefold parameter, and close them from a user namespace.  This causes
unbounded kernel memory consumption and can result in a local denial of
service.

Link: https://lore.kernel.org/20261002081306.637148-1-hnkz.64@gmail.com
Fixes: 58e55efd6c72 ("tmpfs: Add casefold lookup support")
Signed-off-by: Kazuki Hanai <hnkz.64@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Gabriel Krisman Bertazi <gabriel@krisman.be>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: André Almeida <andrealmeid@igalia.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/shmem.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/shmem.c~tmpfs-fix-unicode_map-leaks-in-casefold-option-handling
+++ a/mm/shmem.c
@@ -4711,6 +4711,9 @@ static int shmem_parse_opt_casefold(stru
 	struct unicode_map *encoding;
 	char *version_str = param->string + 5;
 
+	if (ctx->encoding)
+		return invalfc(fc, "casefold parameter cannot be specified twice\n");
+
 	if (!latest_version) {
 		if (strncmp(param->string, "utf8-", 5))
 			return invalfc(fc, "Only UTF-8 encodings are supported "
@@ -5203,6 +5206,7 @@ static int shmem_fill_super(struct super
 
 	if (ctx->encoding) {
 		sb->s_encoding = ctx->encoding;
+		ctx->encoding = NULL;
 		set_default_d_op(sb, &shmem_ci_dentry_ops);
 		if (ctx->strict_encoding)
 			sb->s_encoding_flags = SB_ENC_STRICT_MODE_FL;
@@ -5303,6 +5307,9 @@ static void shmem_free_fc(struct fs_cont
 	struct shmem_options *ctx = fc->fs_private;
 
 	if (ctx) {
+#if IS_ENABLED(CONFIG_UNICODE)
+		utf8_unload(ctx->encoding);
+#endif
 		mpol_put(ctx->mpol);
 		kfree(ctx);
 	}
_

Patches currently in -mm which might be from hnkz.64@gmail.com are

tmpfs-fix-unicode_map-leaks-in-casefold-option-handling.patch

