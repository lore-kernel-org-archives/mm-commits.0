Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2652417D9;
	Tue, 10 Jun 2025 17:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749576769; cv=none; b=fYWBghfJGRqM1i0igJvb/R9fdPQ/4yq1j86SNb28lnVJzkRcoeOffLsvPtpgTjNrUf9pnRdZTUEjydIcwsJUqnw1F8pMpnCnjce/VrD4KDxCEzoCni3mn1a5okqtRDB2/jf/tUHSNX71GxXMVCMwWyAhFPPUqRoULqvMwOlHIRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749576769; c=relaxed/simple;
	bh=PgkRU+KCBkI+XzQziOXb6DzO3cpNep+Sp6LYIGtiV+0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f4GH7rLax/fT3Wbna0iySut84YuDwX13wK1iBvOTQInQSeVMmGrv3O9KhX05+IbbHe5QhSlzz1JZ3c+72So6LQ4tvuaeUZdAogKLsnZgp/K8P+MvT2lk6lgcyQrY84eHdJ7so5Nmm01/3OvnO0+I++I+Fx7zgFUpS1vDfbJgjKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=drF6Gd2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="drF6Gd2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADB5C4CEED;
	Tue, 10 Jun 2025 17:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749576768;
	bh=PgkRU+KCBkI+XzQziOXb6DzO3cpNep+Sp6LYIGtiV+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drF6Gd2sEfG8BiufOAsQnmv1sX01/65+PUu+FOJDUx+js/ihAbH6E8KnfyfvfJ9y3
	 psk0xRAqayoj8r1CvZciQ3jQdPm8YdzkbxJ4GCyrj+pYfeDGY5Znyu7YNGRn71TgSF
	 9QY+Bf446FDYKvcNvU26meC2saSywHjGD8M+E9bxrJl7y4b15v5WJ41bGNVmD/NMm9
	 Qok7M74P2+pvbkJkG26XfJVQwaiwHhQQ3mmp3N5PoCJTNZEtyS+t2FLbiiPOgO+pB0
	 1oyAy1qO8N03/BtqK6E6PiGnRuGnkAjmYFjQmdhsZJFDXox88RcgScA74g0Sq5VBxQ
	 jD6hVz6Brw8NA==
From: SeongJae Park <sj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Honggyu Kim <honggyu.kim@sk.com>,
	linux-mm@kvack.org,
	mm-commits@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Additional MM updates for 6.16-rc1
Date: Tue, 10 Jun 2025 10:32:28 -0700
Message-Id: <20250610173228.49109-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CAHk-=wgXTJo5G7e1cQxetFLbqbTUfP7Nfzt7-C89FjUHo1J9cA@mail.gmail.com>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 10 Jun 2025 10:27:46 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 10 Jun 2025 at 09:41, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >
> > Just revert the commit?
> 
> Yes. We don't do "default y" for random features.
> 
> EVERY SINGLE DEVELOPER thinks that *their* feature is so important
> that everybody else should enable it.
> 
> And if that feature wasn't enabled before, they are completely wrong
> 99% of the time.
> 
> There is a very real reason why 'default' defaults to 'n'.
> 
> So we do *not* use "default y" for features that aren't universal.
> 
> The only time we should use 'default y' is if some old feature that
> used to be unconditional gets split up into a new Kconfig variable and
> not using 'default y' means that people *lose* functionality.
> 
> Or if the feature is some critical security thing, or is some hardware
> thing that has become so universal that you find it on basically every
> single machine.
> 
> Or if that feature cures cancer or brings world peace.
> 
> Then you can enable it by default.
> 
> I have reverted that 'default y' thing, because I see no reason to
> believe that DAEMON cures cancer.

Makes sense, and thank you for explaining these all.  I will keep thse in my
mind to avoid making same mistakes in future.


Thanks,
SJ

[...]
