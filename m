Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08F447F53
	for <mm-commits@vger.kernel.org>; Wed, 27 Dec 2023 21:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tmG56ni9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B129C433C8;
	Wed, 27 Dec 2023 21:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703710929;
	bh=quzvgOIp0OKWAhaMywFZCYlIz2IdouUTF4PFR3wnRQQ=;
	h=Date:To:From:Subject:From;
	b=tmG56ni93BBzLd7xTlCvL7k0jBwIh9s1nmKlagv6jwRhyujWFq/1LLR5PcJzzljek
	 t/zHzXZnV+dhW3fYBpZtBWPnqlrSiZRPPexJHiwC0RHBBeL6adCXrMScIp5GZJxjzs
	 EOYodrQ6ZsBvpXbueJLwE7VtCYdNj24VHc3/+m/8=
Date: Wed, 27 Dec 2023 13:02:08 -0800
To: mm-commits@vger.kernel.org,chenhuacai@loongson.cn,bhe@redhat.com,tangyouling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kdump-remove-redundant-default_crash_kernel_low_size.patch added to mm-nonmm-unstable branch
Message-Id: <20231227210209.6B129C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kdump: remove redundant DEFAULT_CRASH_KERNEL_LOW_SIZE
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kdump-remove-redundant-default_crash_kernel_low_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kdump-remove-redundant-default_crash_kernel_low_size.patch

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

scripts-decodecode-add-support-for-loongarch.patch
checkstack-add-loongarch-support-for-scripts-checkstackpl.patch
kdump-remove-redundant-default_crash_kernel_low_size.patch

