Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B4A54BC5
	for <mm-commits@vger.kernel.org>; Mon, 19 Feb 2024 22:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708380150; cv=none; b=VzBcTQCXtYDNrGhGiGcOQhaX0EHyzwxfp/pdBkTUPAaLDlRF7K102ALoJ8fIJQcLwNMhMtaEAJyZI89ow057z0CbB2Yjz1FiOMbhVzvN89wGNI9xAbHotxyDFAZTegaF7wu6mfvnfZG8+f9JLts3JzbfaUi1qu8kDIF5SA7UKkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708380150; c=relaxed/simple;
	bh=OdwlNYlv5Yq52F+qiVgP84sDmvNu8gdotmwY0ptmUlQ=;
	h=Date:To:From:Subject:Message-Id; b=fXouMU19hslsJ1PvVHd9wIx03gkabyyYrIt88N1I/wFjHWZv8k8gI99D4c1gguwFEyIeEyWroQWqt7kKbJ/POXWKWP9kHNm1c6oKfWoOd6546Qg8fsHMxlfxgd3pwL7NAqUd0xUSq+fksZXAlgf5aZ3RXj20fkuSycxaAi1UTMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FYXMw9ai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FYXMw9ai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F079EC433C7;
	Mon, 19 Feb 2024 22:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708380150;
	bh=OdwlNYlv5Yq52F+qiVgP84sDmvNu8gdotmwY0ptmUlQ=;
	h=Date:To:From:Subject:From;
	b=FYXMw9ai0JcqJVvo4Spzt7RIf2UpeBCPcq8kf4hMe5MaYL9JFaxoMGWmg+C9DEFhs
	 n333FxYlGthWtfa6VSz2EnxNdFKVdmdqKgdleHmUm3Esdz+hitnceDOP1A77KFKUuJ
	 eZzwULEyYPPA845K3qKjsJ+U/mrb74rC+hzAy3Po=
Date: Mon, 19 Feb 2024 14:02:29 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,herbert@gondor.apana.org.au,hannes@cmpxchg.org,ddstreet@ieee.org,davem@davemloft.net,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] crypto-introduce-acomp_is_sleepable-to-expose-if-comp-drivers-might-sleep.patch removed from -mm tree
Message-Id: <20240219220229.F079EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crypto: introduce acomp_is_sleepable to expose if comp drivers might sleep
has been removed from the -mm tree.  Its filename was
     crypto-introduce-acomp_is_sleepable-to-expose-if-comp-drivers-might-sleep.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: crypto: introduce acomp_is_sleepable to expose if comp drivers might sleep
Date: Sat, 17 Feb 2024 17:51:00 +1300

Patch series "mm/zswap & crypto/compress: remove a couple of memcpy", v3.

The patchset removes a couple of memcpy in zswap and crypto to improve
zswap's performance.

Thanks for Chengming Zhou's test and perf data.
Quote from Chengming,
 I just tested these three patches on my server, found improvement in the
 kernel build testcase on a tmpfs with zswap (lz4 + zsmalloc) enabled.
 
         mm-stable 501a06fe8e4c  patched
 real    1m38.028s               1m32.317s
 user    19m11.482s              18m39.439s
 sys     19m26.445s              17m5.646s


This patch (of 3):

Almost all CPU-based compressors/decompressors are actually synchronous
though they support acomp APIs.  While some hardware has hardware-based
accelerators to offload CPU's work such as hisilicon and intel/qat/, their
drivers are working in async mode.  Letting acomp's users know exactly if
the acomp is really async will help users know if the compression and
decompression procedure can sleep.

Generally speaking, async and sleepable are semantically similar but not
equal.  But for compress drivers, they are actually equal at least due to
the below facts.

Firstly, scompress drivers - crypto/deflate.c, lz4.c, zstd.c, lzo.c etc
have no sleep.  Secondly, zRAM has been using these scompress drivers for
years in atomic contexts, and never worried those drivers going to sleep.

Link: https://lkml.kernel.org/r/20240217045102.55339-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20240217045102.55339-2-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Tested-by: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/acompress.c         |    8 ++++++++
 include/crypto/acompress.h |    9 +++++++++
 2 files changed, 17 insertions(+)

--- a/crypto/acompress.c~crypto-introduce-acomp_is_sleepable-to-expose-if-comp-drivers-might-sleep
+++ a/crypto/acompress.c
@@ -152,6 +152,14 @@ struct crypto_acomp *crypto_alloc_acomp_
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_acomp_node);
 
+bool acomp_is_sleepable(struct crypto_acomp *acomp)
+{
+	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp);
+
+	return tfm->__crt_alg->cra_type == &crypto_acomp_type;
+}
+EXPORT_SYMBOL_GPL(acomp_is_sleepable);
+
 struct acomp_req *acomp_request_alloc(struct crypto_acomp *acomp)
 {
 	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp);
--- a/include/crypto/acompress.h~crypto-introduce-acomp_is_sleepable-to-expose-if-comp-drivers-might-sleep
+++ a/include/crypto/acompress.h
@@ -205,6 +205,15 @@ struct acomp_req *acomp_request_alloc(st
 void acomp_request_free(struct acomp_req *req);
 
 /**
+ * acomp_is_sleepable() -- check if an acomp is sleepable
+ *
+ * @tfm:	ACOMPRESS tfm handle allocated with crypto_alloc_acomp()
+ *
+ * Return:	true if the acomp is sleepable, otherwise, false
+ */
+bool acomp_is_sleepable(struct crypto_acomp *tfm);
+
+/**
  * acomp_request_set_callback() -- Sets an asynchronous callback
  *
  * Callback will be called when an asynchronous operation on a given
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

zram-do-not-allocate-physically-contiguous-strm-buffers.patch
mm-zswap-remove-the-memcpy-if-acomp-is-not-sleepable.patch
crypto-scompress-remove-memcpy-if-sg_nents-is-1.patch

