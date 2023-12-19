Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C3E814AB3
	for <mm-commits@vger.kernel.org>; Tue, 19 Dec 2023 10:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD3D81FB;
	Tue, 19 Dec 2023 02:48:09 -0800 (PST)
Received: from [10.1.32.152] (XHFQ2J9959.cambridge.arm.com [10.1.32.152])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F2E63F738;
	Tue, 19 Dec 2023 02:47:22 -0800 (PST)
Message-ID: <563d4703-e726-4e53-b163-2af192423373@arm.com>
Date: Tue, 19 Dec 2023 10:47:21 +0000
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + arm64-mm-set_pte-new-layer-to-manage-contig-bit.patch added to
 mm-unstable branch
Content-Language: en-GB
To: Will Deacon <will@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
 yuzenghui@huawei.com, willy@infradead.org, wangkefeng.wang@huawei.com,
 vincenzo.frascino@arm.com, suzuki.poulose@arm.com, shy828301@gmail.com,
 ryabinin.a.a@gmail.com, oliver.upton@linux.dev, maz@kernel.org,
 mark.rutland@arm.com, jhubbard@nvidia.com, james.morse@arm.com,
 glider@google.com, dvyukov@google.com, david@redhat.com,
 catalin.marinas@arm.com, ardb@kernel.org, apopple@nvidia.com,
 anshuman.khandual@arm.com, andreyknvl@gmail.com, 21cnbao@gmail.com
References: <20231218172316.08623C433C8@smtp.kernel.org>
 <20231219101038.GA6307@willie-the-truck>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20231219101038.GA6307@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/12/2023 10:10, Will Deacon wrote:
> On Mon, Dec 18, 2023 at 09:23:15AM -0800, Andrew Morton wrote:
>>
>> The patch titled
>>      Subject: arm64/mm: set_pte(): new layer to manage contig bit
>> has been added to the -mm mm-unstable branch.  Its filename is
>>      arm64-mm-set_pte-new-layer-to-manage-contig-bit.patch
>>
>> This patch will shortly appear at
>>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-set_pte-new-layer-to-manage-contig-bit.patch
>>
>> This patch will later appear in the mm-unstable branch at
>>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>
>> Before you just go and hit "reply", please:
>>    a) Consider who else should be cc'ed
>>    b) Prefer to cc a suitable mailing list as well
>>    c) Ideally: find the original patch on the mailing list and do a
>>       reply-to-all to that, adding suitable additional cc's
>>
>> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>>
>> The -mm tree is included into linux-next via the mm-everything
>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>> and is updated there every 2-3 working days
>>
>> ------------------------------------------------------
>> From: Ryan Roberts <ryan.roberts@arm.com>
>> Subject: arm64/mm: set_pte(): new layer to manage contig bit
>> Date: Mon, 18 Dec 2023 10:50:48 +0000
>>
>> Create a new layer for the in-table PTE manipulation APIs.  For now, The
>> existing API is prefixed with double underscore to become the arch-private
>> API and the public API is just a simple wrapper that calls the private
>> API.
>>
>> The public API implementation will subsequently be used to transparently
>> manipulate the contiguous bit where appropriate.  But since there are
>> already some contig-aware users (e.g.  hugetlb, kernel mapper), we must
>> first ensure those users use the private API directly so that the future
>> contig-bit manipulations in the public API do not interfere with those
>> existing uses.
> 
> Hmm, I certainly didn't have this series earmarked as v4.8 material. I
> gave it a quick once-over last week but, with the looming holidays, I was
> planning to come back to it properly in the New Year. I also thought ther
> was a fork() regression that was under investigation?

I've fixed the fork regression - well mostly; it's now only a 2.6% regression
when ARM64_CONTPTE is enabled, but chatting with Catalin, we thought that may be
acceptable given the other performance benefits. We also couldn't identify any
real-world use cases where fork is the bottleneck (modern Android uses
pre-forked zygotes as I understand). I've posted a bunch of microbenchmark
results in the cover letter and commit logs.

> 
> Ryan -- what is your expectation here?

My original stated goal for v3 was to push and see if I could get it into v6.8,
but given I didn't get any offical review feedback from the key arm guys, and as
you say, I had a fork regression (now fixed), I assumed v4 would now be
targetting v6.9 at best. I also assumed it would go through the arm64 tree so
would be implicitly held until you/Catalin/Mark/... had reviewed it. It would be
nice to get some review and aim for v6.9 if possible. But I agree v6.8 is not
realistic at this point.

I guess I'm learning yet another process lesson here to be more explicit about
what I'd like to have done with my postings in the cover letter??

> 
> In any case, this series makes significant changes to the low-level
> arm64 mm code and I don't think many of us will be around in the next
> couple of weeks to deal with the fallout if it kicks up any issues.
> 
> Andrew -- if Ryan doesn't object, please can you drop this for now?

It's always nice to get linux-next soak time; Is there a middle ground where we
keep it in mm-unstable for a bit but don't progress it to mm-stable, and if
there are any arm64 bug reports we drop it? Or is that too complicated?

> 
> Cheers,
> 
> Will

