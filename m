Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B905C255E43
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744884; cv=none; b=jwKe5r61UPyWE7w46Agsk4MNFj/5OrfyxzQWEWIs9IDUMNfDUDPsmHAUXbGykqglyqyEqmh/EDDlBuz4WFDxwaFTbMI0CnqqCFVocpnhteZreiqQ9FS09p/1XXTCamKhAtTNWZultkpxKYEhH9ireS4BF05U1za0LPZhtbgpF7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744884; c=relaxed/simple;
	bh=cbq/rwz4ILpWjaEHmSuKT+FeolljMC3X1PTiBHAlo7k=;
	h=Date:To:From:Subject:Message-Id; b=pZPKB3jTc2WrDt3M7o6esAXVym6H2usJzKSdNMhpiUQnbv/2qbOnoS2AKKgDFoL9TNbU/LgVnCK/OdjdSQpH4zDEtyC/pplINV4gEuFMkWcGp9bIAg7pnXqxX51RZSU7TN6wx6btRgGWN9DAAxbhoMwxbDfMtoF87KMBR4feV8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w2zOlNwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w2zOlNwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904C3C4CEF7;
	Sun, 29 Mar 2026 00:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744884;
	bh=cbq/rwz4ILpWjaEHmSuKT+FeolljMC3X1PTiBHAlo7k=;
	h=Date:To:From:Subject:From;
	b=w2zOlNwzM6S1zP5ofMvEMJIKV5yRq3Qbg/D76tBjxWjWWKEoIQdijqkVkdWevij+C
	 FeNRpvbR3LLCtj4cwxUan+YU6CxH3V+HOEp1jnOEhWEujBMxMPwogTjLLPPpG9CoT6
	 HsB4olffWaoiYHHCmTdrKVEuH7befQ9ZK/EXTqLg=
Date: Sat, 28 Mar 2026 17:41:24 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-pagemap_ioctl-remove-hungarian-notation.patch removed from -mm tree
Message-Id: <20260329004124.904C3C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: pagemap_ioctl: remove hungarian notation
has been removed from the -mm tree.  Its filename was
     selftests-mm-pagemap_ioctl-remove-hungarian-notation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: pagemap_ioctl: remove hungarian notation
Date: Wed, 11 Mar 2026 20:07:37 +0200

Replace lpBaseAddress with addr and dwRegionSize with size.

Link: https://lkml.kernel.org/r/20260311180737.3767545-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |   20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-pagemap_ioctl-remove-hungarian-notation
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -113,13 +113,13 @@ int init_uffd(void)
 	return 0;
 }
 
-int wp_init(void *lpBaseAddress, long dwRegionSize)
+int wp_init(void *addr, long size)
 {
 	struct uffdio_register uffdio_register;
 	struct uffdio_writeprotect wp;
 
-	uffdio_register.range.start = (unsigned long)lpBaseAddress;
-	uffdio_register.range.len = dwRegionSize;
+	uffdio_register.range.start = (unsigned long)addr;
+	uffdio_register.range.len = size;
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_WP;
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register))
 		ksft_exit_fail_msg("ioctl(UFFDIO_REGISTER) %d %s\n", errno, strerror(errno));
@@ -127,8 +127,8 @@ int wp_init(void *lpBaseAddress, long dw
 	if (!(uffdio_register.ioctls & UFFDIO_WRITEPROTECT))
 		ksft_exit_fail_msg("ioctl set is incorrect\n");
 
-	wp.range.start = (unsigned long)lpBaseAddress;
-	wp.range.len = dwRegionSize;
+	wp.range.start = (unsigned long)addr;
+	wp.range.len = size;
 	wp.mode = UFFDIO_WRITEPROTECT_MODE_WP;
 
 	if (ioctl(uffd, UFFDIO_WRITEPROTECT, &wp))
@@ -137,21 +137,21 @@ int wp_init(void *lpBaseAddress, long dw
 	return 0;
 }
 
-int wp_free(void *lpBaseAddress, long dwRegionSize)
+int wp_free(void *addr, long size)
 {
 	struct uffdio_register uffdio_register;
 
-	uffdio_register.range.start = (unsigned long)lpBaseAddress;
-	uffdio_register.range.len = dwRegionSize;
+	uffdio_register.range.start = (unsigned long)addr;
+	uffdio_register.range.len = size;
 	uffdio_register.mode = UFFDIO_REGISTER_MODE_WP;
 	if (ioctl(uffd, UFFDIO_UNREGISTER, &uffdio_register.range))
 		ksft_exit_fail_msg("ioctl unregister failure\n");
 	return 0;
 }
 
-int wp_addr_range(void *lpBaseAddress, int dwRegionSize)
+int wp_addr_range(void *addr, int size)
 {
-	if (pagemap_ioctl(lpBaseAddress, dwRegionSize, NULL, 0,
+	if (pagemap_ioctl(addr, size, NULL, 0,
 			  PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC,
 			  0, PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN) < 0)
 		ksft_exit_fail_msg("error %d %d %s\n", 1, errno, strerror(errno));
_

Patches currently in -mm which might be from rppt@kernel.org are

userfaultfd-introduce-mfill_copy_folio_locked-helper.patch
userfaultfd-introduce-struct-mfill_state.patch
userfaultfd-introduce-mfill_get_pmd-helper.patch
userfaultfd-introduce-mfill_get_vma-and-mfill_put_vma.patch
userfaultfd-retry-copying-with-locks-dropped-in-mfill_atomic_pte_copy.patch
userfaultfd-move-vma_can_userfault-out-of-line.patch
userfaultfd-introduce-vm_uffd_ops.patch
shmem-userfaultfd-use-a-vma-callback-to-handle-uffdio_continue.patch
userfaultfd-introduce-vm_uffd_ops-alloc_folio.patch
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops.patch
userfaultfd-mfill_atomic-remove-retry-logic.patch

