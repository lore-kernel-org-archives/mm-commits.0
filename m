Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C5915530C;
	Sun, 25 May 2025 20:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748204916; cv=none; b=Z2L427++Y+Ti9dU6TJCsQcsg7IyLJxRWgIUyuDQRtcnGy7GVrKo1iFpUExrvVBYSpNhN8smtBJZvFDjnguOcDYieD7JgGI5ilX9zAi1/PDGKdBnWarTCKOSXToZZInITQzH0tStkGjveI7CY79OxUm0IBcqa3/TLV9gqM/Loz7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748204916; c=relaxed/simple;
	bh=CPNBXTU9SzDDw8P/BQLIhnpLoFhRAq6rAZfe581mTyw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=BcoPWyWG/A+YI7mtSeQa+fWxtUOE/uGU5Y2Z2xADgo2LzgzFtq31xDqGieoJSUVqv/IpvYf1hKDJ1NEbEIHFFY+T6REBKZNWUaO86Dhnz41Yfx6yD70ayXQfXJ4hB6XZuXVzygGbbWSDznOpK3LLUiZzefyRSp8XVcWKnktxhMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WJf6CkJ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WJf6CkJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCD8C4CEEA;
	Sun, 25 May 2025 20:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748204915;
	bh=CPNBXTU9SzDDw8P/BQLIhnpLoFhRAq6rAZfe581mTyw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=WJf6CkJ/t3OlVAFjdSedq4JHV09mbgfFpFtGg7o0PsfI/YxcP5Aa6xo1WGdwmDIEd
	 +/V2RZ6G04R4Z6F2PeomJXlyhB3mdeEudBp2NXFJ2WHKf1nhyOJFO0d97F6TH+5/Nr
	 ajdE5LQ25J6ky7nTDlXoIgAT5PCf2/kgfdDOsWIaKzwhoTzIWDHAmnBEQHs28nOSXR
	 t9vC6UKqyAXTFFK3LnmPQG2BoY0pE+b2KV8Q1CN8TxeLRb4GTf4myxK1vy1Rz9ItgA
	 VQ0yeMmxPDXuLaP7f6Nxh4fueHH5IbYaCGWhIxwAY6tXbbb8GW2VXgy47jUHH+OUu7
	 YClW0uhT9P/jw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAFC8380AAFA;
	Sun, 25 May 2025 20:29:10 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes against 6.15-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250525010153.4e008d81730ac2137a80fb77@linux-foundation.org>
References: <20250525010153.4e008d81730ac2137a80fb77@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250525010153.4e008d81730ac2137a80fb77@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-05-25-00-58
X-PR-Tracked-Commit-Id: 1ec971da1c10e6376411e6d4a3f3b2351217d94f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0f8c0258bf042a7da8645148f96d063b9c2060b9
Message-Id: <174820494939.18267.11583241414200650908.pr-tracker-bot@kernel.org>
Date: Sun, 25 May 2025 20:29:09 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 25 May 2025 01:01:53 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-05-25-00-58

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0f8c0258bf042a7da8645148f96d063b9c2060b9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
