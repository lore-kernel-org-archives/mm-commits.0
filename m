Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87C62144A5;
	Tue,  1 Apr 2025 22:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545004; cv=none; b=CkdI36QLokbP6xHfq/p5wvT825jMp5PUxmnJ6HOn6sG+8Z9onBZEBvP5VnYmmC9UWGhMq1ioElG/naFBB2P0tKr/ium2oiOQ3ROS/27duRZvoIiWvvWd4oYe9K2KElb2FDzI/zVxRIgY4QPWHbrXCqN8aYOljztm3UGv6460gu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545004; c=relaxed/simple;
	bh=3V19B7qqGyHDRucfjUAISAS0xOMFD4QExWekS6FUvcs=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=mWBEjFPXg8UIeCwSo45kQSlzqgJz7fpge2Um3aRPRug+/G7gfkD+3p52HilrqNv5Zr4ipExlrL2UJjJg9E0EztAfUZbXav1zGDI8ZcptlkvMDYlJEXCb1lXhFtSw4h6vCEMSUWOYH32TinlWYi3IQG55pkj55ORtG9di4XlsWUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BSxQ1Qpp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BSxQ1Qpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D60C4CEE4;
	Tue,  1 Apr 2025 22:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545003;
	bh=3V19B7qqGyHDRucfjUAISAS0xOMFD4QExWekS6FUvcs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BSxQ1Qpp6XTfxTWCuSBE3S5hkCoJ/hRc7kXQc46ACQWMYc5KVyWlCUaTJYM2LY2CX
	 XeINCezr+1sutj7T5wq4t3CJHAI9ry6QFJAaPNiK67B2nO11Jvkdm0EDhj6Ko3Nkl/
	 8pc2O17LNlwbWCin/f0CciYkHfzR/3304IDtSq4Y=
Date: Tue, 1 Apr 2025 15:03:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, <mm-commits@vger.kernel.org>,
 <stable@vger.kernel.org>, <peterz@infradead.org>, <osalvador@suse.de>,
 <luto@kernel.org>, <dave.hansen@linux.intel.com>, <byungchul@sk.com>,
 <42.hyeyoo@gmail.com>
Subject: Re: +
 x86-vmemmap-use-direct-mapped-va-instead-of-vmemmap-based-va.patch added to
 mm-hotfixes-unstable branch
Message-Id: <20250401150322.5f4d85c9f60e1c4e147bc8ae@linux-foundation.org>
In-Reply-To: <cd66058c-35c9-4c32-bcae-bc2f8b9f6811@intel.com>
References: <20250218054551.344E2C4CEE6@smtp.kernel.org>
	<24fae382-2dc4-4658-b9b5-b73ea670b0b0@intel.com>
	<cd66058c-35c9-4c32-bcae-bc2f8b9f6811@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 18 Feb 2025 23:17:29 +0200 Gwan-gyeong Mun <gwan-gyeong.mun@intel.com> wrote:

> > That actually mirrors how __kernel_physical_mapping_init() does it:
> > watch for an actual PGD write and sync there. It shouldn't be too slow
> > because it only calls sync_global_pgds() during actual PGD population
> > which is horribly rare.
> > 
> > Could we do something like that, please? It might mean defining a new
> > __weak symbol in mm/sparse-vmemmap.c and then calling out to an x86
> > implementation like vmemmap_set_pmd().
> > 
> Hi Dave Hansen,
> 
> Thanks for the feedback. I do agree with a generic code rather than a 
> diverse code for x86 implementation.
> If everyone else agrees, I'll send a new patch in this style.

Please do.

I'll drop this version of the patch, thanks.
