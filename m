Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82872B67F
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 02:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731291174; cv=none; b=VRDxtDDneHfRHhdMPc9DiSNYmi7pIAhhJTLF8sN6VxH2pN3lIzNo9sSExhnvV511Fmh/v0SLeOsMRFUawXh76dpC4cTYh0xfAuFjb46qrdCN+lD/Px9fJVZshLUPIAdZcfBu1P2Tja9m1UlqF9gQIRTaZNSbfQ8SZjNf0REL6Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731291174; c=relaxed/simple;
	bh=y/Ic3jRmLnb1FAHPuGh1/X2CLpl4pOFZAVPBgPUIJFE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=LLoUNxVvw7hm3w/0z2TumnYkRDrxHrwk/fZi3W3K02aU2xi/jTaIja7d6SseSf6R9fKGhIm/JLsFaxJd92bMKk0OQkZuCXlWVyLuRZ+b5XN34NsvtHn7jkzR/AkXmnasKOr+zR8CHIFoVeZVsQ5BZGylbUWuKEcBJor/yi3Y7EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NgS+wTV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NgS+wTV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DCFC4CECD;
	Mon, 11 Nov 2024 02:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731291174;
	bh=y/Ic3jRmLnb1FAHPuGh1/X2CLpl4pOFZAVPBgPUIJFE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NgS+wTV2/JjEN6h3OYkYn/5q3AdyLXaUuyUaTJzxogTRCHlpkeAognbKArVVyKlRB
	 IfckNpBPjHD6CfSXxmkcs9YE97m4mKqxZKYXm7s1GHmopUY2eEuiYMlHQy8d15XJ/g
	 Aa08o1R86L1crttqYspMUePW7nkvjJvqpk1yU33E=
Date: Sun, 10 Nov 2024 18:12:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: mm-commits@vger.kernel.org, senozhatsky@chromium.org,
 minchan@kernel.org, liushixin2@huawei.com
Subject: Re: + zram-fix-null-pointer-in-comp_algorithm_show.patch added to
 mm-hotfixes-unstable branch
Message-Id: <20241110181253.0ed6a90d5962edb1a8edb9be@linux-foundation.org>
In-Reply-To: <d720c44c-455e-4d02-b1f2-02544d48a68a@kernel.dk>
References: <20241110061637.2A885C4CECD@smtp.kernel.org>
	<d720c44c-455e-4d02-b1f2-02544d48a68a@kernel.dk>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 10 Nov 2024 18:26:14 -0700 Jens Axboe <axboe@kernel.dk> wrote:

> On 11/9/24 11:16 PM, Andrew Morton wrote:
> > The patch titled
> >      Subject: zram: fix NULL pointer in comp_algorithm_show()
> > has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
> >      zram-fix-null-pointer-in-comp_algorithm_show.patch
> 
> Andrew, can you drop this one?

OK.  It will generate a conflict with one of the 11 zram commits which
are in mm.git, but this is very trivial.

