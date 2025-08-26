Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A005130CD94
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 23:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756251090; cv=none; b=gGfu+ZfH4rZizit04voVpXpm8L/9wHFdy+nwk2LVZCRB0oe/P1rRwebJVfx1N1MSO0XhQ8OkFzsH7EOnOhfbYWdNoPCj2CUHaZnQQgUh4kZ4dqrcRCHPJcJA6argjbFJQLVqdigwLdaBBuQPCVUJicEFH8g52wptAvT0nw2HQrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756251090; c=relaxed/simple;
	bh=NOh3QvU6kTtSjniQZWTO/oG6hjM1zK+l2FOaGM9AE4A=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=bsfoY9dC0ok8lP02uFHMmVNPdAI/RKgR5R7j0fQJP+NE2QSQJYiF+kWQoQdtE4KLTAdMgZhbGqPiHYeZqDr0fQAcpw1YiOvfeUn2BfQqJRgdgRoeojI15HvUwnYjJGXEvAQKOT2AFdvBr7NJwFRtDQ4mHx8v51F/vfLW9y7NgP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fpdnl3Vg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fpdnl3Vg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31C0C4CEF1;
	Tue, 26 Aug 2025 23:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756251090;
	bh=NOh3QvU6kTtSjniQZWTO/oG6hjM1zK+l2FOaGM9AE4A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Fpdnl3VghgvFg1FU1l1eSpcZbnOpG83GDPKc0IghebkBITao/ziFVNELmFKvYYGwx
	 FYXcfBJxAZb7INRurcHuS+Gflx7gNrqFmx+yQtB5Vmb7QyLfVBvYy8rfizqd043aHk
	 GORSVTNrIZHJXgSc/KmGJUVzQu2A0p31HeA7GXnQ=
Date: Tue, 26 Aug 2025 16:31:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: mm-commits@vger.kernel.org, rppt@kernel.org, graf@amazon.com,
 changyuanl@google.com, bhe@redhat.com, epetron@amazon.de
Subject: Re: + efi-support-booting-with-kexec-handover-kho.patch added to
 mm-hotfixes-unstable branch
Message-Id: <20250826163129.8324fd9a457f549a6bd63728@linux-foundation.org>
In-Reply-To: <CAMj1kXG8OhR4TE013TqhFjf__nWbiF17gjSJFEbODH9wKk1b3g@mail.gmail.com>
References: <20250821213034.0B05AC4CEEB@smtp.kernel.org>
	<CAMj1kXG8OhR4TE013TqhFjf__nWbiF17gjSJFEbODH9wKk1b3g@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 26 Aug 2025 14:55:59 +0200 Ard Biesheuvel <ardb@kernel.org> wrote:

> On Thu, 21 Aug 2025 at 23:30, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> >
> > The patch titled
> >      Subject: efi: support booting with kexec handover (KHO)
> > has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
> >      efi-support-booting-with-kexec-handover-kho.patch
> >
> 
> Please drop this patch. Once we agree on the right approach, I will
> take this via the EFI tree. Thanks.

This was part of a two-patch series.  You're saying we should split
that series apart?  That this patch has no interaction with [1/2]?
