Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E88EEBD
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757809069; cv=none; b=tcbD1S4PnY7HrdYrvlZ9Si6eajbtu5gL76WAmUMGM2nYRn9aFEERlnPc4SqYnPWo5pMggopiOV4FNwsg5aAncd+7QvGC14zUEi7db3V0rms6aR/JpRz0U12iR1882XVcDunZ302C+8l7rZCD1jkzl3nOJQgySqoMCCE+XU0W3Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757809069; c=relaxed/simple;
	bh=7yORv1kPc/DZ/Zj3mbTVGCgsoBksCT3Sm4DWCe/LJhY=;
	h=Date:To:From:Subject:Message-Id; b=kIYDxgxZ5k6gbOjJYnts3gI1a9B7HYo+/qvoAiReAxTzwq4rcBmbNRnQKLACDTkncigsU0ymlR67Wvzl2KkSiIVVsZjxmluBHHx3d1sIP4GBNMNEZYcX9ZbpS64AQQizKI6UIvtrCp+/eJMrh7eh0SfIISz7o0OwjP/nAT/icWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z/Rh0jK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z/Rh0jK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77104C4CEEB;
	Sun, 14 Sep 2025 00:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757809068;
	bh=7yORv1kPc/DZ/Zj3mbTVGCgsoBksCT3Sm4DWCe/LJhY=;
	h=Date:To:From:Subject:From;
	b=Z/Rh0jK3xKq2ekTD2eVDJObprbYd9MSQsSFkvwzB6SarZeQJYyd0UVHUAyhNv6DeW
	 UmgKY0Aa+XQhLcCBMcAMx013zV3YjgqY+Vyg/hRO/33cto4MYe25E5p+/a3Sj0h+uh
	 wAgQhOQAKjKEgRtxisN+OyxSitEvujPyyDoAJDro=
Date: Sat, 13 Sep 2025 17:17:47 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,tglx@linutronix.de,mingo@redhat.com,hpa@zytor.com,fuqiang.wang@easystack.cn,dyoung@redhat.com,coxu@redhat.com,bp@alien8.de,bhe@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] crash-add-kunit-tests-for-crash_exclude_mem_range-fix.patch removed from -mm tree
Message-Id: <20250914001748.77104C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash-add-kunit-tests-for-crash_exclude_mem_range-fix
has been removed from the -mm tree.  Its filename was
     crash-add-kunit-tests-for-crash_exclude_mem_range-fix.patch

This patch was dropped because it was folded into crash-add-kunit-tests-for-crash_exclude_mem_range.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: crash-add-kunit-tests-for-crash_exclude_mem_range-fix
Date: Thu Sep  4 08:07:47 PM PDT 2025

export crash_exclude_mem_range() to modules, for kernel/crash_core_test.c

Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: fuqiang wang <fuqiang.wang@easystack.cn>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/crash_core.c~crash-add-kunit-tests-for-crash_exclude_mem_range-fix
+++ a/kernel/crash_core.c
@@ -338,6 +338,7 @@ int crash_exclude_mem_range(struct crash
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(crash_exclude_mem_range);
 
 ssize_t crash_get_memory_size(void)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch
include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch
crash-add-kunit-tests-for-crash_exclude_mem_range.patch

