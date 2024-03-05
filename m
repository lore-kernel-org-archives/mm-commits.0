Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CEF11C85
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600580; cv=none; b=WJzN0jytYW7sVgT6HfXjc7Yflra5sl36kZKUZ6i5E0/NYQv1ZcTOGG/fcXtJx3Dx0DdES6j5hCjcZY8O5D3vQ+efYeo4jsQhokT7epwkPltVPbN/bWUgcx8XXO4dhi/T3dvrcQt1Y2aPDEWjer1AhnwY9CT5qSzbhOYr6aSScC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600580; c=relaxed/simple;
	bh=iav5rkumaQNKtlKYnGx0IYDYUXaKwpqciUsSvjBH+bk=;
	h=Date:To:From:Subject:Message-Id; b=RJ91JirnSQCPi6gO5X37azNj9gVsr+8Xmlp2CLY0fi8WnvVGEa2VbpTUiOtcpaHl1Cw8+MUlP8/LENIwEIbkMpgKZ3QNKD95ppg+AvWn9bYkSUvXV2IWqvEwN7MSl4pN6chNOMOmDOUUCNE7HhvT7wWoj+NJDvXOjP+G/kHy2uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WyKHZ/C8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WyKHZ/C8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11A1C43390;
	Tue,  5 Mar 2024 01:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600579;
	bh=iav5rkumaQNKtlKYnGx0IYDYUXaKwpqciUsSvjBH+bk=;
	h=Date:To:From:Subject:From;
	b=WyKHZ/C8WcuYWGein1cQM8wDw9OKnVtVekTfZ2EpAusZPp2ELRAtCIP727x8gvPvn
	 zKz36KTPRqYdJMhGP37SFoK56L75bQ50heo9LB3IEw7pusTLG+QRe0wGPWQKvF3CGN
	 gCgMp0UGeu2mcYgAQROQHzqakitTcADldqHE4zM4=
Date: Mon, 04 Mar 2024 17:02:59 -0800
To: mm-commits@vger.kernel.org,suxiaoyi@huawei.com,mcgrof@kernel.org,echanude@redhat.com,changbin.du@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] modules-wait-do_free_init-correctly.patch removed from -mm tree
Message-Id: <20240305010259.C11A1C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: modules: wait do_free_init correctly
has been removed from the -mm tree.  Its filename was
     modules-wait-do_free_init-correctly.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Changbin Du <changbin.du@huawei.com>
Subject: modules: wait do_free_init correctly
Date: Tue, 27 Feb 2024 10:35:46 +0800

The synchronization here is to ensure the ordering of freeing of a module
init so that it happens before W+X checking.  It is worth noting it is not
that the freeing was not happening, it is just that our sanity checkers
raced against the permission checkers which assume init memory is already
gone.

Commit 1a7b7d922081 ("modules: Use vmalloc special flag") moved calling
do_free_init() into a global workqueue instead of relying on it being
called through call_rcu(..., do_free_init), which used to allowed us call
do_free_init() asynchronously after the end of a subsequent grace period. 
The move to a global workqueue broke the gaurantees for code which needed
to be sure the do_free_init() would complete with rcu_barrier().  To fix
this callers which used to rely on rcu_barrier() must now instead use
flush_work(&init_free_wq).

Without this fix, we still could encounter false positive reports in W+X
checking since the rcu_barrier() here can not ensure the ordering now.

Even worse, the rcu_barrier() can introduce significant delay.  Eric
Chanudet reported that the rcu_barrier introduces ~0.1s delay on a
PREEMPT_RT kernel.

  [    0.291444] Freeing unused kernel memory: 5568K
  [    0.402442] Run /sbin/init as init process

With this fix, the above delay can be eliminated.

Link: https://lkml.kernel.org/r/20240227023546.2490667-1-changbin.du@huawei.com
Fixes: 1a7b7d922081 ("modules: Use vmalloc special flag")
Signed-off-by: Changbin Du <changbin.du@huawei.com>
Tested-by: Eric Chanudet <echanude@redhat.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Xiaoyi Su <suxiaoyi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/moduleloader.h |    8 ++++++++
 init/main.c                  |    5 +++--
 kernel/module/main.c         |    9 +++++++--
 3 files changed, 18 insertions(+), 4 deletions(-)

--- a/include/linux/moduleloader.h~modules-wait-do_free_init-correctly
+++ a/include/linux/moduleloader.h
@@ -115,6 +115,14 @@ int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *mod);
 
+#ifdef CONFIG_MODULES
+void flush_module_init_free_work(void);
+#else
+static inline void flush_module_init_free_work(void)
+{
+}
+#endif
+
 /* Any cleanup needed when module leaves. */
 void module_arch_cleanup(struct module *mod);
 
--- a/init/main.c~modules-wait-do_free_init-correctly
+++ a/init/main.c
@@ -88,6 +88,7 @@
 #include <linux/sched/task_stack.h>
 #include <linux/context_tracking.h>
 #include <linux/random.h>
+#include <linux/moduleloader.h>
 #include <linux/list.h>
 #include <linux/integrity.h>
 #include <linux/proc_ns.h>
@@ -1403,11 +1404,11 @@ static void mark_readonly(void)
 	if (rodata_enabled) {
 		/*
 		 * load_module() results in W+X mappings, which are cleaned
-		 * up with call_rcu().  Let's make sure that queued work is
+		 * up with init_free_wq. Let's make sure that queued work is
 		 * flushed so that we don't hit false positives looking for
 		 * insecure pages which are W+X.
 		 */
-		rcu_barrier();
+		flush_module_init_free_work();
 		mark_rodata_ro();
 		debug_checkwx();
 		rodata_test();
--- a/kernel/module/main.c~modules-wait-do_free_init-correctly
+++ a/kernel/module/main.c
@@ -2489,6 +2489,11 @@ static void do_free_init(struct work_str
 	}
 }
 
+void flush_module_init_free_work(void)
+{
+	flush_work(&init_free_wq);
+}
+
 #undef MODULE_PARAM_PREFIX
 #define MODULE_PARAM_PREFIX "module."
 /* Default value for module->async_probe_requested */
@@ -2593,8 +2598,8 @@ static noinline int do_init_module(struc
 	 * Note that module_alloc() on most architectures creates W+X page
 	 * mappings which won't be cleaned up until do_free_init() runs.  Any
 	 * code such as mark_rodata_ro() which depends on those mappings to
-	 * be cleaned up needs to sync with the queued work - ie
-	 * rcu_barrier()
+	 * be cleaned up needs to sync with the queued work by invoking
+	 * flush_module_init_free_work().
 	 */
 	if (llist_add(&freeinit->node, &init_free_list))
 		schedule_work(&init_free_wq);
_

Patches currently in -mm which might be from changbin.du@huawei.com are


