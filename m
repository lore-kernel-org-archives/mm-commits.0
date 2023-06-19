Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21215EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjFSXZV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjFSXXj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:23:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06D41988
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EEFF60F32
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CB3C433C0;
        Mon, 19 Jun 2023 23:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216964;
        bh=oghftI9BkKrXWRFFZOnvSyiAFxK4yBjHN8kgnWMx5/M=;
        h=Date:To:From:Subject:From;
        b=pCyD3Nt++13exX60jQotVhafyg44VslOEosZ7hJvp9KLbJCLzVkee6YgqeZ+htMNZ
         bRpazlX1yTFGPl9yWjGOkB6+Z/AqVWQ4o0RN1MBUmUDa+dSWTuF3XPXu6u7K2WN8+k
         9RsEwNui97ezYWFijDhdc/D/olVmw7vl2tAnRoUE=
Date:   Mon, 19 Jun 2023 16:22:43 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, shr@devkernel.io,
        david@redhat.com, usama.anjum@collabora.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-remove-duplicate-unneeded-defines.patch removed from -mm tree
Message-Id: <20230619232244.81CB3C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: mm: remove duplicate unneeded defines
has been removed from the -mm tree.  Its filename was
     selftests-mm-remove-duplicate-unneeded-defines.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: mm: remove duplicate unneeded defines
Date: Mon, 12 Jun 2023 14:53:47 +0500

Remove all defines which aren't needed after correctly including the
kernel header files.

Link: https://lkml.kernel.org/r/20230612095347.996335-2-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c                 |    1 
 tools/testing/selftests/mm/hugepage-shm.c        |    4 --
 tools/testing/selftests/mm/hugepage-vmemmap.c    |    4 --
 tools/testing/selftests/mm/khugepaged.c          |    1 
 tools/testing/selftests/mm/madv_populate.c       |    7 -----
 tools/testing/selftests/mm/map_fixed_noreplace.c |    4 --
 tools/testing/selftests/mm/map_hugetlb.c         |   12 --------
 tools/testing/selftests/mm/map_populate.c        |    2 -
 tools/testing/selftests/mm/mlock-random-test.c   |    1 
 tools/testing/selftests/mm/mlock2.h              |    8 -----
 tools/testing/selftests/mm/mrelease_test.c       |   10 -------
 tools/testing/selftests/mm/mremap_dontunmap.c    |    4 --
 tools/testing/selftests/mm/on-fault-limit.c      |    4 --
 tools/testing/selftests/mm/pkey-powerpc.h        |    3 --
 tools/testing/selftests/mm/pkey-x86.h            |   18 -------------
 tools/testing/selftests/mm/protection_keys.c     |   13 +--------
 tools/testing/selftests/mm/vm_util.h             |   10 -------
 17 files changed, 6 insertions(+), 100 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-remove-duplicate-unneeded-defines
+++ a/tools/testing/selftests/mm/cow.c
@@ -15,6 +15,7 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <assert.h>
+#include <linux/mman.h>
 #include <sys/mman.h>
 #include <sys/ioctl.h>
 #include <sys/wait.h>
--- a/tools/testing/selftests/mm/hugepage-shm.c~selftests-mm-remove-duplicate-unneeded-defines
+++ a/tools/testing/selftests/mm/hugepage-shm.c
@@ -35,10 +35,6 @@
 #include <sys/shm.h>
 #include <sys/mman.h>
 
-#ifndef SHM_HUGETLB
-#define SHM_HUGETLB 04000
-#endif
-
 #define LENGTH (256UL*1024*1024)
 
 #define dprintf(x)  printf(x)
--- a/tools/testing/selftests/mm/hugepage-vmemmap.c~selftests-mm-remove-duplicate-unneeded-defines
+++ a/tools/testing/selftests/mm/hugepage-vmemmap.c
@@ -13,10 +13,6 @@
 
 #define MAP_LENGTH		(2UL * 1024 * 1024)
 
-#ifndef MAP_HUGETLB
-#define MAP_HUGETLB		0x40000	/* arch specific */
-#endif
-
 #define PAGE_SIZE		4096
 
 #define PAGE_COMPOUND_HEAD	(1UL << 15)
--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-remove-duplicate-unneeded-defines
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -11,6 +11,7 @@
 #include <string.h>
 #include <unistd.h>
 
