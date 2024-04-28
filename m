Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD906EB75
	for <mm-commits@vger.kernel.org>; Sun, 28 Apr 2024 16:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714320510; cv=none; b=WyK80CKZifZ0QSGh74QeyGTxGp8WphG4Z5jfehN90hb3VelPhMiTU6ehnzeK9mM75V1LjgDHV255+/z2kozuBJ58TwPzSG/MdkmptXKrfSxWve8AKguQToI0sc28PXgKvQvJHqaY7ph/1lekw7eQjeARFqL8rcY1YR8v94Lh1/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714320510; c=relaxed/simple;
	bh=8W6ieGEkDCedRCtVqh3B40rEb/WnwQ8+IpeuZkFpIn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EvXUPxCkC/cZ73xOWv58WdpmL01fiNkjEBoS+DgJLYu8WUuwqFGyiQ1CW/D/iHlivRFKDTa5I5XzEh2wlpHQkQ+YtD06HvCqbRbW3MdP55V36noPe4n4NJCic1+U3rH8R8YGGuvzobIlRSKOhhpxQbek7j3UfoW41J4QbHmFh+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ilX4qP1m; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ilX4qP1m"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-615019cd427so27969207b3.3
        for <mm-commits@vger.kernel.org>; Sun, 28 Apr 2024 09:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714320508; x=1714925308; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZlXvMzRleOEogcm+kgr/Nnw3JhuwiGELbo1bGaio11A=;
        b=ilX4qP1m7MJJ3r+Kahw0jkymKPeNX9B1s2BlzYuMIv89qQFH0ANUpIt1cg99XD9Trz
         LsByjrbfpkl851gI2fn4qwhIi75tojtzr6UrqM4/PhJamFLyOdLRFdsqqSEZF4l6LtHt
         2Bq/jL/xYMTpN46SLpuYu8YdGynib88WU0IL9Gt1cL0//KTmwqBnEliMfi6oJ3Ggz0Jz
         AQD1Dhg3xuUr9dxVYwcMtwAiqaTbDSJWxnP18O7n/UAJ8AJXjQAULy9eC7bBDTJaLVkB
         Ce/Q8C/bxfHn8geD2y9WHVovQTzCVCpZJA5KW4ah3s0XnY16/Y5PIa4AMqqhAC1GHP2Q
         Rp4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714320508; x=1714925308;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZlXvMzRleOEogcm+kgr/Nnw3JhuwiGELbo1bGaio11A=;
        b=v8hV/slimFI4+nXjl2suSsb7KyojIsv4Y9q+//aTEmu8kIPHrdtu4cmi96Q3RGENwb
         zsvtG3Gu9pXbDrSgVpyQmvqgc8+aygzp2H1at2xX6iRXAugVpGxWRfpddqsKZN9Tfol8
         0RJPtmeTLz1em11vOfDqctSpidWY9jPP94k0RmmwHK8+ywYsWGSnT//mWw7SrwRQMYVN
         HJ/VQKdZd9JhsTYbmKM6C0OuuCAuoEGC8IDgbuYyqZEjNkV/dU5mGmX9Njy4bxY5a5au
         +1pNr+MmmckYwkInUW+WIA3Itdu04gzx3DH8daVE3c/vND7LngVdyIr/tK6wr+683Y7q
         Uxhg==
X-Forwarded-Encrypted: i=1; AJvYcCU+yVrgsq4o+FnepkFhy9TXEqRPTee5qK5BiQD6pH2SX11kvq8qbZ+GSW/4SdbaU6j1wrKCW1SAnhfFTvR4DzHybTnvk/HTHJbi7g==
X-Gm-Message-State: AOJu0YzFK/t6rw1DuAo8QgogDOrzvSnQ9/CIvTQ0SU/5CIzjp4UQTCI3
	ISV/yeIoNu3BjjFLx2+cy2JMZrDIjDoF87/snOjK5FN4d23zcInWMBU9sA==
X-Google-Smtp-Source: AGHT+IE3bfhZqFXW9taiTik0iBEiRRV/0aQS9EpbqgQeW/TxeGbqdtQR9IolXVN3UHTykaAqYjVtaw==
X-Received: by 2002:a05:690c:387:b0:61a:e947:550d with SMTP id bh7-20020a05690c038700b0061ae947550dmr8028123ywb.44.1714320507916;
        Sun, 28 Apr 2024 09:08:27 -0700 (PDT)
Received: from localhost ([2601:344:8301:57f0:ee06:6d35:2cff:4e7c])
        by smtp.gmail.com with ESMTPSA id j16-20020a81ec10000000b0061b055e78d6sm4945102ywm.111.2024.04.28.09.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Apr 2024 09:08:27 -0700 (PDT)
