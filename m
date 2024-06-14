Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E401A0AE3
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 17:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718386316; cv=none; b=ftk5osL+iJ+6KejXJvmQ6+8N4tlwu8FpAmSWKQRxzrrx8KSqzT1w2exoxEBra+1dcdTaLkxKys+ic1NtdiOz62dPymJGUDmopTF6xygv6FGi0S0kd6rCa700zDM5MgPIYwV9nLQw8hXJwHTztcrumT6Dl/B9aBImyBOxixpTb14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718386316; c=relaxed/simple;
	bh=tKiWNDjrDEMuc8AlOT36JPR1/exYSFUeKEhzSKNjUBo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=iiNQUeJJgkfma57aVRgqJfcR3TtLSmKd2Hxx5opK0eDsofziHCPppEoecMTNRmEjZ1Lzx2QcUGHjHqy2jem45IOx+FTfmwOCqGIpgTTqj+OJSi/AgURDfN8ClBrUtRmCQ2ppsMLEPMslPd974WhMeMbTEPhwmiT1cnMafSujhmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sGt3pNpQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sGt3pNpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D69C2BD10;
	Fri, 14 Jun 2024 17:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718386315;
	bh=tKiWNDjrDEMuc8AlOT36JPR1/exYSFUeKEhzSKNjUBo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sGt3pNpQYc0yQlbty+M8maUpiX53IwIFEPTGj7KKLkm16RIQ8moQ5P6yKyQ5AAUTD
	 YvCTrXg0VagnqStRjF8jvt0adqqFSSLCPfhQPRmEEWtqYK72Xrn0rRZ3Zw6mFEpsvD
	 AQMRg+m13mHZbTEJmwz9ObPE3XIx76uHSVlcnLzM=
Date: Fri, 14 Jun 2024 10:31:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Xu <jeffxu@chromium.org>
Cc: mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject: Re: +
 mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3.patch added to
 mm-hotfixes-unstable branch
Message-Id: <20240614103154.2dea6d48dfbbb2e1328acc9f@linux-foundation.org>
In-Reply-To: <CABi2SkW4eg27XTe6otutK8P1MgK0MMnLdwWAuEDks98_aZku=Q@mail.gmail.com>
References: <20240612192325.009E0C116B1@smtp.kernel.org>
	<CABi2SkW4eg27XTe6otutK8P1MgK0MMnLdwWAuEDks98_aZku=Q@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Jun 2024 07:32:07 -0700 Jeff Xu <jeffxu@chromium.org> wrote:

> Hi Andrew,
> 
> By fixing the document, the usage of MFD_NOEXEC_SEAL shall be clear.
> Was the previous patch (which  changed ABI)  removed from unstable ?
> 
> I pulled the mm-unstable this morning, it seems that patch is still here.
> I'm not sure about the process of reverting it, hence asking.
> 
> c1e11be9abae86ebe5cecc42abc412f61ae563c6
>  memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALING`
> 

I'm not completely sure what you're asking here.

Please try not to use terms like "the previous patch".  There are a lot
of patches!

I *think* you're saying that the patch "mm/memfd: add documentation for
MFD_NOEXEC_SEAL MFD_EXEC" (and its two fixups) are tied to the patch
"memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALING`".

If so then this escaped me and I shall rearrange the grouping to be
more logical.

The base patch "memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALING`" is in mm-unstable but I need to revisit the discussion to see whether we should be proceeding with it.  Any guidance you can offer here will be helpful.


Or I've totally misunderstood everything.  Please explain the entire
situation more thoroughly.

