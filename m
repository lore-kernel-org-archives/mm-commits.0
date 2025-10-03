Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C022C236F;
	Fri,  3 Oct 2025 02:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759457901; cv=none; b=dgR8m+exuQE6NFqzf3nWWKWjEQPSzI2hEMYiKdng8Dko0VdllLPwcqrW1zHZWADnQhGyiV7+o5P7zmsjUlhGt6x1fJs7y0I0NRG8Pnv/iqiTqfj1ijDBvt9V+GUUe1oUbj+YCfnfFkCFsT2N37cKANWqtGbKdFID4YKjInkoiQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759457901; c=relaxed/simple;
	bh=We4JqlVa1LZyQEyJ0+q6nXrpRzVKI00SPf3D6FKCf3w=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=S/gbVlYV8zeN3uSuOazNFStylqiR0hf8mJUKDzp2abrCzD8DUlz1O8d65ZJObohkUiJUiL7skNazT/NLICeItueAfOAeOGx0z86SvvdPrNHz4mkRcKw6vqpmt5d7IKzHZEMCiFvTzikNz9byN90Pekxa4F0A9mY7YhpckStE1zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=giY6CZRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="giY6CZRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401D2C4CEF4;
	Fri,  3 Oct 2025 02:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759457901;
	bh=We4JqlVa1LZyQEyJ0+q6nXrpRzVKI00SPf3D6FKCf3w=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=giY6CZRTmwDC4/n3H+2mmttVTx+Cx3D5RAHlCjLdupBXYbYUhRriPCdbDdZzamyxR
	 3tfKmDFKZN0fJTbhAMmo6zH1CtjwxVVtrI5IRG5SWWCwXqEGI2lnlZkT46oZabsF5V
	 FD9aiwetPA6NYGaGoF8KCRfvwAuu1ti+BqFORqfrQx2+F2hKbB0X7Dp9PMM2bcqaXn
	 W/RQR2x6V2VpKp6SWBxKhHWBdyAqlsMhyODGi3VnoFwsa9AMPzqNjC0vbDGh/k0Loc
	 T/zjbt7sphZJWj8omJ+1+JA3MnhmM02K8YHWQ8NKJBNEIchCvYoc1yhIA+CypbwHZu
	 Xz5qs2hzYShEQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33EBA39D0C1A;
	Fri,  3 Oct 2025 02:18:14 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 6.18-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251001190218.f33f695b869696c2df9e841d@linux-foundation.org>
References: <20251001190218.f33f695b869696c2df9e841d@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20251001190218.f33f695b869696c2df9e841d@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-10-01-19-00
X-PR-Tracked-Commit-Id: 1367da7eb875d01102d2ed18654b24d261ff5393
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8804d970fab45726b3c7cd7f240b31122aa94219
Message-Id: <175945789274.3590395.15147942711150864658.pr-tracker-bot@kernel.org>
Date: Fri, 03 Oct 2025 02:18:12 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 1 Oct 2025 19:02:18 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-10-01-19-00

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8804d970fab45726b3c7cd7f240b31122aa94219

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
