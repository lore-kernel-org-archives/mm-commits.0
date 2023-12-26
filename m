Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935614C67
	for <mm-commits@vger.kernel.org>; Tue, 26 Dec 2023 20:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LvpmNsrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F295EC433C8;
	Tue, 26 Dec 2023 20:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703621787;
	bh=X7FKopck87q4z/6iGCzSJp2KRawpJKpSb2CZ75zW9ew=;
	h=Date:To:From:Subject:From;
	b=LvpmNsrpkLxTAc5LlUJd4gAYVBYol4N/TrgFkweYlJknpKtnd6bcUOH/bUuhfgSdY
	 RsD02Pxb10Ev1zXNgZoQ6rXoYsh621q4yHZuJ0hT3hzXjgoR4zyC3+VpH82Y73J6Wv
	 spSTGYtBItDKtcTtZhmygYsSqYrrwrhwvJES9hoA=
Date: Tue, 26 Dec 2023 12:16:26 -0800
To: mm-commits@vger.kernel.org,suxiaoyi@huawei.com,changbin.du@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + modules-wait-do_free_init-correctly-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20231226201626.F295EC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: modules-wait-do_free_init-correctly-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     modules-wait-do_free_init-correctly-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/modules-wait-do_free_init-correctly-fix.patch

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
Subject: modules-wait-do_free_init-correctly-fix
Date: Mon, 25 Dec 2023 14:15:13 +0800

fix compilation issue for no CONFIG_MODULES found by 0-DAY

Link: https://lkml.kernel.org/r/20231225061513.2984575-1-changbin.du@huawei.com
Fixes: 1a7b7d922081 ("modules: Use vmalloc special flag")
Signed-off-by: Changbin Du <changbin.du@huawei.com>
Cc: Xiaoyi Su <suxiaoyi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/moduleloader.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/moduleloader.h~modules-wait-do_free_init-correctly-fix
+++ a/include/linux/moduleloader.h
@@ -115,7 +115,13 @@ int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *mod);
 
+#ifdef CONFIG_MODULES
 void flush_module_init_free_work(void);
+#else
+static inline void flush_module_init_free_work(void)
+{
+}
+#endif
 
 /* Any cleanup needed when module leaves. */
 void module_arch_cleanup(struct module *mod);
_

Patches currently in -mm which might be from changbin.du@huawei.com are

modules-wait-do_free_init-correctly.patch
modules-wait-do_free_init-correctly-fix.patch

