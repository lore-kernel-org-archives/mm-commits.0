Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B21A2D613
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247666; cv=none; b=PdSXVJnkNaRy5I4+I8XFUQ6BYAUa5YH03b7nX2tW8fw7rOR2acnlDN6QOIbY1QGwPoYh9a4LoCbIqUFaFGKQRqzV81labA/at0UihRlTL0y1imk5koNoGNBfgeBLMN0ElaPykCs1D27nU3ArzXWlmrhZbJdSOzcTx7/d7gq60X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247666; c=relaxed/simple;
	bh=+7Q60RRWA/FrwUurYnVrGVV6IwL51K67hqoJ1sJqCLU=;
	h=Date:To:From:Subject:Message-Id; b=rgdoo5u0QEkrIjabbqGQUljM/MQgjqwO8AzV//JNjoCfELLhNcEoNY7/YmqdH/jOwbCaoWe8QXH+JRfEJttcTjqmiq0j01ELisg8iBY80HQiCpf8KDty2ChHMhPQRmdnTfY92JhftjGAo9qpenkLZfJxFYuaXqld4ivDusn+qDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fpSjMsO9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fpSjMsO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A046C4CEC2;
	Mon,  2 Sep 2024 03:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247665;
	bh=+7Q60RRWA/FrwUurYnVrGVV6IwL51K67hqoJ1sJqCLU=;
	h=Date:To:From:Subject:From;
	b=fpSjMsO9BOpLeMWjTOk1iJh2dWBdrTVi1iZpExD/5UD7cJuL/e2pTO1pO2SbYunVh
	 UHf59BsN9QunqPMfAs9+0L9lUhPReCtA3viOFU20EljYP2ZdwSu4msEHGUlI9NHA0m
	 v2KIWZsLcM0YFVK6SQlizPnwB21ge5YcKgc0+wc4=
Date: Sun, 01 Sep 2024 20:27:44 -0700
To: mm-commits@vger.kernel.org,jack@suse.cz,hughd@google.com,cmaiolino@redhat.com,brauner@kernel.org,aris@redhat.com,cem@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem_quota-build-the-object-file-conditionally-to-the-config-option.patch removed from -mm tree
Message-Id: <20240902032745.5A046C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: shmem_quota: build the object file conditionally to the config option
has been removed from the -mm tree.  Its filename was
     shmem_quota-build-the-object-file-conditionally-to-the-config-option.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Carlos Maiolino <cem@kernel.org>
Subject: shmem_quota: build the object file conditionally to the config option
Date: Wed, 17 Jul 2024 08:37:27 +0200

Initially I added shmem-quota to obj-y, move it to the correct place and
remove the unneeded full file #ifdef

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


