Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9AA522E
	for <mm-commits@vger.kernel.org>; Wed, 10 Jul 2024 07:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720595188; cv=none; b=KOLgNZUlESgyia46lOiXN5t7G8g3/Nol1Fy9gDBvEXszgRBI5C2YSNORa1zlojJpOw6FE5Dfo4cg/RCRc2D92xv7zn1CntFopkb/i6lPSdlbcZgqDgYwQKy6XuClWPeICy9kx/LgKTWSua1+WO/KOybg6fQV0P2/lpNTAOf1Dbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720595188; c=relaxed/simple;
	bh=pYStFPQgnRR9fWhD63ywVqhx5hM3ObcDT6ZLK5mKuDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CLHtbefRksoK95ifWdIRNYUmRSTR941akLWORSZyxVOf5YkHOWbXIgnOBwaSEa82R8hx7XxRKQcsW9oAXtVxxbDwCUt55YFh2hdwK2qY9sirShXHgvi/PF+UROTE/uhCBnb34pyPM4tI67j6EPMIDGwmRiAoV/NOh6qba4bLubk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hgisv2we; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hgisv2we"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1fb05ac6b77so32571325ad.0
        for <mm-commits@vger.kernel.org>; Wed, 10 Jul 2024 00:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720595186; x=1721199986; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=btOsFs9QGYW/AGiAGQMhJ6E0LkzARkWSDioMFunBjgE=;
        b=hgisv2wegT3tfepiXuke1HLv7FWFy3xIwraBlrkYV/Az6zVShfbXZlr4cm7EIOdgIZ
         kdKbMDo5jrkhElnY7i3xLIBIgUMNURbNFUO6hVdSlTekmRwLIHGx7kSbYk2ioGZdplfC
         ZwT7sGK8eLWtBqhlicmXEsJp2Mf3t61b/Xfy6ph+fGLNU5sA/N/tJheFDbs3rBnFXwXj
         mDbnMOoKugISM9n/ao2NRYSk5ceqM5nsuEQpKH0f83dXBMCGq5DIDc2F7bKbeXPB5VZF
         GK9ny7rC+BU/ms00LiIANqq4NrB4N5cPCmv7iaNoJ25ljD4hureNCa9WSZx+ejFTlJVP
         VXdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720595186; x=1721199986;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=btOsFs9QGYW/AGiAGQMhJ6E0LkzARkWSDioMFunBjgE=;
        b=s4pdTBrhULye3iNmOZCkiVF1yRnyodyWN0vs20DQRV+agdzeJblFezbzY/I4lu1AAT
         9x15bvCdca0PAjISZbrpx5TcewLo4aRxEYgh+7o9dH8SFB1XDtN3beAKlupfCZiSBfzS
         vf5YQq3sZFisVzeR0BD+kM1ZzaC6WLyGq2KSVd/CunRssErPJ8Eo0ZU7M4wM0ZtLNrRw
         VQjP9BjfYhDjfZYTCYWGC0teUpWWEjSTKshpgeTHkVdcXuzuBQ9nQ2TRAqbQoTlzuWRF
         8eZfyULdJUyBwV6j3KVyf78byJl045IpMhxMDczwM1ICPYiGvNb26VN3fcufN4dL/Z2W
         fYgA==
X-Forwarded-Encrypted: i=1; AJvYcCWubOo8N/r4Y3qf3eDxiWqLzk61LNqXAOsEj/YvZ5koY9c3ru987ynSB63ewSATLGS4+UGF0Gzhhy9qxd6ZeXPnNOjR/qfUzLft2w==
X-Gm-Message-State: AOJu0YzXY+DBIQGMg8vvF5HsHmTllxi54u3PPpelVUIVtYFd9BRnfS4e
	nHnOCS96+/dEiSZJNHQdT3zyMAUpBEzsqXslp8QL5rMlUGKRXYFmsqx221rY
X-Google-Smtp-Source: AGHT+IEjTIVzUupsYIZD4aMWz/R81HaQbrzvLxyR2T7TN4s+KgVWRDWKFwZJJ0bPNoCoDr5MWOwgUQ==
X-Received: by 2002:a17:903:234e:b0:1fb:53e4:4e07 with SMTP id d9443c01a7336-1fbb6f0f16bmr36566865ad.68.1720595185829;
        Wed, 10 Jul 2024 00:06:25 -0700 (PDT)
Received: from [192.168.255.10] ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6a11757sm26845315ad.35.2024.07.10.00.06.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jul 2024 00:06:25 -0700 (PDT)
Message-ID: <8a4e300e-7692-4057-8927-e665860183b7@gmail.com>
Date: Wed, 10 Jul 2024 15:06:22 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-memcg-alignment-memcg_data-define-condition.patch added to
 mm-unstable branch
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 pasha.tatashin@soleen.com, keescook@chromium.org, hannes@cmpxchg.org,
 alexs@kernel.org
References: <20240708214255.9F454C116B1@smtp.kernel.org>
 <CAJuCfpESwaHgqy2LH8BthPXqqCjN3H3u5mX-C5Q6zFrKHG0qHw@mail.gmail.com>
 <7c4b1be3-d161-4a91-bd63-b5c9d69c75c7@gmail.com>
 <CAJuCfpFqVf=-e0b1ZbdY+7y5uuA7P267Z8AQ22wj7pRBMFSdYg@mail.gmail.com>
 <bd270dab-c0d1-4da5-8383-bbf4443d17ff@gmail.com>
 <d1c603d0-6d6b-42c4-a690-a6647131998b@suse.cz>
 <CAJuCfpFQc2PLu-PzzKCLDYFbSDsrVeJzgLk7nDZqp6+ye-bLow@mail.gmail.com>
 <8861d515-3759-4f3d-b0ed-aff974a83d44@gmail.com>
 <CAJuCfpE+QFn04J=pqXZ47NjEj7QB3irv3+_kz_8VhJ023NmNbg@mail.gmail.com>
Content-Language: en-US
From: Alex Shi <seakeel@gmail.com>
In-Reply-To: <CAJuCfpE+QFn04J=pqXZ47NjEj7QB3irv3+_kz_8VhJ023NmNbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/10/24 12:17 PM, Suren Baghdasaryan wrote:
>> Hi Suren & Vlastimil,
>>
>> Thanks a lot for comments! I will follow your suggestion to update the patch.
>> But there are another issue related to the problem, in Suren's patch, make the
>> MEMCG select SLAB_OBJ_EXT? why memcg needs this? I checked the mm/memcontrol.c
>> seems should work with !SLAB_OBJ_EXT.
> It would help you understand this if you think of slab.obj_exts and
> page.memcg_data as the same pointer with two different names. When one
> exists, the other should exist and vice versa, when one does not exist
> the other should not exist. In my patches they both depend on
> CONFIG_SLAB_OBJ_EXT. Now, since CONFIG_MEMCG requires page.memcg_data,
> it should make sure page.memcg_data exists and that's what it does by
> selecting CONFIG_SLAB_OBJ_EXT.
> 
> The above description is how things work today. If you are changing
> the way Vlastimil suggested then this dependency can go away depending
> on how you implement it.

Thanks a lot for the explanation! I just sent out a reference patch to decouple
SLAB_OBJ_EXT and MEMCG. 
https://lore.kernel.org/all/20240710054336.190410-2-alexs@kernel.org/

Would you like to give some comments? :)

Thanks!
Alex
