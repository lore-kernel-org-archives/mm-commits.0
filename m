Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4353B244692
	for <mm-commits@vger.kernel.org>; Tue, 28 Jul 2026 00:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785199134; cv=none; b=ett/YEz/TDGlNjf00+vgB6Y3+tkMm5VwC/HkMaeX6SDuTdXABpSMDTo9CshzS72AoLOu/z8ZWTMS3D0HPk85vREJ+c33ErgvCDChcHG64rzVzpVxZDRmtkb7LLiMOYQp0IYiG1BZJVcKlMemqexq5yl7pC/LBKfv2vMdfTx1Xeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785199134; c=relaxed/simple;
	bh=wlDp2jw/1+p1UkmpSIAdCdQG5dkc8/w2wD424eNIjNM=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=KM8aRv1DfE5fxhIsgB+HtmfANn+TQfyVdCErBQZOAPhefcCHS977ucrjaWUcUaFfoKEGk9knn+NJf2mkY1jFrOX0SMtZcNplk7o3KAaW1zUsLWj/IAJ5kmw8RN8pEkqE9XazZRYwsIL/qVB9e4hKwCyvOC0H4U651gwfKDVU23I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bWoWwaMl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bWoWwaMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D951F000E9;
	Tue, 28 Jul 2026 00:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785199133;
	bh=rtacWlA/oBgxpyYEK+DrFmdhi2/XxpjvkTdQoZxPIZc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bWoWwaMlmtvDOoOPbOtrvox/+hufHrXVjI8cVECahKMobTWToMpB0X2qRWiCO3avr
	 D5eNy4i13YAra9ilgCfRIxibCQ59rZoIxBrHeJQ9ogKKAa/eNxxBZa35cxZTQcuE9N
	 6PeZBptUVNvV9aj7vMGx1aQasIukD3TQeGGYdO1k=
Date: Mon, 27 Jul 2026 17:38:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
 <leon@kernel.org>
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 34cacd0ac7c10dc9e34e1b9f28a2b78d335cb487
Message-Id: <20260727173852.6d54ced5739a55c0ae7024c8@linux-foundation.org>
In-Reply-To: <amZU1hH_9IOeO4G8@skinsburskii>
References: <202607251512.KMStVfrY-lkp@intel.com>
	<20260725193155.0e03a382d76a99485ca05cdd@linux-foundation.org>
	<amZU1hH_9IOeO4G8@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 26 Jul 2026 11:41:26 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> > But I do wonder whether we should be compiling hmm at all if
> > CONFIG_MMU_NOTIFIER=n?
> > 
> 
> Documentation/mm/hmm.rst explicitly states:
> 
> "Address space mirroring's main objective is to allow duplication of a range of
> CPU page table into a device page table; HMM helps keep both synchronized. A
> device driver that wants to mirror a process address space must start with the
> registration of a mmu_interval_notifier"
> 
> I think making CONFIG_HMM_MIRROR dependent on the CONFIG_MMU_NOTIFIER is the right thing to do.

OK, thanks.  How about we use select.  select kinda sucks but we're
doing `select MMU_NOTIFIER' all over the place already.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/hmm: make CONFIG_HMM_MIRROR select CONFIG_MMU_NOTIFIER
Date: Mon Jul 27 05:31:14 PM PDT 2026

hmm doesn't currently build well with MMU_NOTIFIER=n:

With microblaze
https://download.01.org/0day-ci/archive/20260702/202607021433.DYT5fDqE-lkp@intel.com/config
(CONFIG_MMU_NOTIFIER=n):

mm/hmm.c: In function 'hmm_range_fault_unlocked_timeout':
mm/hmm.c:804:25: error: implicit declaration of function 'mmu_interval_read_begin'; did you mean 'mmu_interval_check_retry'? [-Wimplicit-function-declaration]
  804 |                         mmu_interval_read_begin(range->notifier);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~
      |                         mmu_interval_check_retry

Quoting Stanislav:

:  Documentation/mm/hmm.rst explicitly states:
: 
:  "Address space mirroring's main objective is to allow duplication of a
:  range of CPU page table into a device page table; HMM helps keep both
:  synchronized.  A device driver that wants to mirror a process address
:  space must start with the registration of a mmu_interval_notifier"
: 
:  I think making CONFIG_HMM_MIRROR dependent on the CONFIG_MMU_NOTIFIER
:  is the right thing to do.

So select MMU_NOTIFIER if hmm.c is to be compiled.

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Stanislav Kinsburskii <skinsburskii@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/Kconfig~mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier
+++ a/mm/Kconfig
@@ -1250,6 +1250,7 @@ config ZONE_DEVICE
 config HMM_MIRROR
 	bool
 	depends on MMU
+	select MMU_NOTIFIER
 
 config GET_FREE_REGION
 	bool
_

