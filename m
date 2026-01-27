Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64F2320A34
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 18:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769538798; cv=none; b=YKRJ+TQ6mdlrheXk6adxpSALIjIUUgUJAqd+f2tx7/eLfLvYK/KZdR/ZS0avp6mxtLeVljB1V0jtygNNELSrGbvny8rqx5cqR8pGKFfx6+skTvtUzvU1kIrwuO2xlswqzBCqVmDgY1B2WPLl39wAXBIQCGpIelecWH9GsMTaZQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769538798; c=relaxed/simple;
	bh=JbB3uNYviokFX2rnvfBzyFLBPbMFtqmdBRLwU7zKVio=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=er9vyhN+h8XSzFkLsOE2eYWZDXPnW41Wni3yA7ey2prb5l5hYdIWctvyJWh0Ux36rviF3H1iofv+FtSUQ14xhkZj58dzuX0SbJl5huqEkuAAv13P9S09pY1hZ0ArOcqf0CrVCTvEBsyfuGwwZFfYWOPLHBo9KAOS9078BQSeTIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kNp3UKx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kNp3UKx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8430C2BC87;
	Tue, 27 Jan 2026 18:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769538798;
	bh=JbB3uNYviokFX2rnvfBzyFLBPbMFtqmdBRLwU7zKVio=;
	h=From:To:Subject:In-Reply-To:References:Date:From;
	b=kNp3UKx0La/8NmlKdtev408h3At7VcXWuQYDrdsEevP0Uk9bn2sRrvPfu7dIL0B/u
	 MIi5Lnwia1cTVXq0+PiiOvtuQhfJQbYqYw2ddgjyXN0n30fMgI2qpf+TRQdGaaorxx
	 ldWtfw5tQgDLKu4CNTj4h1WxlqCvm8xcilJNNK0RWqJxgsYOhCzKjmeuDGIf7340CC
	 DHn/jqAT2clohmoqFqEr4MD7pcyZHuGgZHVNG8VW/QFB4QqNPaREI8OPIZkFgDtT58
	 KJWx4Xo+uvpIPZgRewUqxRGqWCcpcEjiOYmifr2sC8yJmat6zZBf1yZu1pc69JD0pJ
	 t/zfl7SAZmMVQ==
From: Thomas Gleixner <tglx@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 usama.anjum@collabora.com, shuah@kernel.org, peterz@infradead.org,
 ndesaulniers@google.com, nathan@kernel.org, morbo@google.com,
 mingo@redhat.com, justinstitt@google.com, edliaw@google.com,
 dvhart@infradead.org, dave@stgolabs.net, colin.i.king@gmail.com,
 bigeasy@linutronix.de, andrealmeid@igalia.com, ywen.chen@foxmail.com,
 akpm@linux-foundation.org
Subject: Re: + selftests-futex-fix-the-failed-futex_requeue-test-issue.patch
 added to mm-nonmm-unstable branch
In-Reply-To: <20260126195016.AE9B7C116C6@smtp.kernel.org>
References: <20260126195016.AE9B7C116C6@smtp.kernel.org>
Date: Tue, 27 Jan 2026 19:33:14 +0100
Message-ID: <874io6c3dh.ffs@tglx>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Jan 26 2026 at 11:50, Andrew Morton wrote:
> The patch titled
>      Subject: selftests/futex: fix the failed futex_requeue test issue
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      selftests-futex-fix-the-failed-futex_requeue-test-issue.patch

NAK.

That's a horrible hack and I have no idea why you insist on collecting
and merging unreviewed garbage from the mailing list within less than 24
hours.

Yours grumpy

      tglx
