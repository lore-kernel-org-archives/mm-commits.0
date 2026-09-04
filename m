Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AAE2F9DA1;
	Fri,  4 Sep 2026 05:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501065; cv=none; b=cs/aNzSHUUMO03koR0o8tEHJseYHQ8as3IA3o7mey6G1V2s1OhxhvAv526NaYAYz6CNkXcF+cW9sfg8cb3Z7HHzwZeuOD3CwCphkGC0YUTybCIZyn79A2iskQHtrofVl2DYqasvA0kAM8SIxYNr79TAnZzWVfO+XYbkxlU6FKxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501065; c=relaxed/simple;
	bh=CWVrIsUuxxbw2ELe+5GvfLP8xVX6Ns+zKyVqroUAB68=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=S/afq4KYb5OPpp77BQxkO17Aot8T3rSvd91VGM2ArN3VMfGU4qlmG9YWiXiKMH00GqFv7vdrhAkPN+gv3xja6ujv4WyzBrUDslnL757xW4kuoTr7tis4uoBWKvm+SvL14RFrfXefVGHU3fq9/gqGbsCCEB77MelAhb58558DMRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/P4mY69; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/P4mY69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DE21F00A3E;
	Fri,  4 Sep 2026 05:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788501064;
	bh=Ni9g+VS/7DxBWoYVJAkvr5meS+eqSiNuXWyCSs4HoDs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=T/P4mY69d7b6hQUixCeJyZXv8seyN033qYzYvIKbUX4p7R2OQs6PETh74s8XbDiOR
	 WXFCA2bp94DUcqS3gkjsXCDpRdaRKuHgcqRBz05VnT4pfdGK7mWRbX6PWPrFLQ0eGH
	 OjsjwSkyuUzpjnmYexFZnGtX1auzkKwEqgTPwmbh97BrMHPx77Mm0ALjtvEP3lBM3U
	 o12szbDxevz7rUSkWUNTddxY9hg2RivnO0EHgD2kr23YXIyMf8ag9EYnnLuQ+0O8ox
	 KjGEaCFwNlpYNoMEL14ERHkSAL/f41M/yF8RM3RT0DqS0YwLpmj+PPQ1etj5YCHec7
	 NavJf9LyYQlEQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0C3238119E5;
	Fri,  4 Sep 2026 05:50:06 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.3-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260903174847.a7f81bd5400d48cc8d0feaf9@linux-foundation.org>
References: <20260903174847.a7f81bd5400d48cc8d0feaf9@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260903174847.a7f81bd5400d48cc8d0feaf9@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-03-17-45
X-PR-Tracked-Commit-Id: 97d34aa65c29cca85e3e9050f4c936389b38a054
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bc35965f6940a9bf834d54187b6088b8eb09206d
Message-Id: <178850100549.4186254.2817444267395046439.pr-tracker-bot@kernel.org>
Date: Fri, 04 Sep 2026 05:50:05 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 3 Sep 2026 17:48:47 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-03-17-45

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bc35965f6940a9bf834d54187b6088b8eb09206d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
