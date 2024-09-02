Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C5B15098F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248833; cv=none; b=r14twrFoSjBvvgRyQcWD8KIarcgj0H+W4j8Rk8tXh+iFxInB/TmCwpvnWgUfdVFdNKk+hDKE5OVmwskwUotTclJklQVdJLJx447NyUTYkOKNHapSZkvZiIqdtpZ7bNXP4OTuM70ztfDgvMsf7DauRqYFxp97ZYLVbOQkOCPQ3Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248833; c=relaxed/simple;
	bh=s9h+l0Q2g/1FMLVItorfh6IBYleKoIE/Xy3tqeYxa98=;
	h=Date:To:From:Subject:Message-Id; b=TedI0mdV4P3948O1Hy8upMmOlUuZO6DhUyX0pGGgdtIo88G1F+wfiV06eoSde96vZKLf9jFuXdbHM6/rfYGo5Qo2+asUl/VwOp7kbXYL3GqhNtXOpkrSTe9p4S+1Jh84e9MIOKvj/0v3rfYi/ckqXozRoHVJ+VtkQFnNKHf2rdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cjNFsJ+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cjNFsJ+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F6AC4CEC2;
	Mon,  2 Sep 2024 03:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248833;
	bh=s9h+l0Q2g/1FMLVItorfh6IBYleKoIE/Xy3tqeYxa98=;
	h=Date:To:From:Subject:From;
	b=cjNFsJ+6COA7ynpPRI6l98PCUls9iLtFGdKm+Evss/Z3+Ekvdx58KAn6yaJeX6M+h
	 EuGL8NF+6oqhCeXWWiqEQ+zTPSJjvYTLDSaMBaSuVMFTy5FXB5GG7mch+Z4iVLjeG+
	 ZsqPEF58/qRC81uxcx0qgRiEX2m/CB6lnqlgtilM=
Date: Sun, 01 Sep 2024 20:47:12 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ratelimit-convert-flags-to-int-to-save-8-bytes-in-size.patch removed from -mm tree
Message-Id: <20240902034712.F0F6AC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ratelimit: convert flags to int to save 8 bytes in size
has been removed from the -mm tree.  Its filename was
     ratelimit-convert-flags-to-int-to-save-8-bytes-in-size.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: ratelimit: convert flags to int to save 8 bytes in size
Date: Sat, 17 Aug 2024 14:37:54 +0200

Only bit 1 is used, making an unsigned long a total overkill.

This brings it from 40 to 32 bytes, which in turn shrinks user_struct from
136 to 128 bytes.  Since the latter is allocated with hwalign, this means
the total usage goes down from 192 to 128 bytes per object.

No functional changes.

Link: https://lkml.kernel.org/r/20240817123754.240924-1-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ratelimit_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/ratelimit_types.h~ratelimit-convert-flags-to-int-to-save-8-bytes-in-size
+++ a/include/linux/ratelimit_types.h
@@ -19,8 +19,8 @@ struct ratelimit_state {
 	int		burst;
 	int		printed;
 	int		missed;
+	unsigned int	flags;
 	unsigned long	begin;
-	unsigned long	flags;
 };
 
 #define RATELIMIT_STATE_INIT_FLAGS(name, interval_init, burst_init, flags_init) { \
_

Patches currently in -mm which might be from mjguzik@gmail.com are

mm-hugetlb-sort-out-global-lock-annotations.patch

