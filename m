Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C481B1624D5;
	Fri,  2 Oct 2026 22:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980271; cv=none; b=CMl/9jQqTTww+8eB+DsPSi2NkbLJXzzCzaoTclkSAZTkWbDkwVbfUy1hoOii1mij0idz+VlY9nPADN6h5Hm7v6TxmZLSQt4hcTVmRGJNvoZActjTA5jY4Tso40dsVf0aZcFND3mRNhjql2fv5Rq3IZ4OkJnR3TUL1kA3hTx5gTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980271; c=relaxed/simple;
	bh=w4qlQ6KiXmm+hGJK8ewvfI8geyY2873JqL/huUufabo=;
	h=Date:To:From:Subject:Message-Id; b=du4G2gqj8yomoxuGcwYuEnJ+OmXPd5Y8IZ3/77ad7pIc4iPBy2X3sEQtTkycY22cvTMuTQmk7bYfq00qJfdb0l+/vM2cIieGnBvwYPBjxTmn1btUykiQKa7aGtPVeA5zkg81G6UhxVtvNGbLjeKHgL0Kp7a55/ogY/7pNSPZd10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sVCXG1iY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sVCXG1iY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FEF1F000FF;
	Fri,  2 Oct 2026 22:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790980270;
	bh=HDiVM5JsWnlk7nDIx1UnRa8r52+P2kiMYMkSNXGQGIA=;
	h=Date:To:From:Subject;
	b=sVCXG1iYy2cIJDz2xAtV1FEsLvrc7OdG6XDzOQqmB8SY2ddoXVLu6uFkBe3qFSYzC
	 P2xHo9imlLnB0+z2UQELdq//QmcxBnPI9OZNkfg4IbyOc14UA6wsaxSC7HHJEMPSlP
	 sOk5tZSMIPmXCyVX/UuxiYlZpD5YLCCYH1spQyFI=
Date: Fri, 02 Oct 2026 15:31:10 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hughd@google.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,andrealmeid@igalia.com,akpm@linux-foundation.org,hnkz.64@gmail.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] tmpfs-fix-unicode_map-leaks-in-casefold-option-handling.patch removed from -mm tree
Message-Id: <20261002223110.91FEF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tmpfs: fix unicode_map leaks in casefold option handling
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-unicode_map-leaks-in-casefold-option-handling.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kazuki Hanai <hnkz.64@gmail.com>
Subject: tmpfs: fix unicode_map leaks in casefold option handling
Date: Fri, 28 Aug 2026 00:25:16 +0900

shmem_parse_opt_casefold() stores the unicode_map returned by utf8_load()
in ctx->encoding.  The casefold parameter can be supplied more than once
for the same filesystem context, but replacing the stored map does not
release the previous reference.

The final reference is also leaked when an unmounted filesystem context is
freed.

Release the previous map before replacing it, clear ctx->encoding after
transferring ownership to the superblock, and release any remaining
reference from shmem_free_fc().

An unprivileged user can repeatedly set the casefold parameter on a tmpfs
filesystem context from a user namespace.  This causes unbounded kernel
memory consumption and can result in a local denial of service.

Link: https://lore.kernel.org/20260827152516.805622-1-hnkz.64@gmail.com
Fixes: 58e55efd6c72 ("tmpfs: Add casefold lookup support")
Signed-off-by: Kazuki Hanai <hnkz.64@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: André Almeida <andrealmeid@igalia.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/shmem.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/shmem.c~tmpfs-fix-unicode_map-leaks-in-casefold-option-handling
+++ a/mm/shmem.c
@@ -4530,6 +4530,7 @@ static int shmem_parse_opt_casefold(stru
 	pr_info("tmpfs: Using encoding : utf8-%u.%u.%u\n",
 		unicode_major(version), unicode_minor(version), unicode_rev(version));
 
+	utf8_unload(ctx->encoding);
 	ctx->encoding = encoding;
 
 	return 0;
@@ -4998,6 +4999,7 @@ static int shmem_fill_super(struct super
 
 	if (ctx->encoding) {
 		sb->s_encoding = ctx->encoding;
+		ctx->encoding = NULL;
 		set_default_d_op(sb, &shmem_ci_dentry_ops);
 		if (ctx->strict_encoding)
 			sb->s_encoding_flags = SB_ENC_STRICT_MODE_FL;
@@ -5095,6 +5097,9 @@ static void shmem_free_fc(struct fs_cont
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


