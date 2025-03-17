Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9BD42C0B
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 06:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742192678; cv=none; b=FvrmBVfAMzBwxTvQl98r73sovcBVAa5rjq8jczPZAnTy9qATod9LI2eiadK4SP8q32aF6s0OQu17yNClRyG5M/GTWXkoF7UQUvAi6KDnev4op7V/2c8TjhGSHtjDB0VS2HsJsDs+iQeTdzDvVMbdXDbnfFj0xjT9MyYcuwDHzF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742192678; c=relaxed/simple;
	bh=g/lHrLY0KSNitbZmBfHQ0QpJOlyfwZQmZ64VWuShdcI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=vAEEbgME6jAKNyarBJIX0QLxfp1ukR7614U/PPLus7QP3V3f/6nHDjFv4BKvvyC+vCWND5CXJlFwy9yxGfskuGSlwX03/kz65w2CaO7DW2E/flik2IVZ4sMRsvTFmyvZgCM0lvTuCYj1XHWbpEKiFX+LTb8XRk6gas/VvedIrmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TrGf8woX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TrGf8woX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FCEC4CEE3;
	Mon, 17 Mar 2025 06:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742192678;
	bh=g/lHrLY0KSNitbZmBfHQ0QpJOlyfwZQmZ64VWuShdcI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TrGf8woXV1PkETwrRIEq1bZAhRMaFwUmCWOQIijPuNElGAp5mTk+1x4Uh93SqtGTQ
	 w4qak6Vj+GeLiuMkTVyRvy/9Iu4B0j/tQpIt3u6Qe+Me74brPQ1RNwE3o3PS7OYDLe
	 khfTaJ1/paf0mWBPmEBr4Oq+PXLUmBDqmQDnybfc=
Date: Sun, 16 Mar 2025 23:24:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: mm-commits@vger.kernel.org, tmgross@umich.edu, ojeda@kernel.org,
 lukas.bulwahn@gmail.com, gary@garyguo.net, dwaipayanray1@gmail.com,
 charmitro@posteo.net, boqun.feng@gmail.com, bjorn3_gh@protonmail.com,
 benno.lossin@proton.me, apw@canonical.com, aliceryhl@google.com,
 alex.gaynor@gmail.com, a.hindborg@kernel.org, kurti@invicto.ai
Subject: Re: [merged mm-nonmm-stable]
 checkpatch-add-warning-for-pr_-and-dev_-macros-without-a-trailing-newline.patch
 removed from -mm tree
Message-Id: <20250316232437.573da548b70c0cb2f3ad618f@linux-foundation.org>
In-Reply-To: <638fa6836e1959ba42cac78125568b242e601f73.camel@perches.com>
References: <20250317053150.5115AC4CEEC@smtp.kernel.org>
	<f150abf3659e151b29a2529b266d519465b7345d.camel@perches.com>
	<20250316230922.9d2e6c8c36fb1934ca854ced@linux-foundation.org>
	<638fa6836e1959ba42cac78125568b242e601f73.camel@perches.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 16 Mar 2025 23:12:06 -0700 Joe Perches <joe@perches.com> wrote:

> On Sun, 2025-03-16 at 23:09 -0700, Andrew Morton wrote:
> > On Sun, 16 Mar 2025 22:51:53 -0700 Joe Perches <joe@perches.com> wrote:
> > 
> > > > One false warning that will be generated due to this change is in case we
> > > > have a patch that modifies a `pr_* call without a newline` which has a
> > > > pr_cont with a newline following it.  In this case there will be a warning
> > > > but because the patch does not include the following pr_cont it will warn
> > > > there is nothing creating a newline.  I have modified the warning to be
> > > > softer due to this known problem.
> > > 
> > > I think this patch is a merely a conversion of one defect for another
> > > and it's quite compilcated code too.
> > 
> > Well darn, it would have been nice to receive this review during the
> > review!
> > 
> > Should I drop the patch?
> 
> I don't think it's particularly valuable or useful. 

OK, thanks, I dropped the patch.
