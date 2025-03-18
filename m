Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87D61922D3;
	Tue, 18 Mar 2025 05:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742277366; cv=none; b=KKKLyRnBEdU5rvm96zNSwr48UfH1TUcjQ8+KLaknrEi9yGaEW6X97VmmdP7SV+W8mO8N0RzMFL3asN9ekknnVi1UqmV2jlo6kkrgr5ZG5Rb8icZ20dOBtJ9zO8R2WZ0bh4IxcJmh9tNMzc/elN7K+SWX7BTJgJ/s4Xz1ZXVy01M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742277366; c=relaxed/simple;
	bh=IR1ja90WyBQY91p3/Y38eTFMQmiA9m2LBD9E7185Fvs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=CG2i5GNwt/vlfoz81VLB8QG5+CvXuI5D16yNTpa/i0sHhFaeyzibTXHsE94WVLoGrCsf2CadwALvvTUSCrCatiiSTpYwq06pk5yYEZBGiw3bBy1rPL4mPmAWf8/VSQt8ftPIqjCmy4JIlGMGYxLI2kYL5eXCZYrS/aKwr5a6cqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K4a8J9TY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K4a8J9TY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A55C4CEDD;
	Tue, 18 Mar 2025 05:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742277365;
	bh=IR1ja90WyBQY91p3/Y38eTFMQmiA9m2LBD9E7185Fvs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=K4a8J9TYLWvcdEZk7oA0ofhEz9nIjnfRH9dehHVCGQZze9eeWNlDUieoW1Uu0+ZiK
	 oFUuyAJ+xKb09KwAT2ns0BQoOhxyhMrdk1us+bjuukKBhx8Fd7hiEMz855ta7yCrOD
	 0Dk8dTWZJPkyj36KudQAoIs2Fwt6HDklDUeAUbOBPFuzEwZr3rzmZKb9lhsBxljP3D
	 8ip4xWxySIAB/glvKVnLjBcyemUIX1tCPVFDfM2bgFwz5AZ83iwNG7Lsv3q9jJtjTM
	 Z3Q2wAht46x0nOyU4GAtVIqnhFV2fpnuUv6SRt53r8cv0Gp4XsDxdw7tHMUjzWx3uE
	 jQsyLDKklAF9Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 71744380DBF0;
	Tue, 18 Mar 2025 05:56:42 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes against 6.14-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250317201206.7800aeeb5dad94c230fe1456@linux-foundation.org>
References: <20250317201206.7800aeeb5dad94c230fe1456@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250317201206.7800aeeb5dad94c230fe1456@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-03-17-20-09
X-PR-Tracked-Commit-Id: 800f1059c99e2b39899bdc67a7593a7bea6375d8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 76b6905c11fd3c6dc4562aefc3e8c4429fefae1e
Message-Id: <174227740101.4034597.18151964474355690519.pr-tracker-bot@kernel.org>
Date: Tue, 18 Mar 2025 05:56:41 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 17 Mar 2025 20:12:06 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-03-17-20-09

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/76b6905c11fd3c6dc4562aefc3e8c4429fefae1e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
