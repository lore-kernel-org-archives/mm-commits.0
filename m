Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F36647CC6C;
	Thu, 27 Aug 2026 17:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787851799; cv=none; b=IAlBRMW1tDxg3M92iCSzEP6FxqAlUbwVHnqCJHfAOqFrfDPBdZtBSNtbQbWGR3pe7rnrHeAuXMlyI95u6+g7IBF9kjngHCOF9NECCQTZVsJzIAi65J95nKowST9o6J+r5Vl7qUo6jjCe7/X/4Cg7XgcW3JtSFCetQRKIYduj2F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787851799; c=relaxed/simple;
	bh=eA+59eXuk5d3Iu/JzNIxr/oFTeHloFRpoPlY3U79k50=;
	h=Date:To:From:Subject:Message-Id; b=VmiDOQMdq+7tpcD1mmtlPX6bMIhnsvQ3ppC7SdtiPeRSyUJ1QsrHpcHcAbXJrnZ5OwXVzkdDa6wmLWUTzflCv3wHZRwwhiWFTedQlWAXFxqqKEDVLpDcLFaMzJdXzcyttWARnO3gCUFdWoHI8c+hnSIEqhrE5Riqh6pVapN6/7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=srL2yqa5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="srL2yqa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23311F000E9;
	Thu, 27 Aug 2026 17:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787851798;
	bh=L1IUe41TigVLEBKZAFL8x4gB6k0riRkkI6nkPXLfIvk=;
	h=Date:To:From:Subject;
	b=srL2yqa5JL1ebi3A6h6HUgFM2nbQfEP/6JZ33JOK7ig53F7LJxuiRKEecDPgRr92g
	 TWV9c90pspOHkdnTLj4hgrqB+86qPeWyK1YAX4lkrhf8cjCarTkJ1VkHaH4QCusRI/
	 sBiBBCzs49zn4wf8nyfzh5ory9EVtBe1Y+/DcWFE=
Date: Thu, 27 Aug 2026 10:29:57 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hughd@google.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,andrealmeid@igalia.com,hnkz.64@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tmpfs-fix-unicode_map-leaks-in-casefold-option-handling.patch added to mm-hotfixes-unstable branch
Message-Id: <20260827172957.F23311F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tmpfs: fix unicode_map leaks in casefold option handling
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tmpfs-fix-unicode_map-leaks-in-casefold-option-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tmpfs-fix-unicode_map-leaks-in-casefold-option-handling.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: André Almeida <andrealmeid@igalia.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/shmem.c~tmpfs-fix-unicode_map-leaks-in-casefold-option-handling
+++ a/mm/shmem.c
@@ -4502,6 +4502,7 @@ static int shmem_parse_opt_casefold(stru
 	pr_info("tmpfs: Using encoding : utf8-%u.%u.%u\n",
 		unicode_major(version), unicode_minor(version), unicode_rev(version));
 
+	utf8_unload(ctx->encoding);
 	ctx->encoding = encoding;
 
 	return 0;
@@ -4970,6 +4971,7 @@ static int shmem_fill_super(struct super
 
 	if (ctx->encoding) {
 		sb->s_encoding = ctx->encoding;
+		ctx->encoding = NULL;
 		set_default_d_op(sb, &shmem_ci_dentry_ops);
 		if (ctx->strict_encoding)
 			sb->s_encoding_flags = SB_ENC_STRICT_MODE_FL;
@@ -5067,6 +5069,9 @@ static void shmem_free_fc(struct fs_cont
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

