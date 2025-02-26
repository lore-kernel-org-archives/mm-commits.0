Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98A9218ABB
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 13:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740575958; cv=none; b=oZj7uzJTZy6KiJtKPetoG6pH3v0QYoSkIbDpHNKTfXDRcl1Rt2wYlXFfmcdmuuPupwUVNQugzB/N6gQ/8RvaYMNOmGd/H0K5nKJKUpSPPQrVjO0BaHtmvfJ7N0srhZf+x2QqREu9xsn86UF4RCW8ep8nKrXesMdgN5/r9l8/IO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740575958; c=relaxed/simple;
	bh=2301NLFUUbZyunBneq+grukiaLeHCC2q7vGrgEhh9Qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JxC6CzYT0ujblym5uSKzLWj+azxEIIsTIjme0Z/4ddgcEvlPEekhLi5nerO5OyjKZnjJu4OZ8+dD807Okzpi4RDnhJbIr9JL5/zB2+RaswcIYdDhsOVL2CbubV09DCxiAf0YB0NMqlfEsiHuwq0rjnLcmw0/8X/yPMhscYpqUE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UfFh3FEL; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UfFh3FEL"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5ded46f323fso9414650a12.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 05:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740575955; x=1741180755; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LWGy/u2jG500lJOcAHOmIeRinxVE4qoxh82blT36DVY=;
        b=UfFh3FELKdu8v5AhRpsB9kSqHd59EnfD6tiwdLD/T58VdgyQLollnTBF6Hk20Uxo4X
         xrrHkzcUoOxDI2Pw3u3f1rpUrArA81M/34xATf0Za/XoCqtjWPRv0tqaEqaEKs5lUfbs
         pddDx4eAnJfg3LvB5ukmUBtou79t5bePS6tUaTwBQQmbmonyXX6kfcDbqxbpJDQfiIoa
         2m7Ubt1s0lQ/kyxIeIqA2vwfowsqSOeRBHYL1CMekaVDGdSHQCNO5ZlSKNoc182fGL9O
         MCvHDS8EL+/gqFgbAYp6X92MjMXAOqYpuS+NFyBa4pGxMtcQ3Nz/vV+aFicVmUtazEMR
         A9eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740575955; x=1741180755;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LWGy/u2jG500lJOcAHOmIeRinxVE4qoxh82blT36DVY=;
        b=R3k6OBEP4PvGtrvoYMCe/LoRA5F/xEza29VeKi0lRFZylE0qWrFZnLgCiZJLOz1YLz
         1F0qjAWmp3M9yL1KuwrL89PiwBAtBz7giYnYBprxd9z2nkYhjVM24JsCAVz77sk8mNYm
         LdAROfH1Rw2lA+Dnjby1piOvmMuMCJsUQzo9aAl8Qz/JzpnQ0is9TOfFWBTWh91qCyyw
         Czd9WxbGQM+ip0nB1fWWgT1SxGL1xAmbu6Ercw/R4ngcAvP0rwpBsEsiCdy44zo+I+3x
         UJoHXpy7bbYhypYVtwkkZBMXoari9t/G2cfNXGpVm/xyuo8YmienBRdGQmdmv/19AnnY
         /Viw==
X-Forwarded-Encrypted: i=1; AJvYcCWyTRlaql8DmgnpuAUCIxj6QhxC/vg6c9Mhom4dKGFJg+tUZB0VYioGTJJa/+M2A3UH0xUI4eY7nmyt@vger.kernel.org
X-Gm-Message-State: AOJu0Yza91f4uNmMbn2NO9dTVIEe4oxzqcxY5wd6Ah/oHoP7bmDmzT51
	ZtpbWqZ22C6O6MHw7uRge9/r4XRUFwk2nf5vGkLVHTF8ekhf1WQ2cG+GrEQy
X-Gm-Gg: ASbGncutmuZF9/NXkINtFHXZSsUlKLk/O3OfRirL/li1x7noFfJcJ3LT17UGgDoRhan
	3aFRS2tvbcibSX9utqseQqajsMNYsU2ZmmzVpbAF4D+HpYUCa3mu5RFQRzeqvWbPIeILLtRTPgp
	tXKX6/IBqARCl8cmzGXTfPDxrTrNd8lwPRQL+SJx+vFq6ZWyOEod0CjLN4Qj8wjQh68yvNlJShX
	lovG5VRiTGPQfU5F9C0xI2ClREHjQw25MWnZIOv7ElDU0XvXTuEqT/oRsj+n0H8KqSiNlMI5NgH
	pg7wIlalnv2UgcVULyiXslg5DZatR36pOdP8EamxwCC6
X-Google-Smtp-Source: AGHT+IG/NyAiamXsO9K/J/8aOjK3zDc0dzDz86IVN9+7zioDMs8H5UpfcYRwUWbrx1QXLxSpsloJuA==
X-Received: by 2002:a05:6402:2346:b0:5dc:cc90:a390 with SMTP id 4fb4d7f45d1cf-5e4a0e1b96dmr4138793a12.32.1740575954760;
        Wed, 26 Feb 2025 05:19:14 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e459c3fa2fsm2743273a12.5.2025.02.26.05.19.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Feb 2025 05:19:14 -0800 (PST)
Date: Wed, 26 Feb 2025 13:19:13 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, michel@lespinasse.org
Subject: Re: +
 lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch added
 to mm-nonmm-unstable branch
Message-ID: <20250226131913.ugcy7ujy4rbohykb@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250225042234.AC256C4CEDD@smtp.kernel.org>
 <Z725ERN5KDAANgD6@casper.infradead.org>
 <20250226022233.wjvxv2o6672vhkky@master>
 <Z76ZoxcFUIBSu63a@casper.infradead.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z76ZoxcFUIBSu63a@casper.infradead.org>
User-Agent: NeoMutt/20170113 (1.7.2)

On Wed, Feb 26, 2025 at 04:33:39AM +0000, Matthew Wilcox wrote:
>On Wed, Feb 26, 2025 at 02:22:33AM +0000, Wei Yang wrote:
>> On Tue, Feb 25, 2025 at 12:35:29PM +0000, Matthew Wilcox wrote:
>> >On Mon, Feb 24, 2025 at 08:22:34PM -0800, Andrew Morton wrote:
>> >> The patch titled
>> >>      Subject: lib/interval_tree: skip the check before go to the right subtree
>> >> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>> >>      lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch
>> >
>> >I don't think this patch should be added.  There's no claim of any
>> >performance win.  Wei has a long history of tweaky little patches that
>> >may or may not be buggy.  The interval tree has been around a long time
>> >and doesn't have a test suite.  This feels like unnecessary risk.
>> 
>> Your concern is understandable. A change in fundamental data structure should
>> be very careful. But I thought we don't take things personal.
>
>This isn't personal.  It's noting your history.
>
>If you want to add a test suite for the interval tree to the kernel,
>that would be a useful set of patches.  And it would remove my concern
>if we can demonstrate that we've exercised the code paths that you're
>modifying and everything is fine.

Sure, if my understanding is correct, the test suite is supposed to be put
tools/testing/, right?

-- 
Wei Yang
Help you, Help me
