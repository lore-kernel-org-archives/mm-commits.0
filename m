Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417731E1E1D
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 19:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746731061; cv=none; b=oKqvXyiqoPJJulkAHA9n2b0K27ywx9mHDw1SPQ25sRNbz65FnJoE2YJYVnXfnGONS8xvUQO8p1DS+XhGSqFBUjnwb14k0/TbRGZMXWDrAEySucoHmyiBGlRUs/MPaNusprNeqGPvXcmRfHawe+BmuzBV5lwegsLL2f7gtXZHQA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746731061; c=relaxed/simple;
	bh=Wd2aXaUlHyKbgmHEoN/RsJF3rotf9QRygnv1Tzi9zy8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XsJ2HBcBEyFMKT2JAC31WL24wwPo69Pg3f7wNjTNceGiWpPMYXMhntlnA+92nhuiltbHKED7nBwQndMIkX+HIV0mUHT18AieS9BeUQTC4gj44BMosDjEuYB2o6yUNqUa252tAXpiC2jSaQgpXgVYAEp2mufPlLsuOOQc7/8DPfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dK9qu7XN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dK9qu7XN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746731057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zBYH726eyBRV/RNWNyWIMCCJb9ttuoY+MSDF9Fhnuw0=;
	b=dK9qu7XNGReZ8xhpFu5FlEOA0r6wl3KLhX+GfEUmQE7VpbyMtAkWDU9BnJdInasRxYSL9q
	mySJoEifCnMqa9s8s01/K4cDv8xw7So/xARfNxJrO7ao79dXhTqgE/GgBkRfsRvLXqj5RN
	VxxDuFGo7AA+u3rIxTF420kVuNngeWM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-O1kAzz2BNMiyxcQFk_JGVA-1; Thu, 08 May 2025 15:04:14 -0400
X-MC-Unique: O1kAzz2BNMiyxcQFk_JGVA-1
X-Mimecast-MFC-AGG-ID: O1kAzz2BNMiyxcQFk_JGVA_1746731053
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43ceeaf1524so5803115e9.1
        for <mm-commits@vger.kernel.org>; Thu, 08 May 2025 12:04:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746731053; x=1747335853;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zBYH726eyBRV/RNWNyWIMCCJb9ttuoY+MSDF9Fhnuw0=;
        b=FqoHMsn1DF1RSjwMLzSDSL15Fn6Iwnx1mZujhEPLPV2CHndIZA6//su5QVAUmgoQEr
         S4gZzCYWqb5J/glhu7yTKjxATWoPQ3b/j6rDwywYuLyywxiZzjnY//VY7JdnUPV5bU10
         sio99FS9GwYr8Tb9bPTZ726utilNrSJ+cOF+WBI++ftHQH6/Czp51EPWDQvlrJhTfAD9
         TVi3WnGlAR+284qjsSVJS56RPmSH8sn/Y7g04bI9Itl4sOFfn3hP/TB2kTVfqz2o3CtY
         UmwZEpENgpfxpPAB5IKj8153d/Ck+tFsCSfNz/lBYkpoAhlNXV/0A0u5STvNOIwUSHIB
         luBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZmsJaefh6Ufc801o4Grr4rhZLqpN4lZWDpnQy8n9YmgNQ9AL4igAbX0rt0SR5FyVlzR+noRYidUxX@vger.kernel.org
X-Gm-Message-State: AOJu0YxRA+rMCO7KS77ADWA5j8Qt1lpafCxet3KtHm3ZDIMjs7eRq98Y
	PZAoRCEdbWEJJDkzGib1pcL5Ic7T63LrTZSM5peENaxDnhhyfKQQxHuS+cuCi6fng+n7weKx6Of
	yG55jZ0dBVaw6p9B71Cjy563IMaYknT5KCSCXCeBI93VAGJ7afW+GpRGXzTk=
X-Gm-Gg: ASbGnctG8MWVRDZpQxDu1HUve5dndZUJYNaolsYJuOhKs5lD2SKgFuANTUEHvpOWcNU
	elAJbXJ4EoGcQt7UBTCTvABSPNtrTOUa1P915N8r8whUqfvbaU15WqmJoqVhQ9S1oxZ6SnQE5rE
	ylPk10QayPmmiqQtv+73ZdrQ8vPWb75jyYhGxGa6ct1v4z4YMV4U3Xs6Y/+DXK9LiT8T7YofVxG
	JEMNnEgPycTUdBo4dD4aDE0APtg6fvjdDiirRdDTd7rNOY2pI3zoeg6et96BWw8cnfqQ3VQaJjr
	lpv4GhxiEvGsqcb9EWNaUtPa3XgGlpBON76u933zaW5LQF+dtkpNel3QJ6hz1MNAuErcnY4VFG1
	Rphkv3/d6kG1HUdINZCcS5Y+kzpgrzyjYWZjKcfY=
X-Received: by 2002:a05:600c:4182:b0:435:edb0:5d27 with SMTP id 5b1f17b1804b1-442d02e06c3mr28856635e9.9.1746731053492;
        Thu, 08 May 2025 12:04:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgIhLxeuw0fm3w2x48N8et9RXgr+f03c3h6QlWGlhFfNpyTvl+jFl2vHVNeLPkjz+zqL+4sw==
X-Received: by 2002:a05:600c:4182:b0:435:edb0:5d27 with SMTP id 5b1f17b1804b1-442d02e06c3mr28856295e9.9.1746731053102;
        Thu, 08 May 2025 12:04:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3e:5900:27aa:5f4a:b65c:3d3c? (p200300d82f3e590027aa5f4ab65c3d3c.dip0.t-ipconnect.de. [2003:d8:2f3e:5900:27aa:5f4a:b65c:3d3c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd328455sm47262245e9.2.2025.05.08.12.04.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 12:04:12 -0700 (PDT)
Message-ID: <8d66d995-f69e-4ac8-b10c-13a98ec9e848@redhat.com>
Date: Thu, 8 May 2025 21:04:11 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + fix-zero-copy-i-o-on-__get_user_pages-allocated-pages.patch
 added to mm-hotfixes-unstable branch
To: Peter Xu <peterx@redhat.com>,
 Pantelis Antoniou <p.antoniou@partner.samsung.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton
 <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 wade.farnsworth@siemens.com, jhubbard@nvidia.com, c.briere@samsung.com,
 artem.k@samsung.com, David Howells <dhowells@redhat.com>
References: <aBy8v7gi3tsQ5-iy@x1.local>
 <20250508173612.34d1bea3@sarc.samsung.com> <aBzI3sl6r3HtAWP4@x1.local>
 <cc6d5e06-d0e5-44d7-9a1e-151fc39c5e7c@redhat.com>
 <20250508182718.40f16121@sarc.samsung.com>
 <e74d39d7-c304-48b8-8199-be31be8bd4c9@redhat.com>
 <20250508173535.GA8129@ziepe.ca> <20250508204711.6cf9f6e3@sarc.samsung.com>
 <1030abf7-c8b3-49fc-8bb6-fbd021ebc60c@redhat.com>
 <20250508211136.7a0a3865@sarc.samsung.com> <aBz8QuzT7YkPqrrF@x1.local>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <aBz8QuzT7YkPqrrF@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> +	/* Did we find a special page under VM_PFNMAP? */
> +	if (pfn_valid(args.pfn) && pin_user_page(pfn_to_page(args.pfn)))
> +		res = 1;
>

It's doing the same wrong thing at a different place.

-- 
Cheers,

David / dhildenb

