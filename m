Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34E418562F
	for <mm-commits@vger.kernel.org>; Sat, 26 Oct 2024 08:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729931348; cv=none; b=Kmm+R6ODdDCIdV1VHaQHiEzd7m6LsMB7vA9ZUYON+GudUZL3Y2LZrhQ3JHf8BhDDW4zvXcW+G21QbXvkQhjpNTwwT3yqqCm/uzVf83vEIwN2F2Gg97CdnLoHZ+ur6uyb0sJKTDEvPgbkPKQYcfWbvKYNYHI30B0WuQr661pnQlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729931348; c=relaxed/simple;
	bh=R9CztiA/e1YEonI5ToQTKX6T/wvDb9QQ8U1cd7I4lzg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g0/w7zoshuOrF0JnFuFh7646H4rYpuFMv0N/ld4m5AcdkRn7VeWLXqnN4jLJ8b6d4z49VcciFOCg7m4Ko7JtNdv2Ja/TK2fZWz9zhZKr8ODNc5lW8l0ye3zJKHQtHKloVVA36uU8y5PBuceT2GEHdb+4CbjdMG4Ib6DR78a0ihk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kryyNSTT; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kryyNSTT"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a9a0f198d38so380063466b.1
        for <mm-commits@vger.kernel.org>; Sat, 26 Oct 2024 01:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729931345; x=1730536145; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IFvxZF9q3RGpMKjT4R3jKie7THaDAWt9mGNmCSuAhl0=;
        b=kryyNSTTniNKL356esvhiZPANTYgYrKO8jRFnosCQWORQPU7ch8l9eJ7wiqNJkE1d2
         eBR9wNScOMORRPIQeJheGY/2yCEycKqjed/lvJjnS0bJiluyRCKrNDniB3U7GD28R7ht
         AJdEzWhyZnhu5rZm30IlkYredNhnUCxi3QcJQd5++o+BrKMaLaiaU5n6MazreA+eBxaE
         G+5A3TBRkfmR7Q0AR+WW1lLLLNn75kq8BY/dklqeCfz7fVQdeFVDRHbnze/2rZEzEPrf
         k66NkX3IznR5gua4xDYHV8w9C4ykoy0d5lWm3OWwPVgsf9bXfVTVx4aqY5394P0ADHyC
         mhnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729931345; x=1730536145;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IFvxZF9q3RGpMKjT4R3jKie7THaDAWt9mGNmCSuAhl0=;
        b=fjATpHDZs0GndyNm9VkIvspUaC1Exl1MfS5tnK+rCul3CdkM8GZrVbwlD2yJKpTmSy
         X2S6WDGN7mlBA/nfTQknIvgkd9CqkAWz3C3fATdwFhia/HEgbaT2CuRTzp/IXTJnD4dd
         dl3B+iMbHCyv0zc1E3LOzwsIKoEi+uwG95EamPn60+LbgZtPc5rwko2QrT55bnM6OQAN
         r0afa5VyuD5g5yXw5/pFCmjTcYjnG0le8fnXRWUjPvptEi/VWZfHoGIKm/QJGdRJl8Kp
         +Yg18zuRFdo3hAj6jN7aK2uFa834F+dRTqrJqkkifRQtDdVWpJfwv825C8S9SR0mVuHh
         b+Ag==
X-Forwarded-Encrypted: i=1; AJvYcCWAA/y8rPqeliS3FtnB2lKsR7fAnQnLbyste1kjLiiENsd1B62KTi3wbidYF2l1TZPNiuEi9KL/vT4M@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2S6zGTnyJZVhPEn14adathA7ODjMuFvrpYHRtwoD9BibsTMDx
	EnsCPSZAaADrVery0690Bwnq9pUZU8ccga5BusWelinMjAVyYxv0
X-Google-Smtp-Source: AGHT+IFo0LMLcIljfY3Ge1hTV2/03Nio+DmOr8v+l5EhK1WUCxbH/eoY4ZhbKr+Bpmezw0tCmVyAZg==
X-Received: by 2002:a17:907:31cb:b0:a99:5773:3612 with SMTP id a640c23a62f3a-a9de5f6653bmr159611666b.36.1729931344893;
        Sat, 26 Oct 2024 01:29:04 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9b1f0683edsm153169266b.93.2024.10.26.01.29.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 26 Oct 2024 01:29:04 -0700 (PDT)
Date: Sat, 26 Oct 2024 08:29:03 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Wei Yang <richard.weiyang@gmail.com>, mm-commits@vger.kernel.org,
	vbabka@suse.cz, Liam.Howlett@oracle.com, jannh@google.com
Subject: Re: + mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch added
 to mm-unstable branch
Message-ID: <20241026082903.ohcltnfcylrxdgib@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20241026024123.B621BC4CEC3@smtp.kernel.org>
 <20241026033436.hfb73whfbeypxj5r@master>
 <20241025212224.c03b14a7d658edb9ca09aa07@linux-foundation.org>
 <58b091e1-bb4e-43c6-b049-c866441070bc@lucifer.local>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58b091e1-bb4e-43c6-b049-c866441070bc@lucifer.local>
User-Agent: NeoMutt/20170113 (1.7.2)

On Sat, Oct 26, 2024 at 07:01:57AM +0100, Lorenzo Stoakes wrote:
>On Fri, Oct 25, 2024 at 09:22:24PM -0700, Andrew Morton wrote:
>> On Sat, 26 Oct 2024 03:34:36 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>>
>> > >------------------------------------------------------
>> > >From: Andrew Morton <akpm@linux-foundation.org>
>> > >Subject: mm-vma-the-pgoff-is-correct-if-can_merge_right-fix
>> > >Date: Fri Oct 25 07:39:41 PM PDT 2024
>> > >
>> > >remove now-unused local
>> > >
>> > >mm/vma.c: In function 'vma_merge_new_range':
>> > >mm/vma.c:965:23: error: unused variable 'start' [-Werror=unused-variable]
>> > >  965 |         unsigned long start = vmg->start;
>> > >      |                       ^~~~~
>> >
>> > Andrew
>> >
>> > The removal of start usage maybe come from another patch.
>> >
>> > If my understanding is correct, 'start' would be used to restore the state on
>> > expansion failure.
>>
>> I don't think so.  This patch did
>
>Yeah I removed the logic that would do this in a recent series. We can drop start.
>

I see your latest change.

Sounds there is some latency. When I looked at mm-unstable this morning, the
change is not there.

>>
>> > --- a/mm/vma.c
>> > +++ b/mm/vma.c
>> > @@ -915,7 +915,6 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
>> >  	unsigned long start = vmg->start;
>> >  	unsigned long end = vmg->end;
>> >  	pgoff_t pgoff = vmg->pgoff;
>> > -	pgoff_t pglen = PHYS_PFN(end - start);
>> >  	bool can_merge_left, can_merge_right;
>> >
>> >  	mmap_assert_write_locked(vmg->mm);
>>
>> which was the only usage of `start' in vma_merge_new_range().
>
>Yes this is true now. We're good to drop it, thanks!

-- 
Wei Yang
Help you, Help me
