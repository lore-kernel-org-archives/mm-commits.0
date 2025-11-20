Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF71156CA
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 00:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763599493; cv=none; b=fv9PpsqYA3HyXw++bjIFbfCyYAWQoCF+R9Pl5NS9fj5Y2iAa2IggNL69mJ4W9ujLkApvJ0xWhpz/8c4bFtqML0pbSfY5kpck9fAw8P4XKV08TQxhU4oBK24Vdx2KSEIwGgayzYqkOpjGx2ixOfRguQ+tMeDesi4v9P+sp8NhgYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763599493; c=relaxed/simple;
	bh=5tEwjzs/NOXSCmtN8bRPhVS1rc6pMXRDKVs5VMQXpqg=;
	h=Date:From:To:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=FgyjZ1w3KXmeYINhVOq8eA12CHUeioNNKfHHoiRWQPMt5DU6NxnBhLjRy7h4lv1+qMy1KA+7OwThTHPywQ59asNvXOQ1JUfw+q7jiSzkd/+t196Hxq6lRpp9h1NzrLj3krtnRbhUWOsWUTx1GEYbpAQ2ukEi7DOiEtU1Cr7jS0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DoDrTA/J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DoDrTA/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0295BC4CEF5;
	Thu, 20 Nov 2025 00:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763599493;
	bh=5tEwjzs/NOXSCmtN8bRPhVS1rc6pMXRDKVs5VMQXpqg=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=DoDrTA/JV4He20LOd+NzA69zRdBTXpLDDJUZb+OEbo4Km1rbBYmowfIOn35FPqVKb
	 zICg9V/TvpGHsa3Uupv5BRNrQzZyST50m+sRV+sXCdOFjBwJhOCVXhaI77EkvW5sDO
	 oGsCbsILISVd6LtbA0x3c2tb0bT8WZVU563yXzEE=
Date: Wed, 19 Nov 2025 16:44:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mm-commits@vger.kernel.org, urezki@gmail.com, hch@lst.de,
 hch@infradead.org, vishal.moola@gmail.com
Subject: Re: [to-be-updated]
 mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch removed from -mm tree
Message-Id: <20251119164452.0f763efbb282f71438a2964a@linux-foundation.org>
In-Reply-To: <20251120003637.41AB2C4CEF5@smtp.kernel.org>
References: <20251120003637.41AB2C4CEF5@smtp.kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 19 Nov 2025 16:36:36 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> The quilt patch titled
>      Subject: mm/vmalloc: warn on invalid vmalloc gfp flags
> has been removed from the -mm tree.  Its filename was
>      mm-vmalloc-warn-on-invalid-vmalloc-gfp-flags.patch
> 
> This patch was dropped because an updated version will be issued
> 
> ------------------------------------------------------
> From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
> Subject: mm/vmalloc: warn on invalid vmalloc gfp flags
> Date: Mon, 17 Nov 2025 09:35:27 -0800
> 
> Patch series "make vmalloc gfp flags usage more apparent", v3.
> 
> We should do a better job at enforcing gfp flags for vmalloc.  Right now,
> we have a kernel-doc for __vmalloc_node_range(), and hope callers pass in
> supported flags.  If a caller were to pass in an unsupported flag, we may
> BUG, silently clear it, or completely ignore it.
> 
> If we are more proactive about enforcing gfp flags, we can making sure
> callers know when they may be asking for unsupported behavior.
> 
> This patchset lets vmalloc control the incoming gfp flags, and cleans up
> some hard to read gfp code.
> 

It turns out that this patch had a fix which I didn't notice was
addressing this patch:

https://lkml.kernel.org/r/20251118-only-one-vmalloc-v2-1-fe702aa68d8b@ixit.cz

so please incorporate that when redoing this series.

