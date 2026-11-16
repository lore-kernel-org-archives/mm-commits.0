Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794808923;
	b=CofiFo37Zz20iCnLr+Jf+NZmi1LF3ez/8I3uKCeIDQREljrgOJ5hqzg50Zo1dB6KtHcQ
	 MPRPK1+8K2QaHXFjneE7FxBd8vxYxmCPAtZyE4VOVwFYY41aSb6vKLCPbq0Ea4Qlznjql
	 uqJA2TzU+02aoOc9RvmGVdCOYZuSIHZqybzd4j/wUb8RsbiB/NM9Iq6s7lVkig+D4iN2W
	 EyShclL4rQOnsXjvcDDB+gwcyVraz7dz9KWcRCJ1gaa3bwOl/eRBa2kRvhckhq3Bkvrlh
	 Ju8kuowMcsgWUBsd4tNuIXTe7Dn/XfAk+C8k8KyfZpbJlhR3P8YFmDSa+wcN/65dL+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794808923;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=6FNxbnnu/0yNQoPXbolulSs+Roxu0nUNixTH/GF4RF8=;
	b=VOFR/C497R8xCwvHj8apyY2hC6CLtTgxG2FW//8XTIftL4HN0l6FbSBACzv2y5LIGNYs
	 o5Bo/8nrtonzeTtziNRj3wU7lRcTDD/DNPzY/0XKDYiTrOhm2xCzMhxT7QNijXUwLfvIv
	 t532Xes6eglUqJmH+KVL2LNyjtgpP9VUxQi4vHa3G3mcaZYWd505/6ZaqLqO0Wub8r81p
	 xCMqQy+/5lfrXPDRpGIJ7a1p/DNgklGeR4Vjwu18RJQ/urTq5mX8L/Zkbz/0b1gtXB0Mv
	 XLAIfScLPZ/B6LolDWzWaj8umni66YGA4EK97HgVDnLovqp+jjO3vXAnL8jM+J78UzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MdGh1yX9;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C020606A32A
	for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2026 06:02:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C020606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MdGh1yX9
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso17449385e9.2
        for <mm-commits@vger.kernel.org>; Sun, 15 Nov 2026 22:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794808921; x=1795413721; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6FNxbnnu/0yNQoPXbolulSs+Roxu0nUNixTH/GF4RF8=;
        b=MdGh1yX9fXTnvzwgUdmioMln0+1LpRYnfZwcBYN7HPJ86PKVMCwMhLoQUp1f1znlW7
         cJBPUPvA3tB0d2j5VyPcJFzk1agBXNvweMfIL9P6KiY7al01zGA1TlNJ1oa2Kdu8AUA1
         2QhhwS4jS8Ye7O2/DwZTliONxgssSvlmc76tkQLdqAMNRoTCpg2lZ6pNmnqNPHE7Zc7R
         sYhxYuO8Xk8vYFWkGrCFkiZRpw6eIsDTJguhoWxSbUNhkqzw2cDXhyfoMj5vk3n+xhs0
         eqDWBphmh9ntlonmYa2nmSX/YouVJfS+ISSQvJKnWWkOG/IA31ruj3OEs4PtnR5A0IDA
         mJnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794808921; x=1795413721;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6FNxbnnu/0yNQoPXbolulSs+Roxu0nUNixTH/GF4RF8=;
        b=tcoZZb86Silx6v6MSAwOGb30jVyNDEDC5VfZW9mfGrBT5dyUQ+oEWRFvWjOxMAr1q5
         FYL1pkqkiSnX3ExZ5N08iZ5B6PB/GSvoaxDX3nGdZHHMkYQhCh3QrowLwz+SJLmghq66
         6WnlcEhJOXp7/kDKQ/pgHDHRbqGdJpbH5Qx9zKHXvU8dVQh8YpeS7L+gwvFs0crKQY7Q
         fR36BohCvZl/rXVjnw79S/bCg/dfEXQuaaEQ1m0NRBTuwCzzE5+0jgprbzTg9ziZoAy9
         +25kKw3rlGVUxqsoPuu7bCydvzfJdPgZzK2QZLMdqHM0+BYv6Evoyu6RX6uNxlFDEHPU
         D/aw==
X-Forwarded-Encrypted: i=1; AL+hErFfsQTCRrdtKGF29FT5Kp/LrYi9+t0m+6gF0Wo3sDJ2xfeMt/ThVx+xdylD+suVQFX1//1NXlwixV7d@vger.kernel.org
X-Gm-Message-State: APuU4Z9XlJPyg6shGeRq37zD5u1F31BM9Fl021HVEdcIRYTwv6JczUNJ
	DfcHNjnQYWCSSDsC8FwswjLHi9B0x7XCVfHingIr6O69FeiU0EtqKybOJ9NpPJac/82WJCK0
