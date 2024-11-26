Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265841119A;
	Tue, 26 Nov 2024 01:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732585261; cv=none; b=Q5AliDMWZfc6Uoe24+hkukteOdF2V6hLgGYAzBg3UoSwH1x4bC8MMyeL84QholfZ0Oo1x6SydVx0hHvA4ltxssxuEw7Cp+twXpwsgoMn1GLIW2O4KPQiFExnRAtzcmVV5HSVnWu39BCFRlCD7xEZjAnh6LFywMLyJfypIosCIHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732585261; c=relaxed/simple;
	bh=J9PBZ2Q8DJrlOJCW+0yK5ZHfaV5swSbyXXZwEoSC/Ko=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=JD6gQpvI9Chz2tkZvxbDeYLOsMqsr3Cy3WHFTFqIm/EVNQOyt2FCtL3LB7dQhFzmpZBfZMSES69V3Ath6PgwB90Y11VyEdZV9k/Jv9xVpHMRuiflNnlGX+qtm1vjaXDvvvKF7Qh3ea+VXlGl3ARCq4gypl+Q2KBUC4ReNpEyZOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YnsRvxZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YnsRvxZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0615DC4CECE;
	Tue, 26 Nov 2024 01:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732585261;
	bh=J9PBZ2Q8DJrlOJCW+0yK5ZHfaV5swSbyXXZwEoSC/Ko=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=YnsRvxZFbC2hBmqjY0h/igZdvTkcZsZHIgWoiV3gqP9dDvunoiQV9eOd3rwBv+e5d
	 v7ED3vHlxmVzASpm6bbkdaD82WirnfDWS3zKBTl1IF8ZWmlKM8t3e5oxwHQnBvzAtJ
	 ro8Rb4O1BAK3kZMrypRik0UrBKgn51QMXyS8xWZq4sZL5ZUL8SceopSdlhCXIQxDhi
	 CC9ezsajwbiQSsrtzvaRBVeRO1guqq6siMPSmykM+jOjFj/GL07jgH6r/r0+4aqYqg
	 nxEvUdhGMEtn3xVrdntalWAXhZltLNDC7TAtYujnLGoy+3k7Jbdie0lgwjIbJUyjJa
	 75Z68IOaCbZ0Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAD8F3809A00;
	Tue, 26 Nov 2024 01:41:14 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM updates for 6.13-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241124020841.3a96d9e26be9ce4d5810d0b5@linux-foundation.org>
References: <20241124020841.3a96d9e26be9ce4d5810d0b5@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241124020841.3a96d9e26be9ce4d5810d0b5@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2024-11-24-02-05
X-PR-Tracked-Commit-Id: 2c259a91d8d23a8266092b0dd51b8092877717a4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f5f4745a7f057b58c9728ee4e2c5d6d79f382fe7
Message-Id: <173258527353.4104378.3630372979532846082.pr-tracker-bot@kernel.org>
Date: Tue, 26 Nov 2024 01:41:13 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 24 Nov 2024 02:08:41 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2024-11-24-02-05

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f5f4745a7f057b58c9728ee4e2c5d6d79f382fe7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
