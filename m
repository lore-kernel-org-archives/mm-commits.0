Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EE93D1CA0
	for <mm-commits@vger.kernel.org>; Tue,  3 Feb 2026 16:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770136565; cv=none; b=jouqYYYEcIKAPHgKa4H8kdJ5iXpKbbBnyBPY1ac3kBnA6d5nyCYesMh//rUvFaXWJOMMbWyUT+za7wybsSPWDGqK1wYzzm27GSZCpYQ9Q6ei/eAldNbOY90Xtx8X50SQNR6mFE28ObMaOPKYu+oCtllJQVOrW6lIc1LWSMwL4uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770136565; c=relaxed/simple;
	bh=qap9S7WORoUubJqTBtETXU0xFt0az5wDCXk0PrXYzOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PgXASsfJWzRlM7oUPql9M/wfGwD9ozJSdv+acG2g1CdWSTL9maDsG1s3SFxwAkm/3DsGP87195mHWbdDeZqFpjqdIpXuEuIJ4MAmplhf6HCXy4Yo7XRZnmiJeqmVHi9OPxA7uIZkZHc7pfbrAsYiUo8kd2MSK1j031b2pUqaqEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VBt3hDo9; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VBt3hDo9"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42fbc305914so5174251f8f.0
        for <mm-commits@vger.kernel.org>; Tue, 03 Feb 2026 08:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770136561; x=1770741361; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FQuo/p5AInQk1R/8pvqh/pjovAKXDnSWHvDzZRsI+LE=;
        b=VBt3hDo9vGybANjrUkwXqw61AVGw+GKLWLzBalRMHC30ytCT/TyulnB7Its5Caic0y
         TDeSGPb16o50+O50oUF1ZJWqWswIFcQ8B4B265ftHqNKeOajGJjIpXG4m/bYkgU5lcsy
         DxmftfxirMJ9SnqJdwVE6NABPND8GB4wsjNEtGQ8f1MZpH8jpVySxLmfmcgrdg8YkjLq
         xqTPFxYk4LFKDg6/+L/uloaF1hPRtYlH0bUS5AThzCEep+xioywe90qDRdkpzZ+h48pu
         TM/JdZN8Zf7hiRuDweHSoDbuDp7iaITj/g8WdQmNaYZUb36u4AU6HEFrxAHJrWi56iYX
         9iNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770136561; x=1770741361;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FQuo/p5AInQk1R/8pvqh/pjovAKXDnSWHvDzZRsI+LE=;
        b=JIQBXroJUJL+ELKUlWyDhNOChiaxw8C/p7uB5z7/9/1jyloqmzUqL1HJLb8iExVwO/
         2IaFkNdIq0/2b9B7Eb+OxnOBUF8tNMUWl34TGgHF3eZb/QxaGUXBmJTteEcKxB75lQry
         g/vaiTNlTzSIGuAfc2xc/OtL6CP6UL3FDY/oeZjnHFcyUhwHRZehcyAFHUCwN52hT1ed
         LJTbCflb5+jTQyF2hdMMuanjhWoHc8r5BwSt6dH1EbludP1Io4UhaFaMrGheXXD0mmd9
         yVV5n1YMffX6L44CUKW/cykmd/L7tNZbVLI9RXYMNSZNqQqPXqDiCz4nn292k9ZoVIc7
         nmJw==
X-Forwarded-Encrypted: i=1; AJvYcCU/5y8T2Hd9sLRtuOMPiR1BH8VnHQnBCOHaXMtoZiK22waXJI7WslmuWMQAEhHWSEAo+Wy5FhTSDaSa@vger.kernel.org
X-Gm-Message-State: AOJu0YyjwcCXZNTWtIGel2HQydohdQb9XLfkvi3DHikQ16kZAKXTePzn
	qxg4tO/oaApAsC6bTrv9S4qczczecEYfae8P2FtXM9b0PBOy1JGidIpllCuIR1z4Y+w=
