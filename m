Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F771426F
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yJYmxEe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA3EC433C9;
	Fri, 29 Dec 2023 20:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881418;
	bh=LFQWAG7gyLPtxxAmHF0or4tOJfFy1S5YaGbouS4sCfE=;
	h=Date:To:From:Subject:From;
	b=yJYmxEe6W0xtYJAHRoOxzzuMm22+eb7nAol/Axb9t012zxvPzB9jgkbseMfbc+tAE
	 7Y+iIxbZNkOEt8CoDRkKwJoUnFha9NFTCQk2OsLY/ezKMEnwwLoLJDpwR4pjVtUaen
	 YUcMX2RWSZJsoS32RUDJHPMzMOx4nol7ELCSvAEA=
Date: Fri, 29 Dec 2023 12:23:37 -0800
To: mm-commits@vger.kernel.org,chenhuacai@loongson.cn,bhe@redhat.com,tangyouling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kdump-remove-redundant-default_crash_kernel_low_size.patch removed from -mm tree
Message-Id: <20231229202338.2FA3EC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kdump: remove redundant DEFAULT_CRASH_KERNEL_LOW_SIZE
has been removed from the -mm tree.  Its filename was
     kdump-remove-redundant-default_crash_kernel_low_size.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Youling Tang <tangyouling@kylinos.cn>
Subject: kdump: remove redundant DEFAULT_CRASH_KERNEL_LOW_SIZE
Date: Wed, 27 Dec 2023 07:46:25 +0800

Remove duplicate definitions, no functional changes.

Link: https://lkml.kernel.org/r/MW4PR84MB3145459ADC7EB38BBB36955B8198A@MW4PR84MB3145.NAMPRD84.PROD.OUTLOOK.COM
Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
Reported-by: Huacai Chen <chenhuacai@loongson.cn>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crash_core.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/crash_core.h~kdump-remove-redundant-default_crash_kernel_low_size
+++ a/include/linux/crash_core.h
@@ -87,12 +87,6 @@ Elf_Word *append_elf_note(Elf_Word *buf,
 			  void *data, size_t data_len);
 void final_note(Elf_Word *buf);
 
-#ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
-#ifndef DEFAULT_CRASH_KERNEL_LOW_SIZE
-#define DEFAULT_CRASH_KERNEL_LOW_SIZE  (128UL << 20)
-#endif
-#endif
-
 int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base,
 		unsigned long long *low_size, bool *high);
_

Patches currently in -mm which might be from tangyouling@kylinos.cn are


