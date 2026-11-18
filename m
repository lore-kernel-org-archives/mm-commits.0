Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794980529;
	b=OcVabOAmD5EKAvhfC8NLaoWrWcXYEG4aRd/OrAOy9CiMwG1FJKtm8K5jNetaXdhleTr/
	 TVm1Qp3mlxEiljJ3op+ujVdT5jG5gKZAuAu4hMS4x17ei4EClKWKh0KSAPFiwXc+2NJEG
	 vbGaXmkaEXF0htPboYtcuKqVAEYLojiMti53Ku7cyXEwvZ7PPnMIh2PasKMFAkoN2hxpy
	 LkrJteUBNNYVCzl2r+L7LQ+8voj6CLos7RLebD5a6hvNePUXvih3Ynq06Y/RqA9T9VzwS
	 kK75xV3a3LiCgKQJ2v0dIsLbwiBhqI7m8piBHr0GPPlqNaGD6qf4NE1ohDJ/1C+JcHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794980529;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=FgqQKAZkqHCxaK6ZYQZEsT3J20IWwd16GNiBtXZkTo4=;
	b=UqObko+hwCsFgfnSxTtJ5dc69Wx4ub97a/uZCiAB6fg/Uzs27JYPZ5fKqdxsSnnP6sdr
	 /QSEb4pwyda07UWtjkPDw3XfF4eaGorTdYGFch/kLg7iAPnpfBugM4AfVg929v0zi4vmC
	 PDuyXmoz16+ZvKoeYqHupmWAEoMDe4uqia1ykXTu/ssL11C8zXFaAOqYFCx6g0+dhEmEs
	 rgyRrUh9tu7GrvSZHtBgLROBZ6hXna4IGsGAfqLWKjn8b4tO7mR3SWvI1qkrisQiA6ajz
	 HZhF13Gxxx73qNR866czPsdG17cVvKw9k5T70m6gFmoHscdtTx/D+CkLSvxznPUloPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MKeFtsPt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B29F606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 05:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MKeFtsPt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89F31F000D0;
	Wed, 18 Nov 2026 05:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794980529;
	bh=FgqQKAZkqHCxaK6ZYQZEsT3J20IWwd16GNiBtXZkTo4=;
	h=Date:To:From:Subject;
	b=MKeFtsPtTZS05coWvGXM9wKk7GfVCoIRp+3Wa9AKMHUkVauu28hTAISQex9Bb/zMy
	 P4dz+bL4O8mMW8hHkbBhE2nq8OFinqKPCxViFj0aVUUA3E1MKsq+MG/cQMkiCRxCuR
	 iuw3LMfhNkqEwtDLdbay1bcFgPnelmbD9luiX6TY=
Date: Tue, 17 Nov 2026 21:42:08 -0800
To: mm-commits@vger.kernel.org,kuba@kernel.org,elder@kernel.org,
	elder@riscstar.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] mailmap-add-an-alias-for-alex-elder.patch removed from -mm tree
Message-Id: <20261118054208.E89F31F000D0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mailmap: add an alias for Alex Elder
has been removed from the -mm tree.  Its filename was
     mailmap-add-an-alias-for-alex-elder.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alex Elder <elder@riscstar.com>
Subject: mailmap: add an alias for Alex Elder
Date: Tue, 10 Nov 2026 08:42:47 -0600

Add an entry to .mailmap to indicate that <elder@riscstar.com> represents
the same person as <elder@kernel.org>.

Link: https://lore.kernel.org/20261110144250.656840-1-elder@riscstar.com
Signed-off-by: Alex Elder <elder@riscstar.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alex Elder <elder@kernel.org>

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-an-alias-for-alex-elder
+++ a/.mailmap
@@ -64,6 +64,7 @@ Alex Elder <elder@kernel.org> <elder@iee
 Alex Elder <elder@kernel.org> <elder@inktank.com>
 Alex Elder <elder@kernel.org> <elder@linaro.org>
 Alex Elder <elder@kernel.org> <elder@newdream.net>
+Alex Elder <elder@kernel.org> <elder@riscstar.com>
 Alex Hung <alexhung@gmail.com> <alex.hung@canonical.com>
 Alex Shi <alexs@kernel.org> <alex.shi@intel.com>
 Alex Shi <alexs@kernel.org> <alex.shi@linaro.org>
_

Patches currently in -mm which might be from elder@riscstar.com are


