Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28078F5C;
	Tue,  3 Jun 2025 00:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748910777; cv=none; b=I7OBWwq5ZHEQPklOICp+qYJ5h8xgO43XE+ERChI/a6zPpbfVAHRUG1Bm4jBfjoes2gdhyX1W5+J5zEgHZ2bEtIVu+77gesRPHAKAp6UwieroV+1UGvjVHMX2QO+ddykWVbgRySntzmzrf0ucOppq4yRci7Dp7wef8ep7/b9wCfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748910777; c=relaxed/simple;
	bh=OK6puR/1kBvEZfXb7xdHMQRBi2BdkFaTaM2S34g/oYA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=i0hbIR+ifIDeTcq6Ss9YVM/7a+I6LQnVgxlMI7oy1CXsxpqLh4kRpPNNzKaX6FGPMRpOaXMVTVKu+VfswRaekQW/uyV756jwPVIFKVVFk6zBXeGVKTjJ+hAmePAu5OwM2HoPEs3g5REOib+Nqi0tzpWkgLKCnUa/FQqvjfywkI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sYxPG2HS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sYxPG2HS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECA6C4CEEB;
	Tue,  3 Jun 2025 00:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748910777;
	bh=OK6puR/1kBvEZfXb7xdHMQRBi2BdkFaTaM2S34g/oYA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=sYxPG2HS4rTMK+CQlU9l1sRjvVYVpzLuMpB07KUK71v3BJdsQHMBhrCG6vGQ+6Bo6
	 daEYakp5aEutfiM0uwxcCKdV9Y9Pc8rOtx7z4yyaw2E0syob69hkc83hgVkAhw0res
	 Md5AgWOyve6RbIlxhX2K/sIXY9DehKqsCjO/ol/qvEO2ECdNOSF+CNEkRrcwnOW2oI
	 JxLdRhA2oPsnAbDIvQ7TGoevTSkKKylGj5oiCCvHX9+8gRBy7HxyL3SDZuzKzCRp/q
	 I40OuTdwdciEdY3lZy9rhAYnZfJTkh1RWwx/i2xepeA1tVXghAxl606kUWLwXn3hdn
	 mz6R12n1hDTfw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70F62380AAD0;
	Tue,  3 Jun 2025 00:33:31 +0000 (UTC)
Subject: Re: [GIT PULL] Additional MM updates for 6.16-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250601151222.60ead71e7d8492a18c711a05@linux-foundation.org>
References: <20250601151222.60ead71e7d8492a18c711a05@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20250601151222.60ead71e7d8492a18c711a05@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-06-01-14-06
X-PR-Tracked-Commit-Id: 0b43b8bc8ef88bb45b018b2d4853d38bfc5ce2a7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fd1f8473503e5bf897bd3e8efe3545c0352954e6
Message-Id: <174891081008.961800.5493448222601669134.pr-tracker-bot@kernel.org>
Date: Tue, 03 Jun 2025 00:33:30 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 1 Jun 2025 15:12:22 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-06-01-14-06

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fd1f8473503e5bf897bd3e8efe3545c0352954e6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
