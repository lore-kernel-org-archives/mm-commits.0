Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E043F2746B
	for <mm-commits@vger.kernel.org>; Mon, 30 Dec 2024 23:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735602810; cv=none; b=oSNAO+83M2JZYbRd5pD32fptGeXZdbzt8S5e2XCxPZBO51CMbtDVsX108/R3ThSaWQTuH380gq6SaA/hqkRWjychDUOn9tWqtBIZxF6OUC5XywxDvQ4Cb3gC8chf5J9tRlgJMYmCcr3ytBFA/1reUloigP3VPEjczbL0ghESM2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735602810; c=relaxed/simple;
	bh=oylCesij7VCHUXTM0GeUGfxo4dGObQBo6eALyOG0MH4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=EdS8jeYL1SAObhesN8M0oo+XIoGFEcrToKIG8kmp9OeacoL9i6Qybz8VlNYotCRYJEIB9Y21+c/vmPTFWVFXM1Mu1fr/3t7JHKgTr958P2jO9PEwMsmFy3f6V9Kyq2l5oEfudCvQRzwqJtjw0pM2tq+lJYoO+4DktHOZn0b+qtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LJ2U+I0+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LJ2U+I0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34154C4CED0;
	Mon, 30 Dec 2024 23:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735602809;
	bh=oylCesij7VCHUXTM0GeUGfxo4dGObQBo6eALyOG0MH4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LJ2U+I0+qXZHFugdUH06LarXCA49QpCO76nfV6o4Vi3lbNI4ZSY7D5GAO57TJOBre
	 vLymfrP6EeKH8kSsOWkSFlWhN944eNemBTWsMzev43d8L1yQ+ZChK9HQpza6M5lunA
	 VAYRykWBOpS226FHnOE/ZyoBXlXi2jZNPPIhExd0=
Date: Mon, 30 Dec 2024 15:53:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: mm-commits@vger.kernel.org, jserv@ccns.ncku.edu.tw,
 chuang@cs.nycu.edu.tw
Subject: Re: +
 lib-list_sort-clarify-comparison-function-requirements-in-sort_r.patch
 added to mm-nonmm-unstable branch
Message-Id: <20241230155328.1ab9946d720ac0f61a680a84@linux-foundation.org>
In-Reply-To: <Z3MaX0fvKHHRYpUA@visitorckw-System-Product-Name>
References: <20241226221423.A3ACEC4CED1@smtp.kernel.org>
	<Z3MaX0fvKHHRYpUA@visitorckw-System-Product-Name>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 31 Dec 2024 06:10:39 +0800 Kuan-Wei Chiu <visitorckw@gmail.com> wrote:

> Hi Andrew,
> 
> On Thu, Dec 26, 2024 at 02:14:23PM -0800, Andrew Morton wrote:
> > 
> > The patch titled
> >      Subject: lib/list_sort: clarify comparison function requirements in sort_r()
> 
> Sorry for the typo in the patch subject title.
> The sort_r() should be list_sort().
> 
> Is this small enough for you to fix directly, or should I resend the
> patch series?

Thanks, I made that edit.
