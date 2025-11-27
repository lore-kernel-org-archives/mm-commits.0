Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC96321457
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282430; cv=none; b=Bge1gyjklCYaG31CHpbaeiEjvhg4FvXSUq8wp96XFzrLxELiyHBIan1UgQ7i7dFHFDf/Z1Ez0nq58fTd6vsjKUjX8hSukLfP0p2mmwfmUTjFXMjkgRPjB3WrGENZn8hZoW1GAMkXyBQWchlfGUUKdkAB5j+a5Z7kUtwgwfx23eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282430; c=relaxed/simple;
	bh=kCUq1K92Rz82CgARLbA0tMKWrDmLSpXAQFOY87BBQ3I=;
	h=Date:To:From:Subject:Message-Id; b=c/SFNn2DYjFkopvoF+iC/ps/DI4GCIN4FbVvJL9TiBC6PgGQfx+NioJa63zJQlBO4AHGEebtK2c11xhZMbn1LoHoXiqURUiAwEUhHsA6tLiQOvp3U6cAUTVTxBHuTE5VZQXEzwWbOatfM3fI0CBSIZB+GSezPv1N2r4XLKdv2j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T9M1fOGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T9M1fOGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7386EC113D0;
	Thu, 27 Nov 2025 22:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282430;
	bh=kCUq1K92Rz82CgARLbA0tMKWrDmLSpXAQFOY87BBQ3I=;
	h=Date:To:From:Subject:From;
	b=T9M1fOGtr4iGCNP0av9QMGEogzaFj4wb+EoVZUZmZpQ6UkZ2gglgZ2E6tRSUEkheW
	 YPf6ad5VqIXZiSkOZOxcyJCU0mz3XfMsPPeMHxVVaKoXboLeeoRzVJBr0EkbvWgq6b
	 9hmvsP8TPQomJFeRVLi9ihDPj8IUL63EETlVRdvw=
Date: Thu, 27 Nov 2025 14:27:09 -0800
To: mm-commits@vger.kernel.org,sj@kerneel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] test_kho-always-print-restore-status.patch removed from -mm tree
Message-Id: <20251127222710.7386EC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: test_kho: always print restore status
has been removed from the -mm tree.  Its filename was
     test_kho-always-print-restore-status.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: SeongJae Park <sj@kerneel.org>
Cc: Alexander Graf <graf@amazon.com>
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


