Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795365706;
	b=Jbw9lpJXHI3cTG+8yfALVT+WFjT79BLo9/197YZZixh1r1FUuDKre20c5AvgThXUPo4y
	 vj4ILLFE1ydb//9QYU/iYQbCnr16OkubuHztg02IJXxWZJbdIQ57L0aoD71N4YdaQkwys
	 y0wogwMjASAwSnXb3uXjqdkkNL+jL5h2CIlQjU+g1lFUgg4T2ebUFtoWO2SAWx5flLJvi
	 RF57B+wzMcHx3OYRG95OcQrU3VQt9oONWhV3XFMNv8Iz5VtILsGj2xYdn0EUG/UK3s6t8
	 XkNOLeaaSJFgZuTMHMZuR8gL56h+dLf21Kcvmo7ZF9SPK5+7mEmc52/dbU+pDufIxMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795365706;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=LL3qYOVyI9czVO79Zu0V4wotcvHDG47da4SE8/8wYVY=;
	b=zC/S2OV6hhGHQEDzi/C+gyVjEWddTPsONRz0WaIGPuwDDMd7IWBPPfHuX4jmQrE4XChO
	 pgzBnJpDe1TiMynaEl35OgYTQMMiZvjZrl0+4c8K+N9cTk21HdQoKfeRGXeZ8uKDkiMmn
	 ajctSYa71wo42kHfZphEIPID6fQgOKmjBSjJ8fy09/dl+w67VB7TRDMc5eIaOVLmcCaEo
	 J/iok0fRuUws90wbsQajMfhhrfzMhIn1MdU2BdkmrldrzbX9rjFq80Qus6xKtQPREQPeY
	 Y8l7t6LnOsLiLZKbZFazPstWwgN+WfISiXOq9pZ/4lVrLopB0ymoCofDJ9kDa1VgbGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YSmWOuZ7;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=FrwMa6L2;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62D7606A682
	for <mm-commits@vger.kernel.org>; Sun, 22 Nov 2026 16:41:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B62D7606A682
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YSmWOuZ7;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=FrwMa6L2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795365704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LL3qYOVyI9czVO79Zu0V4wotcvHDG47da4SE8/8wYVY=;
	b=YSmWOuZ7leknP6Ki1LuQwgE7YiDC/3vQyRlKk3hdASDkrbE0D4VHcWbR78lomU5sjGRTFA
	AaAjdKwn5JwZRm7nony7zHsj+8OJvmH/N1W2bboA02x2t1ikJPM0DkbX46apCbnG9ZIwCj
	QcDCYrARXX+KQbxAjNv7AHsEKQLAbA8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-MvmUXf44P4i4JGPydMf3gw-1; Sun, 22 Nov 2026 16:41:43 +0000
X-MC-Unique: MvmUXf44P4i4JGPydMf3gw-1
X-Mimecast-MFC-AGG-ID: MvmUXf44P4i4JGPydMf3gw_1795365702
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48fcb657f32so1444563f8f.2
        for <mm-commits@vger.kernel.org>; Sun, 22 Nov 2026 08:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795365702; x=1795970502; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LL3qYOVyI9czVO79Zu0V4wotcvHDG47da4SE8/8wYVY=;
        b=FrwMa6L2qiLczFZ0yut6IFDT4zQHsuCoT+8k2n5GCF45F/zwar9QM2kbuqU4EZwUng
         oZQKDJagaQ5m9OprQkVZHkqLQ8KDIKnIc71T6iCxamYYcPBUhuPz3w8O2yvjj4dgFJqq
         uLNlxTStZ8nOb1l2RJMi2XPAFzeB0x2wXkWkQYcU1RxeysP1YElYGiS5f6pvznz3vj5C
         BpgyzKamIQjvt9Xijld3i7eOHV6G0S8XWabuRXkG3pKCXoKC5gsfrjKqwQQDusE2KwDe
         YBJVG/YatRXO2qgnO2vQVw8FuYAOk5vyIB9rSDrYf58F85xxPTtOMBHO4V6oKLfDb5Aa
         JEAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795365702; x=1795970502;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LL3qYOVyI9czVO79Zu0V4wotcvHDG47da4SE8/8wYVY=;
        b=mqsPKnri3e9NdfdGaC+VO/Syl+fNnIJUpWz4dx/tlf7lYpGVs2sLgoYQcIeqhpPuf3
         MNF4PZgeq16k2sxTBPPjPmWb80RjqVjSZlM/Suq4YjxswuZnUwzWnd2WpNyaLuXse9yk
         3Mwth/5FKljDz3w4CYHOZYFkjXXhdK9K06lDRZMSG3xxZ9k29cR449yYOfEFjTiZ7TLt
         zPPjpwQ10IQytdko79feHvpFavmiDVZay+M+qFq0oGuRN9zPc3TOsdd708qTazlyaJWM
         El8tqkmDVihMa7Jue6NGLnR+TVtXhwcKF3hfUCfLwVjd1mOyzv1LvMgpjwp7Ka1tYp5n
         e8aQ==
