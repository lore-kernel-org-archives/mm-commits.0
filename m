Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7431CCB53;
	Wed, 30 Oct 2024 23:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730331507; cv=none; b=RydHX/AlXsYHDIgiAVVNs/cfs+jbyld5oHHHp8TFTXLUR214VyF8EIf8zTrG6wLA6mnE5Vu69riXtqajjRdSmknLgEdAcpujy8jy5HKehimGlw8QR/3c5RScmklI5Pe8TtaCzDnsYpQclZKG4RL+o+XMPwBAEesqxT/JYVVNTjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730331507; c=relaxed/simple;
	bh=gYnge1uzbrUyb0Lr74j0FURoQ/0Focp1C5ih+ymsZUk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=cKi0KkTw9v7a5n8dTUJZqRX218spfbzwlDbjgUgYaAOTygCbTrsYRO5sqsMJMdL3J8XB3QBk2zQRE5LSPBdN4Eg6HNuDoE4OWMmvd+SnXbcywJLMU3T6yXPUpAk3apaYXsmZe2TTgaMWttiFOA7jR83xXGPsiuE9xWX3X4e9xsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l87b7GwU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l87b7GwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B4FC4CEF0;
	Wed, 30 Oct 2024 23:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730331507;
	bh=gYnge1uzbrUyb0Lr74j0FURoQ/0Focp1C5ih+ymsZUk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=l87b7GwUmJKcEp8krnLo/NekK+aH/aB/9xVG0W/vwRoaa1aLe92X1WamES5pp2i2Z
	 XxBjh3WTSpkmM+bMXCw/U3s1gNReJswyLxnTHUhlBvHuJEQ6H0wWb/vUEoDpc8yMWx
	 JQB295lDEmWCEGjKc64E6TpilCuzDYqyAfapplCU=
Date: Wed, 30 Oct 2024 16:38:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
 Liam.Howlett@oracle.com, jannh@google.com, richard.weiyang@gmail.com
Subject: Re: + mm-mlock-set-the-correct-prev-on-failure.patch added to
 mm-unstable branch
Message-Id: <20241030163826.e39b5618a92c5bc921d6bafd@linux-foundation.org>
In-Reply-To: <11f2daed-05c7-4c96-9600-a37e6f81ea33@lucifer.local>
References: <20241029041205.A0DEAC4CECD@smtp.kernel.org>
	<11f2daed-05c7-4c96-9600-a37e6f81ea33@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 30 Oct 2024 07:28:21 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> On Mon, Oct 28, 2024 at 09:12:05PM -0700, Andrew Morton wrote:
> >
> > The patch titled
> >      Subject: mm/mlock: set the correct prev on failure
> > has been added to the -mm mm-unstable branch.  Its filename is
> >      mm-mlock-set-the-correct-prev-on-failure.patch
> 
> Hi Andrew,
> 
> This patch needs to be applied as a hotfix as it fixes a bug in released
> kernels.

Done, thanks.
