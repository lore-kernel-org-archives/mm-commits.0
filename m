Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9EB16D307
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 18:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714155680; cv=none; b=qvbUmMPT7/2QOATwdjCgTs1uewck7KVuhfJg9k91sxDjEAWEt3WDpKsyTw+It5imyFlcx8ObNovcY+xx2XSCqkUU2Lv2oyBLbBosg87Z7CgMSeHTysxXvThi9mOHMaVLxT/R2XLFbL5GqrP/gU4vVVzSskNbOnR0yF+EncypvjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714155680; c=relaxed/simple;
	bh=MK1t4K60jOapiUlungJvWGjqk1078mSvH9XoQjiL/Zo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ilQ0fkMV/J3mJXKkA8TOSIKpq1HxJjvdRvKcg/619kSVWhIuNtd9uciu3S+pAEnysB/SZihgsshr4KWY9ErwrOlI+Go5U6ksKtVHmIjpa5sDzRxK6sSxgao1vNCplyLUGgZmSsmoZgoZU98m14sZYuriWkJV2Y0RGcOSqirvAWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pp6KtVjl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pp6KtVjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F246BC113CD;
	Fri, 26 Apr 2024 18:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714155679;
	bh=MK1t4K60jOapiUlungJvWGjqk1078mSvH9XoQjiL/Zo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Pp6KtVjl1Scr38065ISEQF8EiJZTKh/LeRTI+fPDIlow0CStoWe0w+Hep4kwk7vYm
	 4+2FELZYKLDB4+qyFI9tiTehcD1Exyg4CiGF8kX6crlRgfjjAQB+wCHXUZ/Fk/YW6k
	 q1hO2J7AHsmGWMdPCRtBenaBkmWG0Vp0g95EgjNE=
Date: Fri, 26 Apr 2024 11:21:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: mm-commits@vger.kernel.org, wintera@linux.ibm.com,
 twinkler@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com,
 borntraeger@linux.ibm.com, arnd@arndb.de, agordeev@linux.ibm.com,
 nathan@kernel.org
Subject: Re: [merged mm-nonmm-stable]
 s390-netiucv-remove-function-pointer-cast.patch removed from -mm tree
Message-Id: <20240426112118.7d5283428eb07389fc6539cf@linux-foundation.org>
In-Reply-To: <20240426081005.8950-C-hca@linux.ibm.com>
References: <20240426040814.160C2C113CD@smtp.kernel.org>
	<20240426081005.8950-C-hca@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 Apr 2024 10:10:05 +0200 Heiko Carstens <hca@linux.ibm.com> wrote:

> >  drivers/s390/net/netiucv.c |   14 ++++++--------
> >  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> And this one should be dropped as well.

Thanks, I dropped all three.
