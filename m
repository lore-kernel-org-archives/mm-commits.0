Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D78E2D0C9A;
	Wed, 15 Apr 2026 20:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776285383; cv=none; b=sSqalkRcKdpa5QP7t1y0EVbI9++aB7RKBC21SJY2B+m4vvPeuOq3dBq6lywWmreoeXABFzNg70YcK3XSCUIZNOdO5++NpwAT78J3nA8ZkClqzt17VI65LpWbnOWWl+ql7U6oSmXBzc8bWpiPf+AW8vDu5FyebR8CH+TmPmiOyxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776285383; c=relaxed/simple;
	bh=OkRyaHALJZOsKAIGUFjgJClYOhFEvIOKQGIAQaZ/Pp4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=X/fFhLuN0hAbY+53/w6kRt4kUg3LxV2XSStKdfGMXm0JAmY8jHLqqh0iMhdY++0AL3jhxnnF1DoYsg8hHYqfjgH3MB3SniSSRaq5Mn7MJINUzoCn8LyLwTuTS6bEZaAwtY8/O34SLtNecyi6iDbz8Em+h89agiE7yHHUQwGCsFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P0hmam+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P0hmam+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726E6C19424;
	Wed, 15 Apr 2026 20:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776285383;
	bh=OkRyaHALJZOsKAIGUFjgJClYOhFEvIOKQGIAQaZ/Pp4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=P0hmam+17tT+WnD5WOZw5wb+n/Z5UVQXtRYsuYF7TTTGFZCjTiQXzBkODzcqQsVea
	 Cts48hBL/MF88YwyAbuy9rJ/lF+j+ga21uEvHZt5O8vqQjaR5dmqOWQgsXzGo1n9Fp
	 AMjkRYxGlOAFHUpweDJOFVEUed8HDP0sF1sOljJFCWJpgzmrrPxQJo8p2Fdv5ef2jc
	 c034aYf+OxFGgj5ULeqY+fw91xJkegP996q1TVcQ4PhRJTx06xuoRKXkg3pSSsJ2Eo
	 Rv0DqVVXZBOGaACeiqx24KBUn9yAgGXb2o5S+Fcq3N2NHRy6Rb1asM76FLX7iNldIF
	 ToQM+5K65JrEw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02F3E380A963;
	Wed, 15 Apr 2026 20:35:54 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 7.1-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org>
References: <20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-04-13-21-45
X-PR-Tracked-Commit-Id: 3bac01168982ec3e3bf87efdc1807c7933590a85
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 334fbe734e687404f346eba7d5d96ed2b44d35ab
Message-Id: <177628535256.2427174.3960720777414312619.pr-tracker-bot@kernel.org>
Date: Wed, 15 Apr 2026 20:35:52 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 13 Apr 2026 21:49:52 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-04-13-21-45

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/334fbe734e687404f346eba7d5d96ed2b44d35ab

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
