Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FF3238166;
	Mon, 16 Mar 2026 19:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773688648; cv=none; b=ZdVTAxzzu4Oxjn8Jy5CwDhstWrWslXdh8pbJxK7RW1PzJNsMabdIKTBXG4JyyiRkaGx8jCellpAKdh7Jb+xogrynwni09pY8wBPxPuljXq747LhHwkbIUoHEpoh3Ahs1Q+N18pCQYBnYpePyqgHkz5gSsGCpXx7DnphcKrW7lrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773688648; c=relaxed/simple;
	bh=Mcl7mrfaevdnL+TnJ+uRqetMxeqPaZ97LeaI3YnhJsA=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=IvXeCnKmMuT9T2Sfiq70xdHciRkIb8zWy4fXly9cRkc7iUTRTjSVBEn+a9pPrK+ftQhH5/ykjNfY0YTLUwHjI5OObYJMmoFYUnOWH/aZinXf3eA0Dn4Vbzu0peeYTTt4QnIXma2rgImgS0/QrlQ0J2id8EJR2gy9Lb9D3av+Q0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gGNOiEke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gGNOiEke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3950AC19421;
	Mon, 16 Mar 2026 19:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773688648;
	bh=Mcl7mrfaevdnL+TnJ+uRqetMxeqPaZ97LeaI3YnhJsA=;
	h=Date:From:To:Cc:Subject:From;
	b=gGNOiEkeJkDyjYOrxgQw3qo+ZNF2CX4D4ZuiSivjHU065nWXNtEIO9J1aqia5Qpea
	 V5fGXfk3lc0jdgtH2HTAce+HHHZyOQPKjdAcNspncbwbBOlRbF+B9MRbDVw8VGWb8Q
	 aSeoDv91blV37x+jiEFWL6zsnVPcViJosmTQ+cMc=
Date: Mon, 16 Mar 2026 12:17:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.0-rc5
Message-Id: <20260316121727.54468f0e01ca280c17f2b735@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit b4f0dd314b39ea154f62f3bd3115ed0470f9f71e:

  Merge tag 'mm-hotfixes-stable-2026-03-09-16-36' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2026-03-10 12:47:56 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-16-12-15

for you to fetch changes up to 182b9b3d8d1d36500f58e4f3dc82b144d6487bdf:

  MAINTAINERS: update email address for Ignat Korchagin (2026-03-10 16:01:49 -0700)

----------------------------------------------------------------
6 hotfixes.  4 are cc:stable.  3 are for MM.

All are singletons - please see the changelogs for details.

----------------------------------------------------------------
Chris Down (1):
      mm/huge_memory: fix use of NULL folio in move_pages_huge_pmd()

Dev Jain (1):
      mm/rmap: fix incorrect pte restoration for lazyfree folios

Ignat Korchagin (1):
      MAINTAINERS: update email address for Ignat Korchagin

Randy Dunlap (1):
      build_bug.h: correct function parameters names in kernel-doc

Thorsten Blum (1):
      crash_dump: don't log dm-crypt key bytes in read_key_from_user_keying

Wei Yang (1):
      mm/huge_memory: fix early failure try_to_migrate() when split huge pmd for shared THP

 .mailmap                     |  1 +
 MAINTAINERS                  |  8 ++++----
 include/linux/build_bug.h    |  4 +++-
 kernel/crash_dump_dm_crypt.c |  4 ++--
 mm/huge_memory.c             |  3 ++-
 mm/rmap.c                    | 21 +++++++++++++++++----
 6 files changed, 29 insertions(+), 12 deletions(-)

