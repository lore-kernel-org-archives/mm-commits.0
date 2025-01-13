Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD52D25761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742195; cv=none; b=QvM38HCn9Plc9ClWzQYmLssoeGeHSJcaByX2kTceyy8TlRQG9QhiLdc7KWHmqsi+uzx7Gg37RrRUdcWygEHbs8wxGcJBT3cAayWM1cNZt8rDV9jTAB9XgSY/FXoDaHEPHD5IU9mEfTaNdQ6ZS9GtCiUIfIPsxZqYl8onpCg4UXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742195; c=relaxed/simple;
	bh=sLCUqF7RFGoz2PpGLCfUFS6aF3s22zV17K0Tr0FCY8k=;
	h=Date:To:From:Subject:Message-Id; b=dnpGTjvbQ/xEYPCdcBe1z/11zyFV3TM4G0UEq2YlC7nggduWGxqgZBV411Xj4GQCQJzKF5cul39skNqjMBFIEeeFJ4lJIfkZaCB7d6FAJWsO61Ywlk2z2P3p4uNDnsks6nPf22WmadXjDYWcmYrArvn9j9fd9LR00Ujk1EOnLTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wT3Yvnlt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wT3Yvnlt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4D6C4CED6;
	Mon, 13 Jan 2025 04:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742194;
	bh=sLCUqF7RFGoz2PpGLCfUFS6aF3s22zV17K0Tr0FCY8k=;
	h=Date:To:From:Subject:From;
	b=wT3YvnltEsa5x8boRLPkaPeanNc3AMXnaP5BgtFox8Zb3y0I7V/o1Dq792nCTaS34
	 GZ5MpjgEgYBBoj1Pi7zILwl9aXCcsHfD0A2qLNjpbBe9cCwGPPnm3bFJ94ycmy20kb
	 HvyX4ppT/L3D+iKoIQF/Roy7r8x79/O6FTBJZ4hM=
Date: Sun, 12 Jan 2025 20:23:14 -0800
To: mm-commits@vger.kernel.org,pratyushmittal@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-rhashtable-fix-the-typo-for-preemptible.patch removed from -mm tree
Message-Id: <20250113042314.AA4D6C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/rhashtable: fix the typo for preemptible
has been removed from the -mm tree.  Its filename was
     lib-rhashtable-fix-the-typo-for-preemptible.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pratyush Mittal <pratyushmittal@gmail.com>
Subject: lib/rhashtable: fix the typo for preemptible
Date: Sat, 23 Nov 2024 02:29:29 -0800

Fix the spelling of the mis-spelled word

Link: https://lkml.kernel.org/r/20241123102929.11660-1-pratyushmittal@gmail.com
Signed-off-by: Pratyush Mittal <pratyushmittal@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rhashtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/rhashtable.c~lib-rhashtable-fix-the-typo-for-preemptible
+++ a/lib/rhashtable.c
@@ -665,7 +665,7 @@ EXPORT_SYMBOL_GPL(rhashtable_insert_slow
  * structure outside the hash table.
  *
  * This function may be called from any process context, including
- * non-preemptable context, but cannot be called from softirq or
+ * non-preemptible context, but cannot be called from softirq or
  * hardirq context.
  *
  * You must call rhashtable_walk_exit after this function returns.
_

Patches currently in -mm which might be from pratyushmittal@gmail.com are


