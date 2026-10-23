Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792785461;
	b=WjnawcWwv+tmfYnWcfQwdtuWkw7M2zjbfkezdrqP4Qx7kr5p4OcobxotSGEhGfoOFHL3
	 8YZNkJrF+AnKqBPi1r/uxtMryE+60Q/0fiVZQnumTxsoq7VeoTYDsboLW/XfBeOYIDDPO
	 pKavMYOIUd7WwIwj7Yu4h/sm08rKO1aOZGNojfJxJyYSsUrcNNk7++B8oZdnZS9u8eGMN
	 e1gppJeLI3jfF3bPGu9/uDz5Cvx0k5CcPCAsv33LOhlMrKRCgmMmGoUNSv0Temr3dZ64c
	 Zlp4CmjTlkiQcHcJnOpR8oqJ6rgZSmrbS5t1R0mfz9qjvY4iS62WuYc0z/qTyJqUP2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792785461;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=Azo9CniJ7hsZsJtpNzpBWIhDn9knolxQ2Zz2oL4JH7k=;
	b=2I/1QOGFT/tDaWioi9i07GJK4SeNHPYkMn98FrEdvTNy3ncyfB1bnaaPP1VRCpyJM04c
	 Nhjx4yZgkFDL85MTc6Sq5wb+FvKHd9eaWwYIdZhBX/Hac4jZV/S/QfSWyqQamsiaVSy1M
	 p1Z2J+uNrMPc1DyvfVFCV8ETK88xa6zsJN9+kwVMdOCqm9+WR3I0STggkmEihQKzf1QU5
	 FqBtAgDauIImVm9x4qrYo8YtCsxVLMLB4JMdb1SgF0lZOuv29BlNNGEDiMGfFEHJLbxfl
	 goyc3cegxFHmZXiJ90TypKZI+czHmmCNZ/eBTP6rK3ER95FrmaeaUQ81mQwnI3tLbdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tc1qTJIz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B34606A336;
	Fri, 23 Oct 2026 19:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tc1qTJIz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175841F01825;
	Fri, 23 Oct 2026 19:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792785461;
	bh=Azo9CniJ7hsZsJtpNzpBWIhDn9knolxQ2Zz2oL4JH7k=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Tc1qTJIztKux8HGU1uapCL7hso0udwYgmvKWx1HZAniT+GDhNXmjoxtBC1DeCXGUL
	 wyHa9Cl0s2Vqzy0MgMr9TCk83X69pHqOf3wKAolPNq3VBpPfjDVbh3P2FJALPRiOvZ
	 HCqoCp7pPZr7Pw0NVkp0IE2zsoHoxJhzv5s9EXp4F5Z6g7hg3l0oxhEq+RD3ubXhL6
	 /C/PM7qq4ZnKZXxFgUPTOMTSz6AbCQe838Z9USBy6rrIhrgu+ZvIl5G76v7iWLA/Qc
	 HMTXLz0NMJxFZ1myxm0k3cU9XfPc5s7ONyLdzLw7KAj4nAqBowXKPVB5BBZvCq/mGf
	 RChJxbr2xDhGA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 0766E391B153;
	Fri, 23 Oct 2026 19:57:41 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 7.4-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261019220030.056b79bf972b9d6a9c1aa931@linux-foundation.org>
References: <20261019220030.056b79bf972b9d6a9c1aa931@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261019220030.056b79bf972b9d6a9c1aa931@linux-foundation.org>
X-PR-Tracked-Remote: https://lore.kernel.org/akzo2N-H1mm4U7kw@sirena.org.uk mm/hugetlb.c
X-PR-Tracked-Commit-Id: 2967f3ccdb5fae956f1b085370ec292bab5c7e25
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c5fd5e67c7812bc40cd897422c1e0d6dd9ed1e2e
Message-Id: <179278545953.1241373.17245205565850305914.pr-tracker-bot@kernel.org>
Date: Fri, 23 Oct 2026 19:57:39 +0000
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

The pull request you sent on Mon, 19 Oct 2026 22:00:30 -0700:

> https://lore.kernel.org/akzo2N-H1mm4U7kw@sirena.org.uk mm/hugetlb.c

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c5fd5e67c7812bc40cd897422c1e0d6dd9ed1e2e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
