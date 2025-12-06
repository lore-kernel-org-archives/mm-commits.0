Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5D52D97B9;
	Sat,  6 Dec 2025 23:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765064204; cv=none; b=RXpMzrGO/MMW9jAinJzYZ56vf04px8hl4Rk1gcylnl2knnyNJtq28i+hJgYykE5XRysAcRhuBBXzzSq7btY/SxXDGDx+T0l7mJrbCd2bTYOB5fSC2xq/s8EUjGRyZycszJDilYiHBg/RtiN/WTtxuFuIpBPk1AlA/XIGCNW2g/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765064204; c=relaxed/simple;
	bh=Xy490bYBXRCIaVdEKOF3H87YYhykbLI6BBVU7qxvw8w=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=QOgslxCZ5o39a1oZ+KqSo2X5kxEWKR7vKTZzEzkBMiq2YGcPFVroUDLxmDEMuQncHZTbkqMbdB0DJNWPLk2EA5JA+Wcrw3IbpdDlc/bNdlmbrmzu8SOuJq2ug0SU+lYiqX3XiaZPV5gj84JeSLRi3MAUh+aFkeHsOsWvlw3RdOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k2klsx0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k2klsx0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF859C4CEF5;
	Sat,  6 Dec 2025 23:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765064204;
	bh=Xy490bYBXRCIaVdEKOF3H87YYhykbLI6BBVU7qxvw8w=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=k2klsx0Lyr/CRmhIoWDzB2CeQa9otxOJLF+ctidxe21AX9WupLN8nJTraZqfi0zUG
	 ryGJgwbCq82cy6kTDHgdMkYETXqEB45kX+tenLEoP9nJ/vi0dMwhP+PxzCUZ6VrSyO
	 9yVg2D8gwV67GQpV4Q6nyu3akzef6QnUt/MqTS+sa1HWiN2WoxUbI8aKgcuJG2YczR
	 lRsK1chsLJy7qlrELB4lMfVzqUrfPUFuQe9PsKnFQ+x+QdxNvUr6VVPNyMHNFOy55r
	 kBnwR+JuwGYJqdAlHF5j+9YirP/D4pdjJiR5/62ydvQMH4w6SHECW272pXqdAqwDji
	 iIu4E77DmQcFg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B59B63808200;
	Sat,  6 Dec 2025 23:33:42 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM updates for 6.19-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
References: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-12-06-11-14
X-PR-Tracked-Commit-Id: aa514a297a0c175239f24a2e582ebd37f0727494
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 509d3f45847627f4c5cdce004c3ec79262b5239c
Message-Id: <176506402140.2232960.14577174906108791705.pr-tracker-bot@kernel.org>
Date: Sat, 06 Dec 2025 23:33:41 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 6 Dec 2025 11:15:33 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-12-06-11-14

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/509d3f45847627f4c5cdce004c3ec79262b5239c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
