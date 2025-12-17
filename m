Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C96730F546
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 22:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766011403; cv=none; b=Ny7UlDClihnADzdRl58EbhfgjlIw323BoSkpyzdRbd4Wz9YNw/20Cggyco+YDldh8UiNVQjQ9mPZV7AP2A1VaxjxqnNVi42gfYuls8rJY6sVQExk2MOg1iDte+x2pgJRxgWSgE74I5QO+/wS/8S28DYf9YW+zyjA/Fnju4kPspk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766011403; c=relaxed/simple;
	bh=RQ2X7N3k2HOaAgeTVkb0cOw3EujcZEi5eInrkU/Cr0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/CeZusHSCg96cstoumhs7/H43VBWWwS2gnzAp51MNEVRZ9YmUGJE7v9i0Rg9QLHLCgOOhOEY6Ok37CTR2bAep6HiZl52/w/64a4jNKBanhTX/OxqU5JTFXb+BuuVemWAWudIS8RczTyo4k4EncU/a43tzytdVoUfFGkcNNOazk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HkexzotH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HkexzotH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC2EC4CEF5;
	Wed, 17 Dec 2025 22:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766011402;
	bh=RQ2X7N3k2HOaAgeTVkb0cOw3EujcZEi5eInrkU/Cr0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HkexzotH35fPuBSDDbDQJJj8JYobJy1lJcJCpEsVHRLyJku8gx8YzvGDsGkCTbo3g
	 cWc9KO8SCKOOgWYaEAt0poy6r+VQb1pSOSMS2SpOhDqpqfhnkBRoqZpvLOfwCTFvK8
	 ZWBk1Hec66VnRhvDP487C9QUqTAQVi8Qycc509tQcun1ufEPQ1vgVrs1efIu4lHn/o
	 r2VGc7mkNOEn9+Lwh7dXoz9rn8cc3B+R9FmbZk5Paq/2fc0cUrDaWUZkz62lbQnAcJ
	 Dc8CEi75tzkC2iWxnCupj5QDZ+7gNDBCxqHvokDYaTDWczJvn/nh9SPIl6k+U3HSAI
	 fLfcyklTMqGog==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org,
	klourencodev@gmail.com,
	kevin@desktop-mu90jgd.home
Subject: Re: + mm-damon-fix-typos-in-comments.patch added to mm-new branch
Date: Wed, 17 Dec 2025 14:43:19 -0800
Message-ID: <20251217224319.4238-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251217223829.4124-1-sj@kernel.org>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 17 Dec 2025 14:38:28 -0800 SeongJae Park <sj@kernel.org> wrote:

> Hello Andrew,
> 
> On Wed, 17 Dec 2025 13:51:39 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > The patch titled
> >      Subject: mm/damon: fix typos in comments
> > has been added to the -mm mm-new branch.  Its filename is
> >      mm-damon-fix-typos-in-comments.patch
> 
> Thank you for picking this up quickly!
> 
> [...]
> > ------------------------------------------------------
> > From: kevin <kevin@desktop-mu90jgd.home>
> > Subject: mm/damon: fix typos in comments
> > Date: Wed, 17 Dec 2025 19:12:16 +0100
> > 
> > Correct minor spelling mistakes in several files under mm/damon.  No
> > functional changes.
> > 
> > Link: https://lkml.kernel.org/r/20251217181216.47576-1-klourencodev@gmail.com
> > Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
> 
> But, as I noted on my reply [1] to the patch, shouldn't the above
> Signed-off-by: and From: match?  And to my understanding, we need the author's
> agreement at modifying such ones.  Correct me if I'm wrong.  If I'm not wrong,
> could you please drop this at the moment and add back after Kevin clarifies
> what should be used as the author's identity?
> 
> [1] https://lore.kernel.org/20251217222609.3355-1-sj@kernel.org

Seems the above link is not working, since lore URLs are not working without
mailing list at the moment.  Please use
https://lore.kernel.org/damon/20251217222609.3355-1-sj@kernel.org
instead if you want to read it before the lore side issue is fixed.


Thanks,
SJ

[...]
