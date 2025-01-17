Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A8A1A2C06;
	Fri, 17 Jan 2025 17:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737133859; cv=none; b=PtHJGyhv1pd1kXNnlb6brrBcP41u5D6OtY+TLBLQCeVSaOx5jpGaU7FbvA2mHKX1wGbv/bGA7ILGfTwC/HReLNXk6ilBGbYmT6PgOZ8dMi0+ME9f5iSlpetFuXyjdRV1bLH4/T6B172LzIxQTupfP+8lUOU7CB84Uoi3NwRj/I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737133859; c=relaxed/simple;
	bh=231PICht/XzJu8EdyxcdRB6A8DLCsXaXF9+UB4Patp4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=G03mTdOyPKTKYPrjAhLV7WJxzbWcO1t+FL1FKqUve8t1PO5P3n1TW7TpgkFtyFye792lBhxEDiMni1TA0pZPX/VqcwymFAxS9oQ1Yqq0dsP/IfPfibHzLufqfyl+M50VwT6fCMowE/1fYf10jsWlv7bm+6T62fB9qZMCx4K3/4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KyhyQvJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KyhyQvJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9C7C4CEDD;
	Fri, 17 Jan 2025 17:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737133859;
	bh=231PICht/XzJu8EdyxcdRB6A8DLCsXaXF9+UB4Patp4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=KyhyQvJhG9GZcuMWfVJEiaz7Zp7wHghCTB1vVcY71/ropN6EKgMZqbO6Neml0qZWR
	 6WHuC37gWow7uCt4xzG8+0b04ZcH+b7XmT6HG64+P9O913O5OY36TizDsnd5c7b56V
	 tPcPUxSJAeT69swt3DE/zs+SL7jcKDnO9Z+p4lEqK1HBConMbW1Nle7Nc4yriZnTod
	 JZoKujQK2KSlF+Mb18sABVEECg6Tlj7JJew4K6goKXPa/psu+Uh38StCfYEj+wzaoH
	 77HJd9+JHeUvLbGYXEDdSDB440QWSbtKn2ToILIHhKeb+Dv5KoClE4jJrF2eRDROS7
	 z0+LBflBiwdjQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE085380AA6A;
	Fri, 17 Jan 2025 17:11:23 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.13
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250116211322.19c20e534e96f37c3608792f@linux-foundation.org>
References: <20250116211322.19c20e534e96f37c3608792f@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20250116211322.19c20e534e96f37c3608792f@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-01-16-21-11
X-PR-Tracked-Commit-Id: b0fce54b8c0d8e5f2b4c243c803c5996e73baee8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ad26fc09dabfa6a33ad5baee80479f518370b316
Message-Id: <173713388237.2196808.12893035516705475269.pr-tracker-bot@kernel.org>
Date: Fri, 17 Jan 2025 17:11:22 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 16 Jan 2025 21:13:22 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-01-16-21-11

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ad26fc09dabfa6a33ad5baee80479f518370b316

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
