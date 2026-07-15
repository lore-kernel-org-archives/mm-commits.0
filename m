Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AE94C042F
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 18:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784139668; cv=none; b=UhAu/BCESRjRawmUD0S/sJOwdYxi8sCenZHNp9iafvOVSJzwDR/EIdfLTeTH3A1KFGDdawYSWZTxkCj9ctGDx9x5mlasQYwg4ffDppt198aSnyVK1Zwy7wsbiwgVJS6oj14fRmjVGl6BycbmCf2EUq0xZDgNd87XwbjF0vdMlgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784139668; c=relaxed/simple;
	bh=01XokSCZW1WnBpetkX971GX1FMhSJ6iFn2zEPRiS4ag=;
	h=Date:To:From:Subject:Message-Id; b=B0sixp64S/E2B8x4+fWBERrYYiR3hdCXbIoZf7cQFKTCjYKZK2PDXMJ0Dye01NJDgC8weFb7aFkAsFdTsjRaddeZbt017ifkZbIuWjMHqfaK8hfeexr2qQdHhi7BAD698+IDQ4KuVoJsKFq7uz9mWBgy0Jv0jh8RQuJ+yUibx/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=moRHn9JB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="moRHn9JB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071311F00A3A;
	Wed, 15 Jul 2026 18:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784139656;
	bh=rAgsNDq8PRa0dc95PeEJNTkdMp6JXwMB8c7eAY6Ze2Y=;
	h=Date:To:From:Subject;
	b=moRHn9JBAoIQxP8B1qlnxdMzODPjZFQH2CU1qXBVgUWjeKx4EKFq5mCponsp/q2Rz
	 FlxfHyR6NLORzCQavzNL18P+vAkUdHef6RwOY68MInVzyTRFIeWRdke1om4PW5t51S
	 44YMAFAuEKWugFgGVPwCM+H9w8nZ+jwMGa7YZCwA=
Date: Wed, 15 Jul 2026 11:20:55 -0700
To: mm-commits@vger.kernel.org,ebiggers@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid6-defer-implementation-selection-when-built-in.patch added to mm-nonmm-unstable branch
Message-Id: <20260715182056.071311F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: raid6: defer implementation selection when built-in
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6-defer-implementation-selection-when-built-in.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6-defer-implementation-selection-when-built-in.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: raid6: defer implementation selection when built-in
Date: Wed, 15 Jul 2026 16:47:37 +0200

Don't hold up early boot and defer the selection just like we've been
doing for the RAID5 XOR code since commit 524ccdbdfb52 ("crypto: xor -
defer load time benchmark to a later time").

This will also allow full use of the timing subsystem for benchmarking.

Link: https://lore.kernel.org/20260715144825.95432-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/raid6/algos.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/lib/raid/raid6/algos.c~raid6-defer-implementation-selection-when-built-in
+++ a/lib/raid/raid6/algos.c
@@ -239,10 +239,6 @@ static int __init raid6_select_algo(void
 	if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK) || raid6_nr_algos == 1) {
 		pr_info("raid6: skipped pq benchmark and selected %s\n",
 			raid6_algos[raid6_nr_algos - 1]->name);
-		static_call_update(raid6_gen_syndrome_impl,
-				raid6_algos[raid6_nr_algos - 1]->gen_syndrome);
-		static_call_update(raid6_xor_syndrome_impl,
-				raid6_algos[raid6_nr_algos - 1]->xor_syndrome);
 		return 0;
 	}
 
@@ -329,13 +325,34 @@ static int __init raid6_init(void)
 	static_call_update(raid6_recov_datap_impl, raid6_recov_algo->datap);
 	pr_info("raid6: using %s recovery algorithm\n", raid6_recov_algo->name);
 
+	/*
+	 * Pick the last registered implementation as the temporary default until
+	 * calibration happens.
+	 */
+	static_call_update(raid6_gen_syndrome_impl,
+			raid6_algos[raid6_nr_algos - 1]->gen_syndrome);
+	static_call_update(raid6_xor_syndrome_impl,
+			raid6_algos[raid6_nr_algos - 1]->xor_syndrome);
+
+#ifdef MODULE
 	return raid6_select_algo();
+#else
+	return 0;
+#endif
 }
 
 static void __exit raid6_exit(void)
 {
 }
 
+/*
+ * When built-in we must register the default implementation before md
+ * initializes, but we don't want calibration to run that early as that
+ * would delay the boot process.
+ */
+#ifndef MODULE
+device_initcall(raid6_select_algo);
+#endif
 subsys_initcall(raid6_init);
 module_exit(raid6_exit);
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from hch@lst.de are

mm-remove-wb_writeout_inc.patch
shmem-provide-a-shmem_write_folio-wrapper.patch
mm-swap-introduce-struct-swap_io_ctx.patch
mm-swap-also-use-struct-swap_iocb-for-block-i-o.patch
mm-swap-remove-count_swpout_vm_event.patch
mm-swap-use-swap_ops-to-register-swap-devices-methods.patch
mm-swap-remove-swp_fs_ops.patch
mm-vmstat-add-nrswpinout-counters.patch
xor-enable-lock-context-analysis.patch
xor-improve-the-runtime-selection-benchmark.patch
xor-kunit-fix-a-spelling-error.patch
xor-kunit-add-a-benchmark.patch
raid6-enable-lock-context-analysis.patch
raid6-defer-implementation-selection-when-built-in.patch
raid6-improve-the-runtime-selection-benchmark.patch
raid6-kunit-add-a-benchmark.patch

