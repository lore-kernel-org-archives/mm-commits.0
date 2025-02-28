Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F20C182
	for <mm-commits@vger.kernel.org>; Fri, 28 Feb 2025 00:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740701182; cv=none; b=eR+H/pWjV02fN2zGb+DATtok+K+Y3MS4CXnyQLgUWEr/DDFfhBuagsl17IdOMPzX7DFh9h6S/ilhd4zzpoNkytSpnhz6wqoUrrSPUL0AsC6yjpFhh9BGKoalNCOtTYQuSJ31oj5P5MIpUQN5nJ/LIXjODVol6wQxVjjt5R5bvXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740701182; c=relaxed/simple;
	bh=ReSeQ6ygGS2HQe93fQVupsdsS4NRH9eZXkamuAUbMzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W6UlnjW/1i6sHBjrpChSesUYIfmsHOmTEF+9EHfU+c+F5EMQfZLsYN3wOtqp2O86Rizt7uk+mWxAufhqRSSg3g0DbXdQGRar8PHdQEwWQMzAo2RmM9fAMWsNQ8HNwLOrAdvHfaxAEXBkS4iqXxzobIsr+ExtydUfL5xDhsE3qrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kXR4K19c; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kXR4K19c"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5e033c2f106so1695236a12.3
        for <mm-commits@vger.kernel.org>; Thu, 27 Feb 2025 16:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740701179; x=1741305979; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+SrzlGgyoX37to5jOWGt2e0omt/W9C0mISlHQKB0yMs=;
        b=kXR4K19cWhjLKWVUcKRDPLUtfaMQnYVwmUda5eHkLvvZJbgdPhRCCVZBZzvWdcwoC5
         ymBKpxJW1/JRnqT5tjMGnS+kOy/9/PMJkYVIAiehtU/BcRbmfuTwj86JeWUk5TgENUCz
         lXIE/HMi14vHZYeHLjVAzKAlBLPO/Fhw2EzeCEa5Frm/TFytn4Da7YT+iZGiOl5aUri0
         HMIV5+nvalfZVFzTJ8huiyvtPpuOwwAin1rPfqPB0yRjyIPNTzY2BPWylQuijuiLYOQV
         QerR0r1cw9uYGgJH2MZxXRVDuI145j1wIMpvQHFATLmeMJ4qM8b6K++TybdPgOUepqC7
         J7wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740701179; x=1741305979;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+SrzlGgyoX37to5jOWGt2e0omt/W9C0mISlHQKB0yMs=;
        b=Q0VxITi01Od3rw6SYkKtgDRllp+Ewo571D4zf2ZbxAveF0AmM2GbO7zyFq58Ei3IQe
         IYde6gR+HMz4WZg38BNyGJ9sItYagngXaNfmV7/wpsO/QSILVmthSBTiZdfQ4GZ+5jI+
         r1h+T3K8Sx6k7jgJ+HP+yDByH/o6twLUdpoQVqJVnWOnIT5ybM7+YX80F/Fo+szavOnu
         x0j9YCxPrJvHWJ7/Iuwp0lOEPYIcj3GUetumtuCQMO4JMwo6Djc78qjz9wBaWgo7Vez2
         uvCmQM1VpuEGjN2Rr7TmmIHk4x/28GMS4gKyGh5x0vfwS9RUkuosrdP9/WVG8JOXmeEm
         Jncw==
X-Forwarded-Encrypted: i=1; AJvYcCW47Q7nYP4BE6oSbu2n7ytVdbv6RMSTDKN5gUntbaDpaABu0Shdl+PGWiW3TBvxYUl2zQom3WucN8yB@vger.kernel.org
X-Gm-Message-State: AOJu0YxTc30Sd4DaK6zMZ1pLk7A26VwnVV2UtOe5oVaLf68eClrRzmxm
	IaGXb29RcqQUv4ASRLaaLz2Q2VDAJ3e+OUwEHX1UeVB3qZjrYytm
