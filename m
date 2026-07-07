Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E8B2F746D;
	Tue,  7 Jul 2026 02:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783390171; cv=none; b=s9r5g9ZI0savYPasNEMfuI+g1giv+S8bk8l7zJTZlMJwD30VKm0BCxb/b447rW4VYazXU74flPD8SZsa/LrqJ4yv8fyQgXaZt4Ho1eD/Ciu3vovCO3pzNvqwnlaE2XTquyIbEWa8+83xXehSKZdUGT9cme5wsNeyfgkel0sah/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783390171; c=relaxed/simple;
	bh=ehNCfZWZWzkPYZy12O/c1WdZV5E8aH26i99RxuCcFxg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=rJ0k1Od3pBgms40HsbSzlkiMHAsd3NK0MlWr3nDMPihfx/iD4N+pcV3418NlyEwDlgw7JO7MJnKRVK0f6RY3cWeXzP0DWYQ2Lsvj3NImLAlnhh3zTafTjXyRA6U+w8aDIK8YgNjl5y5HAVPfjWkjaSn8FVy7+D75aSAorVu1Cn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cSuHS01Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cSuHS01Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF401F000E9;
	Tue,  7 Jul 2026 02:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783390170;
	bh=ZSeRuFsGx/Wn1nKCRTuLj+Pzgee6JkOaa4XLCrxaHQc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=cSuHS01QpzWP2DO0NjfSNBZpzkXmJQAoAjI+G0frblXW3RoF5R7l+vozVnsElzpr5
	 rywewl6ccSjZpq8rtkb708xuPdiOm6xlMenR3vJ3Y8TGhTw2PGfwAtIWeE9lmIDZ34
	 81q6pNNn0iS/HEkuJ+fmSF7vn56sfIwXx2+Zig270LqK1aWG5ZW6MH7xOChujpjbjO
	 SOjHd1IMVLTga0TAaYwY6mDLvH9nl4Kz3k4gmXHtVOKpo20JlMieAID6DLI5aA8t0f
	 HFt5xrsLMmIW0kW7k75Qmn922wl1XoxDU1RmhhkpsqkfRK//YsTwy8kZB0UdkHPLCH
	 Z7mG9PHYvhZQw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93C9C3925F7B;
	Tue,  7 Jul 2026 02:09:11 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.2-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260706175120.2411eb28603d28ac0424a573@linux-foundation.org>
References: <20260706175120.2411eb28603d28ac0424a573@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260706175120.2411eb28603d28ac0424a573@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-06-17-49
X-PR-Tracked-Commit-Id: 039892c35f9d8f5ea00d7c2ed1c25224f28b11d7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
Message-Id: <178339015024.1289809.10295323944110315873.pr-tracker-bot@kernel.org>
Date: Tue, 07 Jul 2026 02:09:10 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 6 Jul 2026 17:51:20 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-06-17-49

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
