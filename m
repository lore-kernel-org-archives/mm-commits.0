Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F7E8467;
	Sun,  8 Dec 2024 20:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733688107; cv=none; b=jsxeAccp/s1QZq4DEcVhOCW+DbhUIaHOhv8TfpoykUHHRKagdROwaj2MN65X6ybzhZsPFLlm+TXbDBT/8iuXUT3RM0g+oJgBpzRQ91mfM78U4lvL1cKYqSDclRMJXl3sGq3YuGSwmbUUoRe/gPDM5r1NHLCRw90QufoPyxtxlHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733688107; c=relaxed/simple;
	bh=M6VzcDw2jyiUzxhoAIjua441Rw2S1MmRybIdICNQ8y4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=JGLedrw8Gis0D37QbGTDXT4gLdv6/RoZ5YQFRM6EdLeY2rkO+2C85tg+wdk6l3ikCK9vSXelsNPLkIr7aBVUkikvBNdrCM1HejOtnUCbNjvjFpXkiN8Q/vOBgqbEDo2pxCBtYisLIC24QR3GuH+5JYp5W7+Pxz8F+HQxpBFYxKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S7oaKik6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S7oaKik6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A49C4CEDD;
	Sun,  8 Dec 2024 20:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733688107;
	bh=M6VzcDw2jyiUzxhoAIjua441Rw2S1MmRybIdICNQ8y4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=S7oaKik66L7AUYaEMKThRuTsh7aaj9aqq4Kyk8Ls5ao1P+vircWxqHem05Fh9kfm+
	 TlOKDXl91K0NqjutZaWDnYNea7yeiZ5GOg+7Nim/rsgNHTpBTuyLyJe4X/uEzar/h8
	 eztl8r3A2LhQThBYcM6Ehf1oHjyaZ1ifiDGBsddvIq02Nbkl/C6CpRA3kQYKWKVjtG
	 pRCWj81Ju9B04dixJRRcC72e7gKr5hvSVEO6KU8bXdOJhyECE/vsvk9OAsDIk5pnxS
	 FpxgozF1SvKVgKt/ljMNOL5W10GnAD/jTCGyTIyNeDbSL0mkyCBuHjclzzOojrY7SU
	 G6lZDgfgv+VkA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB4C7380A95D;
	Sun,  8 Dec 2024 20:02:03 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.13-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241207224137.b8aa7ed632f97dd07ff201e0@linux-foundation.org>
References: <20241207224137.b8aa7ed632f97dd07ff201e0@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241207224137.b8aa7ed632f97dd07ff201e0@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-12-07-22-39
X-PR-Tracked-Commit-Id: f1ee5483e40881d8ad5a63aa148b753b5c6a839b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 553c89ec31746ff96fc5562943fe5b1c9b1e9276
Message-Id: <173368812262.3330660.5443607630748522939.pr-tracker-bot@kernel.org>
Date: Sun, 08 Dec 2024 20:02:02 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org, linux-mm@kvack.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 7 Dec 2024 22:41:37 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-12-07-22-39

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/553c89ec31746ff96fc5562943fe5b1c9b1e9276

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
