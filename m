Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7EE6AB8;
	Fri, 27 Sep 2024 00:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727396269; cv=none; b=ETs8zSUfA5vOnpZntLIf4SDQw+nAe1iv+u75qoynVF96kF4u4d6HjicNPrHh8VcS87vfDNfjPKuMT0+0Q2CeLEfjMufafWJx86jZyqywrz6ZCQ8StAu2oiihe4C1+mzo/oDZZ8enBbuxWNOPkftB+lDOmVKs9FU1RVlnuivo8K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727396269; c=relaxed/simple;
	bh=NFO2ejFz8qNhGVYyZGYvrC81xYq/IG9YjQ5rSuW6KJk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=KD3/RUYjldI0VC1oUpn/bToioRMCpO+uU3b4D2QNoo0ZUJAxdrVD9bFbul6IIjALDVSE/8MIKh3Ar6SGPLYqcQEFm2BHpxVnrcdfWW8K55+ImcHiSF5R9lDjJJ+qhogtoSaFbflblDJ5PnSySrnnQEhFbth+ZoDcQrjpEkcVhrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fH+HNgqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fH+HNgqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFBCC4CEC9;
	Fri, 27 Sep 2024 00:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727396268;
	bh=NFO2ejFz8qNhGVYyZGYvrC81xYq/IG9YjQ5rSuW6KJk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fH+HNgqzfcfwlFngIt/rxf5BClPi6uiAKUItGyk92T6Ybvmo5D9qts26GYZ9Dmo8K
	 tMEHAz75KxANxVmdXr9nxCjMVI97WglMqS+goAA7/xxF7NR5oEGgCpDic9/cC+gY5c
	 fZ3SSoaGj37aUHZmYtergoOZ/y795KKeYAWDIbNE=
Date: Thu, 26 Sep 2024 17:17:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?B?6auY57+U?= <gaoxiang17@xiaomi.com>
Cc: "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "david@redhat.com" <david@redhat.com>
Subject: Re: =?UTF-8?B?562U5aSNOg==?= [External Mail]+
 mm-cma-print-total-and-used-count-in-cma_alloc.patch added to mm-unstable
 branch
Message-Id: <20240926171747.bacbd2b5d62d4a34926f0d4f@linux-foundation.org>
In-Reply-To: <e02aa8d24a254f36af5132925be4075b@xiaomi.com>
References: <20240926202540.E47E3C4CEC7@smtp.kernel.org>
	<e02aa8d24a254f36af5132925be4075b@xiaomi.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, 26 Sep 2024 23:19:25 +0000 高翔 <gaoxiang17@xiaomi.com> wrote:

> So now we're ready to merge into master?
> 

Nope.  There's a review question I'd like answered and the patch should
go through our regular integration testing.  This is 6.13 material.
