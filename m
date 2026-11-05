Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793914655;
	b=bpvshEoYbxzeG71WKYlLN95nnkeu5ASoAcgqPNgCsR6TjOSqO20smMws3ahIJ9zljhNN
	 nrb3XEplDj2lKq1dB66UpuhvxqiBNKpga1jFlMgGKp9aJ2dwdAyxpfH1e1JJpCuv6BWXF
	 mv75evaCmOgg9KWklrk9XOoR8vDQVuieZ7oFYsib43mmuPsAlfk01fBzZU/dshP0bvZth
	 jZJV7bPFzKrl0XDS9WsRdTiNJsYSZDp0g7wJv9fGkwBgVwftzn0eGdr3uJN2qg/sPnfNV
	 jTZqJ4+l2wLeYyyarw+FJoWe6WeTfHV9peQSnDrjbvFRTzaFWwebEZiGJfg0uzqmoFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793914655;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=WTXHhh5pRi82QXsGsIZV+AuAH7A6K1EJ0oWTh4/aW+U=;
	b=2LSwk2ov0vHeawIOP5zkXsskqko7A8QA5Psk5AxRec1nEgrRJrKLWyJJ4MXr6lBGPs88
	 E6/mVhbcQbTOmewQadyC0NcUA93urUWHOg+QxBHcbDi/tSHZ9pejxPEiJpmBjcGMNzlEr
	 dQsQEaSuXoX4Jh2CI4zBUzEhSH13qBuUvtpAPnWOHWKlqv65mRoH0g2YzUsPrmSChEMEL
	 blrC0qDP/yacrybPJ1/WJczM+5tTx0ZQCs0q6x9pJ7tmV5aY/JKs23jfdC/SqVnt4ko90
	 jynuN/7G8uwrP7MrMIirrHpQ9zEiwL76PONQKrxs7dYFRhFrhg9ppgPSxYJwWhN04Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fnE9PzFv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E915606A330;
	Thu,  5 Nov 2026 21:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fnE9PzFv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AEF01F008A1;
	Thu,  5 Nov 2026 21:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793914655;
	bh=WTXHhh5pRi82QXsGsIZV+AuAH7A6K1EJ0oWTh4/aW+U=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=fnE9PzFvKPEqVaT6U0gwy5UbhH+YB3BFZ3YDcM3KD1A/YXemCHodsIsjW6OnR4fZV
	 uSFROpUduvxagL1qMhv0EiuLGxwir2SefVD/maMJd/uuBPuuqbhCd5wR/OmfT4O43W
	 wv8KOWaQOtUCholVL5lsQqP6QwNwYcfmiPoTX0r+SKGj/IYhLRzPgrC4T/nHlhccdN
	 Ih1OTvy4C1p9CI4qBiwAnDZgKgt+O8ygVkfzdViBbs0asgF0d5hWCupdFt5paGADEx
	 V9T4Oze+82m8QKtByuaMyBtVNqxU1VrHj4GGzqr6OnSG40sApZAHDFrdpxLASqHmnh
	 g3yqpZ5aO/ZIA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 211E1391B19C;
	Thu,  5 Nov 2026 21:37:35 +0000 (UTC)
Subject: Re: [GIT PULL] MM hotfixes for 7.4-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261104201408.90579e9988fe725faf3ad859@linux-foundation.org>
References: <20261104201408.90579e9988fe725faf3ad859@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261104201408.90579e9988fe725faf3ad859@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-11-04-20-02
X-PR-Tracked-Commit-Id: 19eab4cf787c917bfb7615460933e4ae894af65b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: afd661f6a26438c407bd9928ea16e80c14b121d9
Message-Id: <179391465378.190890.6119698743174134267.pr-tracker-bot@kernel.org>
Date: Thu, 05 Nov 2026 21:37:33 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org, David Hildenbrand <david@kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Wed, 4 Nov 2026 20:14:08 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-11-04-20-02

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/afd661f6a26438c407bd9928ea16e80c14b121d9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
