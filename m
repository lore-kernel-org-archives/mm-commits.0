Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176AC1E501E
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 19:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725477528; cv=none; b=r3DxTjNsiY85FvX9J4ozSjaxJStJcYsvK41RFdW7frmkeQbGU6VmDlMs/XUHXRgYZJIR5ndj7K3iwIfYlmE0ZrvJ4mSabpbHPKl38oglXj3uaaYneDSTocxZdB/rU/jnkOV+QJ1KGfxsowxily3TcZMjzY0s0dmtfVYAjNrbIso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725477528; c=relaxed/simple;
	bh=/CeTxrvjHjB7BwL+rHU35QH+SScvpNdgUTJ9w/o/yN4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=nyiweVfrPuZjGKqjx6w7TBUqAP1FG1C+jhelmCqVMH3mRLDgLomJPmpSbU36N5d8xzCLy8Z0GDSrc24afUy0/JPo3CxCxWlsE5E+r1mxEBAi2zujh1QZXKdXvSPbSGv58FzSYbV7PkteEL9b1jJ1r6J4lCZnRQtkJGjZBtecxhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=znIlzd7j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="znIlzd7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59089C4CEC8;
	Wed,  4 Sep 2024 19:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725477527;
	bh=/CeTxrvjHjB7BwL+rHU35QH+SScvpNdgUTJ9w/o/yN4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=znIlzd7jd1nvdHBWL+TNNBFn/qF3+KZaC+cWgDSTM95Zs9XH+lOAhTON5LDuJ43JQ
	 zmAYQIqxKDMmYX49qhlVr38yzvnfsKPx1kg85+nXhw+Qh16XQ6ninrueMPdw67+Hju
	 H5gs9LXzXgW9Fi7wZd5AbwJrL36RDEXQsJLyBwW0=
Date: Wed, 4 Sep 2024 12:18:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, ojeda@kernel.org,
 mmaurer@google.com, glider@google.com, elver@google.com,
 dvyukov@google.com, andreyknvl@gmail.com
Subject: Re: [merged mm-stable] kasan-simplify-and-clarify-makefile.patch
 removed from -mm tree
Message-Id: <20240904121847.45c0977db4c0c97b6b06120d@linux-foundation.org>
In-Reply-To: <CANiq72k=mzebBFfAW2iJ-cWYTVYBDoR5XzYWZ+Crn-tq2YfnLQ@mail.gmail.com>
References: <20240904041800.486C6C4CEC2@smtp.kernel.org>
	<CANiq72k=mzebBFfAW2iJ-cWYTVYBDoR5XzYWZ+Crn-tq2YfnLQ@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, 4 Sep 2024 11:59:06 +0200 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:

> Hi Andrew,
> 
> On Wed, Sep 4, 2024 at 6:18 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > The quilt patch titled
> >      Subject: kasan: simplify and clarify Makefile
> > has been removed from the -mm tree.  Its filename was
> >      kasan-simplify-and-clarify-makefile.patch
> >
> > This patch was dropped because it was merged into the mm-stable branch
> > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> I think we were taking this one through the Rust tree so that we could
> merge the Rust KASAN support through there (and handle the other
> interdependencies we have this cycle), right?

That's what I thought but after more than two weeks it still wasn't in
linux-next so I assumed it had been forgotten, or that plans changed.

> I will apply those very soon (in case you moved it into mm-stable
> because you didn't see it in linux-next).

OK thanks.  I expect Stephen will notify us when there's a duplicate
patch.  As long as the two patches are identical code changes, git will
sort it out when we merge with Linus.  Otherwise I'll drop the mm.git
copy.

