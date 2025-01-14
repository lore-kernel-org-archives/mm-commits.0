Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8679823C71D
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837055; cv=none; b=P/990xWdw/2IODB+w3ejCyGPYYlWo17q/kwMi4UHUVP9fX7sNTA7St+SDPLVo9xI5TpMtz+NIu2njfDIU6ec3MySZIhw1BCuMycUo8Kt6bYRyLmUmp2zi/W6id0KA4Nm8KBY/GO4oL2ZbVq4za15YXF12r3KCpSHz3RIa8OmhCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837055; c=relaxed/simple;
	bh=+Rabj/oIr4mPq6kRaZFfosA8IxKS3y6v7/KWutxRuF8=;
	h=Date:To:From:Subject:Message-Id; b=XP2innoNSgvZ7VjUeOLJ5RN6UKYh/k77UTK9tyWaciIBN1irHOMURpWuOFDWcEq9T86jylBgcgTa5yz3zCh7iuuUD3Da7mMILoBYwpP1WntOfS4qU4S0w2MdVCKo5FGnXzJ/50aku+PgUq7wRG/LXxnPbNZ0AF1BDiW5J7Nye3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vkgyS1ZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vkgyS1ZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1B2C4CEDD;
	Tue, 14 Jan 2025 06:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837055;
	bh=+Rabj/oIr4mPq6kRaZFfosA8IxKS3y6v7/KWutxRuF8=;
	h=Date:To:From:Subject:From;
	b=vkgyS1ZDm4NQZHHxBJW8P8y/qRFGC2kVJYrBYIe0O43A8DSG3+cgmUO9mZRZw6is6
	 O8poivF7hzDFMOmZoSHICHIuW7W1MdwkQzhFegQpwSP6wLFP2mPL5soR+J2HCATWWV
	 2q3QFMNjG7e4qfaQ2CvsZrTOtoH2/OagqZz0oF6o=
Date: Mon, 13 Jan 2025 22:44:14 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-rename-pkey-register-macro.patch removed from -mm tree
Message-Id: <20250114064415.5C1B2C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: rename pkey register macro
has been removed from the -mm tree.  Its filename was
     selftests-mm-rename-pkey-register-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: rename pkey register macro
Date: Mon, 9 Dec 2024 09:50:17 +0000

PKEY_ALLOW_ALL is meant to represent the pkey register value that allows
all accesses (enables all pkeys).  However its current naming suggests
that the value applies to *one* key only (like PKEY_DISABLE_ACCESS for
instance).

Rename PKEY_ALLOW_ALL to PKEY_REG_ALLOW_ALL to avoid such
misunderstanding.  This is consistent with the PKEY_REG_ALLOW_NONE macro
introduced by commit 6e182dc9f268 ("selftests/mm: Use generic pkey
register manipulation").

Link: https://lkml.kernel.org/r/20241209095019.1732120-13-kevin.brodsky@arm.com
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

 tools/testing/selftests/mm/pkey-arm64.h      |    2 +-
 tools/testing/selftests/mm/protection_keys.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/pkey-arm64.h~selftests-mm-rename-pkey-register-macro
+++ a/tools/testing/selftests/mm/pkey-arm64.h
@@ -30,7 +30,7 @@
 #define NR_PKEYS		8
 #define NR_RESERVED_PKEYS	1 /* pkey-0 */
 
-#define PKEY_ALLOW_ALL		0x77777777
+#define PKEY_REG_ALLOW_ALL	0x77777777
 #define PKEY_REG_ALLOW_NONE	0x0
 
 #define PKEY_BITS_PER_PKEY	4
--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-rename-pkey-register-macro
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -396,7 +396,7 @@ static void signal_handler(int signum, s
 	/* restore access and let the faulting instruction continue */
 	pkey_access_allow(siginfo_pkey);
 #elif defined(__aarch64__)
-	aarch64_write_signal_pkey(uctxt, PKEY_ALLOW_ALL);
+	aarch64_write_signal_pkey(uctxt, PKEY_REG_ALLOW_ALL);
 #endif /* arch */
 	pkey_faults++;
 	dprintf1("<<<<==================================================\n");
@@ -842,7 +842,7 @@ void expected_pkey_fault(int pkey)
 	 */
 	if (__read_pkey_reg() != 0)
 #elif defined(__aarch64__)
-	if (__read_pkey_reg() != PKEY_ALLOW_ALL)
+	if (__read_pkey_reg() != PKEY_REG_ALLOW_ALL)
 #else
 	if (__read_pkey_reg() != shadow_pkey_reg)
 #endif /* arch */
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


