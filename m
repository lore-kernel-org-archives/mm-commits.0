Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEF312FB2F
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 23:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720827622; cv=none; b=C3gKw0HYFN2tp1SUxIi/z4w/CgStt3Zkph3RupDGEYeWKapGY4CLiXhkqUbUSyQZxDYetw261XfuzSWq5I6LYvSoyKfWzdj1UQ4oxd2amdaGCO4NiN5vWwSRPL9QAm1BS1HV5cy9qcB3HHxv7SUki4MXWwANkqN7jZSKTx8dRH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720827622; c=relaxed/simple;
	bh=P+AaQQVmmBu1AHwmMpIOWO869dU7O52awf/qtTbDpYU=;
	h=Date:To:From:Subject:Message-Id; b=mju73c0jcliGjT3z+rUV1pLUksIZpRVTS4fIuFuuhXpVnWCvrQngp9kUo48xQMTXXZ9Sb+f8pwT4zLqVH38tOIQkDkjGEMPfVm8Pv0GT8gQsOa8gEjigUXwTxX6/ZWsOJ7O6qWedH6atBPcsD/5WqhFWTpqVGyMT0sA4XTNQr0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i6vRxSqb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i6vRxSqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E49C4AF0A;
	Fri, 12 Jul 2024 23:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720827622;
	bh=P+AaQQVmmBu1AHwmMpIOWO869dU7O52awf/qtTbDpYU=;
	h=Date:To:From:Subject:From;
	b=i6vRxSqb0cC27VzvU/nuyL40Pljshph+Efahfp9IP3KKCV9vaHeBfQPI/LL4e8k5x
	 LU1UkOkCF0EN+H9qSz3X9UZZte56YcbDl10MTlAc3+M3zc3Ejoin14oqPGbWFzet8B
	 79hZVszLSX4UBzyuHPjlxL3S/ngr+xi//GvrPccY=
Date: Fri, 12 Jul 2024 16:40:21 -0700
To: mm-commits@vger.kernel.org,thomas.orgis@uni-hamburg.de,liupeng256@huawei.com,ismael@iodev.co.uk,ebiederm@xmission.com,kees@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tsacct-replace-strncpy-with-strscpy.patch removed from -mm tree
Message-Id: <20240712234021.E0E49C4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tsacct: replace strncpy() with strscpy()
has been removed from the -mm tree.  Its filename was
     tsacct-replace-strncpy-with-strscpy.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kees Cook <kees@kernel.org>
Subject: tsacct: replace strncpy() with strscpy()
Date: Thu, 11 Jul 2024 10:13:09 -0700

Replace the deprecated[1] use of strncpy() in bacct_add_tsk().  Since this
is UAPI, include trailing padding in the copy.

Link: https://github.com/KSPP/linux/issues/90 [1]
Link: https://lkml.kernel.org/r/20240711171308.work.995-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Cc: "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Ismael Luceno <ismael@iodev.co.uk>
Cc: Peng Liu <liupeng256@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/tsacct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/tsacct.c~tsacct-replace-strncpy-with-strscpy
+++ a/kernel/tsacct.c
@@ -76,7 +76,7 @@ void bacct_add_tsk(struct user_namespace
 	stats->ac_minflt = tsk->min_flt;
 	stats->ac_majflt = tsk->maj_flt;
 
-	strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm));
+	strscpy_pad(stats->ac_comm, tsk->comm);
 }
 
 
_

Patches currently in -mm which might be from kees@kernel.org are


