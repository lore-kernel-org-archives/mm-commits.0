Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF543AFCEC;
	Tue, 19 May 2026 15:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779203116; cv=none; b=EfO4ytgOaSkJWj5VDhJOAw3tOs+Kbsz3MbfQLSFqDZAoYpV59VVD4wpxs13hkAgNkkky57deerfFCRddRJ01JtO6yodouJZJssp2zchO/X9J1RYOsQB8GndMQwYYof1jG24N/IlFYFdlfRgyHK8EfvldGoSSnQHowuw1CJnjOS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779203116; c=relaxed/simple;
	bh=p4NLoLqVFXbCPzAsRAwiVxu8kNdq17Ny2ShSQHI/nuU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=h4wdDtmWIsgecBaGX/f+gFGjOC2H6Xf5uVmemWU+h3mwpRSc8ErrZ14Pkt5bdLCyn/5s3Ly+cAm6oqMgV812WTZr6oi7zCUuCMqqij7RCDy4z5RAE08mtI3h6kJ0alFR3iOlf0cXBTX7aU6BEXVoxIiIIS9xxbTCNW+TF3OlRX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RTR49rQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RTR49rQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED0AC2BCB8;
	Tue, 19 May 2026 15:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779203115;
	bh=p4NLoLqVFXbCPzAsRAwiVxu8kNdq17Ny2ShSQHI/nuU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=RTR49rQlK/G1L4uGzSvuJM0EicTZawT8oxv3+LoUviGNbvAZ6CJpZem/25Nw6E/Ph
	 Tm3J33BNGqJDxkNr9EXM3tlsvXz29ApL3Zg3fHAphwXBmQvhYoLdTr51GDv9x8dqbJ
	 iirO6V9EL+BeYWo7oy3LdqI+5Cb6c6IXyW6Yr44Ps/MdXCKgFPFjDqQyc6hdVODW3N
	 NpIUF2crBrg85INUjHe3a26d1ZY17D3Tv0Oh8knWEFyooIaPCnf9NRt2jsLKLSWrR3
	 knw3C9AFmFN2a25E7vPAEBugvJL+rNTGRcK93r5qqSv8kvduvsUFB11W5qfVEOgYEg
	 pMgYmqs4BpUmA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 199EC3930CAC;
	Tue, 19 May 2026 15:05:28 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.1-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260518211010.20af3906b324d3e674ed1e61@linux-foundation.org>
References: <20260518211010.20af3906b324d3e674ed1e61@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260518211010.20af3906b324d3e674ed1e61@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-05-18-21-07
X-PR-Tracked-Commit-Id: be3f38d05cc5a7c3f13e51994c5dd043ab604d28
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c6e99c10fd9855082568cbd71bb2cc5dc90eda53
Message-Id: <177920312675.2759014.16333196484481619763.pr-tracker-bot@kernel.org>
Date: Tue, 19 May 2026 15:05:26 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 18 May 2026 21:10:10 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-05-18-21-07

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c6e99c10fd9855082568cbd71bb2cc5dc90eda53

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
