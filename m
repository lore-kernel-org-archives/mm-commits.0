Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E074412E61
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 23:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718409165; cv=none; b=S62qr74Bqs8gqMnMMrRyuuDyckEufPHCe9voMhf9FHk6qnLNIx2yxVnU7xpL3151uOjEI/U5DZnb2PoRQxLNtmD1+SXxhR7xz4zZFz8zoKn135f75TGJlKZegW3EkM6lGpNpbJ7xKgv3aa9TRgO/MavnLqlvtwxK+YOpQ6fCW18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718409165; c=relaxed/simple;
	bh=Nml8nxrftjgsmtLa+MQQSndJD1knkoOqUq6h3PeBW+w=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ldA3bCdFP+7xZvpCjJegCHUDcU4t38/UHuUgOOMCX4W62LySCzv+HbKVsIONzREG6RJAbvR5VFn3pTvScP2pFSkh5ET4YtaFetmXpGLzvZvtQL29vx64Ce7I1l+CoEIkDMRKgF88DCHtIuN9CLJKb2PZp0mgfKOXBn7QUwG/Vmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AHvSirQ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AHvSirQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10664C2BD10;
	Fri, 14 Jun 2024 23:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718409164;
	bh=Nml8nxrftjgsmtLa+MQQSndJD1knkoOqUq6h3PeBW+w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AHvSirQ7geAxxGg93eYYggyoC12D6SQjZLJ3BcwF8coMc4AccdJP15rhAiPsr99Ln
	 TMdNjC5x8pwJ7ydvNV6LCWmkIqKbR5g7tTH5lu5PhdosBW0NIglbzud+mQuNilZtVA
	 N4eN546Eb38DM6E9ypZ3cKXKMTXBUx4EKDKEV60E=
Date: Fri, 14 Jun 2024 16:52:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?B?QmFybmFiw6FzIFDFkWN6ZQ==?= <pobrn@protonmail.com>
Cc: mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
 keescook@chromium.org, jorgelo@chromium.org, jeffxu@google.com,
 hughd@google.com, dverkamp@chromium.org, dmitry.torokhov@gmail.com,
 david@readahead.eu
Subject: Re: [nacked]
 memfd-mfd_noexec_seal-should-not-imply-mfd_allow_sealing.patch removed from
 -mm tree
Message-Id: <20240614165242.f9d89f9a5711cffc5e0b0f77@linux-foundation.org>
In-Reply-To: <qdcD-qU2Jfk6ImGOIaV4sWrbTZcHj44hNr454b2pd_SV8t4Bu1mnjsWXfYgW-c7tFW7bQowMRaKysMVcmWvGvUW3O20py_2H1jd7kNGT62Y=@protonmail.com>
References: <20240614182715.12694C2BD10@smtp.kernel.org>
	<qdcD-qU2Jfk6ImGOIaV4sWrbTZcHj44hNr454b2pd_SV8t4Bu1mnjsWXfYgW-c7tFW7bQowMRaKysMVcmWvGvUW3O20py_2H1jd7kNGT62Y=@protonmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, 14 Jun 2024 20:00:02 +0000 Barnabás Pőcze <pobrn@protonmail.com> wrote:

> 2024. június 14., péntek 20:27 keltezéssel, Andrew Morton <akpm@linux-foundation.org> írta:
> 
> > The quilt patch titled
> >      Subject: memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALING`
> > has been removed from the -mm tree.  Its filename was
> >      memfd-mfd_noexec_seal-should-not-imply-mfd_allow_sealing.patch
> > 
> > This patch was dropped because it was nacked
> 
> Hi Andrew,
> 
> do I gather it correctly that this is the final decision, and there is not much
> willingness to try to remove this quirk of the `memfd_create()`? As far as I can tell,
> the change was in linux-next for some time, did that uncover any problems? (If so,
> I haven't been notified.)
> 
> Anyways, I believe I have laid out my arguments already, so I won't repeat them here,
> and if this is final, then I will stop wasting everyone's time with further emails. :-)

We do appear to be stuck.

Please feel free to pursue this.  Reissue the patch with an updated
changelog which addresses the various issues which have been raised
thus far and let's reexamine.

