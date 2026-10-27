Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793140263;
	b=rdDrVNlxlrscf+X457NdEYo72ZkxbJ+ABAh7+1BGsOvzmBPw6jz/4nRe1vH4yWEexEV1
	 JnCDdPhxRirCWvsUrLOopNdFQmqun/DRR8goPoGmATGy3hdyA3g5kuLZMvCJ+/mdURhrO
	 lqRZEtGIGUyVf6u+jAK7tj4ORke72T6x9gbAuKCcDYZCU+ZZOi6nqVDDxcqobC+punef8
	 i+LbHkCqWXh+kieNnDgD9HNchAnon1S7Oh2c5JXnTXvv/11R+0Nsnsnn9GQ2Y2XV3+RBQ
	 udXKOeueTNEsGjew4Gbgq4OOJQgUQnhthYHGN5ha+R6oSJ9RFg7AboOJSHrsnQyE2Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793140263;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=C91okvUL0Y06ewCeQiKP8nerc+m3RbY290lx+tzKN94=;
	b=qx+pjgee5lJ1SYZXM3MJ8cHjMQ1ct+ALJhJZU4R3OTwGaYQDnhCBBhQfm77FbsoQAUiQ
	 8FTqQRGpeLerhhGgKFG2ue258PBIRAv1Fh3hUQkMwpCItbLjOaZB3nGss6C9JmD4Sa8Mk
	 lwScAXiwvYRZsDxj5dughxvmU7mxNXzZSx2tGBzX19hRIvQ7xKl+EA3eZEL0luNV9XBKs
	 SkxIHTKseNDFVschgDC9hloFOhlhKwehKsUjgFbbhQCCzNMJMfcnqJUqvaSJxGZoD/lLG
	 4ytrTgkDvUp4zHMD1nmOudngxNwYyRod3rgYwMy8fdMINJDXun8RjG8sz9q6WihcdeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NBlHJW5e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD767606A32A;
	Tue, 27 Oct 2026 22:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NBlHJW5e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7411F01828;
	Tue, 27 Oct 2026 22:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793140262;
	bh=C91okvUL0Y06ewCeQiKP8nerc+m3RbY290lx+tzKN94=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=NBlHJW5elIhSS+OhmSVFuesAqDMhnRwcfbeccaaZ76VeYGKFAYlwaHD+IdcU1Vzrp
	 c1B3o3w8cBXRjcCRZ1iy2jTau3PCMATXurhVgq57pKFm3jxKa2ahv7dh9d0ROWjHjM
	 eHgROE52H2NpPOiAvikLp2wsDSZNAJiNpISpsNZ83pP46tT9HRXoyJTLvGWoH2IvgK
	 o5Xa9pSCPddkB182ho8BcW1JlM8tqsrY27H9N3IncHs6ISr16SjRLczSuijunf5d3m
	 apdk1qTpPYnYjHrI+e05PKKgNNoilQWSU8g4JizxsdUJ+S12SMfo22ok0MopOwrhHh
	 6wxeHtP9cXiFA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 8140C3AA940B;
	Tue, 27 Oct 2026 22:31:02 +0000 (UTC)
Subject: Re: [GIT PULL] Additional MM updates for 7.4-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261026152120.c6ed2222b64943914563232f@linux-foundation.org>
References: <20261026152120.c6ed2222b64943914563232f@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20261026152120.c6ed2222b64943914563232f@linux-foundation.org>
X-PR-Tracked-Remote: https://lore.kernel.org/akzo2N-H1mm4U7kw@sirena.org.uk mm/hugetlb.c
X-PR-Tracked-Commit-Id: 183895979c441e52dbd651b388553b09eaa35cfa
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8a36f53fd5ec3eff01f1b637d42cbdc3821d0493
Message-Id: <179314026135.360848.9768940194637210306.pr-tracker-bot@kernel.org>
Date: Tue, 27 Oct 2026 22:31:01 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Mon, 26 Oct 2026 15:21:20 -0700:

> https://lore.kernel.org/akzo2N-H1mm4U7kw@sirena.org.uk mm/hugetlb.c

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8a36f53fd5ec3eff01f1b637d42cbdc3821d0493

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
