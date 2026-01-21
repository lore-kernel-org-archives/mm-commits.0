Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667122EC54C
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967403; cv=none; b=ctgkezzWwWpKkxJnfWKSgD/42iClH1xEVNy+zGSQix0U8r2HY90d8QP4OgKa76PnG2edub1fKAiZgLQ/zIAX4MoMIOQx4EAMpPmX6l7+2f4y85mA75obzso81O/lK0RBas4AneJu5HqaqmJxd3xgw1xLcRzPMLr8gSgV8BnLvBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967403; c=relaxed/simple;
	bh=oV8SOubqy1+0fAzGJ2wAJnuqpVcTjGU/Yc549ky04tI=;
	h=Date:To:From:Subject:Message-Id; b=IQo053zbAe0ZfCuuRElAyfm66lXGfaxdmgJZbDrDq3ounaaigZ46g9SgSzYcTp2JchDZjb9vSr/2RK7ZxXtRLis8u7Vq7+GDifCNcVbHBZcWmwwFwAyJBCIzcKWJUFCj2icHjoBmlRdQ8QT40PDbEEGZvFbkFjuNc0DBPBi0iyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gdk7kG6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gdk7kG6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29147C19424;
	Wed, 21 Jan 2026 03:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967402;
	bh=oV8SOubqy1+0fAzGJ2wAJnuqpVcTjGU/Yc549ky04tI=;
	h=Date:To:From:Subject:From;
	b=gdk7kG6HlFePObMdJIT+6M/r6UmNY1yUdYbEHRefgKVTZJxkfu5qQakCb8sdCLI1v
	 EkgFWXfDD9P7amBDk5JMl8QFpJicpqth7QEkKj9j3VKqp00bgYlNeWrR3zJUtaxdFe
	 ux0LlnZ45obAD8xuHLCRRASFUQDDe+khE4Spbpek=
Date: Tue, 20 Jan 2026 19:50:01 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,hewenliang4@huawei.com,graf@amazon.com,longwei27@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-test-clean-up-residual-memory-upon-test_kho-module-unload.patch removed from -mm tree
Message-Id: <20260121035002.29147C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: test: clean up residual memory upon test_kho module unload
has been removed from the -mm tree.  Its filename was
     kho-test-clean-up-residual-memory-upon-test_kho-module-unload.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Long Wei <longwei27@huawei.com>
Subject: kho: test: clean up residual memory upon test_kho module unload
Date: Wed, 7 Jan 2026 10:24:27 +0800

During the initialization phase, the test_kho module invokes the
kho_preserve_folio function, which internally configures bitmaps within
kho_mem_track and establishes chunk linked lists in KHO.  Upon unloading
the test_kho module, it is necessary to clean up these states.

Link: https://lkml.kernel.org/r/20260107022427.4114424-1-longwei27@huawei.com
Signed-off-by: Long Wei <longwei27@huawei.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: hewenliang <hewenliang4@huawei.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kho.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/lib/test_kho.c~kho-test-clean-up-residual-memory-upon-test_kho-module-unload
+++ a/lib/test_kho.c
@@ -340,11 +340,15 @@ module_init(kho_test_init);
 
 static void kho_test_cleanup(void)
 {
+	/* unpreserve and free the data stored in folios */
+	kho_test_unpreserve_data(&kho_test_state);
 	for (int i = 0; i < kho_test_state.nr_folios; i++)
 		folio_put(kho_test_state.folios[i]);
 
 	kvfree(kho_test_state.folios);
-	vfree(kho_test_state.folios_info);
+
+	/* Unpreserve and release the FDT folio */
+	kho_unpreserve_folio(kho_test_state.fdt);
 	folio_put(kho_test_state.fdt);
 }
 
_

Patches currently in -mm which might be from longwei27@huawei.com are


