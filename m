Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F420E5380F
	for <mm-commits@vger.kernel.org>; Wed, 14 Feb 2024 15:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707924037; cv=none; b=NOdIKxVYjkMdx47+dM9GocXIqaYyzO5nTfseING7mJWJKvjP787clV5MjWbWbFYKOd5NDZwIVoxYrJXzCyAHm1ItDqj3lG3APmStMLWVQ7rP6iXjzUB7cE8ezMtCaV9IxPrwyUaZOeWqxlkS6HkFvLCCRqe4/25mCJvlLCCAPNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707924037; c=relaxed/simple;
	bh=KYKJmhLfXHhBNDwv2t5QyM0zBH8u1+ZcCPf2BAdOb0Q=;
	h=Date:To:From:Subject:Message-Id; b=HYXjsX8eDXDC64XUHo6L2i8/zbka/cpNxwrot1xDr8ihrezs6BoxjNpdh8KRDpPTgcHmPVcFy2sXKf3WGgbnnDrFN5YD1Wxjg/h/I35Q61zg3XmOqR1ooaMJz2Vupxx3OvZsPlJFDHctvf0zL9yr6I90Uv64ExfUTiNSZIIrYcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nA9TFg5v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nA9TFg5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E00EC433C7;
	Wed, 14 Feb 2024 15:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707924036;
	bh=KYKJmhLfXHhBNDwv2t5QyM0zBH8u1+ZcCPf2BAdOb0Q=;
	h=Date:To:From:Subject:From;
	b=nA9TFg5vXByExt4mVdvqp9jFXlmGHnUk1yvmYcoDS+aw4wxHfhWc/xpoI0NrAGTFC
	 VY956ww1MfDlhtCf4lk2ZhnLErEjYx8uWttxyowEWLbblAC2riCy4Kf5BD9L/NlmQm
	 8C6DBPLKX6ipYZe6UYNYAMVLpI9kSHzFxQtSE8Nw=
Date: Wed, 14 Feb 2024 07:20:35 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-stackdepot-move-stack_record-struct-definition-into-the-header-fix.patch added to mm-unstable branch
Message-Id: <20240214152036.4E00EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-stackdepot-move-stack_record-struct-definition-into-the-header-fix
has been added to the -mm mm-unstable branch.  Its filename is
     lib-stackdepot-move-stack_record-struct-definition-into-the-header-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-stackdepot-move-stack_record-struct-definition-into-the-header-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-stackdepot-move-stack_record-struct-definition-into-the-header-fix
Date: Wed Feb 14 07:17:48 AM PST 2024

fix CONFIG_STACKDEPOT=n build

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/stackdepot.h~lib-stackdepot-move-stack_record-struct-definition-into-the-header-fix
+++ a/include/linux/stackdepot.h
@@ -39,6 +39,7 @@ typedef u32 depot_stack_handle_t;
 #define DEPOT_POOL_INDEX_BITS (DEPOT_HANDLE_BITS - DEPOT_OFFSET_BITS - \
 			       STACK_DEPOT_EXTRA_BITS)
 
+#ifdef CONFIG_STACKDEPOT
 /* Compact structure that stores a reference to a stack. */
 union handle_parts {
 	depot_stack_handle_t handle;
@@ -73,6 +74,7 @@ struct stack_record {
 		};
 	};
 };
+#endif
 
 typedef u32 depot_flags_t;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix.patch
mm-ptdump-have-ptdump_check_wx-return-bool-fix.patch
mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages-fix.patch
lib-stackdepot-move-stack_record-struct-definition-into-the-header-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch
panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

