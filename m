Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDB523D3DD
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837051; cv=none; b=sMOs62abNtMRvNpaO5hHYE1fhVt6YYnidEb4396Jbf0/LX5bqCA2sVtBhRwAMg3z477kqiMzKUGiVPj+Ay4e2O2vI7TTkacDA0c7APC4ssKKxtrROBrOPKgJchPqNtFx7V2IKMR5CtqyuN2vkFKJU5immwB5axCLToHbTzKMfck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837051; c=relaxed/simple;
	bh=Q3Dv2Oo8kH+i83V8SXt4A/C+h6eqz686dgPvT17VPZA=;
	h=Date:To:From:Subject:Message-Id; b=tcglkJ3eNJ4pQZEr351vwCSsE/LCYR72wu+fI+9OWffrZywTdEPKHciJ+Mve7IXIJjuiPQVvFxMB3TtYIpgIjjDbgShVjuLlkeG8V8zNN4ImTYklOVUu+KFo4n+NvQ+5fmBjgYDpw2+XW1Y49VoaJsmoiKDfcac9b8VWr1Tv/Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=arxoFFfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="arxoFFfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE1EC4CEDD;
	Tue, 14 Jan 2025 06:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837050;
	bh=Q3Dv2Oo8kH+i83V8SXt4A/C+h6eqz686dgPvT17VPZA=;
	h=Date:To:From:Subject:From;
	b=arxoFFfPQcp0YFWSK/1iy3NVq/pk8IWC6TuVMUaVcVW4O3CZzaFclss01WbOtTD+E
	 CFfIhJXeCdifTzTrJF4MdtHmujO+rN1HNksSqF5b/NKA9Ni3H+7QhVwCll/TkpkcGo
	 BSUATDmPg8+RchCLrr7SBDETVkNMyDjsW6txKV6w=
Date: Mon, 13 Jan 2025 22:44:10 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-remove-empty-pkey-helper-definition.patch removed from -mm tree
Message-Id: <20250114064410.AEE1EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: remove empty pkey helper definition
has been removed from the -mm tree.  Its filename was
     selftests-mm-remove-empty-pkey-helper-definition.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: remove empty pkey helper definition
Date: Mon, 9 Dec 2024 09:50:14 +0000

Some of the functions declared in pkey-helpers.h are actually defined in
protections_keys.c, meaning they can only be called from
protections_keys.c.  This is less than ideal, but it is hard to avoid as
these helpers are themselves called from inline functions in
pkey-<arch>.h.  Let's at least add a comment clarifying that.  We can also
remove the empty definition in pkey_sighandler_tests.c:
expected_pkey_fault() is not meant to be called from there.

Link: https://lkml.kernel.org/r/20241209095019.1732120-10-kevin.brodsky@arm.com
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

 tools/testing/selftests/mm/pkey-helpers.h          |    6 ++++--
 tools/testing/selftests/mm/pkey_sighandler_tests.c |    2 --
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/pkey-helpers.h~selftests-mm-remove-empty-pkey-helper-definition
+++ a/tools/testing/selftests/mm/pkey-helpers.h
@@ -84,10 +84,12 @@ extern void abort_hooks(void);
 # define noinline __attribute__((noinline))
 #endif
 
-noinline int read_ptr(int *ptr);
-void expected_pkey_fault(int pkey);
 int sys_pkey_alloc(unsigned long flags, unsigned long init_val);
 int sys_pkey_free(unsigned long pkey);
+
+/* For functions called from protection_keys.c only */
+noinline int read_ptr(int *ptr);
+void expected_pkey_fault(int pkey);
 int mprotect_pkey(void *ptr, size_t size, unsigned long orig_prot,
 		unsigned long pkey);
 void record_pkey_malloc(void *ptr, long size, int prot);
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-remove-empty-pkey-helper-definition
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -32,8 +32,6 @@
 
 #define STACK_SIZE PTHREAD_STACK_MIN
 
-void expected_pkey_fault(int pkey) {}
-
 pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
 pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
 siginfo_t siginfo = {0};
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


