Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BBD168C4
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 17:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473212; cv=none; b=C7SkgsYvF7C/Ov6bONqF3csXDm1ij1Dt1Gcq2RVquXbTe3LQ8EO7EkdmqpId1eNjVinpAwPQ/D8sam1z2K4rgCxV/xQNLbzwaFtNThSOAKVwLpPwouo9w+czaSoPexFG5WPM8rNwiH88ZO7L6w/kyHP9PW/XCIxKuyBgpWCuYK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473212; c=relaxed/simple;
	bh=jrjsVjMXAyOvv4eC+y6uXtyNRuCEan7V2OH8Hao/er0=;
	h=Date:To:From:Subject:Message-Id; b=mWz9RHXv3N14eIK4sTeX13GVywlomCEJ0fjvGDNcJHYCMgYEKQidUptff0BASnR5C3RT/Q5T96eeTwvCTkREZaAEpkwE+/tz6yUhJVncDJxLwUVriz/V6YJs2dPbCOerRKC8LECWHAKMgOzFyresWVy+PbzFLDA67QfhiIs4c0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cdTmaCs8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cdTmaCs8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDECC116B1;
	Sat, 15 Jun 2024 17:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473212;
	bh=jrjsVjMXAyOvv4eC+y6uXtyNRuCEan7V2OH8Hao/er0=;
	h=Date:To:From:Subject:From;
	b=cdTmaCs8e4qOYihjJhKkK/p/sY5C9W62PQ8NyJY9d+bwxEZ7Qwt9YJWe8hJfodSVC
	 MDqDkPLINTF7CWiGwGFXjcldeROAJA3grLQGu7BDFjVfh7bIv4ikpoGcFsvI2QS+GB
	 F6jkzxz+ih4tJ6O+dTiNGQm7U7RbUrpsf7R7yFzg=
Date: Sat, 15 Jun 2024 10:40:11 -0700
To: mm-commits@vger.kernel.org,samuel.holland@sifive.com,rppt@kernel.org,pmladek@suse.com,paulmck@kernel.org,hca@linux.ibm.com,arnd@arndb.de,aquini@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default-fix.patch removed from -mm tree
Message-Id: <20240615174012.2DDECC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default-fix
has been removed from the -mm tree.  Its filename was
     mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default-fix.patch

This patch was dropped because it was folded into mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default-fix
Date: Tue Jun 11 07:39:46 PM PDT 2024

default to `y' if 32-bit, per Rafael

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Samuel Holland <samuel.holland@sifive.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/Kconfig~mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default-fix
+++ a/arch/Kconfig
@@ -1048,7 +1048,7 @@ config ARCH_MMAP_RND_BITS_DEFAULT
 
 config FORCE_MAX_MMAP_RND_BITS
 	bool "Force maximum number of bits to use for ASLR of mmap base address"
-	default n
+	default y if !64BIT
 	help
 	  ARCH_MMAP_RND_BITS and ARCH_MMAP_RND_COMPAT_BITS represent the number
 	  of bits to use for ASLR and if no custom value is assigned (EXPERT)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mmap-allow-for-the-maximum-number-of-bits-for-randomizing-mmap_base-by-default.patch
writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3-fix.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-fix.patch

