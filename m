Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC962599;
	Thu, 23 May 2024 02:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716430536; cv=none; b=hM9Zo8h+sAMPrvjYwPq1u+E95GzpZQv1tohfIzF4+0JIniizcNZrCDapljgm99WnwaBx1kqp6g3LsVLvHUID/2B83pOxzNXH5ZMr3PluF5vilzyYuk/EmyIRV3M1PKl5f4EoaDweM6KIv1o1X86G+Eo+y/LegAm3rQNJUaBV8DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716430536; c=relaxed/simple;
	bh=/OWizz99gA+IQaLT2upB3eQGm0hptzGEn3g1e8qGd4c=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=G96rG40EDBcdQ1c1fRzVAe140LqB+aUsGJQ/LFNztCyI2W3+fRQshAzQO3cEadZbSAM5811AiIiyHt3fJlSyP+aJ62iuxs124SLJpMFz8qvZXDbs1lVgO6zWgCKmU4+SJvb3DKL9RXKgPGqWOc65hM8Iji91yo+KyD56rAN7QcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ki+wzUHm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ki+wzUHm"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9BAFDC32781;
	Thu, 23 May 2024 02:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716430536;
	bh=/OWizz99gA+IQaLT2upB3eQGm0hptzGEn3g1e8qGd4c=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ki+wzUHm4vlMS9crPUJsaGaKc8VRp7VtmbvB8/VAUjSq9TqUwND9t5u+4TMUaiPBh
	 B5sH8KlTr6hBC227he8fYonl6rzVeEmd3YihbpzJyYS/rSThSSP9jqYKLz3BwX6QkI
	 E3yjxcLfSR/m6RO4BDy7irNIwmRsOHzPyL2WDoikU5xHFiiGNHH2iQNSm9D+s987/8
	 soab7VgfPPUhYVGKFwzEPFB7wwUBPFTsNYQAr/QEO7Sy3DHuoeIM9hdvvE4IWPnBeq
	 2z0cBqIF1YF8o/QD/6xtvr58LVs1QXy+uIEzQhF14LiHly0yaY/G89Vi4M+QZOM8e4
	 cc5QVYi4viJ/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 92226C43333;
	Thu, 23 May 2024 02:15:36 +0000 (UTC)
Subject: Re: [GIT PULL] additional non-MM updates for 6.10-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240522173553.4653fabdd1f4d9825f38e0ae@linux-foundation.org>
References: <20240522173553.4653fabdd1f4d9825f38e0ae@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240522173553.4653fabdd1f4d9825f38e0ae@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2024-05-22-17-30
X-PR-Tracked-Commit-Id: db3e24a02e29b507c24c0adb4d22914c65dab763
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c760b3725e52403dc1b28644fb09c47a83cacea6
Message-Id: <171643053659.23672.3142603833677830881.pr-tracker-bot@kernel.org>
Date: Thu, 23 May 2024 02:15:36 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 22 May 2024 17:35:53 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2024-05-22-17-30

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c760b3725e52403dc1b28644fb09c47a83cacea6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
