Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13351DCB12;
	Wed,  4 Sep 2024 16:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725467138; cv=none; b=tX0HrFa7HQZ8c5sHYwFZe2OSn7gB9ZsawNdlqvx3t/bHWl2gHOzTFxlJozwmo1/WwHlvZo72j9JxMlFtuJrKMwCB3AAPEePb1nerYlnfxNpsjnp8cHHyUQIRsQjhDGLlX24+JTZhYaPBUt8WtiEBbRqShkuafnCTbesnwRJS47A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725467138; c=relaxed/simple;
	bh=rX+EMbJ9r5XE/UFerJ7KLd9U2AC6c7FMJ5q5hACvXrQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=SAHDTRmtZIl4kWgv1bpbJcqdb0rN5vy23/Escd5txCNogB5XSuXTDTjyUa/tp8N7YW7lwqoV2+3ALZjCW/bJiFPW7t1Sia0ddffBgW0A+Sxiy5qcmXhkRfMJDnnzjp8Hy27JCFiR6rY9jkFMPBI+jWtwZztYMmyOtULZGhVR9xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QpmIgp2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QpmIgp2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28973C4CEC2;
	Wed,  4 Sep 2024 16:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725467138;
	bh=rX+EMbJ9r5XE/UFerJ7KLd9U2AC6c7FMJ5q5hACvXrQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=QpmIgp2fxAufn0sVVZFN3NoIJ+v32yB4TzH3UNuemo8We8Yv+P+Ue2hk1PgAjXEWX
	 AF/7XJIvlm6CBWCZZedW5DGJwy/z48NzdrzKV+m2oUDOGmN3Of6+AhXLZwL/d80+Fi
	 5T/fF6gyXJRlFMJbEj0FZgLI6yme9IFfiYo1NoEMJ6DVpKxuEMDYQayC/UgPesHgVK
	 SiGZuKb2mZ3z6+J71PYI2BkdbOcROex8gjkZJB5wYy51gdT3OJLeYgW/jiy9Mgeh4d
	 pSHWdB36KxHEx+caxQU1rMfv5UrVd31s+hK1iUykD4XCaZtk5NHAmF6ByeTIjqGrFG
	 FXhJASAvNi76Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3472D3822D30;
	Wed,  4 Sep 2024 16:25:40 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.11-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240903202651.f258324d271b4813dfa8de7a@linux-foundation.org>
References: <20240903202651.f258324d271b4813dfa8de7a@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20240903202651.f258324d271b4813dfa8de7a@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-09-03-20-19
X-PR-Tracked-Commit-Id: 052a45c1cb1b32f05dd63a295d65496d8b403283
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 76c0f27d063079ce2c6e7fa971a185a38905d844
Message-Id: <172546713885.1088236.2704685090526522328.pr-tracker-bot@kernel.org>
Date: Wed, 04 Sep 2024 16:25:38 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 3 Sep 2024 20:26:51 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-09-03-20-19

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/76c0f27d063079ce2c6e7fa971a185a38905d844

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
