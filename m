Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26AA40861D
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816338; cv=none; b=k4Rk9DKkzfPWl5jUnlWH/armJ7wHzYh1XOuaCe5NA+Tuu83mCR08gvpidAwHaWfoYJpkQXL64NBfzqRJLTtKspQ0a6EeXPnkyEuZ9xKZSHdHT8W7QHfuYnsVW3ws/JGXSfkBMWkd3IT27jScWdB/C71Litl2V5qWuW/kNwSUgNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816338; c=relaxed/simple;
	bh=dM9LZJW4lo64PPCWqF9AUrH4kA9CLYqyIQYwQ6y21Uk=;
	h=Date:To:From:Subject:Message-Id; b=NHMgaR/zPQifeD4aHLyAbPL5mGy0KCfmAcbvY0h1cRhtQ1dRdFrPK011nqO2KAz7kDYSTleWpV+hogA48pmmX5F6Ishfc4OZwubEr4W4zkMyKe2tZTuAp424LSWxWs4WnIzcEPanT7Miy1W98d3/cplvqkukdKhF93y5hJP1mj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0IjiK5Xo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0IjiK5Xo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98EEF1F00A3D;
	Tue,  4 Aug 2026 04:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816336;
	bh=ancyiRLi/cBnzG8fn+5O5KSstpGjFBRZA9xatUTe7vk=;
	h=Date:To:From:Subject;
	b=0IjiK5Xo9Ujsrua/X3E2tOTznTWcT/lh0mgVxMpoljad6qk9Ezk95Sjl7jWZ63NkE
	 Bq79GBuD9D+6MTb916S85bfo8iLH9JXXqnqqclYbXMQ9RkSaOqR9iESy/Io28tiTkH
	 AYlvChAm/zQbSRVfh0sYkH+jpo7aHX2QN0c04XuE=
Date: Mon, 03 Aug 2026 21:05:36 -0700
To: mm-commits@vger.kernel.org,ebiggers@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] raid6-defer-implementation-selection-when-built-in.patch removed from -mm tree
Message-Id: <20260804040536.98EEF1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: raid6: defer implementation selection when built-in
has been removed from the -mm tree.  Its filename was
     raid6-defer-implementation-selection-when-built-in.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

