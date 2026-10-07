Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DD63515E3
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338676; cv=none; b=PV9vM4D/qQPcIqW+CLuw9KkuMR3sVRldkUcIwwVTM1vcNJJYr/4wIicD9xBq/3u5zQisSEvnR2SR5qiLMmEsszJwsVM//plR7aIh8zTPs/mUktbYqeNIoHthiGRFniYrGCp++xNnfX5nQYk9mQvGMXRZLtCt4Oi3RwvBn5Bpcr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338676; c=relaxed/simple;
	bh=HfjbflD1oN0hESbxy7lGT+VF1LOauw7CZspZM7FlpuY=;
	h=Date:To:From:Subject:Message-Id; b=Z8vbznqxtoHcJPEam9ttEoKhohfqUYjZ0YDTH0B7emIF/9XPki8aQ9QOkZKWfgQX1N35yDvr0mtScl+OSfndFCwg06kVSD8gC8zYBGB0uICAOtBAXYZGVd82dWsEfhXgTH1iUOdYrGmf2Aq1LkmaHqGNZxb3NLJsaZn5Wf5xAzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s6Vwn1Rl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s6Vwn1Rl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA191F0089B;
	Wed,  7 Oct 2026 02:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338675;
	bh=wqhVytmpoX2iqBXauEaHtcij8w8bFKHcHJK29L8tghs=;
	h=Date:To:From:Subject;
	b=s6Vwn1Rl36P4AysSiKjf2qxFQedDWD1ajDHjHAZLxmuzsm0ctpETapZQv3sKNi7/H
	 14jFrP1DF9mQNDIoy3I363GWoq9rJc6hMFa2mp6+A9SEGjrQj3wRHDNmZMLOuUtKgl
	 yk1EFYoP/H/GbH49izw5U+G+IgHS0PNVhlJ+cZqU=
Date: Tue, 06 Oct 2026 19:04:34 -0700
To: mm-commits@vger.kernel.org,ruanjinjie@huawei.com,arnd@arndb.de,julianbraha@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] arch-kconfig-fix-dead-conditions-by-removing-dead-options.patch removed from -mm tree
Message-Id: <20261007020435.4DA191F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch/Kconfig: fix dead conditions by removing dead options
has been removed from the -mm tree.  Its filename was
     arch-kconfig-fix-dead-conditions-by-removing-dead-options.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Julian Braha <julianbraha@gmail.com>
Subject: arch/Kconfig: fix dead conditions by removing dead options
Date: Mon, 31 Aug 2026 00:00:16 +0100

These two 'int' options:

ARCH_MMAP_RND_BITS_DEFAULT
ARCH_MMAP_RND_COMPAT_BITS_DEFAULT

are used directly as conditions for defaults. 'int' options should not be
used as conditions, because they will always evaluate to false.

Let's remove these options, because they are not used anywhere else.

This dead code was found by kconfirm, a static analysis tool for Kconfig.

Link: https://lore.kernel.org/20260830230016.2730093-1-julianbraha@gmail.com
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
---

 arch/Kconfig |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/Kconfig~arch-kconfig-fix-dead-conditions-by-removing-dead-options
+++ a/arch/Kconfig
@@ -1238,13 +1238,9 @@ config ARCH_MMAP_RND_BITS_MIN
 config ARCH_MMAP_RND_BITS_MAX
 	int
 
-config ARCH_MMAP_RND_BITS_DEFAULT
-	int
-
 config ARCH_MMAP_RND_BITS
 	int "Number of bits to use for ASLR of mmap base address" if EXPERT
 	range ARCH_MMAP_RND_BITS_MIN ARCH_MMAP_RND_BITS_MAX
-	default ARCH_MMAP_RND_BITS_DEFAULT if ARCH_MMAP_RND_BITS_DEFAULT
 	default ARCH_MMAP_RND_BITS_MIN
 	depends on HAVE_ARCH_MMAP_RND_BITS
 	help
@@ -1272,13 +1268,9 @@ config ARCH_MMAP_RND_COMPAT_BITS_MIN
 config ARCH_MMAP_RND_COMPAT_BITS_MAX
 	int
 
-config ARCH_MMAP_RND_COMPAT_BITS_DEFAULT
-	int
-
 config ARCH_MMAP_RND_COMPAT_BITS
 	int "Number of bits to use for ASLR of mmap base address for compatible applications" if EXPERT
 	range ARCH_MMAP_RND_COMPAT_BITS_MIN ARCH_MMAP_RND_COMPAT_BITS_MAX
-	default ARCH_MMAP_RND_COMPAT_BITS_DEFAULT if ARCH_MMAP_RND_COMPAT_BITS_DEFAULT
 	default ARCH_MMAP_RND_COMPAT_BITS_MIN
 	depends on HAVE_ARCH_MMAP_RND_COMPAT_BITS
 	help
_

Patches currently in -mm which might be from julianbraha@gmail.com are


