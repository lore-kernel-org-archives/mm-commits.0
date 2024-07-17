Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49536179AD
	for <mm-commits@vger.kernel.org>; Wed, 17 Jul 2024 20:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721247247; cv=none; b=SoFqxJO2smX+/JXpbOQd1KcFFWJ+xuZXrHu2rKcBm3+HE6m319nZ4A9vgPV184qBCeu/0qGldk//9AvJjhWBa4bLBTunnvLH9IniSQD62HBn0BFBqn4P1WyKdk3Dii5mTZKejA/I9J8VgWDLv9KSfkLPhIJxJyT8Lnt/WmxRtS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721247247; c=relaxed/simple;
	bh=ZcJdr1wH5dc7LtzcSWWRhUuKWpLj6Lqj+1tOtbn+sps=;
	h=Date:To:From:Subject:Message-Id; b=qAoN9px3hxYvSyqSiPwRGOoZuI1BW8vOFRM8ZSdBflnvWC2t2gKRMFWs1Zvgeqz7Pa/EIumqQRaTwuwFHwMii6Omiun7HJUMw91SfDIuWoc7z4S8zi9BbfFyes+3DZGd3LdH1lssO0FXl9go+N2TvWqqDlG4OaoCUm8BbulnxPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2T7jXgh4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2T7jXgh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E28C2BD10;
	Wed, 17 Jul 2024 20:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721247246;
	bh=ZcJdr1wH5dc7LtzcSWWRhUuKWpLj6Lqj+1tOtbn+sps=;
	h=Date:To:From:Subject:From;
	b=2T7jXgh4Kbk6WhyiQOjeiG+08Smp7TUDcsc3jLPnIMBOEZX2q/Sk7kQR6E10sk4Un
	 iLbFXCXTm8XTIdlLKctwciGzwz76Te2QGIv2fsbst0Ym09Roc3Pz0AOjDTRT1r2Yb0
	 AaIq5kvkJlS0KhjO/dWLMU19rggKycf/jGz3a+LE=
Date: Wed, 17 Jul 2024 13:14:06 -0700
To: mm-commits@vger.kernel.org,jack@suse.cz,hughd@google.com,cmaiolino@redhat.com,brauner@kernel.org,aris@redhat.com,cem@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem_quota-build-the-object-file-conditionally-to-the-config-option.patch added to mm-unstable branch
Message-Id: <20240717201406.A5E28C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: shmem_quota: build the object file conditionally to the config option
has been added to the -mm mm-unstable branch.  Its filename is
     shmem_quota-build-the-object-file-conditionally-to-the-config-option.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem_quota-build-the-object-file-conditionally-to-the-config-option.patch

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
From: Carlos Maiolino <cem@kernel.org>
Subject: shmem_quota: build the object file conditionally to the config option
Date: Wed, 17 Jul 2024 08:37:27 +0200

Initially I added shmem-quota to obj-y, move it to the correct place and
remove the uneeded full file #ifdef

Link: https://lkml.kernel.org/r/20240717063737.910840-1-cem@kernel.org
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Suggested-by: Aristeu Rozanski <aris@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Makefile      |    3 ++-
 mm/shmem_quota.c |    3 ---
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/mm/Makefile~shmem_quota-build-the-object-file-conditionally-to-the-config-option
+++ a/mm/Makefile
@@ -53,7 +53,7 @@ obj-y			:= filemap.o mempool.o oom_kill.
 			   readahead.o swap.o truncate.o vmscan.o shrinker.o \
 			   shmem.o util.o mmzone.o vmstat.o backing-dev.o \
 			   mm_init.o percpu.o slab_common.o \
-			   compaction.o show_mem.o shmem_quota.o\
+			   compaction.o show_mem.o \
 			   interval_tree.o list_lru.o workingset.o \
 			   debug.o gup.o mmap_lock.o $(mmu-y)
 
@@ -141,3 +141,4 @@ obj-$(CONFIG_HAVE_BOOTMEM_INFO_NODE) +=
 obj-$(CONFIG_GENERIC_IOREMAP) += ioremap.o
 obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
+obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
--- a/mm/shmem_quota.c~shmem_quota-build-the-object-file-conditionally-to-the-config-option
+++ a/mm/shmem_quota.c
@@ -34,8 +34,6 @@
 #include <linux/quotaops.h>
 #include <linux/quota.h>
 
-#ifdef CONFIG_TMPFS_QUOTA
-
 /*
  * The following constants define the amount of time given a user
  * before the soft limits are treated as hard limits (usually resulting
@@ -351,4 +349,3 @@ const struct dquot_operations shmem_quot
 	.mark_dirty		= shmem_mark_dquot_dirty,
 	.get_next_id		= shmem_get_next_id,
 };
-#endif /* CONFIG_TMPFS_QUOTA */
_

Patches currently in -mm which might be from cem@kernel.org are

shmem_quota-build-the-object-file-conditionally-to-the-config-option.patch