X-Gm-Gg: ASbGnct6qiJRe9/wxKlvogK/4diJY20LuVmAeK7Tapo3tjmp0pJkKx58hFTCS/xcNtl
	ZcXfr2F/0sLC76jeamtz1iKB4JLCPP5nOKPgb0Q8CFlXeESTtoVp8ljU34csDNaa5DlITAC6XFb
	XPXsm9z/KfbjQP6PdesprSpGpUcfUUVwpxomneVCpES5BUwWZAz/SYq8lNoM8Xdqf3kt1KUYd83
	Vc7ioInD1Vsw3cIMUQy26hoIVc/BMnUIJsHI7bh2Be4a5djawm3+1zLnfcBD0CdTR2d77nH9VEQ
	CnS865av7FZPKgAKCuKumjwGIA==
X-Google-Smtp-Source: AGHT+IFwNXC7WeLo8HU6fW7x/fDHmGRswpIujelw2yjvCDBzOeYcWJla4BZ0jgja31WN3lX+x7RtBA==
X-Received: by 2002:a05:6402:274b:b0:5e0:7510:5787 with SMTP id 4fb4d7f45d1cf-5e4d6af67efmr2554433a12.19.1740701178895;
        Thu, 27 Feb 2025 16:06:18 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e4c3b4afeasm1739709a12.3.2025.02.27.16.06.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Feb 2025 16:06:17 -0800 (PST)
Date: Fri, 28 Feb 2025 00:06:16 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Michel Lespinasse <michel@lespinasse.org>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org
Subject: Re: +
 lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch added
 to mm-nonmm-unstable branch
Message-ID: <20250228000616.xte5du52imypjyrw@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250225042234.AC256C4CEDD@smtp.kernel.org>
 <Z725ERN5KDAANgD6@casper.infradead.org>
 <20250226022233.wjvxv2o6672vhkky@master>
 <Z76ZoxcFUIBSu63a@casper.infradead.org>
 <20250226131913.ugcy7ujy4rbohykb@master>
 <Z8DubWlhB5K4WgGG@lespinasse.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8DubWlhB5K4WgGG@lespinasse.org>
User-Agent: NeoMutt/20170113 (1.7.2)

On Thu, Feb 27, 2025 at 02:59:57PM -0800, Michel Lespinasse wrote:
>On Wed, Feb 26, 2025 at 01:19:13PM +0000, Wei Yang wrote:
>> On Wed, Feb 26, 2025 at 04:33:39AM +0000, Matthew Wilcox wrote:
>> >On Wed, Feb 26, 2025 at 02:22:33AM +0000, Wei Yang wrote:
>> >> On Tue, Feb 25, 2025 at 12:35:29PM +0000, Matthew Wilcox wrote:
>> >> >On Mon, Feb 24, 2025 at 08:22:34PM -0800, Andrew Morton wrote:
>> >> >> The patch titled
>> >> >>      Subject: lib/interval_tree: skip the check before go to the right subtree
>> >> >> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>> >> >>      lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch
>> >> >
>> >> >I don't think this patch should be added.  There's no claim of any
>> >> >performance win.  Wei has a long history of tweaky little patches that
>> >> >may or may not be buggy.  The interval tree has been around a long time
>> >> >and doesn't have a test suite.  This feels like unnecessary risk.
>> >> 
>> >> Your concern is understandable. A change in fundamental data structure should
>> >> be very careful. But I thought we don't take things personal.
>> >
>> >This isn't personal.  It's noting your history.
>> >
>> >If you want to add a test suite for the interval tree to the kernel,
>> >that would be a useful set of patches.  And it would remove my concern
>> >if we can demonstrate that we've exercised the code paths that you're
>> >modifying and everything is fine.
>> 
>> Sure, if my understanding is correct, the test suite is supposed to be put
>> tools/testing/, right?
>
>(I accidentally sent this privately at first, resending publicly now)
>
>I haven't touched the code much since I originally wrote it, but I
>think the logic of Wei's patch is sound.
>

Thanks.

>Even then, I agree a more robust test suite would be nice. There is an
>existing suite at lib/interval_tree_test.c, but it's more oriented
>towards performance testing that correctness. It would be nice if it
>checked the interval tree invariants (i.e. that each node's ITSUBTREE
>is the max of its ITLAST and its children's ITSUBTREE) between
>operations, like lib/rbtree_test.c check_augmented() does.
>
>I know many people don't like test suites that involve randomness, but
>personally I think verifying that inserting 1000 random nodes works as
>expected, and repeating that test 10000 times or so, should give
>reasonable confidence in this code.
>

Let me have a try.

>--
>Michel "walken" Lespinasse

-- 
Wei Yang
Help you, Help me
