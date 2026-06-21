Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D6425FA29;
	Sun, 21 Jun 2026 21:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782076164; cv=none; b=JyLHZe5z2GqZhxaNPm2sHBp3xbg4fAHvCXrjcK3FlrOQLO1hIEYRc6MsvBnr5lunBYp9P81kvkHBdDxXOYfwTnP6X6f+UwOIqYRalXkxmK9NtmAXb5jpl9UHkeLKormAfjwrtSRqzYp2fSxOUZVpwumT8lYkWooJUBm31Rrh/uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782076164; c=relaxed/simple;
	bh=lEecJ3w7L4X87KRGMaPnhtNqXL03N+uh84JJWm4KpaA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=G1sLWzBvAVj9KhQyWkmzhKOLPLQbZhL9lRckVzzm6+dQHXRGyCM6brLyPZ4pKnUfTVT01zPPanNEyLDuqo4oIkHxAy4X8TQEQIYCrCpqWzDkaMhjTzVM64pGs4Q4uFdiDMNwVqnj4t58lBiVJLdO7CJcT5+Ku1QWawwImsz1PrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M7iWdAqP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M7iWdAqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24DC1F000E9;
	Sun, 21 Jun 2026 21:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782076162;
	bh=tNI3BTKWQnW0XLih6fm4AoyOHw6aYAjSTdAk+RAUuAQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=M7iWdAqP88wEpBAFWK3jfZqrkR9wgkDFAKs2qEzu/U+mrG8zzSX37GE/UU0azjkWc
	 XBgrKeFMbtdqk/NioyncdEka9EYK6QdUuze6ZQJEWu0XV9KEvNvzxL1wVeSv/OhAGX
	 QMBJFlko6FXKUsZLo5AuXMkLL9mZ8i3WKFZ76fAkvKFhPaWvMMGiMbYvNOf8+D7jkH
	 XAqGwZVtY6Jern2cawFChkktOfBjtZxujyzs1BZJSxwhKwGGjCUzv0UPJ1+Nb9rjsG
	 d+kp7bnZhmC8Q2u+6Y5M/+SaL5kaW6g04ElbUe+yIy5+K64issE1bKqUzdSPiS3NIQ
	 07wCp4gEqIyuQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56BB23AAA6E4;
	Sun, 21 Jun 2026 21:09:15 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM updates for 7.2-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260621102749.186ffe45cf2fd65838bc3ccc@linux-foundation.org>
References: <20260621102749.186ffe45cf2fd65838bc3ccc@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260621102749.186ffe45cf2fd65838bc3ccc@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-06-21-10-22
X-PR-Tracked-Commit-Id: ff6f26c58421614b02694ac9d219ac61d924bc68
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2e05544060b9fef5d4d0e0172944e6956c55080f
Message-Id: <178207615376.500153.10811916983795748695.pr-tracker-bot@kernel.org>
Date: Sun, 21 Jun 2026 21:09:13 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 21 Jun 2026 10:27:49 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-06-21-10-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2e05544060b9fef5d4d0e0172944e6956c55080f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
