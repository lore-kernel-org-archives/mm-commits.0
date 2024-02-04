Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6629514F64
	for <mm-commits@vger.kernel.org>; Sun,  4 Feb 2024 09:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707037778; cv=none; b=T2hs9FGPkm5FqZCjNNwg8CH957qibJykAsLUTDgCasO/NFLO+FXnu2LJabra3b7oGm/K1XTQSO0PjGYnp63eUrZ1Sy38HRF4c1eOFJcbOrM3wkB8qPb5mvrjLt8n+yBlLujk+pP+qtvOcbv+sT9ZIeIIOD+v2eARIB9Dxd3i9YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707037778; c=relaxed/simple;
	bh=QBfO/fVBUGbd2B+gQQfdgwvVTKuSgWnOSx8bYhh8dmQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N/mbnSLyM5p/i+X/mYpLCp0/b+IqytkwazOXjmKFW7Dr/39I9dmJ4Zf30mjhtHhB5XhUSkv2pAQTIvfGVwv6WRgRhVQO1H9h2YZgYx62zXrrnd7fcSyHeMg/ojWbSu5cjLfLil4CRe6pWieWVRm37c74HODodJi3K/Lc09MJseE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gncM030U; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gncM030U"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a364b5c5c19so546377666b.1
        for <mm-commits@vger.kernel.org>; Sun, 04 Feb 2024 01:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1707037774; x=1707642574; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=x+bOGtvhSdoCBkpFP05S+UJkiX09M/YWlTNg9SFndfw=;
        b=gncM030UZAvl2LB2ccvmneHHmycj76VEuddzmT1PE7mWq/IrGHLGNa/KnJ9siLgn/p
         0Sv7PI8XZmDqhI7Qokokz4uOV7SoNpeiHmzVA1HwoyrYqu/CAtqlJGyz+vy8uSx87kh5
         /GQtFA/MzQIe8Ln0EqV4rStiC6A6ZF6MkOayk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707037774; x=1707642574;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x+bOGtvhSdoCBkpFP05S+UJkiX09M/YWlTNg9SFndfw=;
        b=QyJmE1EcjLtv20ptampjOdPUhtot5HeWNp4OdD+znqFPkqXr9XwjoScVkqTykN+1p2
         oHz7htocqZ7Iqq/d8FWCNZCSmKlPmxLZFfA5UIqOjSCWag102Fnl2HiUlb99V5Lciulc
         PMS8rrxl3IKCqG6rDsdnIWCniJ8vxy0fRrWnunZLzD2hdhchWENx4z0pJF4mW/HFKWXB
         QDT5ZEROWgB/W8eyykxiMYiDHJYUaF5iCwNVMvfm2yi+nukvBPvyQGGrtKgfbn2u55Li
         WERUoQ7o/5Llv4hNmUYltmC+C2Q5FGoDjSmHS5oMt05o30qIc26UD6+mTU1WovnKN1PV
         WIIw==
X-Gm-Message-State: AOJu0YzyLHGZHCUVrtIKDiDd9Eq5uQTjvovGMYdAasaRfWH+O9gyE6eY
	EqP16Cvk6tzXwLAoizjb8WIoACQx0szSiJH9TWA8mebQB3u5EovcMQMmLGapVXFULD2oC5jQOwA
	mFVU=
X-Google-Smtp-Source: AGHT+IHgDv6nJfGwFvLdvNuVvCh9MTmWMa2+d/xAUYpNBC7vMe4DaUc04GoXETxHncZt7bk5IaaKmw==
X-Received: by 2002:a17:907:7711:b0:a36:f27b:f0f with SMTP id kw17-20020a170907771100b00a36f27b0f0fmr4661571ejc.8.1707037774490;
        Sun, 04 Feb 2024 01:09:34 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWFLE5tJ8IJWDLEUtDy21F86of/97/ikTXZ5oqeaSd1NpQTL3cHTVEID2y5AeUagu7J9RNzucjaFL06WUiIZnBG/UerktBSxwlpyA==
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id h8-20020a1709063b4800b00a369b47996esm2931601ejf.80.2024.02.04.01.09.33
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Feb 2024 01:09:33 -0800 (PST)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5600d950442so1281125a12.1
        for <mm-commits@vger.kernel.org>; Sun, 04 Feb 2024 01:09:33 -0800 (PST)
X-Received: by 2002:aa7:d4d1:0:b0:55e:eb81:2db0 with SMTP id
 t17-20020aa7d4d1000000b0055eeb812db0mr2894600edr.38.1707037772839; Sun, 04
 Feb 2024 01:09:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240204085155.6745-1-sanpeqf@gmail.com>
In-Reply-To: <20240204085155.6745-1-sanpeqf@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 4 Feb 2024 09:09:16 +0000
X-Gmail-Original-Message-ID: <CAHk-=wgxkAgRPb7ZZ+w7UHhp2OuV=pc_C7D+hEYcA65ieMFt0g@mail.gmail.com>
Message-ID: <CAHk-=wgxkAgRPb7ZZ+w7UHhp2OuV=pc_C7D+hEYcA65ieMFt0g@mail.gmail.com>
Subject: Re: [PATCH] lib/bch.c: increase bitrev single conversion length
To: John Sanpe <sanpeqf@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, rdunlap@infradead.org, 
	unixbhaskar@gmail.com, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 4 Feb 2024 at 08:52, John Sanpe <sanpeqf@gmail.com> wrote:
>
> Optimized the performance of the three functions (load_ecc8 store_ecc8
> and bch_encode) using a larger calculation length.

Honestly, with any optimization, you should quote performance numbers.

Also, it's questionable how meaningful this is, considering that most
architectures dop the bit swap with a byte lookup, and the 32-bit bit
swap is just four byte lookups. For all we know, this only makes
things worse.

Finally, if you actually want to do things in bigger chunks, that
->swap_bits conditional should probably be moved out of the loops, not
just have that questionable 8->32 bit expansion.

            Linus
