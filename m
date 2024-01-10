Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B365381
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 04:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wSsazx2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACC9C433C7;
	Wed, 10 Jan 2024 04:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704860029;
	bh=jhBVc/am4SipPAr+FHpVMCdNzTQ7/agXAWH8qGYFkH0=;
	h=Date:To:From:Subject:From;
	b=wSsazx2JkvDtPC2QGH7wv6/dNh1v+xZ/gQHRUoQMifVmYSo8UPXIM67svE6P5XXeU
	 2/sgb882+KjMazMBhyDhTilKxRNx4MPYKI8laGPG5Z18e9PZwrWx5SBqdjCi7lUFYV
	 Xt7SzdypOamuejfknwpjqdqOwwR81/IvmcbRfAEc=
Date: Tue, 09 Jan 2024 20:13:48 -0800
To: mm-commits@vger.kernel.org,suxiaoyi@huawei.com,changbin.du@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] modules-wait-do_free_init-correctly-fix.patch removed from -mm tree
Message-Id: <20240110041349.3ACC9C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: modules-wait-do_free_init-correctly-fix
has been removed from the -mm tree.  Its filename was
     modules-wait-do_free_init-correctly-fix.patch

This patch was dropped because it was folded into modules-wait-do_free_init-correctly.patch

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

