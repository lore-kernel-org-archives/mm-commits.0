Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE2F2EB5DA
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 20:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755634242; cv=none; b=U6qcMEYX0lRXj2iMRi8exDJWJBP4GPpJ5/bIEO6hwiQ/nE5iYaFmRqPlrZ0zFQHe0/FYaz3PKPZu5kszomqTUcKXNXbStLb/rZXrZuLvgIqfNsFyYYB4MgI/QAS5WueWryQA8z/DlvRzCJn9+LTT3dpyca0OAqYB0gvZKZQs4co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755634242; c=relaxed/simple;
	bh=uAPgLlpo/Jaqe5r2FiRSyBCtQJzMnTtR2RjB6v2OJ8I=;
	h=Date:To:From:Subject:Message-Id; b=L8SIoa0r9J3cNTLw4PtkrXF26dgExJksIUPvRQPR7Tout0K4zBB4TceEkRzS7BI5xAmVNLrihtkV8rmnKGuIbduUafGM01QrmJpesAZ+UXKPJQswUJnMf1KSLLw7IzZf2oIEtA5wr3qa1apS6DYGmIrDOOnzL0xpHuzALtxKlPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XQv9N46z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XQv9N46z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E2AC4CEF1;
	Tue, 19 Aug 2025 20:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755634241;
	bh=uAPgLlpo/Jaqe5r2FiRSyBCtQJzMnTtR2RjB6v2OJ8I=;
	h=Date:To:From:Subject:From;
	b=XQv9N46zJuIoDh4VL+S3lhZHDPI7+K1ODf7J3JBpp6kRSKYFsksmhNbL6ygR1RL5O
	 Pha5HB0pM4c7QxC0PJmj6BE9nRkOhLkkk++2vq8jRABwXQPckvB1YXOLCbF/SAowVr
	 OMHYgeLx+md6movCFmyEP25Jw/4XJkTzvc2ObnCE=
Date: Tue, 19 Aug 2025 13:10:40 -0700
To: mm-commits@vger.kernel.org,jlayton@kernel.org,hughd@google.com,baolin.wang@linux.alibaba.com,libaokun1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tmpfs-preserve-sb_i_version-on-remount.patch added to mm-new branch
Message-Id: <20250819201041.77E2AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tmpfs: preserve SB_I_VERSION on remount
has been added to the -mm mm-new branch.  Its filename is
     tmpfs-preserve-sb_i_version-on-remount.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tmpfs-preserve-sb_i_version-on-remount.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Baokun Li <libaokun1@huawei.com>
Subject: tmpfs: preserve SB_I_VERSION on remount
Date: Tue, 19 Aug 2025 14:18:03 +0800

Now tmpfs enables i_version by default and tmpfs does not modify it.  But
SB_I_VERSION can also be modified via sb_flags, and reconfigure_super()
always overwrites the existing flags with the latest ones.  This means
that if tmpfs is remounted without specifying iversion, the default
i_version will be unexpectedly disabled.

To ensure iversion remains enabled, SB_I_VERSION is now always set for
fc->sb_flags in shmem_init_fs_context(), instead of for sb->s_flags in
shmem_fill_super().

Link: https://lkml.kernel.org/r/20250819061803.1496443-1-libaokun@huaweicloud.com
Fixes: 36f05cab0a2c ("tmpfs: add support for an i_version counter")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~tmpfs-preserve-sb_i_version-on-remount
+++ a/mm/shmem.c
@@ -5081,7 +5081,7 @@ static int shmem_fill_super(struct super
 		sb->s_flags |= SB_NOUSER;
 	}
 	sb->s_export_op = &shmem_export_ops;
-	sb->s_flags |= SB_NOSEC | SB_I_VERSION;
+	sb->s_flags |= SB_NOSEC;
 
 #if IS_ENABLED(CONFIG_UNICODE)
 	if (!ctx->encoding && ctx->strict_encoding) {
@@ -5385,6 +5385,9 @@ int shmem_init_fs_context(struct fs_cont
 
 	fc->fs_private = ctx;
 	fc->ops = &shmem_fs_context_ops;
+#ifdef CONFIG_TMPFS
+	fc->sb_flags |= SB_I_VERSION;
+#endif
 	return 0;
 }
 
_

Patches currently in -mm which might be from libaokun1@huawei.com are

tmpfs-preserve-sb_i_version-on-remount.patch

