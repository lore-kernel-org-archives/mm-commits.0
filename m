Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3648A35F18A
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 22:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772837664; cv=none; b=A0dolXNWG6xRe9HHJg8/Ip2PwjqX3FKIVY7fU3v7kxDZF3e13zkO5IBIDHI0TKwJu+01s8TovDyYymP2H6tfo9NlrvHi6ZEDerzZhZYM0ki+VPVXQ3+knKVB7SXu7b4L9dMvT4nF98OS4ut3edb77MF+IUa/+z6/YvVPCbqE3b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772837664; c=relaxed/simple;
	bh=CwyjLDTrZC3vWWBTNuAV0HOzpX1HKcZF8WBOLacEyug=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=SOPgw93eHHu/XHF0ibGGKgfyEqIiFePN07UYiq9Ut8vBPCTPPBxliKJ49y40G0FpcomixWmGW1hxk8HxsfN7h0hF7RiyEGZ/yJGR7/u7GfIO+0PQ2bJrHdGzXrdRYDUD/Ttynb9aWq0TTGmww+ZmHL8PQKvk63phYv4qbUfJKsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cTOUvfB4; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cTOUvfB4"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-439b790af67so3759925f8f.0
        for <mm-commits@vger.kernel.org>; Fri, 06 Mar 2026 14:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772837661; x=1773442461; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CwyjLDTrZC3vWWBTNuAV0HOzpX1HKcZF8WBOLacEyug=;
        b=cTOUvfB4PtbUB8/NZhpYCQNXg93+nMh6AOofRUs9019OD9e14apoYuzQD49uirTVsG
         MppGbyEckVUvGrs/UkQAsXWGo5z9bGo8rwJn34WV4d2+qAMH/TFGPr7tOSq1VCD5BaYj
         adxGbctqa7lB0ibvafkcAR1g6ffocqZO+yNvGihLAaRu/esNBjxrwn0bagWecJSTxICt
         HLvbjdayQSr8ZniCcCQquc39yhEHCjSnTmCGAleAgna8UpRNVJ9UGoGG7tRZ6beXPWRO
         5TJC9mYWNE35jEPwjIAJ4hCBkWkbFkefo88uQbN1URNb+InqbZIQx3igIxm/n0fS4dhH
         /SFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772837661; x=1773442461;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CwyjLDTrZC3vWWBTNuAV0HOzpX1HKcZF8WBOLacEyug=;
        b=dJrzO8b1mDAn1hqh9UHmHdK8m/C0GYandVVAu8K947PX8PVzh2u26dH5W7R423bxPn
         MDOKMNan0g9wp1IRYfgufW7tM299VMRzZx58uhgOHhitgoqcXarZ6xlv8gUO4juinnj2
         McdU3nLuOZ2CPAIC3hwqb9/0JTGmlLXtORerNrMkDoSCJUEIRbKmPoykXM7mzKnCMvQN
         tPG158i2IMewtZKkmiUMKE9xaJ6Vs8ChbBsFGzsJxNUJQ3/XFHeqyAhqNBuHBcetvQ9V
         /jQIb8hPI2tigI5vM5s8wfVV6wuFiIVMljPeGdFDp1UbF2pBGjXYC84YQL2CYRlISlGl
         tQEQ==
X-Gm-Message-State: AOJu0YxQUDSVDTwSRxbGEtHAbTHY8fTSWUt1PJccf9zJfyBhKLyhyghd
	oTRsPXGvic8r1Gt3XAHsPE7x1AVh8fPPRCCepPy9meHAAU/VR92YWdJ5
X-Gm-Gg: ATEYQzxmyvcpJX/ieefO6mAKDJp4mfabOm4wHRijUKBtJZ+BcHP/KhfQ4+MBqJ9PiqO
	i1/1HwNOS42RNIiA1vbXsNBQMvUG4MQjartGlHRtBSvVxsC6lwQrFVd0dCun2I51EiNQ5DZAQgE
	0mNZdL97P8nvfK/FS+CCTN4md4EBEPvi0vuPmkSkRU27fBkLRUPTxGn6kawEfY+e+K02w7ScSji
	pMfwt6jzbRhl/i7rSi6Po+ijZQuTBtYhEKz7agIoi0JzHmSmI8AuGijNm60HlmUoLEWVw6aElDJ
	YBhkGfSCmpLBYYfrvrZMXh7Vp6PWZJcNTxStpC54cR7SaBsp04Ml9awhWaakBZI848qc9Ey0Wry
	W/gwhLgfh8Nr+i7LpJdBl092YNG0Uo9CO39savFJM0414bTlSvHtahMSgVUhPZ/ijQPcbNMFSWl
	fcLwIbL8HZTERRouop
X-Received: by 2002:a05:6000:24c1:b0:439:5fe4:421a with SMTP id ffacd0b85a97d-439d00638d9mr13330114f8f.30.1772837661460;
        Fri, 06 Mar 2026 14:54:21 -0800 (PST)
Received: from [127.0.0.1] ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dad8daf2sm7623665f8f.2.2026.03.06.14.54.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 14:54:20 -0800 (PST)
Date: Fri, 6 Mar 2026 22:54:21 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, liam.howlett@oracle.com,
	andrewjballance@gmail.com, aliceryhl@google.com,
	techyguyperplexable <objecting@objecting.org>
Message-ID: <3930119c-9dbd-48c9-89c9-393a7d69e885@gmail.com>
In-Reply-To: <20260306145238.e39787f9a09b68a82af7bfa7@linux-foundation.org>
References: <20260306213342.D7C02C4CEF7@smtp.kernel.org> <CAHgTTC+i_wUady+CQkkHf+BaQhGcjA21Qrxp8a+UXqvtvp8dAA@mail.gmail.com> <20260306145238.e39787f9a09b68a82af7bfa7@linux-foundation.org>
Subject: Re: +
 lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch added to
 mm-new branch
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <3930119c-9dbd-48c9-89c9-393a7d69e885@gmail.com>

6 Mar 2026 22:52:40 Andrew Morton <akpm@linux-foundation.org>:

> On Fri, 6 Mar 2026 21:36:11 +0000 kek ma <hlcj1234567@gmail.com> wrote:
>
>> Hello, I'm using Gmail because this is very important
>>
>> What needs to be improved to make it merge to linux-next?
>>
>> It says in your email it won't be merged to next
>>
>
> OK, I enhanced the message:
>
>
> =C2=A0 The mm-new branch of mm.git is not included in linux-next
> +
> + If a few days of testing in mm-new is successful, the patch will me mov=
ed
> + into mm.git's mm-unstable branch, which is included in linux-next

Thanks Andrew, I submitted another patch with the Cc: stable
Because I think that it is needed

Better safe than sorry :)

V/R

V/R



Josh Law
