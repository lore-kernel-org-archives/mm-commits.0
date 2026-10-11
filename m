Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993B045FFB8;
	Sun, 11 Oct 2026 22:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791757213; cv=none; b=aQ71jsM9csc4aYf4p6thgqsbl9QKHn5pQxJf9uEg5hGWhmRGwkiTtFz8GsGaJ53O2E4bbmluCYCf/C8A7YBowSv7gnmCixfrXWgZYWMiBld63IREqPRcuKW2lbKeqAj7GY+4Qq3bOyRynuJIRGVKjFxYX50L+kSnadYY0OySEaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791757213; c=relaxed/simple;
	bh=kHq4zCz+m8iR8c1+dvehM1hICGK5p1wZtT3BMX92QM4=;
	h=Date:To:From:Subject:Message-Id; b=SwdToBQlASzNVUFnABGZ3cjymswdrx3Vf4nrfN9O2Sbp4m70Ms9eSJxCyPB+iYRtgpTDIpTMJu/9HXlj1IPt6aRZmQWV5MPWIrp3mdMu+5n5fbylXYXSQfXp7vXCJs0gycTj70y0q3vlvtuz69y1RKtCqjaXqdxcqg2V3TgrsFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g3wIaeCY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g3wIaeCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7069B1F0089D;
	Sun, 11 Oct 2026 22:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791757212;
	bh=3oq9yjH7YMvI4qZtOlNThNWstJ2Uq4esafZFXWgCDcw=;
	h=Date:To:From:Subject;
	b=g3wIaeCYB+WUcO5xKdhYVfKjC9RQBUi89KM8r1lmIPVTFsx5WGPHw0ox/4NqF2jIa
	 QkYM+5sz8zuIJkYiA5vEyY6Gcxmu+WfoPO9JzViwTrcrybnCfFHjLamossvzjagc2k
	 23do+tgkHPSwOqoieu8GiI9WJZFQy1nCJiEubRhU=
Date: Sun, 11 Oct 2026 15:20:12 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hughd@google.com,gabriel@krisman.be,brauner@kernel.org,baolin.wang@linux.alibaba.com,andrealmeid@igalia.com,hnkz.64@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tmpfs-fix-unicode_map-leaks-in-casefold-option-handling.patch removed from -mm tree
Message-Id: <20261011222012.7069B1F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tmpfs: fix unicode_map leaks in casefold option handling
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-unicode_map-leaks-in-casefold-option-handling.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -4509,6 +4509,9 @@ static int shmem_parse_opt_casefold(stru
 	struct unicode_map *encoding;
 	char *version_str = param->string + 5;
 
+	if (ctx->encoding)
+		return invalfc(fc, "casefold parameter cannot be specified twice\n");
+
 	if (!latest_version) {
 		if (strncmp(param->string, "utf8-", 5))
 			return invalfc(fc, "Only UTF-8 encodings are supported "
@@ -4998,6 +5001,7 @@ static int shmem_fill_super(struct super
 
 	if (ctx->encoding) {
 		sb->s_encoding = ctx->encoding;
+		ctx->encoding = NULL;
 		set_default_d_op(sb, &shmem_ci_dentry_ops);
 		if (ctx->strict_encoding)
 			sb->s_encoding_flags = SB_ENC_STRICT_MODE_FL;
@@ -5095,6 +5099,9 @@ static void shmem_free_fc(struct fs_cont
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


