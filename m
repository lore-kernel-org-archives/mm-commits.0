Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFA823C71C
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837057; cv=none; b=jY2zKEtK3NTlDDiYMcP12DDRSrkxwC9KUWNHVPdsNxcf2jbEbjwYPdPoC6B86TYx9OhfW7Gb+LgIeV9fW7mE4egplfC8kCvYANKFzX64egIAPiK2UnT4QhKJEL3zuUIm8RChRYaDRHoZXGapgc4f7fVNENa5rbZi36ZS/Epr8t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837057; c=relaxed/simple;
	bh=cNQ0U7AjnZadWrcJSkcbL3aTdYl5FYqUCY6pdVoLunk=;
	h=Date:To:From:Subject:Message-Id; b=kpDXMQDo9BY3ZBZuhh01s6OU2sExbuZV0jzdQPK1h5yPDwYfFG61c7/eBDKxXNnFoahTpEhF8HS5ZuA4JFYmDeSQzxO4ds6yicYBDpo3Ng+lh4c2e9n8wKkNEsqCYfbFC51gegR0ehnLnZyjZhuAmc4N29Ny+t8B7ioxQc/41ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KrZJtqyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KrZJtqyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BD5C4CEDD;
	Tue, 14 Jan 2025 06:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837057;
	bh=cNQ0U7AjnZadWrcJSkcbL3aTdYl5FYqUCY6pdVoLunk=;
	h=Date:To:From:Subject:From;
	b=KrZJtqydrEZexuqNLzAgDg5VZ5auekJMkE+Kur6L6uqHBQ2phRX3kEWm+qyqIq8cJ
	 tIgqNm9h7c7cOdK9T8VGbc3o4RVq73wKkKNjtlJYO3DnUGotW8Izi5gN17HWsh7FwP
	 xCje4jz1q5f8D0BlNHSctz7JcTuSZFVa+nKkQwCw=
Date: Mon, 13 Jan 2025 22:44:17 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-remove-x-permission-from-sigaltstack-mapping.patch removed from -mm tree
Message-Id: <20250114064417.93BD5C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: remove X permission from sigaltstack mapping
has been removed from the -mm tree.  Its filename was
     selftests-mm-remove-x-permission-from-sigaltstack-mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: remove X permission from sigaltstack mapping
Date: Mon, 9 Dec 2024 09:50:19 +0000

There is no reason why the alternate signal stack should be mapped as RWX.
Map it as RW instead.

Link: https://lkml.kernel.org/r/20241209095019.1732120-15-kevin.brodsky@arm.com
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

 tools/testing/selftests/mm/pkey_sighandler_tests.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-remove-x-permission-from-sigaltstack-mapping
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -315,7 +315,7 @@ static void test_sigsegv_handler_with_di
 	sys_mprotect_pkey(stack, STACK_SIZE, PROT_READ | PROT_WRITE, pkey);
 
 	/* Set up alternate signal stack that will use the default MPK */
-	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE | PROT_EXEC,
+	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	sigstack.ss_flags = 0;
 	sigstack.ss_size = STACK_SIZE;
@@ -488,7 +488,7 @@ static void test_pkru_sigreturn(void)
 	sys_mprotect_pkey(stack, STACK_SIZE, PROT_READ | PROT_WRITE, pkey);
 
 	/* Set up alternate signal stack that will use the default MPK */
-	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE | PROT_EXEC,
+	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	sigstack.ss_flags = 0;
 	sigstack.ss_size = STACK_SIZE;
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


