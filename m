Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795363257;
	b=yxpDRwz43ZgAsBqxTl91qymWnIxkrfy+msLdSGP3ro5LCTBRb9u1K6VGnUUIcxtuH2hq
	 6MmxlRIA7mAm+KvdZOdJlCj0uFpzEWmffSCS1IP4tlwA7FkVdYORy3V4MzAaI8iuLqMWy
	 QaoHiB+lbhiF1ee+Yz7XG7pauS6tqnj83wU6cdFQMnwwQz/Om87TI/OgFI4PN6O+YjldA
	 TijpX1lvcLZa7LL93l77vF/U/qEHmCUsifuhuoyfjKie/XtOvgYUtVF65tOMwGK099sqK
	 JQwialcc6+hL7nrfBHPWHsLYIgZD/Ugo/fytvZZ3h4SIM0xuuYUczqWTKbXq9Z3RafQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795363257;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=zL8qNWVqadmoqMqIUqkbNCrsjwnOwNsrU9YI6mReoPI=;
	b=PgqVus9YmGApIjPlwFMPHpALBpOVT4W06tYop7Z1BNeCN2qggxrRHM9tGcTd5P4Z9oTR
	 nowKetcp/YTCriQ6Wj9Mt5Py0jV50a7SwS/w0WfjQATVHqGmnY6sDK4KBbHBssXFfagKj
	 jcqHotp2aghoc+WmfETe1rJ/kcOXUXVdKQU3S5UC/8BJMJgBlnRw9ypQCAGFMmpNYjDU3
	 OtOrBLlVlZ3PJ/ppo6UXS4jDysbvTnP/imK292/ReuYLNEDMDguPcnMVMWtdp3q5kbMjk
	 7YItNHKHTfnqv7wVrs4dWWIUNXB4K8fzjQ4KcUB/PkaudMb4d/mn4Cga0Wv9sov9/ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="XRX7Nk/8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C82606A332
	for <mm-commits@vger.kernel.org>; Sun, 22 Nov 2026 16:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XRX7Nk/8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C54E1F000C4;
	Sun, 22 Nov 2026 16:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795363256;
	bh=zL8qNWVqadmoqMqIUqkbNCrsjwnOwNsrU9YI6mReoPI=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=XRX7Nk/8oMRrHGJ1GL0UorkoviBZxSRCurUQMPytDbOqIGvinYmBw5aXPitYh7Koo
	 ZTTZnb8FsKgxTSR41r0bzGR7MSt2+vLnv8uBQSVJFN121ZeQfHI6KrsUtdZugxlgd2
	 FMcOv+/xq1G32sz96fONLTgNe0StBuFzWn1fW1MT31Iyh/hH3J/fExkcgWI9sRtBuf
	 uw8da5S06/Mm0LqimRRCNuFlqX9B/viFCyesCD6NvA+haSGAK+oH7GcZ09fc2McN7z
	 vRoVnwjxkChYT3svNtn8JPPn3zqOukHgBo6qDzHM4WB5tHZVsd0lC+t8AZir8HtJXU
	 4rUtvP7Z06uZg==
Message-ID: <4587b2d8-2aaa-481e-babc-8901423faf11@kernel.org>
Date: Sun, 22 Nov 2026 17:00:47 +0100
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 mm-introduce-copy_mc_highpages-and-batch-copy-in-folio_mc_copy.patch added to
 mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 vbabka@kernel.org, torvalds@linuxfoundation.org, tglx@kernel.org,
 tejavojjala@google.com, surenb@google.com, rppt@kernel.org,
 rientjes@google.com, pfalcato@suse.de, peterz@infradead.org,
 nhuhuan@google.com, mingo@redhat.com, mhocko@suse.com, ljs@kernel.org,
 liam@infradead.org, hsalunke@amd.com, hpa@zytor.com,
 david.laight.linux@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de,
 bharata@amd.com, ankur.a.arora@oracle.com, shivankg@amd.com
References: <20261113-batpagecopy-v3-1-297f5b2fd28e@amd.com>
 <20261122073025.90A441F000C0@smtp.kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261122073025.90A441F000C0@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/22/26 08:30, Andrew Morton wrote:
> The patch titled
>      Subject: mm: introduce copy_mc_highpages() and batch copy in folio_mc_copy()
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-introduce-copy_mc_highpages-and-batch-copy-in-folio_mc_copy.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-copy_mc_highpages-and-batch-copy-in-folio_mc_copy.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
> 
> ------------------------------------------------------
> From: Shivank Garg <shivankg@amd.com>
> Subject: mm: introduce copy_mc_highpages() and batch copy in folio_mc_copy()
> Date: Fri, 13 Nov 2026 17:09:21 +0000
> 
> folio_mc_copy() copies a folio one page at a time with copy_mc_highpage(),
> so a 2MB folio makes 512 separate copy_mc_to_kernel() calls.  Each page
> pays the startup cost of the string instruction ("REP; MOVSB" on x86 CPUs
> with ERMS) plus a cond_resched().
> 
> Introduce copy_mc_highpages(), the page range variant of
> copy_mc_highpage().  When copy_mc_to_kernel() is available and the pages
> are in the linear map, copy the whole range with a single
> copy_mc_to_kernel() call, so the CPU can optimize for the larger extent. 
> Otherwise, fall back to copy_mc_highpage() one page at a time.
> 
> On a machine check, queue the poisoned source page for memory_failure(),
> as copy_mc_highpage() does, and return -EHWPOISON, as folio_mc_copy() does
> today.
> 
> copy_mc_to_kernel() cannot reschedule, so only take the single-call path
> when CONFIG_PREEMPTION is set and the copy can be preempted.  Since commit
> 7dadeaa6e851 ("sched: Further restrict the preemption modes"), x86 and
> powerpc, the only architectures that select ARCH_HAS_COPY_MC, only offer
> the full, lazy and RT preemption models, also with PREEMPT_DYNAMIC, so
> they always take this path.  The per-page fallback calls cond_resched()
> before each page, as clear_contig_highpages() does.  Other architectures
> keep copying one page at a time.
> 
> Switch folio_mc_copy() to copy the whole folio with copy_mc_highpages().
> 
> On a Zen 6 system with CXL memory, move_pages() gets ~1.4x faster for 2MB
> THPs and up to ~2.8x faster for 1GB hugetlb pages (numbers below).  When
> demoting to CXL, kswapd uses ~31% less CPU per GB demoted.

Hi Andrew,

please drop it. I'll take care of it once we have more review (including review
from me).

-- 
Cheers,

David
