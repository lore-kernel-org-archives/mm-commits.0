Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59075265CB1;
	Thu,  3 Apr 2025 19:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743708805; cv=none; b=c84slGGCKHcSavC1op25yXUKJSNzwaYm8sUHUniFVpri4zbPH0Y9bEgzALgi/Bgu6cxZZEzEsANqLjojceKL621f9jmHzOUvjA0zdzCVv+TcCyeprZg8/gy+KwZ2RYzvns+h0MccUjpS/Uzis5jItEjT+x6ttzESsxZHKwbPFVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743708805; c=relaxed/simple;
	bh=/0pinxV0VF9ZvMilS7UGYCnSFyWw4P7hfsKDiT64pNw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=r8LBSdNJCHEBDMXQ2QHckPdjpuDVku8ZwWg5At0PfPn2vbV4cwihJFmTNCTd6k3se+Ppw8lNGayXYr1bFEm+h4PFJgXngXYwHX1HeMEMPG3Pm6sJWPXjawAO1glukW2e6ZZqc2lDb3JBlXT+Pk+MbMQEcono7sExVRR9mUFCnaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YAllCzWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YAllCzWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4C8C4AF09;
	Thu,  3 Apr 2025 19:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743708805;
	bh=/0pinxV0VF9ZvMilS7UGYCnSFyWw4P7hfsKDiT64pNw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=YAllCzWftWeHI5HD22k/dcxBNIdjl+tkkwb88oV6JgPSYspkBoSarrJPOADkbbhFt
	 hP9b6+hi65/zEvES/rqAAMJUKoLOr1PD3VTSAbvQUb4P44vyBL8LzZxUeYdugeyupv
	 F+DR1L9on933GRyjtRrm994zz6E5rMmxXEch0MUxOcm92Y6C4XllkpXw5BsGlNJnfa
	 vXuQdshgPvJdSYWttoo73WtPek/dQbUaEakxnUoUiy3ZOf/2d3PGxmjyVJp8rILhzW
	 F+toYVTLz4IUSoN9EhtmUPBFUeCpacQmW8qyed46h2VK6IbX2y8CtsBUxFhskcC9rD
	 DxmBpYxksA6vQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70BB1380664C;
	Thu,  3 Apr 2025 19:34:03 +0000 (UTC)
Subject: Re: [GIT PULL] Additional non-MM updates for 6.15-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250402221551.4d682cf5ee222b9e5b6a1a8b@linux-foundation.org>
References: <20250402221551.4d682cf5ee222b9e5b6a1a8b@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20250402221551.4d682cf5ee222b9e5b6a1a8b@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-04-02-22-12
X-PR-Tracked-Commit-Id: 8b46fdaea819a679da176b879e7b0674a1161a5e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5a2b5cb76cb4c3e878d25f92801df9e12a7b2037
Message-Id: <174370884207.2657822.366281129953906288.pr-tracker-bot@kernel.org>
Date: Thu, 03 Apr 2025 19:34:02 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 2 Apr 2025 22:15:51 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-04-02-22-12

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5a2b5cb76cb4c3e878d25f92801df9e12a7b2037

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
