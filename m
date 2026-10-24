Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792828044;
	b=ofuHgplYb1+D+NSEKrj4Aih27ZoZ5Xqt20RbhrRcvpClyzryrSHIwufuD9aRFcCKhXHL
	 QJfqF4N8WH0ptuPqYn9K6kpk74qWuNlRLUK0RbJHfUQoiaVY3yyQISMdJq8FyomfTJpjK
	 J0CmEQUjWb5mFs9KE1q/hnnlZpzGSEjwX4HxDnj/ZIQao/0QUNZRE6uxcpHvCmNB/mAgv
	 Kdc1AJ112kcDQDkhWCNr3pIs2MEvQjIT8GvmSjXcAey6gxnKGeHumXYRZ36sFXUbxvUaq
	 ctaRYXFzXYeNpfYN/CiGISmoQHB4FXCLgRbqYDePqln/6inNcqOB29AJndXNu1L6T4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792828044;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=v3VF1X4n3GjF+gZDCX3AfI99qYnNWKzTjzEtGPZqHyM=;
	b=u/58tQOD/W/Z09bIq+Am0FIGywiNAx+kBnSNDN9LWTL8GmfwLFwS+HU30Bj060gNB97P
	 SC+D9TmfkU+G0Fn6oh08gNSdcqhB3C3ub2IjAGEXVJZvOw5ps96bKPE4CKALK3yfi6rqR
	 QCO2fxu0DEvETr0btwHCO3DVCVUmqfAolXKd0GOEk+SLY9IS0fbHtuFyP5jc9vgJ3dsR2
	 0fpA+biR1dvETQonxUFYBytSIyw9dHe9UUceEr9Q+84h6mYL6/knJezf2aB2znodsx18w
	 jgQ5Kb13wt15i3CTVLxdl8RFI1USJHouYar1iXMCdHfKQQVBp7FCbTm3/aUPysGoXbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="j/XxraAv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412C9606A321
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 07:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=j/XxraAv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD911F01825;
	Sat, 24 Oct 2026 07:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792828044;
	bh=v3VF1X4n3GjF+gZDCX3AfI99qYnNWKzTjzEtGPZqHyM=;
	h=Date:To:From:Subject;
	b=j/XxraAvPkV9OZnABmvUHDk/cRXpGIziUawMFkv+klYytsKp+MHvEug49ORX8FD5F
	 /hft4Wti+05RNGo1DJwyAwQnDEsboy/Peck62Y0J/Yt2EaoKQworAIWzRrG/PBUFOQ
	 vss0EvgoJ+8NFNW1SQrC/NZqHVXKoPHnrtXSs+YM=
Date: Sat, 24 Oct 2026 00:47:23 -0700
To: mm-commits@vger.kernel.org,kuan-ying.lee@canonical.com,kbingham@kernel.org,jan.kiszka@siemens.com,ue081723@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-fix-stack-depot-out-of-bounds-diagnostic.patch removed from -mm tree
Message-Id: <20261024074724.0BD911F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: scripts/gdb: fix stack depot out-of-bounds diagnostic
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-stack-depot-out-of-bounds-diagnostic.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ting-Han Hou <ue081723@gmail.com>
Subject: scripts/gdb: fix stack depot out-of-bounds diagnostic
Date: Sun, 11 Oct 2026 10:30:44 +0800

The pool_index field was renamed to pool_index_plus_1, but the
out-of-bounds diagnostic in stack_depot_fetch() still accesses the old
field.  Looking up a handle whose pool index is outside stack_pools
therefore raises "There is no member named pool_index" instead of printing
the diagnostic and returning an empty result.

Use the already decoded pool_index variable in the diagnostic.

Link: https://lore.kernel.org/20261011023044.1722-3-ue081723@gmail.com
Fixes: 9d938f40b228 ("scripts/gdb: rename pool_index to pool_index_plus_1")
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
---

 scripts/gdb/linux/stackdepot.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/stackdepot.py~scripts-gdb-fix-stack-depot-out-of-bounds-diagnostic
+++ a/scripts/gdb/linux/stackdepot.py
@@ -39,7 +39,7 @@ def stack_depot_fetch(handle):
 
     pool_index = parts['pool_index_plus_1'] - 1
     if pool_index >= pools_num:
-        gdb.write("pool index %d out of bounds (%d) for stack id 0x%08x\n" % (parts['pool_index'], pools_num, handle))
+        gdb.write("pool index %d out of bounds (%d) for stack id 0x%08x\n" % (pool_index, pools_num, handle))
         return gdb.Value(0), 0
 
     stack_pools = gdb.parse_and_eval('stack_pools')
_

Patches currently in -mm which might be from ue081723@gmail.com are