X-Gm-Gg: AZuq6aIJ9dtX9k9VEAQVLMrKCrUXpsnkky4oP8wLa0ej1VGhYxLB7DDl7KVFs8fU8AW
	603jnVbal0NEyy+XLn3nBTlyelElL+UJtCe3DhJhhY6G4lWDEpUN7TYyiwOsDxW1KjSsD3JGtvV
	d6GafgXgsj/fqoo/qAXwbzvZrFkgpAdZqadOQ5sEnScWDsa3lHBMhpzMQxnzdHhOOLVGCwutfUl
	QtkE8Ep8gdOE5cq0bLp/CT9xQskXLbbnXBs7Ldw8NVclHjJycK9S4CvwhQ9DeBxgFv7/U3vFtr3
	UQWYKbZnS5fI3W73fu2+mC6yeUwbvKmpBXrNKyLIkDBIZxn+VCQrKbCrpbhWflZabFrC6NZqfLv
	094nn1zwfp6gIsQrfc41GXsRgmOYYaGA3F/wrsnik9tOGEGXxYiBnBCWNX138HpaI72smBlFf5g
	p/XTAGA+hzw3f2TA==
X-Received: by 2002:a05:6000:401e:b0:430:feb3:f5ae with SMTP id ffacd0b85a97d-435f3ad7646mr20374411f8f.55.1770136560693;
        Tue, 03 Feb 2026 08:36:00 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e10e48a6sm51375458f8f.8.2026.02.03.08.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 08:36:00 -0800 (PST)
Date: Tue, 3 Feb 2026 17:35:56 +0100
From: Petr Mladek <pmladek@suse.com>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Li Huafei <lihuafei1@huawei.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Pingfan Liu <kernelfans@gmail.com>,
	Lecopzer Chen <lecopzer.chen@mediatek.com>,
	Douglas Anderson <dianders@chromium.org>,
	linux-watchdog@vger.kernel.org, mm-commits@vger.kernel.org,
	Shouxin Sun <sunshx@chinatelecom.cn>,
	Junnan Zhang <zhangjn11@chinatelecom.cn>,
	Qiliang Yuan <yuanql9@chinatelecom.cn>, Song Liu <song@kernel.org>,
	stable@vger.kernel.org,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] watchdog/hardlockup: Fix UAF in perf event cleanup
 due to migration race
Message-ID: <aYIj7BzCI46iz2wj@pathway.suse.cz>
References: <20260127022238.1182079-1-realwujing@gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127022238.1182079-1-realwujing@gmail.com>

On Mon 2026-01-26 21:22:24, Qiliang Yuan wrote:
> The hardlockup detector's probe path (watchdog_hardlockup_probe()) can
> be executed in a non-pinned context, such as during the asynchronous
> retry mechanism (lockup_detector_delay_init) which runs in a standard
> unbound workqueue.

[...]

> Refactor hardlockup_detector_event_create() to be stateless by returning
> the created perf_event pointer instead of directly modifying the per-cpu
> 'watchdog_ev' variable. This allows the probe logic to safely manage
> the temporary event. Use cpu_hotplug_disable() during the probe to ensure
> the target CPU remains valid throughout the check.
> 
> Fixes: 930d8f8dbab9 ("watchdog/perf: adapt the watchdog_perf interface for async model")
> Signed-off-by: Shouxin Sun <sunshx@chinatelecom.cn>
> Signed-off-by: Junnan Zhang <zhangjn11@chinatelecom.cn>
> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
> Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
> Cc: Song Liu <song@kernel.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Jinchao Wang <wangjinchao600@gmail.com>
> Cc: <stable@vger.kernel.org>

Please, do not remove people from Cc, especially when you send new
versions on such a rapid speed.

I was on Cc only for this version. There were no replies. I started
review just to realize that another 4 versions were sent within
a week and they got some proper review and v9 already ended in
linux-next...

Best Regards,
Petr
