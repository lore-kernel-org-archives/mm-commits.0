Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788B41A9FBA
	for <mm-commits@vger.kernel.org>; Wed, 25 Mar 2026 18:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774464928; cv=none; b=R1iLbTCfZ8sqGxieUZCIPmdg/elLL9UVpvQ9HjPFLoNfAl7NuXzzaRMyNRfUXPI50H9IzH0O8fk+VmkSe5/YmvGWiGMsgG6nGJglN8meUqEYTQys3Ld8l96uSi5eoK+HCIft+c1ypSj2up8YYHT+16Bz0zaN5MewhZyxrph75mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774464928; c=relaxed/simple;
	bh=gCpgv71YAuPWYxlUpAKh5yR1pwL59q1mR4nx0JLXsB8=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=H18cGkk9K/GaxmL8OppL/NHB77Un9s7Nbui7bqdJ4ve0RFrXwB6CleMt9iOIyy/ctZBh0O/aNof/A7lemKCWsF3nFeP6D52oc9ZcKDs+e1T9afp6GcLrwbml+hB/nTZjvNV8UYV1H4k4Tc2qoH0rWR3QJ1R5M2B76wWVoBKDpJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pt/19dd8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pt/19dd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09435C4CEF7;
	Wed, 25 Mar 2026 18:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774464928;
	bh=gCpgv71YAuPWYxlUpAKh5yR1pwL59q1mR4nx0JLXsB8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pt/19dd8T1wENBBzaFHMGahgmVZedYhFHjRhQG6D7MN7P+zQX50qmizG+cAYvW/Fj
	 hFi+siJSXe+lUMhPM87Bknxdq4RKu1dcbXPGrzpvXUdoPZK4Sg2dB1GAZM5JrPngjQ
	 jBijwPVJPWzeE7d4jbvlZAJ72NxMbF7i4jA5/60M=
Date: Wed, 25 Mar 2026 11:55:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: mm-commits@vger.kernel.org, bblock@linux.ibm.com
Subject: Re: +
 debugobjects-allow-to-configure-the-amount-of-pre-allocated-objects.patch
 added to mm-nonmm-unstable branch
Message-Id: <20260325115527.36034bfd3d91d6f258526c74@linux-foundation.org>
In-Reply-To: <87qzp7et8k.ffs@tglx>
References: <20260311174822.42D6DC4CEF7@smtp.kernel.org>
	<87qzp7et8k.ffs@tglx>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 25 Mar 2026 18:03:55 +0100 Thomas Gleixner <tglx@kernel.org> wrote:

> Andrew!
> 
> On Wed, Mar 11 2026 at 10:48, Andrew Morton wrote:
> > The patch titled
> >      Subject: debugobjects: allow to configure the amount of pre-allocated objects
> > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >      debugobjects-allow-to-configure-the-amount-of-pre-allocated-objects.patch
> 
> Can you please drop this. The underlying problem is not explained at
> all and the question I asked vs. deferred page init is not answered.
> 

Yep, no probs, I agree that this isn't the one.

Benjamin, please do pursue this - the issue is real and has been around
for a long time!


btw, I was retaining this in mm.git in a permaparked state, with a
note-to-self.  So I had no plan to upstream it until everything is
sorted, or a replacement is available.  I do hold onto things for too
long, to get them more testing and to keep myself a bit focussed on the
issue.
