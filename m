Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40D938B7D2
	for <mm-commits@vger.kernel.org>; Fri, 12 Jun 2026 15:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781277122; cv=none; b=jVR+ewXI4FooLqH45l24m1mhR6fJ+OHEG6VxFy+9uyStWA12BQgf/mRoPitJh477uNAgSyfh0PUlB1LOpxEHdFRPaJuDgtFs3nulsVhVxneyuNFE07lkSjZdWHEmh+0+f0mIwR2lVjifOCu12JTiucus8FHAXo2icDtZuHl0UiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781277122; c=relaxed/simple;
	bh=G75brgHYs2YfSe+Qlduz0qj9/u727IddI66jXx2vWFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O76wmp6XzOdN2G5hNJ1KCRq8VtNI1fYpb87CcYyDvzjmh6oIU8cjmdZNvAYJTWAkfxmcoBh2/jsIcFpj6kdm15bSSK5EbrYLtTd/l2OK9ry1wmhm3G7o0/ffNNN7y0A2CNmXeE8tPr/+i9jTmOiIYF5zu+P9Q0fqOguhAs6Z/0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=R8F3NSXq; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="R8F3NSXq"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-45ef6565cfdso572670f8f.0
        for <mm-commits@vger.kernel.org>; Fri, 12 Jun 2026 08:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781277119; x=1781881919; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uHz30rGtCI4aGvtHgmZ0RxbN8WTv9zc5L1bDGGQ4qcI=;
        b=R8F3NSXqmvxuJiPVMiMTT2M7+gajgYka5n3GMB/HqQshDvfcEDzCIKmjn5RgZK3KAl
         dYTNE5pMIgvPaIwfWFIgLtRF7ZwN7dPUx4G4YYmYEaj29y81BkpRhfclM1IXTCu6c+Tc
         F1AuXKVttlc3KmKirfr56KMjIA25UjKMAJfhLen/o/+AQp5MtxGVHp+f9EfMbsnmoo3z
         OfNj94Yxnr5ZspVAeW5Pj6hHfaTRy/Xfk8Ci8RPnNKAA9o482SSl6eOmZ60F6C32ACbd
         YRMdrKvQWqOT+QXrUfvQGiiqSZL3TflypsRFGdFU5Mfvn/74t/v9mS4g3IxE2cdxQvO3
         TtrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781277119; x=1781881919;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uHz30rGtCI4aGvtHgmZ0RxbN8WTv9zc5L1bDGGQ4qcI=;
        b=cmN5A93aFQDFUuu5ha3XWjuabO/TOZb5Aalt1LY4sXu+Le/dXOzYyloxeGmtxcdZK3
         jo4vPK2P+KQJVnPBJbZE1hhjDT3m5MwVPiltmxvW4HYe5FGpr6Pct/4UcqXS7SX1b8cA
         8kEzN6/NTbLLkb2Em9SeWbaDKJgQCVRmHGyuD1hNGouTukwGaTUSNbbMo9T9P16t9o4+
         lg7WFGnsEGaSl5fFJIyjGxSKprqt4Ge2hx3u8mTSNb6qrJKGQA3/Elj+akRCvmqSanMb
         kZccvIGbg+228bbOV2NptBidE/5uUGfszXvlEr1PJw3LLhZAafURNs8wxncYr3YRUoO+
         cCTQ==
X-Forwarded-Encrypted: i=1; AFNElJ/WdWzMoU5W0J1NLpqkDM1zPtbpOFhXiJRZWJXYt/dw6GuE4kWm45D9ILqPztHY4d7bXUfW7WdQyKKV@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9h64FrdFA6u7PfptpEm/Fs/MSBlL5VVvUXvZivE/MSmizfYb0
	KsxbsiX1vO4mW/ZrjULNUQerMGyYa4Aa4MIW3MHCqHuEBU73Ss08QcsMRVWYZoIEWIo=
