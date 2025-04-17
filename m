Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F75521506E
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 23:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744933968; cv=none; b=J+G4zLdeYthoY++qQ94GSm5tviGs883shDFx9mNse6q41GRAFkv636gdGKZPoyMCDiX6DiYA/x4LoP3Q1Zlg8YVSmqKI3XmC0eGUP/Ga5a7oRBf9F3I0DSxVMNpoUQ+ZSuC02KyvzCaTZFHuF0akXijAjQv9fj0zwHj5BMcapyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744933968; c=relaxed/simple;
	bh=qRxWVfW2gkTU+POr8H5NlabgF+orKqOZJ7NNIkjbIT0=;
	h=Date:To:From:Subject:Message-Id; b=lUc/qa3gNxpS35LMk+IDIuhodMUAX/bMpcdBC1TGKfeb25A6JR1vaYSL2mnNo4K0l6fgEvmBxKVBlsguWJ0LVRjcVE7IhGyTe343YcC2GJHiurYhDfxL3ZrrMml0XNIy0veTbr0IVmOFdV8Y1+ThSA9UhrgvLmTSNHnwWe3M7wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AC6qkpgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AC6qkpgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D489CC4CEE7;
	Thu, 17 Apr 2025 23:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744933967;
	bh=qRxWVfW2gkTU+POr8H5NlabgF+orKqOZJ7NNIkjbIT0=;
	h=Date:To:From:Subject:From;
	b=AC6qkpgXlinaSTaR9a6JeK3A+p2ZIZrNZfq8PY8IOjAKkLVqdKlmOXSBLkIU5psGe
	 IynB5GvYAFMpkbgdpR0BMTgGYvKsMKK66PocOpeDXJQn3Ss141vSa8q4zdDJo50xZf
	 0Rc+kfYpenSf5iHo83zISzTuHq0lrZSsszSUxkVQ=
Date: Thu, 17 Apr 2025 16:52:47 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,hch@infradead.org,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmalloc-align-nr_vmalloc_pages-and-vmap_lazy_nr.patch added to mm-new branch
Message-Id: <20250417235247.D489CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmalloc: align nr_vmalloc_pages and vmap_lazy_nr
has been added to the -mm mm-new branch.  Its filename is
     vmalloc-align-nr_vmalloc_pages-and-vmap_lazy_nr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmalloc-align-nr_vmalloc_pages-and-vmap_lazy_nr.patch

This patch will later appear in the mm-new branch at
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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: vmalloc: align nr_vmalloc_pages and vmap_lazy_nr
Date: Thu, 17 Apr 2025 18:12:16 +0200

Currently both atomics share one cache-line:

<snip>
...
ffffffff83eab400 b vmap_lazy_nr
ffffffff83eab408 b nr_vmalloc_pages
...
<snip>

those are global variables and they are only 8 bytes apart.  Since they
are modified by different threads this causes a false sharing.  This can
lead to a performance drop due to unnecessary cache invalidations.

After this patch it is aligned to a cache line boundary:

<snip>
...
ffffffff8260a600 d vmap_lazy_nr
ffffffff8260a640 d nr_vmalloc_pages
...
<snip>

Link: https://lkml.kernel.org/r/20250417161216.88318-4-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christop Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~vmalloc-align-nr_vmalloc_pages-and-vmap_lazy_nr
+++ a/mm/vmalloc.c
@@ -1008,7 +1008,8 @@ static BLOCKING_NOTIFIER_HEAD(vmap_notif
 static void drain_vmap_area_work(struct work_struct *work);
 static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
 
-static atomic_long_t nr_vmalloc_pages;
+static __cacheline_aligned_in_smp atomic_long_t nr_vmalloc_pages;
+static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
 
 unsigned long vmalloc_nr_pages(void)
 {
@@ -2117,8 +2118,6 @@ static unsigned long lazy_max_pages(void
 	return log * (32UL * 1024 * 1024 / PAGE_SIZE);
 }
 
-static atomic_long_t vmap_lazy_nr = ATOMIC_LONG_INIT(0);
-
 /*
  * Serialize vmap purging.  There is no actual critical section protected
  * by this lock, but we want to avoid concurrent calls for performance
_

Patches currently in -mm which might be from urezki@gmail.com are

vmalloc-add-for_each_vmap_node-helper.patch
vmalloc-switch-to-for_each_vmap_node-helper.patch
vmalloc-use-for_each_vmap_node-in-purge-vmap-area.patch
vmalloc-use-atomic_long_add_return_relaxed.patch
lib-test_vmallocc-replace-rwsem-to-srcu-for-setup.patch
lib-test_vmallocc-allow-built-in-execution.patch
maintainers-add-test_vmallocc-to-vmalloc-section.patch
vmalloc-align-nr_vmalloc_pages-and-vmap_lazy_nr.patch

