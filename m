Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2953F2D9499
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 22:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763504311; cv=none; b=fHw5SYXjYhs/I4ZS4kDNBLnLPrCFP4ReuvN+/NvV+r70Jyr9MFru7M3k+leXNcIde35RRXoXA0/FhgFpBHuNavGI5+9z4ppkzMDH28nm5Y635wtG87uJ2p7LBRuccXGrXMhrji+EnXIQtWUPbx5OmXlQAKJrgHYAH4/bw0IxCS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763504311; c=relaxed/simple;
	bh=3J5NTrzGuEPjJW5i2T6iCj1PDMhqZsCEK06SNfmLKwU=;
	h=Date:To:From:Subject:Message-Id; b=PmbdL7HNiBcxqECKbMqsMMPNgjXybekfADuTXJVlCG1umMiwPfF5UxayMEKNi0Kh3YAMLCrspNDCAQZctaIqUGidGbYB/y/jAqhDRJ12Fd+w9gp/7AfOhyUMUUAChX+laG9eGTx6dcaqwqKRkZt+R13bBiqqCcP25fXCGGSJPYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VNUgVNTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VNUgVNTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F617C4CEF5;
	Tue, 18 Nov 2025 22:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763504310;
	bh=3J5NTrzGuEPjJW5i2T6iCj1PDMhqZsCEK06SNfmLKwU=;
	h=Date:To:From:Subject:From;
	b=VNUgVNTYwMIEwInr0ny3JAtdAjO9JwKFYdvlcHibo/WL57ZJJfJQDr3kWy0PyY0MF
	 Vrtkd3l6sBiqaAqrSmC4C9dNXg8CRyFh+Vn8NZAK9DCzud9VWmwGYGkdUPFqu4dS4s
	 ob0oxosrYgbGd4LVcrutaDJd88ReRqIuuLZzUlpw=
Date: Tue, 18 Nov 2025 14:18:28 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + test_kho-always-print-restore-status.patch added to mm-nonmm-unstable branch
Message-Id: <20251118221830.0F617C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: test_kho: always print restore status
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     test_kho-always-print-restore-status.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/test_kho-always-print-restore-status.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Pratyush Yadav <pratyush@kernel.org>
Subject: test_kho: always print restore status
Date: Tue, 18 Nov 2025 19:10:45 +0100

Currently the KHO test only prints a message on success, and remains
silent on failure.  This makes it difficult to notice a failing test.  A
failing test is usually more interesting than a successful one.

Always print the test status after attempting restore.

Link: https://lkml.kernel.org/r/20251118181046.23321-1-pratyush@kernel.org
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kho.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/lib/test_kho.c~test_kho-always-print-restore-status
+++ a/lib/test_kho.c
@@ -306,7 +306,6 @@ static int kho_test_restore(phys_addr_t
 	if (err)
 		return err;
 
-	pr_info("KHO restore succeeded\n");
 	return 0;
 }
 
@@ -319,8 +318,15 @@ static int __init kho_test_init(void)
 		return 0;
 
 	err = kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys);
-	if (!err)
-		return kho_test_restore(fdt_phys);
+	if (!err) {
+		err = kho_test_restore(fdt_phys);
+		if (err)
+			pr_err("KHO restore failed\n");
+		else
+			pr_info("KHO restore succeeded\n");
+
+		return err;
+	}
 
 	if (err != -ENOENT) {
 		pr_warn("failed to retrieve %s FDT: %d\n", KHO_TEST_FDT, err);
_

Patches currently in -mm which might be from pratyush@kernel.org are

maintainers-add-test_kho-to-khos-entry.patch
maintainers-add-myself-as-a-reviewer-for-kho.patch
liveupdate-luo_file-add-private-argument-to-store-runtime-state.patch
kho-free-chunks-using-free_page-instead-of-kfree.patch
test_kho-always-print-restore-status.patch

