Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA90B368D48;
	Tue,  2 Jun 2026 18:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780423752; cv=none; b=UBqpKoft9ga6Y5S7YN+FJKL5wX+Y9gGBvOVu+lLzRcvUBqHxvkXuuJw6AgAL3HTjXCuV5fRY/zThJyeKVIaGz2FemqiyfA/oDjkc+WG2UiuO2N0OnP/YCjjTn/q8L5xB7/Xq5HRn9B7Z51vCbhLq/UmfAPCd2WxOkWHFlSVFUjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780423752; c=relaxed/simple;
	bh=AiGNC8qCz2y/uPGiENYvos26KV6j54GAHRcODFAgSfQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sDThSG6mBe88vSz+tCGCVyDsGYrn9TxAkY5/xg27FaGI7tj7U5vMIAxT0DF6yr5pLb30KhBCg2/9/+HmsIXOEb6dlr8ozr3VnLA/sS7Mi8Pwvx2gLABFxPpEPcG4hL/yQRv5nKzoGcbuQIgIk6KGaOE8vzC78ntb+iycsPKsciE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nmy8Ion6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nmy8Ion6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762891F0089C;
	Tue,  2 Jun 2026 18:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780423748;
	bh=f82i8cmK1u0wtDqDHUpqQz8R7QLi4aPEQxEJdlSUoAw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Nmy8Ion6SeolbtPN/jhpseRHXPahnVBJjmHbtL21QGF/vJuNUMpcZhKsdBK3ybDEy
	 IuinTEdyuhvcLy4q50LCzDH8QW7Mumup416kN/c6dY1HJwojOWmbctNg+5oyNlO3t9
	 Qf0j63/B2xdzvja66DIiZUqdA3Stnoyn10iRVGGCbfoLeEpMKqbdUugFze9h4dJRJA
	 yAW4zAHsvi4SWUaeATHAuRVvP3+frpfHAxp2aK3kSRV60jyrquZCP/wWrhQgYgONd3
	 GNAlxtDXHPfPcrLiVsit9fYA1LnBzS9X4FdPWbK+oYnmeikc1pQOW83/enXGZ9uKYH
	 xXmEsqTX8VG1A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93B823811A6C;
	Tue,  2 Jun 2026 18:09:11 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.1-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260601210527.ad1549849df4d9d58b12cffe@linux-foundation.org>
References: <20260601210527.ad1549849df4d9d58b12cffe@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260601210527.ad1549849df4d9d58b12cffe@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-06-01-20-58
X-PR-Tracked-Commit-Id: 9d7bea186ba5a002456471edf36cc9b69f809397
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4a694a77c3d60bc974c6ef7fb98cdb872b5330ea
Message-Id: <178042375002.983785.8559277558601300819.pr-tracker-bot@kernel.org>
Date: Tue, 02 Jun 2026 18:09:10 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 1 Jun 2026 21:05:27 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-06-01-20-58

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4a694a77c3d60bc974c6ef7fb98cdb872b5330ea

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
