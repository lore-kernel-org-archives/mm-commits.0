Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E5A7CF01
	for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2024 15:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710258915; cv=none; b=FJdYSb7a1arQDsxMLFtCEA2wkusfAzrKUKlj9SCd3CAB6+c0ula9xb6kCQxN9GyQiiJMQWJvWWVuZ1t6r9vmdN9uhsAjOoJnWDe03Vv9z58rX0+4BomMSSTX9N1BurYi0QbNPbRc0nOPpoQIqcOsp6Q3HdtSo3gFFM3IydMMqzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710258915; c=relaxed/simple;
	bh=C8Xj7Iaia0koQUgZeMftGWiNgCN5fOSSiXOtVGtPpLk=;
	h=Date:To:From:Subject:Message-Id; b=jvVztg6WO7JUyGv+4JCv2HgppElsdiJ2R6dfo5kOy1UrvK25yb44+YOlzbGcTXMm/f+yFfIhh85acxhg8Lg/y7/JvvYgpXLUvvF7ekGrXTydiqZ8jyaxtElmto73uDWED04/UIjbUVAFKeMJyy0IoFgUpV+5G4t7uA75mxTc8iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qZdjIaja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qZdjIaja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD7CC43394;
	Tue, 12 Mar 2024 15:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710258914;
	bh=C8Xj7Iaia0koQUgZeMftGWiNgCN5fOSSiXOtVGtPpLk=;
	h=Date:To:From:Subject:From;
	b=qZdjIajadH70IUEqb0j1tqBs1Mun/3HGfNxngOEUJCiNmkyyU/qAjRcRoUZp70o/F
	 kBveXOUjtdgOkr16xN4KSh7XTwef8+2eTAOZCKs735oHzGi+tTT7lskBIWderH1NPf
	 /CD62bkrpr58urkQ4F3KArXbAJXvDGE8OaCSMSE0=
Date: Tue, 12 Mar 2024 08:55:14 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,herbert@gondor.apana.org.au,hannes@cmpxchg.org,ddstreet@ieee.org,davem@davemloft.net,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crypto-introduce-acomp_is_async-to-expose-if-comp-drivers-might-sleep.patch added to mm-unstable branch
Message-Id: <20240312155514.9CD7CC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crypto: introduce: acomp_is_async to expose if comp drivers might sleep
has been added to the -mm mm-unstable branch.  Its filename is
     crypto-introduce-acomp_is_async-to-expose-if-comp-drivers-might-sleep.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crypto-introduce-acomp_is_async-to-expose-if-comp-drivers-might-sleep.patch

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
Subject: crypto: introduce: acomp_is_async to expose if comp drivers might sleep
Date: Thu, 22 Feb 2024 21:11:34 +1300

acomp's users might want to know if acomp is really async to optimize
themselves.  One typical user which can benefit from exposed async stat is
zswap.

In zswap, zsmalloc is the most commonly used allocator for (and perhaps
the only one).  For zsmalloc, we cannot sleep while we map the compressed
memory, so we copy it to a temporary buffer.  By knowing the alg won't
sleep can help zswap to avoid the need for a buffer.  This shows
noticeable improvement in load/store latency of zswap.

Link: https://lkml.kernel.org/r/20240222081135.173040-2-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/crypto/acompress.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/crypto/acompress.h~crypto-introduce-acomp_is_async-to-expose-if-comp-drivers-might-sleep
+++ a/include/crypto/acompress.h
@@ -160,6 +160,12 @@ static inline void acomp_request_set_tfm
 	req->base.tfm = crypto_acomp_tfm(tfm);
 }
 
+static inline bool acomp_is_async(struct crypto_acomp *tfm)
+{
+	return crypto_comp_alg_common(tfm)->base.cra_flags &
+	       CRYPTO_ALG_ASYNC;
+}
+
 static inline struct crypto_acomp *crypto_acomp_reqtfm(struct acomp_req *req)
 {
 	return __crypto_acomp_tfm(req->base.tfm);
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-prohibit-the-last-subpage-from-reusing-the-entire-large-folio.patch
crypto-introduce-acomp_is_async-to-expose-if-comp-drivers-might-sleep.patch
mm-zswap-remove-the-memcpy-if-acomp-is-not-sleepable.patch