X-Gm-Gg: AYBFou1xVTrl1mykQSAhR2x1yJufxx9lQcZegvcKrbbFLzmkwbQHclgVMu34QLV1oB0
	xYccZtyeEsvGPISzqlAFmP0AuasyRi4Ez4Pi5PjmJ8ou5SlF3czhQ8LTwCOij8m3yLhD84ZWadk
	VSRSvxhJBzn9PgHn/bR+/ISskzhzjPakEhWckymU0AQZPL5RTqRHSUnhdRuw2rXJtO2oFrYsg55
	MhZ9xuuHnKsH3c9nnwkuswpXAaD9eSxJiYWqwduvRBBdhz2MboxVu5xcFpYldyhoLsESwqYMgD7
	6gGexFQ7Fo8l/xXMR8kB56AR85bjPtMkA9KTo/XJfK88DfJi1XDqr260VOdLMmMVUP4QBCxonCA
	/UwNy+1onZzaEck9rGesrT3LS8rZgtGNzRt+nt9kkkKHjloiTox8SGCslCWYDitDwSZgkzRFnn0
	LsAfnuIgiuRLCBq6ijKi2Q9NHaboZVWpAupgEQv+TyuLq2Lwf2tg4gwPvkC8t+hqsUCr1fDyq7p
	Zy0FD29twsHtqik1qQxgb6FTVThymP1zc7XtAwO7h3RooS+Oy3dK2YfVXpUPGeNCu+qI1iLFMjG
	5i7Xlpf1x2j/z4G5zDqSQQoEVE7aAcxDTv1UJzIFCgrM649MjhSIodrFmrKm1TH8DdqA5Kgim4w
	fP1j6Qj3m+ooKoFsRj981g4wGVd0+aWNht7XAjJGQsVghHbwZvagMtpwuKo0hh2hs65c=
X-Received: by 2002:a05:600c:c165:b0:4bb:685e:cc42 with SMTP id 5b1f17b1804b1-4bb685ecce6mr91958735e9.18.1794808920781;
        Sun, 15 Nov 2026 22:02:00 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e29daa5sm372885465e9.12.2026.11.15.22.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 22:02:00 -0800 (PST)
Date: Mon, 16 Nov 2026 09:01:56 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild@lists.linux.dev, Phillip Lougher <phillip@squashfs.org.uk>,
	lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-nonmm-unstable 139/151] fs/squashfs/namei.c:283
 squashfs_lookup() warn: passing zero to 'ERR_PTR'
Message-ID: <avqcVK8VjSl6RqJ_@stanley.mountain>
References: <202611131955.0Gd7ipSP-lkp@intel.com>
 <20261115215756.839150412f8e2ce4bab5105c@linux-foundation.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115215756.839150412f8e2ce4bab5105c@linux-foundation.org>

On Sun, Nov 15, 2026 at 09:57:56PM -0800, Andrew Morton wrote:
> On Mon, 16 Nov 2026 08:26:18 +0300 Dan Carpenter <error27@gmail.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> > head:   152f0559e66c079f717de375f133ff127afb1f58
> > commit: 5213b0a08263b2191b86b046c3a63f11e8abc399 [139/151] Squashfs: fix variables in directory code and add more sanity checks
> > config: um-randconfig-2200-20261113 (https://download.01.org/0day-ci/archive/20261113/202611131955.0Gd7ipSP-lkp@intel.com/config)
> > compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 8621950157210c1fa68f20f0614cb51310ec9dff)
> > smatch: v0.5.0-9187-g5189e3fb
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Reported-by: Dan Carpenter <error27@gmail.com>
> > | Closes: https://lore.kernel.org/r/202611131955.0Gd7ipSP-lkp@intel.com/
> > 
> > New smatch warnings:
> > fs/squashfs/namei.c:283 squashfs_lookup() warn: passing zero to 'ERR_PTR'
> 
> OK.
> 
> > 5213b0a08263b21 Phillip Lougher 2026-11-11  224  			if (!squashfs_dir_space(dir, length, sizeof(*dire)))
> > 5213b0a08263b21 Phillip Lougher 2026-11-11  225  				goto read_failure;
> > 
> > We need an error code on this path.
> > 
> 
> How's this?
> 

There were two paths which need an error code.

regards,
dan carpenter