Date: Sun, 28 Apr 2024 09:08:26 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	jserv@ccns.ncku.edu.tw, n26122115@gs.ncku.edu.tw,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: + bitops-optimize-fns-for-improved-performance.patch added to
 mm-nonmm-unstable branch
Message-ID: <Zi50cAgR8nZvgLa3@yury-ThinkPad>
References: <20240426190857.BB28FC2BD10@smtp.kernel.org>
 <CAAH8bW9o+d48_84mWXwYkVgMzY+__UxfBnuzauci4qgt1jFZ+Q@mail.gmail.com>
 <ZiyOQ7RtG763rUSJ@visitorckw-System-Product-Name>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZiyOQ7RtG763rUSJ@visitorckw-System-Product-Name>

+ Rasmus

On Sat, Apr 27, 2024 at 01:33:55PM +0800, Kuan-Wei Chiu wrote:
> Before:
>                Start testing find_bit() with random-filled bitmap
> [    0.299085] fbcon: Taking over console
> [    0.299820] find_next_bit:                  606286 ns, 164169 iterations
> [    0.300463] find_next_zero_bit:             641072 ns, 163512 iterations
> [    0.300996] find_last_bit:                  531027 ns, 164169 iterations
> [    0.305233] find_nth_bit:                  4235859 ns,  16454 iterations
> [    0.306434] find_first_bit:                1199357 ns,  16455 iterations
> [    0.321616] find_first_and_bit:           15179667 ns,  32869 iterations
> [    0.321917] find_next_and_bit:              298836 ns,  73875 iterations
> [    0.321918] 
>                Start testing find_bit() with sparse bitmap
> [    0.321953] find_next_bit:                    7931 ns,    656 iterations
> [    0.323201] find_next_zero_bit:            1246980 ns, 327025 iterations
> [    0.323210] find_last_bit:                    8000 ns,    656 iterations
> [    0.324427] find_nth_bit:                  1213161 ns,    655 iterations
> [    0.324813] find_first_bit:                 384747 ns,    656 iterations
> [    0.324817] find_first_and_bit:               2220 ns,      1 iterations
> [    0.324820] find_next_and_bit:                1831 ns,      1 iterations
> 
> After:
>                Start testing find_bit() with random-filled bitmap
> [    0.305081] fbcon: Taking over console
> [    0.306126] find_next_bit:                  854517 ns, 163960 iterations
> [    0.307041] find_next_zero_bit:             911725 ns, 163721 iterations
> [    0.307711] find_last_bit:                  668261 ns, 163960 iterations
> [    0.311160] find_nth_bit:                  3447530 ns,  16372 iterations
> [    0.312358] find_first_bit:                1196633 ns,  16373 iterations
> [    0.327191] find_first_and_bit:           14830129 ns,  32951 iterations
> [    0.327503] find_next_and_bit:              310560 ns,  73719 iterations
> [    0.327504] 
>                Start testing find_bit() with sparse bitmap
> [    0.327539] find_next_bit:                    7633 ns,    656 iterations
> [    0.328787] find_next_zero_bit:            1247398 ns, 327025 iterations
> [    0.328797] find_last_bit:                    8425 ns,    656 iterations
> [    0.330034] find_nth_bit:                  1234044 ns,    655 iterations
> [    0.330428] find_first_bit:                 392086 ns,    656 iterations
> [    0.330431] find_first_and_bit:               1980 ns,      1 iterations
> [    0.330434] find_next_and_bit:                1831 ns,      1 iterations
> 
> Some benchmarks seem to have worsened after applying this patch.
> However, unless I'm mistaken, the fns() changes should only affect the
> results of find_nth_bit, while the others are just random fluctuations.

So...

The patch itself looks good, and indeed it should not affect
anything except find_nth_bit(). But -40% for find_next_bit()
and find_next_zero_bit(), and -25% for find_last_bit() don't
look like a fluctuation by any measure.

Looking at the numbers, I can only guess that your testing machine
isn't trustworthy, which means that +18% for find_nth_bit() is not
trustworthy as well. Maybe it's a sort of virtualized environment?

Can you share more about your hardware? Can you make sure it's a bare
metal machine and run your test compiled in the kernel? That way it
will run at boot time, at least before any possible userspace payload.
Can you also run test_bitmap? It has some functional testing for the
function?

> Should I include the above benchmark data in the commit message and
> send a v2 patch?

Yes, I'd like to do so. Because the current benchmark numbers look so
weird, can you run it again? Maybe several times before and after, to
estimate the scatter. Also please run the test_bitmap to check
functional correctness.

Since you already have a code testing the performance of fns(), can
you add it in lib/find_bit_benchmark or lib/test_bitops in a following
patch?

Thanks,
Yury
 
> Additionally, I apologize for you not receiving the email. I received
> the following "Message not delivered" email, but I'm unsure if it's
> related and what caused the error:
