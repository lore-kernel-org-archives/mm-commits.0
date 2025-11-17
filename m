Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5634523E342
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343278; cv=none; b=kehw3lWpRD8yQQOqRM44h22oLPAJbKj+2WmesTX2UJyQ3ludNREUNalK2M1PD6MeAEjoVbkLHNoPrWle0eV/k8FuHRaqKJsFxXIJpBuyBEXLX/T/IIOiCZDbQ5G9a2wnDlO3jm58tnpxtgLWGKf6SqPh7XIZhYzgyHMyu8GuwnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343278; c=relaxed/simple;
	bh=C43FLhUJ4npk7YQPLpQsG3c+7GGWzydCgfj3LKHJSjI=;
	h=Date:To:From:Subject:Message-Id; b=C/jVGcRc8HW0bOB2ocnS3Jnu7j2QqDEHG46qGJ6K9pz7NrOMsKwsYt6IN0whnt/fgi19tOaIwzGsXZI+1oxAg/RQvkY0uPcrJhATl7qFxCViM8WEf/OLrpmQ3Quh1CBuq1IANxJM4uLNdkuUl2xgrg4WlE6+mes4xfcLy2rv/ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qT0hHXy9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qT0hHXy9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264D5C116D0;
	Mon, 17 Nov 2025 01:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343278;
	bh=C43FLhUJ4npk7YQPLpQsG3c+7GGWzydCgfj3LKHJSjI=;
	h=Date:To:From:Subject:From;
	b=qT0hHXy9nDGhwnjo0DPfUkXVLPvAe/nwLXwzPwWKk7cPkPP6mGZYlO380lNdQjgOE
	 VkVSWA7lLg9Zm/j7B0tuIVGnxHmHT86RzAYujmdwKt6crknRuRHxKPmeZoDk/t7aW5
	 gGlMhcwU4ul2sX8C2BJ/aqNdK1dlBuqy3sVbk0uA=
Date: Sun, 16 Nov 2025 17:34:37 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,rdunlap@infradead.org,osandov@osandov.com,lorenzo.stoakes@oracle.com,david@redhat.com,linux@israelbatista.dev.br,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-type-of-parameter-for-memory_notify.patch removed from -mm tree
Message-Id: <20251117013438.264D5C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: change type of parameter for memory_notify
has been removed from the -mm tree.  Its filename was
     mm-change-type-of-parameter-for-memory_notify.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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


