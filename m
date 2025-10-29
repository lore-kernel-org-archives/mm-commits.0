Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B462EBB84
	for <mm-commits@vger.kernel.org>; Wed, 29 Oct 2025 21:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761774910; cv=none; b=EtI0ZRneg9zTSRROSivOgIZfVmJDCyE2XuXyn+fG3+q6DzotOuatxaW5M22KCEsHWvquTPr0M6IoU+mFWUTcsZZHwrdxOkrX59gRchUe/U5M7kNgDbWB0CCx9Y8e/5EPk8QUfBNNaG+bICBxfUyVHoMfzB2DUc1r+EsrHNh3Ye0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761774910; c=relaxed/simple;
	bh=DkTGGmaUCkxHhdmJat+ZguFQfpPomWxDZG9vmtkWf8M=;
	h=Date:To:From:Subject:Message-Id; b=LxqM8tRP6d674K3ZAgLRLaHgEXUikJzVl9A61XNIupCgwxg9FKrnXH4QpBQYvZjBwVWmqWKXnlcFEd00vzNaTJeaQOHff6o8VWKIL2TmeOrnYJt5v0kBrlfALoS38Y3CN24IgCcGdIZiCXVQ/LKx0LcwZV9r2CGZ2xcJB9v3BCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IJQplGmy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IJQplGmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4883C4CEF7;
	Wed, 29 Oct 2025 21:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761774906;
	bh=DkTGGmaUCkxHhdmJat+ZguFQfpPomWxDZG9vmtkWf8M=;
	h=Date:To:From:Subject:From;
	b=IJQplGmyCmApwO8haNeMpi3jueXeFA9L2noaG4uy1I4A9nG+p9N2LBbMLN5fb8ks3
	 DgdSGL6D0ZZvnfD30T4rIvy7qrN+ELtCmbZcwmoHDYLOjvEY149MO33juOan2DCJ/W
	 XR6majKipSpMfsGNYhaE+voGsk29wJYM8CqFGeTE=
Date: Wed, 29 Oct 2025 14:55:06 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,rdunlap@infradead.org,osandov@osandov.com,lorenzo.stoakes@oracle.com,david@redhat.com,linux@israelbatista.dev.br,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-type-of-parameter-for-memory_notify.patch added to mm-new branch
Message-Id: <20251029215506.C4883C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: change type of parameter for memory_notify
has been added to the -mm mm-new branch.  Its filename is
     mm-change-type-of-parameter-for-memory_notify.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-type-of-parameter-for-memory_notify.patch

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
From: Israel Batista <linux@israelbatista.dev.br>
Subject: mm: change type of parameter for memory_notify
Date: Wed, 29 Oct 2025 19:56:32 +0000 (UTC)

memory_notify() is responsible for sending events related to memory
hotplugging to a notification queue.  Since all the events must match one
of the values from the enum memory_block_state, it is appropriate to
change the function parameter type to make this condition explicit at
compile time.

Link: https://lkml.kernel.org/r/20251029195617.2210700-4-linux@israelbatista.dev.br
Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Omar Sandoval <osandov@osandov.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c  |    4 ++--
 include/linux/memory.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/base/memory.c~mm-change-type-of-parameter-for-memory_notify
+++ a/drivers/base/memory.c
@@ -204,9 +204,9 @@ static ssize_t state_show(struct device
 	return sysfs_emit(buf, "%s\n", output);
 }
 
-int memory_notify(unsigned long val, void *v)
+int memory_notify(enum memory_block_state state, void *v)
 {
-	return blocking_notifier_call_chain(&memory_chain, val, v);
+	return blocking_notifier_call_chain(&memory_chain, state, v);
 }
 
 #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
--- a/include/linux/memory.h~mm-change-type-of-parameter-for-memory_notify
+++ a/include/linux/memory.h
@@ -141,7 +141,7 @@ static inline int register_memory_notifi
 static inline void unregister_memory_notifier(struct notifier_block *nb)
 {
 }
-static inline int memory_notify(unsigned long val, void *v)
+static inline int memory_notify(enum memory_block_state state, void *v)
 {
 	return 0;
 }
@@ -165,7 +165,7 @@ int create_memory_block_devices(unsigned
 				struct memory_group *group);
 void remove_memory_block_devices(unsigned long start, unsigned long size);
 extern void memory_dev_init(void);
-extern int memory_notify(unsigned long val, void *v);
+extern int memory_notify(enum memory_block_state state, void *v);
 extern struct memory_block *find_memory_block(unsigned long section_nr);
 typedef int (*walk_memory_blocks_func_t)(struct memory_block *, void *);
 extern int walk_memory_blocks(unsigned long start, unsigned long size,
_

Patches currently in -mm which might be from linux@israelbatista.dev.br are

mm-convert-memory-block-states-mem_-macros-to-enum.patch
mm-change-type-of-state-in-struct-memory_block.patch
mm-change-type-of-parameter-for-memory_notify.patch

