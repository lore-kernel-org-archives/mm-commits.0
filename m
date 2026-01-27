Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BB325CC6C
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 07:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769497625; cv=none; b=Qp7tglQwAPGF727Ql1iQ5PQfE0s5wduiEmARLTnjsssNm6XlzMcnOMulWPkRyyBhm7p2Z7iOPEO/ZZrDPn8M1qx5df6V6cs0yUSyC3LVX6cxqjkDrRZgFsFjaYOezuMUhr9UDM99R3KnhFiwsig++AcdnRVPfsIjW7n/FJ8OF9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769497625; c=relaxed/simple;
	bh=60yYJaYdMAQNcr6oQn4pchj+IymjpoNeYF1NwpaBqxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UQOdVcO8BViF+4xFY7Fy1kxlceRnLGVghRA0AttbHYP1QZc0G05hr2xvxVKvvlcdXox4xRcI5033m/7NRuXhKHJKS38KBpyiCnMTDYpehFoQ+k/XQyHGq2r8BicMxfzUU624Vv8M0AWYqmZTn50yQ81jAtGvsuOd/HZyoktzeTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=zGuHi3dN; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=zrMOrWZl; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="zGuHi3dN";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="zrMOrWZl"
Date: Tue, 27 Jan 2026 08:07:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1769497622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ql+RqQMEQP+yq6zOTAvnFxyWCXVBT6mAJApo6HZsc2U=;
	b=zGuHi3dNLCZjWbXaplSpLr/0cHmeekBOHApUFy0q2AAjcAZlSUr2p4FEmgbuMje15LA4mK
	TFDhRa6l5cJDU2H4h24R7L+aO5RRxSFuRazHQeRLmooMQu5cpFIvsl7/GKfp0InbmYtG1f
	letKacmGjKvBQ+zEXRx5w6i2vK6Ft6FTUB4WvIEISxkLIJzLzCz2V8rfPXoELuiYRYw3U1
	vX+m/A2AAP6eMmcDwWQc65TPl08AHODCrmCRcPf33t4UujiN9IFQIRIyIoauDlZAPBL/m3
	KX8W4YuO1mvUzfV6HMN2zg3fNsK/uYl4BI8qXXsfmxThSYS0sTefsanHeBw/qQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1769497622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ql+RqQMEQP+yq6zOTAvnFxyWCXVBT6mAJApo6HZsc2U=;
	b=zrMOrWZl72tZ8GfVWT40dPWvUX/TnVFP6ZrK7O3c6DeHvfSYjDbMrp73bMqesZbduYiPkb
	OC3bHgS8NaUmLAAQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, usama.anjum@collabora.com,
	tglx@linutronix.de, shuah@kernel.org, peterz@infradead.org,
	ndesaulniers@google.com, nathan@kernel.org, morbo@google.com,
	mingo@redhat.com, justinstitt@google.com, edliaw@google.com,
	dvhart@infradead.org, dave@stgolabs.net, colin.i.king@gmail.com,
	andrealmeid@igalia.com, ywen.chen@foxmail.com
Subject: Re: + selftests-futex-fix-the-failed-futex_requeue-test-issue.patch
 added to mm-nonmm-unstable branch
Message-ID: <20260127070700.Kho5amle@linutronix.de>
References: <20260126195016.AE9B7C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260126195016.AE9B7C116C6@smtp.kernel.org>

On 2026-01-26 11:50:16 [-0800], Andrew Morton wrote:
>=20
> The patch titled
>      Subject: selftests/futex: fix the failed futex_requeue test issue
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      selftests-futex-fix-the-failed-futex_requeue-test-issue.patch
>=20
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/selftests-futex-fix-the-failed-futex_requeue-test-issue.patch
>=20
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>=20
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's

Please don't send it any further before someone acks it. It is on my
list for some time now=E2=80=A6

Sebastian
