Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4A423D3C5
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837047; cv=none; b=gT5xC8zYYomy98VrilWPh6UTfKu9Du0I1u2ZF/DcIbTCmp42e+37GOUdJ10/T8v0LtXqnygwzwIW43408LoVO6NPQp9KaCx7fjONv7eUYVL+gzwEoJPAI9gb0t9XWxwQrv8d7P+rBFFw8dj9VInyO1JEbKatTjjeG3HJdoKID90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837047; c=relaxed/simple;
	bh=xqyTrbPQzWyObiuFoqkArmp1UwwPcD/s8HqbLf9VzOg=;
	h=Date:To:From:Subject:Message-Id; b=KulF233uikjbTmrb8S63kxheUFZzMrjyBfMJq0UD67sx0Ol+GWv8yT4hh+o7X81qJk7ajEZWT/FxOW4r36iFCgLIWr9FZw7bzyXXKT8UDc0hG+9FHa+8quaei9k3LZXZ3SrJLCgG9QLdBAgVxanlSlOgDgVFH9tbpBz6uZjFisU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rxVgr+RE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rxVgr+RE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48980C4CEDF;
	Tue, 14 Jan 2025 06:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837047;
	bh=xqyTrbPQzWyObiuFoqkArmp1UwwPcD/s8HqbLf9VzOg=;
	h=Date:To:From:Subject:From;
	b=rxVgr+RER534rfH6zbZgaGpSXl2/dHHe6GZ9fvJby7mbaGNq+Qe3zGVeWZy+OYP8k
	 3t/wLLDNanvdHgRL4Z+qkj9tz4YI5cmicLxBGAw1JD1kmyqOnguUqrfeIYCCX7pITd
	 HjTNkznKssnmLufLmK6drqxY74nISLixdGbKTb8I=
Date: Mon, 13 Jan 2025 22:44:06 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-remove-unused-pkey-helpers.patch removed from -mm tree
Message-Id: <20250114064407.48980C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: remove unused pkey helpers
has been removed from the -mm tree.  Its filename was
     selftests-mm-remove-unused-pkey-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: remove unused pkey helpers
Date: Mon, 9 Dec 2024 09:50:11 +0000

Commit 5f23f6d082a9 ("x86/pkeys: Add self-tests") introduced a
number of helpers and functions that don't seem to have ever been
used. Let's remove them.

Link: https://lkml.kernel.org/r/20241209095019.1732120-7-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pkey-helpers.h    |   34 -----------------
 tools/testing/selftests/mm/protection_keys.c |   34 -----------------
 2 files changed, 68 deletions(-)

--- a/tools/testing/selftests/mm/pkey-helpers.h~selftests-mm-remove-unused-pkey-helpers
+++ a/tools/testing/selftests/mm/pkey-helpers.h
@@ -26,9 +26,7 @@
 #ifndef DEBUG_LEVEL
 #define DEBUG_LEVEL 0
 #endif
-#define DPRINT_IN_SIGNAL_BUF_SIZE 4096
 extern int dprint_in_signal;
-extern char dprint_in_signal_buffer[DPRINT_IN_SIGNAL_BUF_SIZE];
 
 extern int test_nr;
 extern int iteration_nr;
@@ -171,38 +169,6 @@ static inline void write_pkey_reg(u64 pk
 			pkey_reg, __read_pkey_reg());
 }
 
-/*
- * These are technically racy. since something could
- * change PKEY register between the read and the write.
- */
-static inline void __pkey_access_allow(int pkey, int do_allow)
-{
-	u64 pkey_reg = read_pkey_reg();
-	int bit = pkey * 2;
-
-	if (do_allow)
-		pkey_reg &= (1<<bit);
-	else
-		pkey_reg |= (1<<bit);
-
-	dprintf4("pkey_reg now: %016llx\n", read_pkey_reg());
-	write_pkey_reg(pkey_reg);
-}
-
-static inline void __pkey_write_allow(int pkey, int do_allow_write)
-{
-	u64 pkey_reg = read_pkey_reg();
-	int bit = pkey * 2 + 1;
-
-	if (do_allow_write)
-		pkey_reg &= (1<<bit);
-	else
-		pkey_reg |= (1<<bit);
-
-	write_pkey_reg(pkey_reg);
-	dprintf4("pkey_reg now: %016llx\n", read_pkey_reg());
-}
-
 #define ALIGN_UP(x, align_to)	(((x) + ((align_to)-1)) & ~((align_to)-1))
 #define ALIGN_DOWN(x, align_to) ((x) & ~((align_to)-1))
 #define ALIGN_PTR_UP(p, ptr_align_to)	\
--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-remove-unused-pkey-helpers
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -53,7 +53,6 @@ int test_nr;
 
 u64 shadow_pkey_reg;
 int dprint_in_signal;
-char dprint_in_signal_buffer[DPRINT_IN_SIGNAL_BUF_SIZE];
 
 void cat_into_file(char *str, char *file)
 {
@@ -397,12 +396,6 @@ void signal_handler(int signum, siginfo_
 	dprint_in_signal = 0;
 }
 
-int wait_all_children(void)
-{
-	int status;
-	return waitpid(-1, &status, 0);
-}
-
 void sig_chld(int x)
 {
 	dprint_in_signal = 1;
@@ -817,39 +810,12 @@ void *malloc_pkey_hugetlb(long size, int
 	return ptr;
 }
 
-void *malloc_pkey_mmap_dax(long size, int prot, u16 pkey)
-{
-	void *ptr;
-	int fd;
-
-	dprintf1("doing %s(size=%ld, prot=0x%x, pkey=%d)\n", __func__,
-			size, prot, pkey);
-	pkey_assert(pkey < NR_PKEYS);
-	fd = open("/dax/foo", O_RDWR);
-	pkey_assert(fd >= 0);
-
-	ptr = mmap(0, size, prot, MAP_SHARED, fd, 0);
-	pkey_assert(ptr != (void *)-1);
-
-	mprotect_pkey(ptr, size, prot, pkey);
-
-	record_pkey_malloc(ptr, size, prot);
-
-	dprintf1("mmap()'d for pkey %d @ %p\n", pkey, ptr);
-	close(fd);
-	return ptr;
-}
-
 void *(*pkey_malloc[])(long size, int prot, u16 pkey) = {
 
 	malloc_pkey_with_mprotect,
 	malloc_pkey_with_mprotect_subpage,
 	malloc_pkey_anon_huge,
 	malloc_pkey_hugetlb
-/* can not do direct with the pkey_mprotect() API:
-	malloc_pkey_mmap_direct,
-	malloc_pkey_mmap_dax,
-*/
 };
 
 void *malloc_pkey(long size, int prot, u16 pkey)
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


