Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E675C9A
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 05:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705989571; cv=none; b=EgyhMFyPvdPWKdeB2XAMkmtcdZ7ictMSWlvdKBc+ncb7nt3b4ojhVRnfzYVm2cru/8QVxVlMfpI86UgO8DMooggOLyccxpFI7KOUXNtzOy32Nk+FQ2a0Kok5ABWKLEfI11JA9yN9w8SkwDqvkPhGm6shUCFTlStTe6YvdbGQNB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705989571; c=relaxed/simple;
	bh=XKhtStTwrkeN73Ke1WusGIAOfzoz3vQcPJekDWhwavM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rHBoqE2VU9QNwhEVrw2bH7ZXIbRuCwAx/HSI24zZ3OKAiDqoVvhL8Fe3NTZTGK+Uuq/+6sqrXO7equHsGDFtihrfmE1fDgYldvU+Sa78EKsFbP/bV4Ol8IAoSDmItGrpYMqxODr0rh4uBUhie0FCAbvKeZhQibuCBrtAT0tcZRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=azeAANUO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="azeAANUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711B9C433F1;
	Tue, 23 Jan 2024 05:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705989571;
	bh=XKhtStTwrkeN73Ke1WusGIAOfzoz3vQcPJekDWhwavM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azeAANUOHWl90Ukb3PEBtjJmyuNa1M8q5gqjX2xyvm7cSf6oFCMFyI/c8ZzBvUHv2
	 CsMRxkF+cKB6IopBd6Q46yE4A+CT1eeclQBv/KwqDzuxDjsY+akDO0e8lR0d2HdQDv
	 geHSDgFoItTrQTKj1wPSSAoVC1BfOdSl+Mqbj3x2Iv2Is/cNz/TNwPWXky7ljTGz+R
	 xEwxTlDOuzDf9GFOO67pmcnjwLPpc0uZ9ZKmqeIrcT9uQr1MD6mHg5lmoIAHyJybWF
	 Br01VGbvuk+bgNsv2mEaj9/8BXTcNgwdXWf0k1F50qtcX7hOlJtPXLcFnmdK0WelMo
	 tR9U2kgJRLIiQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	piliu@redhat.com,
	hbathini@linux.ibm.com,
	ebiederm@xmission.com,
	bhe@redhat.com
Subject: Re: + crash-remove-dependency-of-fa_dump-on-crash_dump.patch added to mm-unstable branch
Date: Mon, 22 Jan 2024 21:59:28 -0800
Message-Id: <20240123055928.472239-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240123004403.54547C43394@smtp.kernel.org>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Andrew,

On Mon, 22 Jan 2024 16:44:00 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> The patch titled
>      Subject: crash: remove dependency of FA_DUMP on CRASH_DUMP
> has been added to the -mm mm-unstable branch.  Its filename is
>      crash-remove-dependency-of-fa_dump-on-crash_dump.patch
[...]
> 
> ------------------------------------------------------
> From: Baoquan He <bhe@redhat.com>
> Subject: crash: remove dependency of FA_DUMP on CRASH_DUMP
> Date: Fri, 19 Jan 2024 22:52:30 +0800
> 
[...]
> To remove the dependency of FA_DUMP on CRASH_DUMP to avoid confusion,
> rename kernel/crash_dump.c to kernel/elfcorehdr.c,
[...]
> 
> Link: https://lkml.kernel.org/r/20240119145241.769622-4-bhe@redhat.com

I confirmed the original patch is making the above mentioned file renaming.

> Signed-off-by: Baoquan He <bhe@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Hari Bathini <hbathini@linux.ibm.com>
> Cc: Pingfan Liu <piliu@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/powerpc/Kconfig    |    1 -
>  kernel/Makefile         |    3 +--
>  kernel/kexec_internal.h |    2 ++
>  3 files changed, 3 insertions(+), 3 deletions(-)

However, seems the renaming change has mistakenly not took here.  Apparently
for the reason, I'm getting below build warning on mm-unstable tree after this
patch.

    make[4]: *** No rule to make target 'kernel/elfcorehdr.o', needed by 'kernel/built-in.a'.  Stop.

I confirmed the build error is disappeared after I manually rename the source
file.


Thanks,
SJ

[...]