X-Gm-Gg: Acq92OEmmIzGHKhUkbTN5yAu9eP6gqJz+cPewdK5e4gThxCf82GpcTbkOLYzdIXcSaf
	q5QFU87B+HzUFVMUaHCO4s2cAs5XCftQqVJrKW5sNF8PykRAp4aqfZEFI18s7e61B0vFFvmcpuS
	nsIi/0g8r8Ek4/+UZYxVq3PnN7m2nNl2v7pEQTrYMwHh0ZzSBs9Tl6jHU5lmp2NWG0ptLi2kTSm
	TC7Bnymje/wXuMTtHoi0/aIo9zp9XXps31IWk4B/lKVcpjiWgzbNHpF7uI7AW6GUxh6WQpheKlI
	7esrsoWiGCCtU54cYyyriQInxaqej/RP07twkFI1894EBR8ytSFZXKN/cMqgJRnyqGb9jdcGHK3
	rjEgCF9OKrO+5wg//WtgKWJJiiuUKNV0ZPUPvNpxlb1yXC31YTVWMUP9EpbTT9EE7UWHNCYzqHH
	Zk4zYKICtNyj1HpJNTQsXAe4qCiQ==
X-Received: by 2002:a05:6000:41f6:b0:45e:ed7f:1dd with SMTP id ffacd0b85a97d-4606db96b8dmr5403781f8f.25.1781277119080;
        Fri, 12 Jun 2026 08:11:59 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2dbfb1sm6913084f8f.35.2026.06.12.08.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 08:11:58 -0700 (PDT)
Date: Fri, 12 Jun 2026 17:11:56 +0200
From: Petr Mladek <pmladek@suse.com>
To: Tamir Duberstein <tamird@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, stable@vger.kernel.org,
	nathan@kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
	ansuelsmth@gmail.com, andersson@kernel.org,
	aleksander.lobakin@intel.com, agordeev@linux.ibm.com, arnd@arndb.de
Subject: Re: + errh-use-__always_inline-on-all-error-pointer-helpers.patch
 added to mm-nonmm-unstable branch
Message-ID: <aiwhvPaHef0pdm3-@pathway.suse.cz>
References: <20260526184100.3BA431F000E9@smtp.kernel.org>
 <ah6WDkwO8eYY5f2a@ashevche-desk.local>
 <ah7PWK4gTdOYG1t_@pathway>
 <CAJ-ks9nHkcgwdh7i8efAv=ka2rtX9o6ZnGZk5KeroCX2G_t3mg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ-ks9nHkcgwdh7i8efAv=ka2rtX9o6ZnGZk5KeroCX2G_t3mg@mail.gmail.com>

On Tue 2026-06-02 09:46:33, Tamir Duberstein wrote:
> On Tue, Jun 2, 2026 at 8:41 AM Petr Mladek <pmladek@suse.com> wrote:
> >
> > Adding Tamir into Cc.
> >
> > On Tue 2026-06-02 11:36:30, Andy Shevchenko wrote:
> > > On Tue, May 26, 2026 at 11:40:59AM -0700, Andrew Morton wrote:
> > >
> > > > The patch titled
> > > >      Subject: err.h: use __always_inline on all error pointer helpers
> > > > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> > > >      errh-use-__always_inline-on-all-error-pointer-helpers.patch
> > > >
> > > > This patch will shortly appear at
> > > >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/errh-use-__always_inline-on-all-error-pointer-helpers.patch
> > >
> > > Petr, shouldn't this also fix the problem with old (buggy) GCC for xtensa
> > > (IIRC) that we encountered in some tests a couple of months ago?
> >
> > It might here there as well. Unfortunately, I could not test it easily
> > because it required some old GCC.
> >
> > I wonder if Tamir could try to revert the commit 8901ac9d2c7eb8ed
> > ("printf: Compile the kunit test with DISABLE_BRANCH_PROFILING")
> > and try this patch instead.
> 
> Yes, confirmed.
> 
> I rebuilt xtensa-linux GCC 8.5.0 and tested printf_kunit.c with the original
> randconfig and branch profiling enabled, without DISABLE_BRANCH_PROFILING.
> 
> Without Arnd's patch, the original failure reproduces:
> 
> printf_kunit.c: In function 'errptr.part.2': error: call to
> '__compiletime_assert_313' declared with attribute error: BUILD_BUG_ON failed:
> IS_ERR(PTR)
> 
> With "err.h: use __always_inline on all error pointer helpers" applied, the same
> compile succeeds.
> 
> So Arnd's patch fixes this case and commit 8901ac9d2c7e ("printf: Compile the
> kunit test with DISABLE_BRANCH_PROFILING") can be reverted once it lands.

Great. Thank you both for pointing it out and testing it!

It seems that it is not in the Linus' tree yet. I guess
that it will appear in the 7.2 merge window, ...
I set up reminder to myself.

Best Regards,
Petr
