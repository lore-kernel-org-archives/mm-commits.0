Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D94B1624E0
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 02:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740536557; cv=none; b=iJT2wVEbe2kPaKd0E7GcDvNoHGo9xNktutLu+9jkTixq4EQXDcPnRZeHWKPQG4qpzgGHrbFdn8PJmL8UdEh0e1lTIJAO09jmKWmsezlQYHGlt8mN2HML14t+cZai8Uq5EAEfX3Cd2Wzc/4ilDQ4ve1M8g7VxaQzNrEo8oQtx8HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740536557; c=relaxed/simple;
	bh=HcC5Ut1hNrTX6svqPAx/JMxMRHfZjZsMZuRyGxAeJ+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fr37G3KXef1eZ763xbJr8EfEZgkiSUTevGaHCzIy2FE9jGMImTpoBU/eKzbhocXaOoS1nhiADsi5+sz04bl30ieTXK0z0l2NmAT0wbB/ugbQwKmXYhRAXG01/pSux/KXKAme7+nMn1VwQOYgRuwBaKE7cOlVWb95KkDIdaV3GJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iw4rrtOj; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iw4rrtOj"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aaeec07b705so1049564966b.2
        for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 18:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740536554; x=1741141354; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K8tZ49WFho0BEJOJCYVPAkiM8Hu/TdWSvSCG/EdklLI=;
        b=iw4rrtOjXGYf43Ql0lvI4qtrkzvcgXlc5i/PYVfNTM61GeuFHLKZPVfsHf6NnS3HCy
         ZpknZGhm6+8DngPnvI7RMQ4kbrXAqxj8VKFdYGNcugzidCnpGSCTAfxASFDTDAMtRd82
         90ZkK6scjTIZXkizYM7Gm8L1j8gMDhLHsQ86S4sWpBStR3j6ffur0Rk102QaOya5kAmC
         soWFOfSJuv+zjJUrxkhG4wgwzIkQYlIj2VHcHYBJ3YXf29A5FHWMInas/s9OQgfnTd1y
         uyfWhctIAnobP33hsq1EvuHlsMr37X5iGIPZibkPPY/SRq7cZBFinQB/BTHEClR9AAIL
         DqjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740536554; x=1741141354;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K8tZ49WFho0BEJOJCYVPAkiM8Hu/TdWSvSCG/EdklLI=;
        b=tsBqXIhQfzE6lOojM+ZIG5dQtqLQ3DzBi74EnD2D5A254vWlUixCEZcp87LIkrVafW
         RCQ4CGoCzMrvkygk7HHhQZTeTS4k1rszKBW4lXiw9oFHrB+P5F0NPa5uNT5mEPalBmDY
         ciLtwYb/uNrErDfhdMhXKC3lj/T72Ze3n6K2MEjiOihkrzQOrjaKl2oscwt91sBC5c5z
         X/h1lf8Hqfh7KEz464/CzyE+EhdOounlIjvuLkb01CTS7x1DHWp1lFEnBBVmIMD1zXkU
         //R4Iy0UF6aRAyn3tL1AxpDDDNGzxd3jGuKsTk4G6cvb2JLHgMS1TdP649f4UuUACxc7
         wpOw==
X-Forwarded-Encrypted: i=1; AJvYcCX6p720UpyE6ByNZihP+xD3tkzk340DB25ymDFzK0ey/S1tqaYORJsLJEPACWa8GtmrdqgersmktujY@vger.kernel.org
X-Gm-Message-State: AOJu0YwV5Ww5gCgxWutrr0f7ZJ7eflgoRwzfw2pn93wYRuZ/DdFATJME
	mBGtcLXk+EJVXUx1daEyKiOVylnm2cbSbml7SPTBY/V5mvOmWxEz
X-Gm-Gg: ASbGncuoft5wvUWrQ/qChVVuSLBxBxiXWiV6Dy6owWxKxTlXGRlnTkpSlm5nJZ1wDIn
	xGtYmzdD7Hbe4jXEPT9h/IFXJCzidHuEvmh/EdKmmbHxzfppffF5VPAi9HUmgxJMBi/AqZBFlZf
	rb4AAVvaqTRivPWwfRCMy2vDraf4sCdgmFBhHS0QDNqLbI/6h61dISI4M7hrecoxw0qJ7ZnkNib
	OMLWdJfNSLlAOUQZrSOBMVyI45UJUa/U1Nr+onKqCD7RFdNFdqDj+mA1s5Pey7LtC/PzWKTHAhY
	epJfjMxRsM0plXc3w+XoGflklA==
X-Google-Smtp-Source: AGHT+IEJABHEiumPPwUsp3qetkr0M3qiTDXxYgyIhj+2dd5ShIIJNnRVCikkAKHr3QKNnmexRwupbQ==
X-Received: by 2002:a17:906:318b:b0:abb:b322:2b37 with SMTP id a640c23a62f3a-abc0d9888eemr1479245766b.7.1740536554371;
        Tue, 25 Feb 2025 18:22:34 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1d5ae56sm242435166b.57.2025.02.25.18.22.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Feb 2025 18:22:33 -0800 (PST)
Date: Wed, 26 Feb 2025 02:22:33 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	michel@lespinasse.org, richard.weiyang@gmail.com
Subject: Re: +
 lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch added
 to mm-nonmm-unstable branch
Message-ID: <20250226022233.wjvxv2o6672vhkky@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250225042234.AC256C4CEDD@smtp.kernel.org>
 <Z725ERN5KDAANgD6@casper.infradead.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z725ERN5KDAANgD6@casper.infradead.org>
User-Agent: NeoMutt/20170113 (1.7.2)

On Tue, Feb 25, 2025 at 12:35:29PM +0000, Matthew Wilcox wrote:
>On Mon, Feb 24, 2025 at 08:22:34PM -0800, Andrew Morton wrote:
>> The patch titled
>>      Subject: lib/interval_tree: skip the check before go to the right subtree
>> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>>      lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch
>
>I don't think this patch should be added.  There's no claim of any
>performance win.  Wei has a long history of tweaky little patches that
>may or may not be buggy.  The interval tree has been around a long time
>and doesn't have a test suite.  This feels like unnecessary risk.

Your concern is understandable. A change in fundamental data structure should
be very careful. But I thought we don't take things personal.

-- 
Wei Yang
Help you, Help me