X-Forwarded-Encrypted: i=1; AL+hErGvlQk0HS3ZzxHdI2RjVkHN4BqCu7NjuRApTwQmueNtpfFZo0gHWDGIcd7xZvF9RgKzZ+pIfBo+pl/z@vger.kernel.org
X-Gm-Message-State: APuU4Z81lDxvLLNNfMI2Bx6hKg3fidjpeMw6wyqxlp7oztOOG4ZxXO7M
	vn0CHbvNABl8EqoERabtR41kSx3CnQhZgu2L6iJN3JuDAECYq3CFYZr+nvKuH8hyISR1RstyDMD
	413lIEJII81v9bCDtRwyjZioPA72z5lxdAtMWyMpcxJjN3l8YNc/d5km/QbtSbw==
X-Gm-Gg: AZFdTZe+TEqkCJIoohe6bfZKhoZpDkOi95dVewnozim+iWJlQbvYGsMthm/pJcSKPeh
	wBARBX7U0EtsGHG2QKxq3OGHAdebBinrJrRl+guL2pQiNCE15UhOQo4RgFHacQ+OhDZFzjbmVdd
	kIrlO5KWHd20IBLvRADDPkGA1dGtPflxvq8edLsJW/x9fx2WslFUc4M034G665Mx04/xqfIFwYp
	0WqYG6fTBzn70Yji2W59R0EO9My/C7e7WO+IUI0/keNeFFjwK7gWplgg8jtaQQ3HZlv8cxkIVae
	ju7RK+ueCIf8IAW95Hvt1bn6yCmoS04iiGnOjdXthBXTie522GzUCfhjVIsxaNzO9yp01ff4ymI
	VNxhHU6H/6jLuZ1/dXgESCISM3gd2hxOKeglpqP07MFr8AnnMY7RF7d5pLKVu7xZ6gQQRyZGkYT
	HTL72f
X-Received: by 2002:a05:6000:400b:b0:4a8:dbbd:69ab with SMTP id ffacd0b85a97d-4abb4f58c75mr17629616f8f.27.1795365701978;
        Sun, 22 Nov 2026 08:41:41 -0800 (PST)
X-Received: by 2002:a05:6000:400b:b0:4a8:dbbd:69ab with SMTP id ffacd0b85a97d-4abb4f58c75mr17629591f8f.27.1795365701633;
        Sun, 22 Nov 2026 08:41:41 -0800 (PST)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf62f7sm18809912f8f.13.2026.11.22.08.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 08:41:41 -0800 (PST)
Message-ID: <af91d4a7-11ca-4f84-b8da-33ee1a585916@redhat.com>
Date: Sun, 22 Nov 2026 18:41:39 +0200
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
Subject: Re: [PATCH] mm/hmm: account for subpage offsets in device-private
 PMDs
To: Aveline Noir <jm5905938@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: airlied@gmail.com, apopple@nvidia.com, balbirs@nvidia.com,
 christian.koenig@amd.com, dri-devel@lists.freedesktop.org,
 Francois Dugast <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org,
 jgg@nvidia.com, jgg@ziepe.ca, leon@kernel.org, leonro@nvidia.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Brost <matthew.brost@intel.com>, mm-commits@vger.kernel.org,
 Patchwork <patchwork@emeril.freedesktop.org>, Shuah Khan <shuah@kernel.org>,
 SeongJae Park <sj@kernel.org>, thomas.hellstrom@linux.intel.com,
 Vlastimil Babka <vbabka@suse.cz>, ziy@nvidia.com
References: <179342234355.4.16705453209886955762@gmail.com>
 <20261121160037.1a479f3c8b4e860bc23c106d@linux-foundation.org>
 <36be0904-168d-4813-82ff-27ecced464e3@redhat.com>
 <20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org>
 <179535872126.34.4789080961796247940.b4-reply@b4>
Content-Language: en-US
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <179535872126.34.4789080961796247940.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/22/26 16:45, Aveline Noir wrote:

> Hi Andrew,
>
> On Sun, 22 Nov 2026 01:52:46 -0800 Andrew Morton wrote:
>
>> Store the corresponding RAM backing page instead.
> This avoids the oops on the first read through the second descriptor,
> but leaves a stale backing page pointer after CPU faultback.
>
> Since the mirror XArray entries don't take a page reference, they rely
> on invalidation.  When the CPU later faults the page back to RAM,
> dmirror_interval_invalidate() skips MMU_NOTIFY_MIGRATE for the same
> mdevice, and dmirror_devmem_fault_alloc_and_copy() only clears the
> migrating descriptor's entry before the backing folio is freed.  The
> second descriptor still points to that freed backing page.
>
> Reading the same page again through the second descriptor in QEMU
> triggers a KASAN use-after-free in dmirror_do_read(), and the read
> returns the stale data instead of what the CPU wrote.

I think this is right, but a fairly artificial scenario: it needs two
descriptors open on the same test device in one test, a migration through one,
a read through the other, a CPU fault back, and then another read through
the second descriptor..

The fix lets the device private page content be read without an oops
in the context of one fd which is an improvement. 


>
> The second descriptor's entry probably needs to be invalidated before
> the backing page is freed, and it'd be nice to cover a second read
> after faultback in the selftest too.
>
> Thanks,
> Aveline Noir

--Mika

