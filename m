Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B78A279346
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 15:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746718823; cv=none; b=YeyshJUYsYTBx8q80IDzGysQB0K4VZla7WeJl34uraJ02/3C9Qs093f/KCUfIOSzaOl3Ijdw6NBMLAXhBdX93D3Ad1MhpVTYarizm8PjZkc9ViRdO0PQcZWbcaN6zlWS9zIXncdjunBH91fcL2prn6+a8FOV4jY6oI7sBx3zqaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746718823; c=relaxed/simple;
	bh=EYAsNV5OmeXjuHv0NDSFU01AX/zbfamienKdTR1p+T8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BVkNtJdC6HRO5qIOTIGezLxZA0JPlWxYBn5p2CZTUfAQQsv/NnNLJCDP6O92LMNpFzFg0BoOuw278b+lZowThAmFpA6WCGbTenjzbnEvcH+84IkgLvnjZlRuCRG0F27DZp9lYJDTplOQGX4vDMgmNiWN7sC9FxCOthXLAbRPq88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MZ/7jNuR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MZ/7jNuR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746718820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LsE+a0WMhT/Uoa+BdkRynvgWuJFRdXTEv+pAU5CVIXE=;
	b=MZ/7jNuRL54P+ggxzSWJNI13VW5N0aR8bDBxM5DNqEXuxS6MDI+MnzJGlTCHNCf41L2IFk
	Bv5x63sbqvD5h/HDDLXw0NKGZyO+ZJRsXDUZg0/gSQ/i+ULjz3F3aSJ/UqX5E7ihYtpBG7
	Fxw57K4mrUXWXj3LMpQN/GePKerGc2g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-vYsEBe7uMDqQTBRcg0XVqw-1; Thu, 08 May 2025 11:40:19 -0400
X-MC-Unique: vYsEBe7uMDqQTBRcg0XVqw-1
X-Mimecast-MFC-AGG-ID: vYsEBe7uMDqQTBRcg0XVqw_1746718818
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43cf446681cso6387065e9.1
        for <mm-commits@vger.kernel.org>; Thu, 08 May 2025 08:40:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746718818; x=1747323618;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LsE+a0WMhT/Uoa+BdkRynvgWuJFRdXTEv+pAU5CVIXE=;
        b=FIpQHznUATworQQNRO3S4zZV6qtBEDVZZCUTroAo4d32FcscvHnnHAcCOTb25MmNNw
         zo1fqaHaxpp/O7oFAHytC4mGDpBFf8CY7+u2MOPqgxSn93t3tJgzmC6XCsr2nl+9wf34
         eFW4AIwVnOIGfesCQn8joTmYeCVOyTYBxTQ0a8WYr1wVIAT62MWAIxM6nPfTCNqFfwpg
         r9yweZYybXZYIKGtCxQ1k6vQUb3SC1WXc0QePv/AVcHlZ+cC8wRlsEE0Dp2A/u7dDetp
         VmQkoglQShaMfw0hIYsX3IQs00uCuuwyIgvZZwasxdue9E6johoa4+AOSee7FHeJElLB
         VpKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqiFrePb2Fy2ItkoFWGPgcy6mBTa5U+uueSJVIP7g/uDuaflLOzaSLxmM+7rAlPySauGlHLNuvG/uF@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4p+yXN9TPZUv86kxyhl2TNtZeKZ58FVaC+Z2Q6kGp1oa+Ua2D
	N4fOpED0bFhibJa6ABMJI8gqyzi3800so7OJ3MRDyxV2WONLP5H5DJV9WynxeuO9AydbJhVE6De
	Lj6hb7iL4Lozbaz3qisOzimw5VO8oku0ngjgY9Q2Ao+FiI8pzMdClJRPdsyc=
X-Gm-Gg: ASbGncsQB1ru0Q6KrBJzqXikXAPHqMPYXODT//URSWnKUeYvS38ZdNRnFWrvKezdYv+
	Vc31hTFMJ5j2gpZa9WyTZ6F8r2wD2WundBsQsHuJ/PhmzX8ZIC8I1g8p6ygxNxKzf7nIP3ilW/n
	/sAJijF+P5Y1mYYaOP2zPBr4DsKSP6aie+HAIwHxMbTidKaSIG93VYthA/qIFeFBm7cE3VioVre
	R1aVYrMl2lWlu3Rxdd9rSTJWshCbEckEkRN0Vpf0VbA71LuBcUw9ILLsjcwpcAcggSeYYJ4f3tJ
	DMURMkR9uy3AClHsGmBYldZRWMWY0lNpqz68N+9iiLLnImMzst+2TZP576IsA0OXWh7R4cdMAlw
	B49dx9hFpcEvr9afFgliJgo97MOFZ9AhKQmHkb1Y=
X-Received: by 2002:a05:600c:a413:b0:43c:f597:d589 with SMTP id 5b1f17b1804b1-442d57ccbd0mr9877685e9.27.1746718817845;
        Thu, 08 May 2025 08:40:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFg3IgeSBzi4e/HTxmo+uyafrhLgfNHrD9RRelCyZegunAjfz4jRD97Jxqr7yWrqMn0Lng5JA==
