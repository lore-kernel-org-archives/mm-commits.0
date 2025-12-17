Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361F222C32D
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 22:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766011113; cv=none; b=jiE5ghM1vV17cqvCdWWhNco0YCX7QBfPULIBlkmYoSXD0zU89Msf9z9idE9oeON20dDwZBu6dcRyEjoHKG9UP/bKDFCUNiIOJJ3NHDVUom2fZFna3p+/C1bqrm5lCgTpmMUBdOVPc3vC6kbfeuUfjRPI/qHo9k2i5leeAA0hT0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766011113; c=relaxed/simple;
	bh=aZ5M1/p3ZHgXlW57VLEvpPCxIzX1cIpoe5pS6PjB8FU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DsRdHmLx2oGaiR784Adm78XaMGJCsd53weTPkDzxwmhSeBMFmpTZ2gNr1LmGhnqsglsG44wBSwsrcPlblsasBvpTSZuY+fpbDMtixiiRpS4Gs27aAhkyADqEJrBaCZD4fdjC5YK9Am/6e6Iw9QC88OqxVuL3bomulKj8wYblwu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JYLY8W5C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JYLY8W5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C1BC4CEF5;
	Wed, 17 Dec 2025 22:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766011112;
	bh=aZ5M1/p3ZHgXlW57VLEvpPCxIzX1cIpoe5pS6PjB8FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYLY8W5CgmWvHpkb39ZIvqh45X2zZd5lIRH3UZXgrqbS9/cJziavyBhY/WWdGPkFf
	 rubtXStOJvhXrTEhtpBO5oL69C4HWG+EFqxAi4x85A4Wujwjyb0rzJio1g6WUG9mZF
	 v40FdoHNmbqUzhnOgnMxVrdY/k9jJTj2OcTMn6s/dmsfeTI2mQFfp/6zPOc2oEfBI+
	 1KApKplrhTqyS995n4zpg2HQA7dsot0gl6IHrqXnx/TI0JfZeNrLWYwwBAEbn7ivgB
	 0+PFpGveaz2B03mtILqadn+Rx79oSWAyQieiG0MB9bzcupH77zCKmW/rCW5xCRNIod
	 o7HmLaTuTiykQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	mm-commits@vger.kernel.org,
	klourencodev@gmail.com,
	kevin@desktop-mu90jgd.home
Subject: Re: + mm-damon-fix-typos-in-comments.patch added to mm-new branch
Date: Wed, 17 Dec 2025 14:38:28 -0800
Message-ID: <20251217223829.4124-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251217215140.18465C4CEF5@smtp.kernel.org>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello Andrew,

On Wed, 17 Dec 2025 13:51:39 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> The patch titled
>      Subject: mm/damon: fix typos in comments
> has been added to the -mm mm-new branch.  Its filename is
>      mm-damon-fix-typos-in-comments.patch

Thank you for picking this up quickly!

[...]
> ------------------------------------------------------
> From: kevin <kevin@desktop-mu90jgd.home>
> Subject: mm/damon: fix typos in comments
> Date: Wed, 17 Dec 2025 19:12:16 +0100
> 
> Correct minor spelling mistakes in several files under mm/damon.  No
> functional changes.
> 
> Link: https://lkml.kernel.org/r/20251217181216.47576-1-klourencodev@gmail.com
> Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>

But, as I noted on my reply [1] to the patch, shouldn't the above
Signed-off-by: and From: match?  And to my understanding, we need the author's
agreement at modifying such ones.  Correct me if I'm wrong.  If I'm not wrong,
could you please drop this at the moment and add back after Kevin clarifies
what should be used as the author's identity?

[1] https://lore.kernel.org/20251217222609.3355-1-sj@kernel.org

> Cc: SeongJae Park <sj@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


Thanks,
SJ

[...]