+#include <linux/mman.h>
 #include <sys/mman.h>
 #include <sys/wait.h>
 #include <sys/types.h>
--- a/tools/testing/selftests/mm/madv_populate.c~selftests-mm-remove-duplicate-unneeded-defines
+++ a/tools/testing/selftests/mm/madv_populate.c
@@ -20,13 +20,6 @@
 #include "../kselftest.h"
 #include "vm_util.h"
 
-#ifndef MADV_POPULATE_READ
-#define MADV_POPULATE_READ	22
-#endif /* MADV_POPULATE_READ */
-#ifndef MADV_POPULATE_WRITE
-#define MADV_POPULATE_WRITE	23
-#endif /* MADV_POPULATE_WRITE */
-
 /*
  * For now, we're using 2 MiB of private anonymous memory for all tests.
  */
--- a/tools/testing/selftests/mm/map_fixed_noreplace.c~selftests-mm-remove-duplicate-unneeded-defines
+++ a/tools/testing/selftests/mm/map_fixed_noreplace.c
@@ -13,10 +13,6 @@
 #include <stdlib.h>
 #include <unistd.h>
 
-#ifndef MAP_FIXED_NOREPLACE
-#define MAP_FIXED_NOREPLACE 0x100000
-#endif
-
 static void dump_maps(void)
 {
 	char cmd[32];
--- a/tools/testing/selftests/mm/map_hugetlb.c~selftests-mm-remove-duplicate-unneeded-defines
+++ a/tools/testing/selftests/mm/map_hugetlb.c
@@ -19,18 +19,6 @@
 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
 
-#ifndef MAP_HUGETLB
-#define MAP_HUGETLB 0x40000 /* arch specific */
-#endif
-
-#ifndef MAP_HUGE_SHIFT
-#define MAP_HUGE_SHIFT 26
-#endif
-
-#ifndef MAP_HUGE_MASK
-#define MAP_HUGE_MASK 0x3f
-#endif
-
 /* Only ia64 requires this */
 #ifdef __ia64__
 #define ADDR (void *)(0x8000000000000000UL)
--- a/tools/testing/selftests/mm/map_populate.c~selftests-mm-remove-duplicate-unneeded-defines
+++ a/tools/testing/selftests/mm/map_populate.c
@@ -17,9 +17,7 @@
 #include <string.h>
 #include <unistd.h>
 
-#ifndef MMAP_SZ
 #define MMAP_SZ		4096
-#endif
 
 #define BUG_ON(condition, description)					\
 	do {								\
--- a/tools/testing/selftests/mm/mlock2.h~selftests-mm-remove-duplicate-unneeded-defines
+++ a/tools/testing/selftests/mm/mlock2.h
@@ -4,14 +4,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 
-#ifndef MLOCK_ONFAULT
-#define MLOCK_ONFAULT 1
-#endif
-
-#ifndef MCL_ONFAULT
-#define MCL_ONFAULT (MCL_FUTURE << 1)
-#endif
-
 static int mlock2_(void *start, size_t len, int flags)
 {
 #ifdef __NR_mlock2
--- a/tools/testing/selftests/mm/mlock-random-test.c~selftests-mm-remove-duplicate-unneeded-defines
+++ a/tools/testing/selftests/mm/mlock-random-test.c
@@ -7,6 +7,7 @@
 #include <sys/resource.h>
 #include <sys/capability.h>
 #include <sys/mman.h>
+#include <linux/mman.h>
 #include <fcntl.h>
 #include <string.h>
 #include <sys/ipc.h>
--- a/tools/testing/selftests/mm/mrelease_test.c~selftests-mm-remove-duplicate-unneeded-defines
+++ a/tools/testing/selftests/mm/mrelease_test.c
@@ -9,18 +9,10 @@
 #include <stdlib.h>
 #include <sys/wait.h>
 #include <unistd.h>
+#include <asm-generic/unistd.h>
 #include "vm_util.h"
-
 #include "../kselftest.h"
 
-#ifndef __NR_pidfd_open
-#define __NR_pidfd_open -1
-#endif
-
-#ifndef __NR_process_mrelease
-#define __NR_process_mrelease -1
-#endif
-
 #define MB(x) (x << 20)
 #define MAX_SIZE_MB 1024
 
--- a/tools/testing/selftests/mm/mremap_dontunmap.c~selftests-mm-remove-duplicate-unneeded-defines
+++ a/tools/testing/selftests/mm/mremap_dontunmap.c
@@ -15,10 +15,6 @@
 
 #include "../kselftest.h"
 
-#ifndef MREMAP_DONTUNMAP
-#define MREMAP_DONTUNMAP 4
-#endif
-
 unsigned long page_size;
 char *page_buffer;
 
--- a/tools/testing/selftests/mm/on-fault-limit.c~selftests-mm-remove-duplicate-unneeded-defines
+++ a/tools/testing/selftests/mm/on-fault-limit.c
@@ -6,10 +6,6 @@
 #include <sys/time.h>
 #include <sys/resource.h>
 
-#ifndef MCL_ONFAULT
-#define MCL_ONFAULT (MCL_FUTURE << 1)
-#endif
-
 static int test_limit(void)
 {
 	int ret = 1;
--- a/tools/testing/selftests/mm/pkey-powerpc.h~selftests-mm-remove-duplicate-unneeded-defines
+++ a/tools/testing/selftests/mm/pkey-powerpc.h
@@ -3,9 +3,6 @@
 #ifndef _PKEYS_POWERPC_H
 #define _PKEYS_POWERPC_H
 
-#ifndef SYS_mprotect_key
-# define SYS_mprotect_key	386
-#endif
 #ifndef SYS_pkey_alloc
 # define SYS_pkey_alloc		384
 # define SYS_pkey_free		385
--- a/tools/testing/selftests/mm/pkey-x86.h~selftests-mm-remove-duplicate-unneeded-defines
+++ a/tools/testing/selftests/mm/pkey-x86.h
@@ -5,29 +5,11 @@
 
 #ifdef __i386__
 
-#ifndef SYS_mprotect_key
-# define SYS_mprotect_key	380
-#endif
-
-#ifndef SYS_pkey_alloc
-# define SYS_pkey_alloc		381
-# define SYS_pkey_free		382
-#endif
-
 #define REG_IP_IDX		REG_EIP
 #define si_pkey_offset		0x14
 
 #else
 
-#ifndef SYS_mprotect_key
-# define SYS_mprotect_key	329
-#endif
-
-#ifndef SYS_pkey_alloc
-# define SYS_pkey_alloc		330
-# define SYS_pkey_free		331
-#endif
-
 #define REG_IP_IDX		REG_RIP
 #define si_pkey_offset		0x20
 
--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-remove-duplicate-unneeded-defines
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -294,15 +294,6 @@ void pkey_access_deny(int pkey)
 	pkey_disable_set(pkey, PKEY_DISABLE_ACCESS);
 }
 
-/* Failed address bound checks: */
-#ifndef SEGV_BNDERR
-# define SEGV_BNDERR		3
-#endif
-
-#ifndef SEGV_PKUERR
-# define SEGV_PKUERR		4
-#endif
-
 static char *si_code_str(int si_code)
 {
 	if (si_code == SEGV_MAPERR)
@@ -476,7 +467,7 @@ int sys_mprotect_pkey(void *ptr, size_t
 			ptr, size, orig_prot, pkey);
 
 	errno = 0;
-	sret = syscall(SYS_mprotect_key, ptr, size, orig_prot, pkey);
+	sret = syscall(__NR_pkey_mprotect, ptr, size, orig_prot, pkey);
 	if (errno) {
 		dprintf2("SYS_mprotect_key sret: %d\n", sret);
 		dprintf2("SYS_mprotect_key prot: 0x%lx\n", orig_prot);
@@ -1684,7 +1675,7 @@ void test_mprotect_pkey_on_unsupported_c
 		return;
 	}
 
-	sret = syscall(SYS_mprotect_key, ptr, size, PROT_READ, pkey);
+	sret = syscall(__NR_pkey_mprotect, ptr, size, PROT_READ, pkey);
 	pkey_assert(sret < 0);
 }
 
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-remove-duplicate-unneeded-defines
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -60,13 +60,3 @@ int uffd_register_with_ioctls(int uffd,
 
 #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
 #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
-
-#ifndef MADV_PAGEOUT
-#define MADV_PAGEOUT 21
-#endif
-#ifndef MADV_POPULATE_READ
-#define MADV_POPULATE_READ 22
-#endif
-#ifndef MADV_COLLAPSE
-#define MADV_COLLAPSE 25
-#endif
_

Patches currently in -mm which might be from usama.anjum@collabora.com are


