Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2919218AB3
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 13:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736430489; cv=none; b=UMCQnh7bV5EIrtJfABsWOUPpu6NcGq3Va1OMC74h8w6ic7CTVqrdZ86oRDweythVnktRYI2+feRfs/Ui0CBxaPyHAbZYO0G39MR1pkjYtXx/uB99Lirothy9zz9dUWObiEiFNRXXXQoNsx8zV1yfzF4EDO8+OGRetml1tiMohfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736430489; c=relaxed/simple;
	bh=MfUAsByiN5G1cpKWskdIpU8Hzs1S1TOv2sPq1G8qPaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mdw47gV9IR6ZdHyQqRuwYmEXnVrEypYqCHF0aL2vjVJWeP60JhrSFN6kDpmfRX0f3JZ044FU/tPh4rFRNpyUYbMPVhq4eupP3jHQA/tem9/yXeB4iUsQjFZWH6v+G0Ahoj+cqGkQlsSfBvWYW3CVKF4i5YsnlbpUXlpZzDIFkRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PD4afNIz; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PD4afNIz"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a7d7db4d89so2373935ab.1
        for <mm-commits@vger.kernel.org>; Thu, 09 Jan 2025 05:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736430484; x=1737035284; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NjFJHiLttVQ/1qgu1DVPvVlnOW9nGnLZZjIldl0AS5o=;
        b=PD4afNIz/9MOj9esQMJRrCcE3FE9qCDPBGlDhzf/yV42/bsIyQlbbPazcyfDxLIS02
         tVQ+JOyemHCE6PAGMz/QJZiCssphdCYPK/QAZL5pXS04y5hR3KTcEwRO7uib8JOl3NEi
         KB9iKYuMJd77s7FNO/yYYdflpd1Jrba+XN09RoBSWr5lgO7WY+tdz3WU8/95fB2cLxsx
         Adx4GxM3JIld/fXM70lhE0ASu42shkGEXsv5Z9f/aElb0Q0zVGxJhT3b94DDgRU+2/XP
         WPDGjTvUTTOcEDrTKcJu1a78KYwQ5RorVNOXYUFwgVr/acGid4l8XCNVET6TLuGHXpj/
         Pm7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736430484; x=1737035284;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NjFJHiLttVQ/1qgu1DVPvVlnOW9nGnLZZjIldl0AS5o=;
        b=ISxQx5RaBD2JAbpUH267uwqhVI+sU/nSS3J4jSED3M0zOP+YfY45S7FyLAAsD2qmX9
         cMTVdKE9uoK993XExK5C7T5r5NLE9JVnEGK7IBTdqK03jgHF62nibGznSiQ7DKMmMov7
         6T2GbDnVCaB6ZyMB85pwwOQ477m4occ7lZJvIiYVYMkvYyLwHsMmlBVbERyeku8bfCkJ
         vYOSNs2d/aNDNOtDC9R3g4iGs8e9bJdxUNb4Mu6Mg/ZJsoB3YoffhQvNlKg+OsQa50hm
         xiDgP5jnBVX/9v8AOGqvXhq1E98kWYgeuy4A96RlvW7tBSba0e4HCSeW35JY5HuWdEt5
         97rw==
X-Forwarded-Encrypted: i=1; AJvYcCXC9I13XcQLaeFTVNLH7jczwDuqKOOUtPYrwwwip2ncRQIEDI15G9XVhUOOm+bKLCYIMX0DfwUJ2lGi@vger.kernel.org
X-Gm-Message-State: AOJu0Yw80c8O8NnQNnAB4NgqBkXerdp2T2z2FXWkZYa0wDcxqznzEFrC
	WmJh5vhnUtQ6VNjcrDGBMFVjdYeU1Fne4eMllO0juQsLPMorBxy0+fwV/d1rp1Q=
X-Gm-Gg: ASbGncvicVibYQq0QsLbmPMdPRNU2nixnpTRfHMho7tME/8w0+5MNV1IKe2OId+It1r
	gBi5CTdzPPE6PMFSUCr9FMI4Q5okwzq/Ly4poxwLDdGg2zUBJKR/6zvVFAIvrCE6Z8/eYJxBOHA
	0xZ3RWP8X3cHF5sKriZfEzDiR+4PYSztG3H4VVkigC/Zyk9VguNv+KVUZTvl8Z9CDt9y2PWmzDO
	zIORchplyN0mv5qO8z/ho4JaXdD0YJ4XBfEH5Zf+kqYixdltKaPwQ==
X-Google-Smtp-Source: AGHT+IG5SANKVDmAgAYjDqK10COs4jWHaFf9VTuEjRa7uGEWse3fQ6B/s8xNC11pOGn29F5jf4C8zg==
X-Received: by 2002:a05:6e02:1fcb:b0:3ab:a274:d68 with SMTP id e9e14a558f8ab-3ce3a9b59b3mr52636765ab.8.1736430484442;
        Thu, 09 Jan 2025 05:48:04 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b7488casm316012173.135.2025.01.09.05.48.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2025 05:48:03 -0800 (PST)
Message-ID: <73c72b29-3847-4617-a2f7-14c2b452d23d@kernel.dk>
Date: Thu, 9 Jan 2025 06:48:03 -0700
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-add-pg_dropbehind-folio-flag.patch added to mm-unstable
 branch
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 hch@lst.de, hannes@cmpxchg.org, clm@meta.com, bfoster@redhat.com
References: <20250108033555.926E6C4CED0@smtp.kernel.org>
 <Z36LFTqnHM-jywV5@casper.infradead.org>
 <q4kpgg5l5s3vprg7zc5hkmyo4a3gnzrsrcm6wnmfj6p26ypayv@6kmconrrwjhi>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <q4kpgg5l5s3vprg7zc5hkmyo4a3gnzrsrcm6wnmfj6p26ypayv@6kmconrrwjhi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/9/25 3:27 AM, Kirill A. Shutemov wrote:
> On Wed, Jan 08, 2025 at 02:26:29PM +0000, Matthew Wilcox wrote:
>> On Tue, Jan 07, 2025 at 07:35:55PM -0800, Andrew Morton wrote:
>>>
>>> The patch titled
>>>      Subject: mm: add PG_dropbehind folio flag
>>> has been added to the -mm mm-unstable branch.  Its filename is
>>>      mm-add-pg_dropbehind-folio-flag.patch
>>
>> I was hoping we'd get some response to Kirill's suggestion that we not
>> do this.
>>
>> https://lore.kernel.org/linux-mm/Z2WRJdKnTD5eSfBS@casper.infradead.org/
> 
> I can do this conversion on top of Jens patchset.

Yeah, was hoping we could do something like that. As I replied to
earlier questions on this, I don't feel comfortable overloading
any existing flags, as I don't have a good enough overview of how
it all ties together. IMHO that kind of change should be done by
someone that has intimate knowledge of the subsystem and flags,
not a plebe like me.

-- 
Jens Axboe

