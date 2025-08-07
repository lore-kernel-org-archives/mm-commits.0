Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59571186A
	for <mm-commits@vger.kernel.org>; Thu,  7 Aug 2025 03:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754538298; cv=none; b=GabP7/NhWeIasxMw52pREfR24c/Lk6Yllm5LZKX7Ji5FEC9eZbT+SeTPP37YwrEs+XNWmG9dhVr1FYlU1PYj/pbx3m4EeBy6nZrvORU5UUBpHpK9e4EPYvpIV2dsmvaNuoBJuZdN5j3P1TgQJrvxnU3cXLnQBpnnPZc3ocaKpdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754538298; c=relaxed/simple;
	bh=n1dXW6qKQJyHsZHSKu5IqzNNCqxdmSFDButwsk2Qj1w=;
	h=Date:To:From:Subject:Message-Id; b=K8ZD9Vut9Fo2GMMQFtA+JGf4AfGSvm4B1cs7dTs3O9FMkX7Dj6KwNdVtOlLnUPAGHh3K8F6oQnBpgVghJTQd+w977H1XoJHhr0v2hD0hay7kwWbB924R4Pqw7j7IfXOMR1tGnPcvEuV90Xfe8+jywO5DcuT0BTfRd7iLrYnDICg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GbxLls90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GbxLls90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE41C4CEEB;
	Thu,  7 Aug 2025 03:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754538298;
	bh=n1dXW6qKQJyHsZHSKu5IqzNNCqxdmSFDButwsk2Qj1w=;
	h=Date:To:From:Subject:From;
	b=GbxLls90sH9BsHcF7fRMhQfto95Qhe+95UDwI39/r77Jg+dVHmT74W4hBju9at5q1
	 R7/OOgetmLxX4UypWWvmnfk0VvWV0vtlcmjjH8xFcMxar6ZTEVn49VJpGQjKXg17Yx
	 ET0tEvuuwmREZX55d6yxsBuet0Oj4Q4L2grHNASk=
Date: Wed, 06 Aug 2025 20:44:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sidhartha.kumar@oracle.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leon@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,aou@eecs.berkeley.edu,alex@ghiti.fr,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-unused-parameter-warnings-for-different-architectures.patch added to mm-new branch
Message-Id: <20250807034458.2BE41C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix unused parameter warnings for different architectures
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-unused-parameter-warnings-for-different-architectures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-unused-parameter-warnings-for-different-architectures.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: fix unused parameter warnings for different architectures
Date: Thu, 31 Jul 2025 21:01:32 +0500

There are functions which have unused arguments for different
architectures.  Separate the code for each architecture and move #ifdef
arch outside these functions.

Link: https://lkml.kernel.org/r/20250731160132.1795351-9-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c            |    8 +++-
 tools/testing/selftests/mm/pkey_sighandler_tests.c |   21 +++++++++--
 2 files changed, 24 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-fix-unused-parameter-warnings-for-different-architectures
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -131,17 +131,21 @@ static unsigned int __read_pkey_reg(void
 	return pkey_reg;
 }
 
+#if defined(__i386__) || defined(__x86_64__) /* arch */
 static void __write_pkey_reg(u64 pkey_reg)
 {
-#if defined(__i386__) || defined(__x86_64__) /* arch */
 	unsigned int eax = pkey_reg;
 	unsigned int ecx = 0;
 	unsigned int edx = 0;
 
 	asm volatile(".byte 0x0f,0x01,0xef\n\t"
 			: : "a" (eax), "c" (ecx), "d" (edx));
-#endif
 }
+#else
+static void __write_pkey_reg(u64 __unused pkey_reg)
+{
+}
+#endif
 
 static unsigned long pkey_bit_position(int pkey)
 {
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-fix-unused-parameter-warnings-for-different-architectures
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -41,11 +41,12 @@ static siginfo_t siginfo = {0};
  * syscall will attempt to access the PLT in order to call a library function
  * which is protected by MPK 0 which we don't have access to.
  */
+#ifdef __x86_64__
 static __always_inline
 long syscall_raw(long n, long a1, long a2, long a3, long a4, long a5, long a6)
 {
 	unsigned long ret;
-#ifdef __x86_64__
+
 	register long r10 asm("r10") = a4;
 	register long r8 asm("r8") = a5;
 	register long r9 asm("r9") = a6;
@@ -53,12 +54,26 @@ long syscall_raw(long n, long a1, long a
 		      : "=a"(ret)
 		      : "a"(n), "D"(a1), "S"(a2), "d"(a3), "r"(r10), "r"(r8), "r"(r9)
 		      : "rcx", "r11", "memory");
+	return ret;
+}
 #elif defined __i386__
+static __always_inline
+long syscall_raw(long n, long a1, long a2, long a3, long a4, long a5, long __unused a6)
+{
+	unsigned long ret;
+
 	asm volatile ("int $0x80"
 		      : "=a"(ret)
 		      : "a"(n), "b"(a1), "c"(a2), "d"(a3), "S"(a4), "D"(a5)
 		      : "memory");
+	return ret;
+}
 #elif defined __aarch64__
+static __always_inline
+long syscall_raw(long n, long a1, long a2, long a3, long a4, long a5, long a6)
+{
+	unsigned long ret;
+
 	register long x0 asm("x0") = a1;
 	register long x1 asm("x1") = a2;
 	register long x2 asm("x2") = a3;
@@ -71,11 +86,11 @@ long syscall_raw(long n, long a1, long a
 		      : "r"(x0), "r"(x1), "r"(x2), "r"(x3), "r"(x4), "r"(x5), "r"(x8)
 		      : "memory");
 	ret = x0;
+	return ret;
+}
 #else
 # error syscall_raw() not implemented
 #endif
-	return ret;
-}
 
 static inline long clone_raw(unsigned long flags, void *stack,
 			     int *parent_tid, int *child_tid)
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-add-wunreachable-code-and-fix-warnings.patch
selftests-mm-protection_keys-fix-dead-code.patch
selftests-kselftesth-add-__unused-macro.patch
selftests-mm-add-wunused-family-of-flags.patch
selftests-mm-remove-unused-parameters.patch
selftests-mm-mark-unused-arguments-with-__unused.patch
selftests-mm-mark-unused-arguments-with-__unused-2.patch
selftests-mm-fix-unused-parameter-warnings-for-different-architectures.patch

