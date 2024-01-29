Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F36556469
	for <mm-commits@vger.kernel.org>; Mon, 29 Jan 2024 10:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706525307; cv=none; b=lJBsc+GbYxpaTr//z/rMQtO3eWdBgRgmSdVeNgh+d/Umw2kKmXV6h6CtsH6hj8M8WlkOxBIIp6d0VAU+AVd76/idW7NsG1Sh3S8X02Xk9FRzX3B+iMCygXS6rUYqcZ5b55injk3LhGCKq5N7iODaWN4QeMDLJ/+bgUq+ykZeBZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706525307; c=relaxed/simple;
	bh=cq1ZKv1cH/WeuBEMcNvbYA3RRZeGUK8yx92qli3+Yyc=;
	h=Date:To:From:Subject:Message-Id; b=daHNpQSoi5T2lSK/IGtcgLzCF4HhxP4PNsl7boJmDDZ0Z1AIlLxp8LdEVgkk0q15ZEVyS/lIYzOJOWYKR75u5nERvcOnfq8KiE2mKls7kFs9fjrPCjnlgsglO/sYQnuGp/Yy/kqDi7HFQmW1uABfmCFd6XsP7umHLxhjwu+jAZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SKt/3Wci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SKt/3Wci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFA1C433F1;
	Mon, 29 Jan 2024 10:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706525306;
	bh=cq1ZKv1cH/WeuBEMcNvbYA3RRZeGUK8yx92qli3+Yyc=;
	h=Date:To:From:Subject:From;
	b=SKt/3WciKRLdbbVXWSBrFgmjVKJnVe/RzW6phdX+Q+KvFnlFdFRJKVJlTE2y99gDw
	 HZYt7jdwyn5uuIPMmYS9By+kM855RQ/OjSJfzBbMiRabL6dm6rZShGtJ0ypgBKm86j
	 /jHkkZsxWMcH50/mKdYEyE7E4vZAZ1J5dAfi8neA=
Date: Mon, 29 Jan 2024 02:48:23 -0800
To: mm-commits@vger.kernel.org,suxiaoyi@huawei.com,mcgrof@kernel.org,changbin.du@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + modules-wait-do_free_init-correctly.patch added to mm-nonmm-unstable branch
Message-Id: <20240129104826.3DFA1C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: modules: wait do_free_init correctly
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     modules-wait-do_free_init-correctly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/modules-wait-do_free_init-correctly.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Changbin Du <changbin.du@huawei.com>
Subject: modules: wait do_free_init correctly
Date: Mon, 29 Jan 2024 10:03:04 +0800

commit 1a7b7d922081 ("modules: Use vmalloc special flag") moves
do_free_init() into a global workqueue instead of call_rcu().  So now
rcu_barrier() can not ensure that do_free_init has completed.  We should
wait it via flush_work().

Without this fix, we still could encounter false positive reports in W+X
checking, and rcu synchronization is unnecessary.

Link: https://lkml.kernel.org/r/20240129020304.1981372-1-changbin.du@huawei.com
Fixes: 1a7b7d922081 ("modules: Use vmalloc special flag")
Signed-off-by: Changbin Du <changbin.du@huawei.com>
Cc: Xiaoyi Su <suxiaoyi@huawei.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/moduleloader.h |    8 ++++++++
 init/main.c                  |    5 +++--
 kernel/module/main.c         |    5 +++++
 3 files changed, 16 insertions(+), 2 deletions(-)

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
@@ -99,6 +99,7 @@
 #include <linux/init_syscalls.h>
 #include <linux/stackdepot.h>
 #include <linux/randomize_kstack.h>
+#include <linux/moduleloader.h>
 #include <net/net_namespace.h>
 
 #include <asm/io.h>
@@ -1397,11 +1398,11 @@ static void mark_readonly(void)
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
 		rodata_test();
 	} else
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
_

Patches currently in -mm which might be from changbin.du@huawei.com are

modules-wait-do_free_init-correctly.patch

