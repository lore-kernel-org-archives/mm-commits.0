Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BB7311589
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282363; cv=none; b=Nz/748M02nrNmd+E9BZilSZ18dInMqaaZX49ZA3QxFGoah1wRuObyWLT2JD7Ximyxmx6kxeGRTaErC8UmInDf7cyKA82dvhqsZyUmhRKEf4fBCTZ+Gf5IioO3weazHIXQueSczPhQX2Si3KEYaTYB3GDB/RyVXbKbBsCzzwcLBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282363; c=relaxed/simple;
	bh=NOyKLCzqWmT3YtycAQUeNFJFHil91bKiUd4ybgUIj9c=;
	h=Date:To:From:Subject:Message-Id; b=MOvo7pTGTYZqw5xtPU2ibOHF9TuNc2prsVFFc85zk9pflvS3UfRScm2nEYh66GDsyiXiQjhvaHQg/f506uh70aIS2i1PJ5aty8e5PqnlbXGE6tL05cXjZNuBdiAer36VsCn20F+DuJPcb2N8e2hQO5NmZWnPRr96idzlPdXL6oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z5o3KC/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z5o3KC/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0F1C4CEF8;
	Thu, 27 Nov 2025 22:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282363;
	bh=NOyKLCzqWmT3YtycAQUeNFJFHil91bKiUd4ybgUIj9c=;
	h=Date:To:From:Subject:From;
	b=Z5o3KC/ozGW3TP+tL8csS3/fXnMSeERKo9MfX37UhhQ422mBYfCSjSQofc77Y0HzY
	 +SABe5UvZY+YJOplUd13E69Bu8mudBg9bFhP4VJumQ3O5ZVT7C3IJGKMik741emgbI
	 QofH/Y00vZvgCwSEYQ72VvdGyCXB3XtqQxIwt1es=
Date: Thu, 27 Nov 2025 14:26:02 -0800
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,horms@kernel.org,graf@amazon.com,corbet@lwn.net,changyuanl@google.com,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-dont-unpreserve-memory-during-abort.patch removed from -mm tree
Message-Id: <20251127222603.5B0F1C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: don't unpreserve memory during abort
has been removed from the -mm tree.  Its filename was
     kho-dont-unpreserve-memory-during-abort.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: don't unpreserve memory during abort
Date: Sat, 1 Nov 2025 10:23:22 -0400

KHO allows clients to preserve memory regions at any point before the KHO
state is finalized.  The finalization process itself involves KHO
performing its own actions, such as serializing the overall preserved
memory map.

If this finalization process is aborted, the current implementation
destroys KHO's internal memory tracking structures
(`kho_out.ser.track.orders`).  This behavior effectively unpreserves all
memory from KHO's perspective, regardless of whether those preservations
were made by clients before the finalization attempt or by KHO itself
during finalization.

This premature unpreservation is incorrect.  An abort of the finalization
process should only undo actions taken by KHO as part of that specific
finalization attempt.  Individual memory regions preserved by clients
prior to finalization should remain preserved, as their lifecycle is
managed by the clients themselves.  These clients might still need to call
kho_unpreserve_folio() or kho_unpreserve_phys() based on their own logic,
even after a KHO finalization attempt is aborted.

Link: https://lkml.kernel.org/r/20251101142325.1326536-7-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Simon Horman <horms@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |   21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

--- a/kernel/kexec_handover.c~kho-dont-unpreserve-memory-during-abort
+++ a/kernel/kexec_handover.c
@@ -1119,31 +1119,12 @@ EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
 static int __kho_abort(void)
 {
-	int err = 0;
-	unsigned long order;
-	struct kho_mem_phys *physxa;
-
-	xa_for_each(&kho_out.track.orders, order, physxa) {
-		struct kho_mem_phys_bits *bits;
-		unsigned long phys;
-
-		xa_for_each(&physxa->phys_bits, phys, bits)
-			kfree(bits);
-
-		xa_destroy(&physxa->phys_bits);
-		kfree(physxa);
-	}
-	xa_destroy(&kho_out.track.orders);
-
 	if (kho_out.preserved_mem_map) {
 		kho_mem_ser_free(kho_out.preserved_mem_map);
 		kho_out.preserved_mem_map = NULL;
 	}
 
-	if (err)
-		pr_err("Failed to abort KHO finalization: %d\n", err);
-
-	return err;
+	return 0;
 }
 
 int kho_abort(void)
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