X-Received: by 2002:a05:600c:a413:b0:43c:f597:d589 with SMTP id 5b1f17b1804b1-442d57ccbd0mr9877135e9.27.1746718817006;
        Thu, 08 May 2025 08:40:17 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3e:5900:27aa:5f4a:b65c:3d3c? (p200300d82f3e590027aa5f4ab65c3d3c.dip0.t-ipconnect.de. [2003:d8:2f3e:5900:27aa:5f4a:b65c:3d3c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f57ee95asm316804f8f.11.2025.05.08.08.40.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 08:40:16 -0700 (PDT)
Message-ID: <e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
Date: Thu, 8 May 2025 17:40:15 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
To: Pantelis Antoniou <p.antoniou@partner.samsung.com>
Cc: Peter Xu <peterx@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 mm-commits@vger.kernel.org, wade.farnsworth@siemens.com,
 jhubbard@nvidia.com, jgg@ziepe.ca, c.briere@samsung.com,
 artem.k@samsung.com, David Howells <dhowells@redhat.com>
References: <20250507215555.81672C4CEE2@smtp.kernel.org>
 <CGME20250508141641uscas1p265a41a862e38f9d8ab8b67fc0f8610d5@uscas1p2.samsung.com>
 <aBy8v7gi3tsQ5-iy@x1.local> <20250508173612.34d1bea3@sarc.samsung.com>
 <aBzI3sl6r3HtAWP4@x1.local> <cc6d5e06-d0e5-44d7-9a1e-151fc39c5e7c@redhat.com>
 <20250508182718.40f16121@sarc.samsung.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250508182718.40f16121@sarc.samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 08.05.25 17:27, Pantelis Antoniou wrote:
> On Thu, 8 May 2025 17:10:10 +0200
> David Hildenbrand <david@redhat.com> wrote:
> 
>> On 08. 05. 25 17: 08, Peter Xu wrote: > On Thu, May 08, 2025 at 05:
>> 36: 12PM +0300, Pantelis Antoniou wrote: >> On Thu, 8 May 2025 10:
>> 16: 31 -0400 >> Peter Xu <peterx@ redhat. com> wrote: >> >> Hi Peter,
> 
>> On 08.05.25 17:08, Peter Xu wrote:
>>> On Thu, May 08, 2025 at 05:36:12PM +0300, Pantelis Antoniou wrote:
>>>> On Thu, 8 May 2025 10:16:31 -0400
>>>> Peter Xu <peterx@redhat.com> wrote:
>>>>
>>>> Hi Peter,
>>>
>>> Hi, Pantelis,
>>>
>>> [...]
>>>
>>>>>> @@ -1271,8 +1287,6 @@ static int check_vma_flags(struct vm_are
>>>>>>    	int foreign = (gup_flags & FOLL_REMOTE);
>>>>>>    	bool vma_anon = vma_is_anonymous(vma);
>>>>>>    
>>>>>> -	if (vm_flags & (VM_IO | VM_PFNMAP))
>>>>>> -		return -EFAULT;
>>>>>
>>>>> Is there's any justification that this won't break some existing
>>>>> GUP users that may rely on properly failing at pfnmaps?
>>>>>
>>>>> IIUC netfs isn't the first one that wants to GUP on top of
>>>>> pfnmaps, KVM does it for years and so far it was processed in a
>>>>> standalone path:
>>>>>
>>>>> hva_to_pfn:
>>>>> 	else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
>>>>> 		r = hva_to_pfn_remapped(vma, kfp, &pfn);
>>>>>
>>>>> That started with supporting real pfnmaps (with no page struct),
>>>>> but pfnmap with page structs can also happen afaict, and kvm
>>>>> processes that too by checking page==NULL ultimately, e.g. in
>>>>> kvm_release_faultin_page().
>>>>>
>>>>
>>>> I see. The problem is that we're not the owners of the code in
>>>> netfslib, and it is considerably more intrusive to fix things
>>>> there.
>>>>
>>>> This is a hotfix for a userspace regression. I sort of agree that
>>>> having different handling for these areas in netfslib would be
>>>> ideal.
>>>
>>> Do you mean this used to work in older kernels?  Some more info on
>>> the regression would be more than welcomed if so..  If it fixes a
>>> kernel regression, we may want a Fixes for whatever patch at last.
>>
>> To be precise: Whoever decided to use remap_pfn_range() essentially
>> decided that GUP cannot possibly work.
>>
>> So is the regression introduced by a conversion to remap_pfn_range()
>> in some code, or because suddenly someone relies on GUP for these
>> things?
>>
> 
> I don't think there was a deliberate decision here, but there was no
> conversion to remap_pfn_range(), the code (in DRM) was always there.
> 
> The regression occurred when netfslib started using GUP for I/O and
> when filesystems switched to it we hit this case.

Okay, so GUP and DRM always worked that way. They are essentially 
incompatible at this point due to VM_PFNMAP.

So netfslib requesting something that is impossible is the problem .. or 
rather filesystems switching to that and not realizing the problem.

Hmmm

-- 
Cheers,

David / dhildenb

