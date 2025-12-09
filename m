Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759C03043DE
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308815; cv=none; b=JfIM99Ptxtfy1zTBkPYoOZgLuxkRZWLrkSs5v9VgAeU0wDM1manZhmuG3ghCKt9e4CVTqgAGHOsV+cEath2zsZmqGxC4u6k1DaKg2CjS/1bF1VL9Hk/O744FN3n/TncRfBrTt2NL4af6/EyFbzdeFHbfPxuvlXezIsHjsumssQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308815; c=relaxed/simple;
	bh=kYUlA4m0CfQpuOm9EQC93gAWwL17X6odjzA6ufVqsNQ=;
	h=Date:To:From:Subject:Message-Id; b=qDv6cBLH6S1DDtJXZqNgDV1aEIUj1vXrwHXgPaaMWgBwHJYVEFzN+Dl95BPLINgSSCgpS4KGm23UCYfJtli5KRAdLFWi8Lax6iChYeSh+eeRrEm3vDUUCeE8/Y36nAkOgG8DruJgZM4JVCV91Z0cGNp2glvsfu3scNib6WStHgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EmOM/LJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EmOM/LJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C66C4CEF5;
	Tue,  9 Dec 2025 19:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308815;
	bh=kYUlA4m0CfQpuOm9EQC93gAWwL17X6odjzA6ufVqsNQ=;
	h=Date:To:From:Subject:From;
	b=EmOM/LJq6pwrsftbLwkYMpnMokIVo1N18FtnADSIsl5TDlzA1o7bmYrmpXxtLVA6j
	 MOzjHbTGV9T7UkSzcJVzmqmoIXq3pzb6R9OfYZU7R3Uc1uXHYmyLBfyj7Wp7PWFE/H
	 eU2SOhvSe+AqqRhzkBX8Tb40zxRduzQePGjPM6A4=
Date: Tue, 09 Dec 2025 11:33:34 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mm-memfd_luo-add-config_shmem-dependency.patch removed from -mm tree
Message-Id: <20251209193335.48C66C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memfd_luo: add CONFIG_SHMEM dependency
has been removed from the -mm tree.  Its filename was
     mm-memfd_luo-add-config_shmem-dependency.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: memfd_luo: add CONFIG_SHMEM dependency
Date: Thu, 4 Dec 2025 11:01:58 +0100

The new memfd code fails to link without SHMEM:

aarch64-linux-ld: mm/memfd_luo.o: in function `memfd_luo_retrieve_folios':
memfd_luo.c:(.text.memfd_luo_retrieve_folios+0xdc): undefined reference to `shmem_add_to_page_cache'
memfd_luo.c:(.text.memfd_luo_retrieve_folios+0x11c): undefined reference to `shmem_inode_acct_blocks'
memfd_luo.c:(.text.memfd_luo_retrieve_folios+0x134): undefined reference to `shmem_recalc_inode'

Add a Kconfig dependency to disallow that configuration.

Link: https://lkml.kernel.org/r/20251204100203.1034394-1-arnd@kernel.org
Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/liveupdate/Kconfig~mm-memfd_luo-add-config_shmem-dependency
+++ a/kernel/liveupdate/Kconfig
@@ -54,6 +54,7 @@ config KEXEC_HANDOVER_ENABLE_DEFAULT
 config LIVEUPDATE
 	bool "Live Update Orchestrator"
 	depends on KEXEC_HANDOVER
+	depends on SHMEM
 	help
 	  Enable the Live Update Orchestrator. Live Update is a mechanism,
 	  typically based on kexec, that allows the kernel to be updated
_

Patches currently in -mm which might be from arnd@arndb.de are


