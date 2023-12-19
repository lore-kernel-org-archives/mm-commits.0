Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777003B191
	for <mm-commits@vger.kernel.org>; Tue, 19 Dec 2023 20:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ntCEpc8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0D2C433C8;
	Tue, 19 Dec 2023 20:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703019173;
	bh=I0bqvZzXwmrk3zKj3qfhLAw8AijOE/4G2YMg3wB6aqY=;
	h=Date:To:From:Subject:From;
	b=ntCEpc8QYrLmQv1dyJ24OjgC/jn2NPd//7YIGAht4IBivTfDfeE66y7uTnjdq8T6Y
	 U1lrbsVGrfar24bS0QJt9Ih0vFHPC6Nqzo1U4BtrJQ7UJDBrr+7HYbdG+zQlHgkbjy
	 KSiUuHWG+EW0HcaE4Ty93Pd3louxfoMthhOlXyAc=
Date: Tue, 19 Dec 2023 12:52:52 -0800
To: mm-commits@vger.kernel.org,suxiaoyi@huawei.com,mcgrof@kernel.org,hw.huiwang@huawei.com,changbin.du@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + modules-wait-do_free_init-correctly.patch added to mm-nonmm-unstable branch
Message-Id: <20231219205253.2B0D2C433C8@smtp.kernel.org>
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
Date: Tue, 19 Dec 2023 22:12:31 +0800

Commit 1a7b7d922081 ("modules: Use vmalloc special flag") moves
do_free_init() into a global workqueue instead of call_rcu().  So now we
should wait it via flush_work().

Link: https://lkml.kernel.org/r/20231219141231.2218215-1-changbin.du@huawei.com
Fixes: 1a7b7d922081 ("modules: Use vmalloc special flag")
Signed-off-by: Changbin Du <changbin.du@huawei.com>
Cc: Xiaoyi Su <suxiaoyi@huawei.com>
Cc: Hui Wang <hw.huiwang@huawei.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/moduleloader.h |    2 ++
 init/main.c                  |    5 +++--
 kernel/module/main.c         |    5 +++++
 3 files changed, 10 insertions(+), 2 deletions(-)

--- a/include/linux/moduleloader.h~modules-wait-do_free_init-correctly
+++ a/include/linux/moduleloader.h
@@ -115,6 +115,8 @@ int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *mod);
 
+void flush_module_init_free_work(void);
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
@@ -1402,11 +1403,11 @@ static void mark_readonly(void)
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
@@ -2486,6 +2486,11 @@ static void do_free_init(struct work_str
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

