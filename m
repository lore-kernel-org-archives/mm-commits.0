Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DA72309B0;
	Sun, 28 Sep 2025 17:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759080687; cv=none; b=aWBjw2H88sBD6NhIj1v7e7GU2sYqZoO7sxRyako1MUTLIdIFGRljo513z+kPdGrc3rurkIxTZZejSQ2aDsDLbT+G5MJuCBRZ59to526QG7SOKn2gPqaPV1otE/a5sQmmEV7/Qk5YKdrxetBpCqFaL4gnnU8ID8+dCtG6WpzV9L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759080687; c=relaxed/simple;
	bh=1VMnkyz6jgjmq+6gteWLQjg0c+OIVIN7buC+/GB0lg8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=JvSDyzs3nSmQiK+IwT5p6/n5aaPJdPw+RU9meuBxshc72MrvFZFQJZr8tOjrpT/KMfA5g0pUSgzYouAtwafBIOX+VN3V5mc4eMdqwWSOkQof7Sr35whgvV5qoIuLVGs1PqXxP10HblYv0wBCOUpt4HOAW+ZPF0CqTIrF5uVDoVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dUQQBIxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dUQQBIxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F3DC4CEF0;
	Sun, 28 Sep 2025 17:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759080687;
	bh=1VMnkyz6jgjmq+6gteWLQjg0c+OIVIN7buC+/GB0lg8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=dUQQBIxtWiRaKWcA5KDrBwZQ4C5CkeXEtkNHmhrx/1fYvcnDZMSW4JIvdRFQ3McN0
	 ZTUqEZKYMkpXupTVpvu9h/l9IHx4GRvsrMkS+3ltJVM0uk2zSZtOUN8F/q1N/+XUCD
	 r4dIXoqE/f66JRwxSotMmQ8FNR7bpXW3O+zfaVCVqTx1fI19Dr+LgCLurY6h3/oqTX
	 iPkGLV2aj7rFNbeEk+fFiy1dvisoo9TDyz24dqvb68ferTL4z8zv1r2xoJHPs/DSof
	 nbD2ZfjY0VGxTZh56MZYjdCPCirxeQvsH8ggsTbiPaI+i/cxWuatVBMisN13Zlms7t
	 qSeal/zJlJF/g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33CDD39D0C1A;
	Sun, 28 Sep 2025 17:31:23 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.17
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250927224612.fffdf688aa7be4206a4a3ff1@linux-foundation.org>
References: <20250927224612.fffdf688aa7be4206a4a3ff1@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250927224612.fffdf688aa7be4206a4a3ff1@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-27-22-35
X-PR-Tracked-Commit-Id: 7e89979f6695fb56e8739b7d19614256e637131d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 09d95bc8023569a56078950f2fc6f1a12a94ee08
Message-Id: <175908068168.569924.1441363109262301561.pr-tracker-bot@kernel.org>
Date: Sun, 28 Sep 2025 17:31:21 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 27 Sep 2025 22:46:12 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-27-22-35

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/09d95bc8023569a56078950f2fc6f1a12a94ee08

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
