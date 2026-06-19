Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F6C1FA859;
	Fri, 19 Jun 2026 07:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781855629; cv=none; b=MPj0wjauM5pb3Aqk+90aHGttTnpLoKg8bzPKc+AjeWhrmaepCjYQtve7nevJugDe7bPa5LZ2l6C8PbKMqIBJHfExd26ciJ9ts1922M7vlIlU1kXqDSU7dtrtv28BCp6yPFODTdi3/i+jIcrxq7uM33cLb6tfSNaFyqA+ZhgWDa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781855629; c=relaxed/simple;
	bh=KTNTeKmcKrl0HzqrWjC4sT5hldMQ3qLGw0qHug62rao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LK+lykSzmBbQ1fzzrdueTiZRZP8FOjPG0ZWkwHNL73Q8oNO+V/T8vqCjnNW2jt9iBGz9RHsrDM7QHGejzhVEtBL1HMzkctyxzEwNllIhWGVGTYbLCaiFgQLmzzx14pbzKWs5s+0Rvf2pBukpE4Qe+Zty0PArJ5oYWhjK3Do/gRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KDoJ64zw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KDoJ64zw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438491F000E9;
	Fri, 19 Jun 2026 07:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781855628;
	bh=haVgRnmIpelVO1VhwqkMbIrQtyXdHS3KTFbeiyRjyPk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KDoJ64zw/lO6HtsuNwxG8E4d+BZIDL0bFRDxNH/CWDCon5jPnqhetqGLWaQ/D0Bg/
	 bLzioNiqdf+sW/ywkomoAME7mW+lzOT4VvVdpMBkt3Ly4ZlN3CBkCn12OSjIMzZ85u
	 OpGY2jCoRJYj4bCS7YSWc/slpyRjXtsDuAIoTcUHTP9co+CXwORFjT6DpPp3HT1LdV
	 V8SJcZP/D4mMZsYrSC5euXUxlxgQz3GEDgTaZHmKCqAU5KNFS5EA3CVu94sFcHOmED
	 6HJrgKzSyU2Xc3wJUjLGt++9SbOdrvd4jeE3fcVNHM0l3DSXdH6SK9JCQ4kR+1x0Ws
	 ypc+nKgSlupgQ==
Message-ID: <cb30b646-31a0-4afe-aba2-3cb01f299c00@kernel.org>
Date: Fri, 19 Jun 2026 09:53:43 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + userfaultfd-prevent-registration-of-special-vmas.patch added to
 mm-hotfixes-unstable branch
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 vladimirelitokarev@gmail.com, viro@zeniv.linux.org.uk,
 stable@vger.kernel.org, peterx@redhat.com, oleg@redhat.com, jack@suse.cz,
 brauner@kernel.org, rppt@kernel.org,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
References: <20260618183442.BBCD71F000E9@smtp.kernel.org>
 <CAHk-=wiQ_10MRYYW+aRfLP4Ah9gDrShOvLESXtz+Q32-9M9Y9w@mail.gmail.com>
 <9bbaa053-ea06-4b36-98ba-dc487a28964e@kernel.org>
 <CAHk-=wjWhvmy5xUcTMCJZats2cUJ5iGU4o5Kdt+OvRepu+MUeQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <CAHk-=wjWhvmy5xUcTMCJZats2cUJ5iGU4o5Kdt+OvRepu+MUeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/18/26 23:42, Linus Torvalds wrote:
> On Thu, 18 Jun 2026 at 14:07, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> Maybe we should rename and possibly split that up, like
>>
>>         VM_NO_MLOCK
>>         VM_NO_VMA_MERGE
> 
> That sounds saner, indeed.
> 
>> And then have some generic "there are really special things mapped in here"
>>
>>         VM_HAS_SPECIAL_MAPPINGS
> 
> I think maybe we should stop using "bitmasks of VM_xyz bits" and start
> moving to a "helper inlines for vma testing".

100%

> 
> That way we could make hugetlb not set DONTEXPAND at all, if we
> instead just introduce a
> 
>    static inline bool vma_can_merge(const struct vm_area_struct *vma)
>    {
>         if (vma->vm_flags & VM_SPECIAL)
>                 return false;
>         if (vma_is_hugetlb(vma))
>                 return false;
>         return true;
>     }

Yes. DONTEXPAND is a weird thing and I am afraid it's getting abused at other
places.

> 
> Ok, so that vma_is_hugetlb() thing doesn'ty exist - but we do have a

We have is_vm_hugetlb_page() that we should probably rename.

We probably need helpers for VMA vs. VMA flags, but I'd let Lorenzo figure that
out. (CC)

> VMA_HUGETLB_BIT to implement it. I wrote it that way mainly in an
> effort to make it all make sense logically.
> 
> And maybe we could get rid of VM_SPECIAL entirely at some point usign
> these kinds of helpers - by making "vma_can_merge()" and others that
> currently use VM_SPECIAL use the *actual* real bits explicitly and
> simply making each rule have simple and logical tests.

Yes. Or make them build on each other (vma_maps_special_pages() or whatever)

> 
> And the reason we should pass in the vma - not just vm_flags - is that
> often things like "is the vma anonymous" is part of the decision of
> what can be done.

Right, I think the problem is that sometimes (VMA modifications) we might have
the updated flags but not the updated VMA. But again, I'm sure Lorenzo could
figure that out.

> 
> I think this would make the code both more flexible _and_ more
> understandable if we had these kinds of helpers for different
> situations rather than have VM_SPECIAL kinds of flag combinations.
> 
> But I'm just throwing this out as an idea. Maybe there are better ways
> to deal with this. The current code does seem rather annoying.

Yes, thanks for raising that; it needs a proper rework with clear semantics.

-- 
Cheers,

David
