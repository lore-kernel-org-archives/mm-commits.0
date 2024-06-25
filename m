Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8B913D289
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291585; cv=none; b=cFI1itz9VvABp23k7UoIaVQQLUYvVcw3TUI+pZGiFlHiSYs9LACub2eqt9r6KVLxZf2sV/Mmc8sT5hWvoxRxbmnWGhnV60xI7X8RbJY9M/S3YZixnN2AlrpfWfb0B5o4WvLGCTbYMiEoFxdZz6/xmThkl27zMuf4kdQ+8YbEgGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291585; c=relaxed/simple;
	bh=X8G2+SejM/hfpJBj8ZMBD0okzX7aAwHpuhM7tiOsq5Q=;
	h=Date:To:From:Subject:Message-Id; b=lPxg4bIMrNoRHsG8ed+VCrqoRwaQqIc8N39MW6NXaUKsUQlf3QO+zMVDdrG4Yt1Z7Of5c6ovj+DQZlyDbiA9dPdPy59GriKDgiqn1OkUFPbMpd8GJTV+DXBAbxHuh2hrg+QuYl1mbJWvQvrCYddNUxGZ9qeGGuICISbfxq5JEDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xm9mKpit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xm9mKpit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004A9C32782;
	Tue, 25 Jun 2024 04:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291585;
	bh=X8G2+SejM/hfpJBj8ZMBD0okzX7aAwHpuhM7tiOsq5Q=;
	h=Date:To:From:Subject:From;
	b=xm9mKpit/2wEi9Vh3wie+jm4CBgSShI7agK8eleF/0QWiYoN9fZLWjU1tLq2ybymX
	 2XplzSXQ/mlSPE5rzDEhEPIpEIEI/JYL9FnBNWXO7PgDSXkBHq+9zbJT/nHIbo0LW2
	 Y4MmCOZPVMho4KcvUYyQxfjB+zrcPWfTr+EdgpJg=
Date: Mon, 24 Jun 2024 21:59:44 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,nao.horiguchi@gmail.com,minchan@kernel.org,linmiaohe@huawei.com,glider@google.com,elver@google.com,dvyukov@google.com,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-add-module_description.patch removed from -mm tree
Message-Id: <20240625045945.004A9C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hwpoison: add MODULE_DESCRIPTION()
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-add-module_description.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: mm/hwpoison: add MODULE_DESCRIPTION()
Date: Mon, 13 May 2024 12:37:38 -0700

Patch series "mm: add missing MODULE_DESCRIPTION() macros".

This fixes the instances of "WARNING: modpost: missing
MODULE_DESCRIPTION()" that I'm seeing in mm/.


This patch (of 4):

Fix the 'make W=1' warning:
WARNING: modpost: missing MODULE_DESCRIPTION() in mm/hwpoison-inject.o

Link: https://lkml.kernel.org/r/20240513-mm-md-v1-0-8c20e7d26842@quicinc.com
Link: https://lkml.kernel.org/r/20240513-mm-md-v1-1-8c20e7d26842@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hwpoison-inject.c~mm-hwpoison-add-module_description
+++ a/mm/hwpoison-inject.c
@@ -110,4 +110,5 @@ static int __init pfn_inject_init(void)
 
 module_init(pfn_inject_init);
 module_exit(pfn_inject_exit);
+MODULE_DESCRIPTION("HWPoison pages injector");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

backtracetest-add-module_description.patch
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch
kunit-add-missing-module_description-macros-for-lib-_testko.patch
lib-asn1_encoder-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-to-lib-_kunitc.patch
uuid-add-missing-module_description-macro.patch
siphash-add-missing-module_description-macro.patch
lib-test_kmod-add-missing-module_description-macro.patch
lib-test_linear_ranges-add-missing-module_description-macro.patch
kunit-add-missing-module_description-macros-for-lib-test_ko.patch
kfifo-add-missing-module_description-macros.patch
resource-add-missing-module_description.patch
selftests-fpu-add-missing-module_description-macro.patch

