Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60E123C70B
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837056; cv=none; b=alGZ6TMJZkdVrKBlsfATeXez38AI+vP8UWVV0Z35KnfcpqRpYKc/77YAdq4M3atzVSRfKxvFYiIRU0QVCGSc+oN6LQ2H1JJHttIhlRmNx+Riab6Fptij9N7K5ol8gMENAKnkvdEQAG0H8D008l0n9yvF3ZN4qsDqaKMTX5WYNs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837056; c=relaxed/simple;
	bh=Ah3xtD48BrZGyhhedxpZLJHdQF3NVIOf6nyx8gJcQZk=;
	h=Date:To:From:Subject:Message-Id; b=B+d7FqG/MCxhBYGIKJT5lzgzz9pKrJDxA18kcBmDBBILyrF4CZ1VWeabK7gIb07owViPogkxJf5rNYzOUN2TTTzOy0Pi6bvJlJcHlmM1XTEEZBoluHxf6U2wh/j2YICjzizntoz6vZCXT96QClWNxnr0d/kEFq74fzUvahzBJvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YX093e8r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YX093e8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D651C4CEDD;
	Tue, 14 Jan 2025 06:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837056;
	bh=Ah3xtD48BrZGyhhedxpZLJHdQF3NVIOf6nyx8gJcQZk=;
	h=Date:To:From:Subject:From;
	b=YX093e8rBzTtTu8A2xbvjhN1m+6qdhbxLBxFhoPfMJPi2GJyCYQtXhfyKSQKioL3I
	 QMPmY1by5zx+rfHi/zOj+BVumEc6bPvcgeq8hOFkLN4DAupdv6K6ddXz1OZhg+mpPJ
	 bQB1FeWsc5EoE7jgY+DBPD6QOLemZkHvcyKxHxM8=
Date: Mon, 13 Jan 2025 22:44:15 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-pkey_sighandler_tests-if-support-is-missing.patch removed from -mm tree
Message-Id: <20250114064416.7D651C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip pkey_sighandler_tests if support is missing
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-pkey_sighandler_tests-if-support-is-missing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: skip pkey_sighandler_tests if support is missing
Date: Mon, 9 Dec 2024 09:50:18 +0000

The pkey_sighandler_tests are bound to fail if either the kernel or CPU
doesn't support pkeys.  Skip the tests if pkeys support is missing.

Link: https://lkml.kernel.org/r/20241209095019.1732120-14-kevin.brodsky@arm.com
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

 tools/testing/selftests/mm/pkey_sighandler_tests.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-skip-pkey_sighandler_tests-if-support-is-missing
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -535,6 +535,9 @@ int main(int argc, char *argv[])
 	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(pkey_tests));
 
+	if (!is_pkeys_supported())
+		ksft_exit_skip("pkeys not supported\n");
+
 	for (i = 0; i < ARRAY_SIZE(pkey_tests); i++)
 		(*pkey_tests[i])();
 
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


