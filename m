Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A485D311973
	for <mm-commits@vger.kernel.org>; Mon,  2 Mar 2026 22:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772489371; cv=none; b=twoyc8oyGUtswr8SCQTJBR/ei7yimTtwQ/YANtOSZlGlt+T2IcG9CVMjKR6AXyXyV21Wb7THtRnVNQ2Pa6fyoeXvfpS/gL/yKbNqL6vxIqxCIoXq1Uk6fpaWB8yWS8AZY+lsyjL8pwgftqeg1gSSSSKUxCSmYgJk7Uu4F9e9P30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772489371; c=relaxed/simple;
	bh=G759lo8K7ABcE63M84BDPBTAaVBVGsfoby8qWJtTPPA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=jksSoDXH2brm0FGH79GBKP9vBEoX7bvgpxOhgakLKPwv6jJJjqryWRGINPcOMD9Oefh9ze+PgQ5GraeZXSKBafCgkKJiqeKHbKr8GeYyBRMHvQ9a17E5TfhiY7QN7kQXw71PalnBcxGTDgwKP6rj4JgIMAaaFUOTG3YWKQFWEiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JLmhdl5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JLmhdl5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C304DC19423;
	Mon,  2 Mar 2026 22:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772489371;
	bh=G759lo8K7ABcE63M84BDPBTAaVBVGsfoby8qWJtTPPA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JLmhdl5p7NgduRL4wtiMEVLeUK2TQO8m2lO2qYudozb5IF2Ymrs1WNdS/4oe/1HUI
	 VpaeDP9fiuVcYdhYyNLeZOhXLDQ+Z+nB2xN39HJEzHr0FcvIyxWN7Zt7SIVVMQfk/J
	 4ZAOwsvHUXS6XIi/xx8F2uJG4azDJtVov902faKk=
Date: Mon, 2 Mar 2026 14:09:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: mm-commits@vger.kernel.org, willy@infradead.org, peterx@redhat.com,
 joshua.hahnjy@gmail.com, jhubbard@nvidia.com, jgg@ziepe.ca,
 dywoq.contact@gmail.com, aleks.koyf@gmail.com
Subject: Re: +
 mm-initialize-seq-in-gup_fast-to-remove-wmaybe-uninitialized-warning.patch
 added to mm-new branch
Message-Id: <20260302140930.b2bce25f2921741c32bf3393@linux-foundation.org>
In-Reply-To: <f6f30640-750f-4c52-ac4b-fa900bd21ac6@kernel.org>
References: <20260302204309.E824DC19423@smtp.kernel.org>
	<f6f30640-750f-4c52-ac4b-fa900bd21ac6@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 2 Mar 2026 22:08:44 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> > --- a/mm/gup.c~mm-initialize-seq-in-gup_fast-to-remove-wmaybe-uninitialized-warning
> > +++ a/mm/gup.c
> > @@ -3131,7 +3131,7 @@ static unsigned long gup_fast(unsigned l
> >  {
> >  	unsigned long flags;
> >  	int nr_pinned = 0;
> > -	unsigned seq;
> > +	unsigned int seq = 0;
> >  
> >  	if (!IS_ENABLED(CONFIG_HAVE_GUP_FAST) ||
> >  	    !gup_fast_permitted(start, end))
> 
> Odd, because raw_seqcount_try_begin() does as a first thing
> 
> 	start = raw_read_seqcount(s);

gcc has always had problems with

	if (something)
		initialize
	...
	if (same thing)
		use

> I don't seem to get the warnings on "gcc (Debian 15.2.0-14) 15.2.0".

Neither do I.
