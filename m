Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFA021E0AC;
	Tue,  1 Apr 2025 18:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743532609; cv=none; b=DJ/B8AVe7f04VnqyN6EzXNp+vwzwSosV1SFhmK5YERUt+bI7Y3szcW7+A0bdOQwsGMrkEGo9vXFgTG9S52zd3h8LSGBSxS1X6xCSOlRVBT4iaZyqv68uxGLLxIu26hPz/qBzeHrDp9ICgp/m2RGoO3+HcG2fVMzY+8ICGZg+C0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743532609; c=relaxed/simple;
	bh=AvF1nAzwmJ4p7X1+IEdxUeIv5LfSiojrXwrs+TqWWp8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=O8YzJZXW/gOsKlIUVVLSx4okuvkoWemNED+qMb9clMNaLcYRnbWNTGrkeQNqxsZTGzrLF+BiPkFsPmpfar061NJzY5uWSDE9EEIaIfvO/O/WcsnWnA1D+h6enRfiQrx/H17gf1ytWZlIZyT+BXcZuBF1/j4qJqVnyWPf2yjmfLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cmBp7Yld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cmBp7Yld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E235FC4CEE4;
	Tue,  1 Apr 2025 18:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743532608;
	bh=AvF1nAzwmJ4p7X1+IEdxUeIv5LfSiojrXwrs+TqWWp8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=cmBp7YldWrhZxy3zZbDNN7bBJev8tYwfkXb6wYIi2T95qcIOC0PyRe5HJ47BYLklZ
	 VGiYrvxfzA7NNUySdNX5q9JcmXXX1dMWOw85uw9dEuh31gH6sqLN9Vrh64hlUW8aEY
	 HfA0hfU4UBg5Re0p8i7aEUVWtQsS75MtVaZFBMI/UgrQdTTlD4p+8uTX23w74aoXXS
	 D5pHlXrHc7T7z/SIWg4HNziquRquKdtMwCkh5lWHqyVNgElfdyBhDvarcf5/Zddu3S
	 3a+rv99KMV8zPojsBv4MC+Om9zdf7H1yyRnVEjcHkTNCoDYamvcT/O+6HZDc2ua/uy
	 3u4eqsGymps1g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EADD3380AA66;
	Tue,  1 Apr 2025 18:37:26 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 6.15-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250330165732.f4c1493615375623f67e38eb@linux-foundation.org>
References: <20250330165732.f4c1493615375623f67e38eb@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20250330165732.f4c1493615375623f67e38eb@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-03-30-16-52
X-PR-Tracked-Commit-Id: 0a1e082b64ccce165e7307a7b49d22b2504f9d1f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: eb0ece16027f8223d5dc9aaf90124f70577bd22a
Message-Id: <174353264556.872225.9086869587709845716.pr-tracker-bot@kernel.org>
Date: Tue, 01 Apr 2025 18:37:25 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 30 Mar 2025 16:57:32 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-03-30-16-52

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/eb0ece16027f8223d5dc9aaf90124f70577bd22a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
