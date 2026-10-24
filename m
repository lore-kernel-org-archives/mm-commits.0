Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832333;
	b=4+5Dky1hFFdzwdsG2eWZwKd82lJlfElF/mHfrHQP3N5aJC0bDEm2uRfq2AgPZFpoWs3C
	 pJoQe8eggXnjIJNlLue9nBVHOJrkeDV1a4J4GEUAx7rZA0iVw8Lpj+TNxdQBASVmRQ+kb
	 xmptuTrcvCaKBGSXkNOX9RjowEh+urSesIygYJVAXqOB1/wqC87WziicDOwUnY/1ENs3m
	 kYtfM4AosdXl0lGNm5yKqkko/RzYhvTEShnMHA0ZyjHjiHzcHb396tF8F+0flFdiDvVSN
	 8L2zJZgnki8oXJb1IreNdP4cDPul0tFbJvFZxzMQeeE/RCcKl0QuScCBQAne0fWEB2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832333;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Nmsl0/obE/QRivQEPsJuWhgkLap8XCLhJUn7xLM8RRA=;
	b=ruBAZUt7bWqVKsc6j1KON5SCfq8uxQC/klvUB5GYKa8VWZ7J9W0Zq/AdSTLxRUw9EEKV
	 3RkSv5dw+8JbO3RIgYR2igil5Jkg7TRNgpA08SZxj1/G480QAJbN5cVMoYQAXP+T/k/g3
	 /f8PVaoL8R4xu1KkuWO6N07yVctIs/SF4ZM+LJcVJyalbYeklcgU8v138PlPvSoUw9Xxt
	 2UKootGXiyStjWEiU9Ng1YNfWfUa+HAgZLhEJdC7M9NIB0D2wwBWO9UTtis8kC9yhbBJq
	 fl0s3xq2tYGW9kixA5SZOwNgABhlajpDgYzOIDC4bVt0F/Naq5qsLgYiYHQQm9MCElg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="s6PHya/M";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBC3606A31E
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=s6PHya/M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C9B1F01825;
	Sat, 24 Oct 2026 08:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832333;
	bh=Nmsl0/obE/QRivQEPsJuWhgkLap8XCLhJUn7xLM8RRA=;
	h=Date:To:From:Subject;
	b=s6PHya/MKnDgDobrEbbBg7um/41f7foRtVKEDC3/ouHV3IsuGBN9ckwOYWWtWKxQl
	 XUepMKmuOJ2NbEvn2tfVVdSeKbLB7D0IrhLhSsq9NjcE9rlbU/QmxEjwyVE8vMLXc6
	 gWKWdJ6JA4T2/yXz1F0q0R3TltiErIEAacI9zaic=
Date: Sat, 24 Oct 2026 01:58:52 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-remove-sparsemem-related-entries-from-kconfig.patch removed from -mm tree
Message-Id: <20261024085853.07C9B1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: sh: remove SPARSEMEM related entries from Kconfig
has been removed from the -mm tree.  Its filename was
     sh-remove-sparsemem-related-entries-from-kconfig.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: sh: remove SPARSEMEM related entries from Kconfig
Date: Sun, 10 May 2026 16:55:45 +0300

Without NUMA support, SPARSEMEM related configuration options only create
unnecessary overhead.

Remove them.

Link: https://lore.kernel.org/20260510135546.13554-10-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---

 arch/sh/Kconfig    |    6 ------
 arch/sh/mm/Kconfig |   10 ----------
 2 files changed, 16 deletions(-)

--- a/arch/sh/Kconfig~sh-remove-sparsemem-related-entries-from-kconfig
+++ a/arch/sh/Kconfig
@@ -387,7 +387,6 @@ config CPU_SUBTYPE_SH7723
 	select CPU_SH4A
 	select CPU_SHX2
 	select ARCH_SHMOBILE
-	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_SH_CMT
 	select PINCTRL
 	help
@@ -398,7 +397,6 @@ config CPU_SUBTYPE_SH7724
 	select CPU_SH4A
 	select CPU_SHX2
 	select ARCH_SHMOBILE
-	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_SH_CMT
 	select PINCTRL
 	help
@@ -439,7 +437,6 @@ config CPU_SUBTYPE_SH7785
 	bool "Support SH7785 processor"
 	select CPU_SH4A
 	select CPU_SHX2
-	select ARCH_SPARSEMEM_ENABLE
 	select PINCTRL
 
 config CPU_SUBTYPE_SH7786
@@ -474,7 +471,6 @@ config CPU_SUBTYPE_SH7722
 	select CPU_SH4AL_DSP
 	select CPU_SHX2
 	select ARCH_SHMOBILE
-	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_SH_CMT
 	select PINCTRL
 
@@ -483,8 +479,6 @@ config CPU_SUBTYPE_SH7366
 	select CPU_SH4AL_DSP
 	select CPU_SHX2
 	select ARCH_SHMOBILE
-	select ARCH_SPARSEMEM_ENABLE
-	select SYS_SUPPORTS_NUMA
 	select SYS_SUPPORTS_SH_CMT
 
 endchoice
--- a/arch/sh/mm/Kconfig~sh-remove-sparsemem-related-entries-from-kconfig
+++ a/arch/sh/mm/Kconfig
@@ -115,16 +115,6 @@ config VSYSCALL
 config ARCH_FLATMEM_ENABLE
 	def_bool y
 
-config ARCH_SPARSEMEM_ENABLE
-	def_bool y
-	select SPARSEMEM_STATIC
-
-config ARCH_SPARSEMEM_DEFAULT
-	def_bool y
-
-config ARCH_SELECT_MEMORY_MODEL
-	def_bool y
-
 config IOREMAP_FIXED
        def_bool y
        depends on X2TLB
_

Patches currently in -mm which might be from rppt@kernel.org are


