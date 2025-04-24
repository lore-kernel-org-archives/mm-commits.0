Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6221DE2BF
	for <mm-commits@vger.kernel.org>; Thu, 24 Apr 2025 06:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745476991; cv=none; b=EmnZZl+ueFypHeVhwiitogRcTw2Q8fnZ0AqI+rk8XngOoM5oJVG99RoRUt+Bld0vNBYw5pbjbE8bgEZGa9iNDVdtg6sFlFWACE/xOfMP0ODtKTsyOHLURa5vtjInHKf8UR2q4jbv96Qz0DsyWWTUW7kyeIxc4bJ9Ks6UeJJvFaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745476991; c=relaxed/simple;
	bh=3Vlc3ALXovDu1EiBZKw2RpsaCjSPa7LK1eXw5QFMzo4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=enNsEWP+Lyf2lwKsenJq6hMc/5J+5ps8vCMvXtGrwJIrVVhwNqprUGc+dNv53KwLfSw0C67YZxU+NeHl8ToRRVhmaLD9P8yACfgz8uJtVufPbfNERlubQBqyGNsMtiQE2LJ006amw68KA+tCP2ePba32k9SM0HWkWvvRZF7ETVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mDxD3Cqq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mDxD3Cqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0A5C4CEE3;
	Thu, 24 Apr 2025 06:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745476991;
	bh=3Vlc3ALXovDu1EiBZKw2RpsaCjSPa7LK1eXw5QFMzo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDxD3CqqG+amxEfWpMSCn3dDUl1tf0GfpWFcX1JqnVguBppl9vJwNPTBH+fZTdrfq
	 beCIHfhgJq+gP1NIpfG/jgp8WE9i/WGdsTVV6NgwD+44Rjc+zwpQ1LbA75ccmSNlMT
	 pnj81rvC44tx9BeIjeBms5oYaNld2DlIN1i/UVig9xm1hjSpU5iE9f39TIcPsHjPQ/
	 Lon4oXKBnt4KkHGPTIRgIEK6oyiiPTVghWNkkVNfPAEMWRCc78vA0MVuPGiiVJ/9Gu
	 CrXxh7SNBfnvpJLfZ3nezw6tyF23Wt2wCgVGK2HkR43QS8vghRgOpc5zcBlJ+Y1a4t
	 sJfAXyke5T6Ng==
From: SeongJae Park <sj@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org,
	suhui@nfschina.com,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <kees@kernel.org>
Subject: Re: [withdrawn] mm-damon-sysfs-schemes-using-kmalloc_array-and-size_add.patch removed from -mm tree
Date: Wed, 23 Apr 2025 23:43:08 -0700
Message-Id: <20250424064308.50117-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <73691a8c-f5b5-4ae0-b3e9-55ac6f74b265@stanley.mountain>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 24 Apr 2025 09:00:52 +0300 Dan Carpenter <dan.carpenter@linaro.org> wrote:

> Let me add Justin to the CC list because there could be a way to make
> this work with a compiler extension.
> 
> On Wed, Apr 23, 2025 at 03:40:56PM -0700, SeongJae Park wrote:
> > Hi Andrew,
> > 
> > On Wed, 23 Apr 2025 15:21:09 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > 
> > > The quilt patch titled
> > >      Subject: mm/damon/sysfs-schemes: use kmalloc_array() and size_add()
> > > has been removed from the -mm tree.  Its filename was
> > >      mm-damon-sysfs-schemes-using-kmalloc_array-and-size_add.patch
> > > 
> > > This patch was dropped because it was withdrawn
> > > 
> > > ------------------------------------------------------
> > > From: Su Hui <suhui@nfschina.com>
> > > Subject: mm/damon/sysfs-schemes: use kmalloc_array() and size_add()
> > > Date: Mon, 21 Apr 2025 14:24:24 +0800
> > > 
> > > It's safer to use kmalloc_array() and size_add() because it can prevent
> > > possible overflow problem.
> > > 
> > > Link: https://lkml.kernel.org/r/20250421062423.740605-1-suhui@nfschina.com
> > > Signed-off-by: Su Hui <suhui@nfschina.com>
> > > Reviewed-by: SeongJae Park <sj@kernel.org>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > 
> > Dan did mention "No need to change"[1], but I think that means this patch needs
> > no additional change, and hence nobody really asked withdrawal of this patch.
> > 
> > Cc-ing Dan and Christophe to make it clear.  Please let me know if I'm
> > misunderstanindg something.
> > 
> > [1] https://lore.kernel.org/all/fd372c23-1bf7-4c93-a51d-ba5dad255b04@stanley.mountain/
> 
> The patch isn't necessary.

Thank you, I understand that you are asking to withdraw this patch.  I have no
objection to that.


Thanks,
SJ

[...]
