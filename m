Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F86E20A5EA;
	Sat, 11 Oct 2025 18:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760207882; cv=none; b=PrbWuPRK/lhbAsPPyCo1tDi5ZrVFqJsEYeZDqawQRCH1w/zZFRqieqdA8X1Dzla/vOTPv4V0+V62tIyS4kYyvKDgKmyHkxbx0V98ie9aQK9iQfKm2ODzg8AtdotqXsvh7l6By/d2R7I+0K8kbTax9F+wCv5ScQT0wXcu5S2dQvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760207882; c=relaxed/simple;
	bh=+4I6/7gKW49KdhJ+r5k2IKqth6kx2WhiqWw0C5OIRM4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=GlkIdC6o7pADO4Q9OZOI4R+DUE94YRqYXe/twFk56foxY2DMPbcUL4nRG4ebdyht31hNElWKRxjW+2qwV/dn73aNAVIzOFeAEadtPAQXtnFULbt98aLimll8jP+60WttXf1/Maqr03jKFXMnWluBIpWoIccgwGK2F6Fl2yrGSpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fHkqSFvs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fHkqSFvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA74DC4CEF4;
	Sat, 11 Oct 2025 18:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760207881;
	bh=+4I6/7gKW49KdhJ+r5k2IKqth6kx2WhiqWw0C5OIRM4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=fHkqSFvsp6R/eFe3n/3aGYcqhzP8pn3NyoPej8FXvcqfrTG8+e9cdEyyzgL21R6PG
	 dLhWsg2W1lOXSaaO28PWR5xS4Pw987x3qS5juHWhVTwfNTmZoPHjWXrGdvR30YVEDr
	 oSpdurw9ZS5Xp9fHRDfwxg/I2NHgMAjGD//EhIvdWJG3Igs0+7lezqs/I/AIu4sdQ3
	 F2IPKLDgrfk8ekvpEH+6DgC7g6WDzjVLG01ZL8mfp30tv/24YSZTbIHqZYIOwVeqYl
	 PPyWbNjK9C0W7NXfNkceTNxlTHIM+q76yLYYiJdZzvMJUcVjoWLtA29tugHBhQADt1
	 2vprsZEjtt6Iw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB2493809A18;
	Sat, 11 Oct 2025 18:37:49 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.18-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251010150323.2d73ad0f6fa1c49fbb7d9870@linux-foundation.org>
References: <20251010150323.2d73ad0f6fa1c49fbb7d9870@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251010150323.2d73ad0f6fa1c49fbb7d9870@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-10-10-15-00
X-PR-Tracked-Commit-Id: f52ce0ea90c83a28904c7cc203a70e6434adfecb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 971370a88c3b1be1144c11468b4c84e3ed17af6d
Message-Id: <176020786851.1422231.15209279275130489404.pr-tracker-bot@kernel.org>
Date: Sat, 11 Oct 2025 18:37:48 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 10 Oct 2025 15:03:23 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-10-10-15-00

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/971370a88c3b1be1144c11468b4c84e3ed17af6d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
