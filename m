Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DB52F35
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 04:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ELuMJYQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B6FC433C7;
	Wed, 10 Jan 2024 04:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704860059;
	bh=pJ5I8IANjjbNDIj5heXjBAx+qEplqyBzGOCHCpwE/TA=;
	h=Date:To:From:Subject:From;
	b=ELuMJYQUluybpSnsci2lsey3SNraGbWc/xB8OoOqPMKTh1K5iiiV/pdsZVTsitlHx
	 8C0rTvLMPa65VKcjUEXHAe/wIxRWPpgFo25Z+ju9f+sLtmaV1tWoODAAy4Z5pgT63E
	 QeiLc7qzWstFnxZ/qeUMNcvlyCA3DVdYRJ/lJsqI=
Date: Tue, 09 Jan 2024 20:14:18 -0800
To: mm-commits@vger.kernel.org,suxiaoyi@huawei.com,mcgrof@kernel.org,hw.huiwang@huawei.com,changbin.du@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] modules-wait-do_free_init-correctly.patch removed from -mm tree
Message-Id: <20240110041419.03B6FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: modules: wait do_free_init correctly
has been removed from the -mm tree.  Its filename was
     modules-wait-do_free_init-correctly.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Changbin Du <changbin.du@huawei.com>
Subject: modules: wait do_free_init correctly
Date: Tue, 19 Dec 2023 22:12:31 +0800

Commit 1a7b7d922081 ("modules: Use vmalloc special flag") moves
do_free_init() into a global workqueue instead of call_rcu().  So now we
should wait it via flush_work().

[changbin.du@huawei.com: fix compilation issue for no CONFIG_MODULES found by 0-DAY]
  Link: https://lkml.kernel.org/r/20231225061513.2984575-1-changbin.du@huawei.com
Link: https://lkml.kernel.org/r/20231219141231.2218215-1-changbin.du@huawei.com
Fixes: 1a7b7d922081 ("modules: Use vmalloc special flag")
Signed-off-by: Changbin Du <changbin.du@huawei.com>
Cc: Xiaoyi Su <suxiaoyi@huawei.com>
Cc: Hui Wang <hw.huiwang@huawei.com>
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


