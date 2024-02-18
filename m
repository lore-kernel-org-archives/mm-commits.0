Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD272AF10
	for <mm-commits@vger.kernel.org>; Sun, 18 Feb 2024 23:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708297482; cv=none; b=q7jqTpmQfKv/fBW5OQ5gB9cTpNGrdflN9scgUaBlAxsRaPvaamSBetpvuvtEaXebF9kXVUcVcpf8nanfQoDTago8iyxwztiLLHDqGxzOR/uwIUMtb7t9d51DqQRnCnrTr99MWybHJw3mZcoDcIDFJptcbCfAAh7sBNabE1fY/pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708297482; c=relaxed/simple;
	bh=UP/XnLN/3RSq8WnD1frOTBcAF1Wq2wJFuwdSIemtZLU=;
	h=Date:To:From:Subject:Message-Id; b=KhAP+yRV0NU8oDNaRKj7cnYWLRu+SMZC7xae5hmKJHUbVnA5GFSs6YEDemU9TcjMxd3vN2p+g9BXc5cTofsb2+Z5aGgqJgrFk6j58MW+H92rd6S9QZ9+aDFRaJQwLS4H+NhwKe6M9JxvC7NziCOtVJzKK2R9Oo034E1if9qoP4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oZHfC9RH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oZHfC9RH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7E3C433C7;
	Sun, 18 Feb 2024 23:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708297481;
	bh=UP/XnLN/3RSq8WnD1frOTBcAF1Wq2wJFuwdSIemtZLU=;
	h=Date:To:From:Subject:From;
	b=oZHfC9RHfX3T0UV7VqrG21SOmtl6iR90TqtsALLPE5f3HSNBFTDXfx4egBIpC2jWu
	 yY+9f8H6klXCcFVOARjA4I1kUmFaQiK7KgKp3isfrCCBBE6EyOgCVYPTQ4BzQ3AO34
	 V0kF0zlUHMfEZ7UIIsv0VQD6Uvtc+O49ohtkZSmc=
Date: Sun, 18 Feb 2024 15:04:40 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,herbert@gondor.apana.org.au,hannes@cmpxchg.org,ddstreet@ieee.org,davem@davemloft.net,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crypto-introduce-acomp_is_sleepable-to-expose-if-comp-drivers-might-sleep.patch added to mm-unstable branch
Message-Id: <20240218230441.7D7E3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crypto: introduce acomp_is_sleepable to expose if comp drivers might sleep
has been added to the -mm mm-unstable branch.  Its filename is
     crypto-introduce-acomp_is_sleepable-to-expose-if-comp-drivers-might-sleep.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crypto-introduce-acomp_is_sleepable-to-expose-if-comp-drivers-might-sleep.patch

This patch will later appear in the mm-unstable branch at
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
crypto-introduce-acomp_is_sleepable-to-expose-if-comp-drivers-might-sleep.patch
mm-zswap-remove-the-memcpy-if-acomp-is-not-sleepable.patch
crypto-scompress-remove-memcpy-if-sg_nents-is-1.patch

