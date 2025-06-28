Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7A416EB42
	for <mm-commits@vger.kernel.org>; Sat, 28 Jun 2025 14:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751121114; cv=none; b=NxUzy1xbknM5rXJ4Ru4F3iApmbn2Sso0GCy+sOrlTG/LkjVB8hUtFjDIQtCdUL4agawGVpwlr5rTtRqLGWH9pkUxycocptE360C9vqkVdaPnSM9f/DJHfdHK9c1Y/WX8GjVmBcmdLG2V9zxVKEyQTo+S3ayzttnQuSsMBNn5DxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751121114; c=relaxed/simple;
	bh=nK1PMi6QKrTrXQbpsFPf8/YYhRWJDDVS74/b8RHpwmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dCGXe2nmq2QvgUqA5aGfHlS+gdMgS41FjFPMy5XcOO8QuaCJFdzbc+EsX2mbBYl97RvLWpwrB08pLCov5c2p6rTIOOUu4j4gyta7ERAW9+QCQhqblGs9eaYdFmfsUCkWbsPgVdJWkZjAoOcPfzxvlMT5l7seaiuUgMC0jWz5vTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XqiWNMEJ; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XqiWNMEJ"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ae0d4451a3fso128090466b.1
        for <mm-commits@vger.kernel.org>; Sat, 28 Jun 2025 07:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751121111; x=1751725911; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CU8ALcwtSpkKehh7ClZXAcv86N3Fy3LdxzdimSnmhls=;
        b=XqiWNMEJzw3nYD3qDzJXzKojPeG2qRuBTtwaVCnBBvpou/W8MXFd9IiQWzVGhbTFlz
         kFYBI6s1uC/VyTzn22+ObZ+QQHKYv/aeP97lgVtmQJivAXg/MnfvKaHC0uuoEiUhhiRe
         hPwRA8cI5iUu8yPQDsnl8vWPMoDZTJJ+D13XzBD33OnvozPiOd61eq1CUvtmwvy1Li3T
         r5oJEtszFmJLvGSUiezDQtWjEir8nDJDobztmFePYUA90X+iWQpz35Fa7Hq1oQ0DaZsJ
         WvDNcTKAu/bVhRpt6OZYBUqs8z7zM1jteZdMklnV0pV+cS2Sf5JVn7ay/8RVG87+VO7/
         EoLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751121111; x=1751725911;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CU8ALcwtSpkKehh7ClZXAcv86N3Fy3LdxzdimSnmhls=;
        b=HRn7/T7UONCtCJ08TRIv2+7pYoLpvWnbVWfuQXNNZaokptb/mv/l7VmtY5OTf7Gnh4
         3cF3xKL9n80u+/yIgASA+W05vvrnGgVtjYzFgaRk2G1Td8C4Zwg6dAV3m1RHD6wMKb3g
         /7lwpOvMLo2WIYF3mZJ+cZ1ylNuYM/OTT+QBo7+g4nnm9F5MJIk6mhcWFRB23qnMhCTD
         3pq3jwbYF/PPHtPPgHdF1EtixtJDKWtX309vEt+ymoLUiK4pmUQc8ZE8S9zDM/DS7Aer
         nHhuO5l5KZEdruOttr4HmWad5RQA7XpWXLqg6ZfSB6rCqUsi44D+RrwsnteQ2dDHxpMR
         QDpA==
X-Gm-Message-State: AOJu0YzOl+pr4vfgz8xxbOyB3EmCy0/hLh/3G7XA1nEvO3wcOk4XNfgA
	t4QY3/zSyC/JHskvNv0eeRZS3IPrYSm2YYojSo8PHwzyMCqP3A+ohlM=
X-Gm-Gg: ASbGncs+7F8pT9sGqC4YCH7SLBwJgb0D8YJSWeSUYJsHcuFIl5w9wPEnIaX53d/WZuO
	vzDl8KYllZWcplVypjepdKwWUfQSOf1jfP1N3OSEH7pTr6Q6LWohlCibk2pn/uB96i2r00Q9woX
	q/qBh2dmphiwFTB14vpUH8upVVyqvPQQoGS8/A3wyPRUAQOJrKK6zWtO/aOQUdUiYJAo8xOohim
	FYIcSXWna/lVj+Hfs9YK/Mys2cIm98zOHjwSQRnmHKd2qJ4fowWKq0AXA0ra4abdceAKDVRdkLC
	vv4ceh61oT7KnrpUw6MBdJQDuljwefustO37y1k5MMlMX4UZ
X-Google-Smtp-Source: AGHT+IFFjZm8sjsuSxlAs94+0rz737HetHovfmcgajs4iZtJczlthQ52Q5OmAEQlrXDqy3082VNgaQ==
X-Received: by 2002:a17:907:3c8f:b0:ae0:d013:8b20 with SMTP id a640c23a62f3a-ae350101c1dmr710131566b.41.1751121111335;
        Sat, 28 Jun 2025 07:31:51 -0700 (PDT)
Received: from p183 ([46.53.249.82])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353ca2095sm320063166b.162.2025.06.28.07.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jun 2025 07:31:50 -0700 (PDT)
Date: Sat, 28 Jun 2025 17:31:48 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yebin10@huawei.com, willy@infradead.org,
	vbabka@suse.cz, tjmercier@google.com, shuah@kernel.org,
	ryan.roberts@arm.com, peterx@redhat.com, paulmck@kernel.org,
	osalvador@suse.de, mhocko@kernel.org, lorenzo.stoakes@oracle.com,
	linux@weissschuh.net, liam.howlett@oracle.com,
	kaleshsingh@google.com, josef@toxicpanda.com, jannh@google.com,
	hannes@cmpxchg.org, david@redhat.com, christophe.leroy@csgroup.eu,
	brauner@kernel.org, andrii@kernel.org, surenb@google.com
Subject: Re: + mm-maps-read-proc-pid-maps-under-per-vma-lock.patch added to
 mm-new branch
Message-ID: <0760b4dd-b6e3-4b78-aab2-ae5cdb8076cd@p183>
References: <20250624200809.54B9DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250624200809.54B9DC4CEE3@smtp.kernel.org>

On Tue, Jun 24, 2025 at 01:08:08PM -0700, Andrew Morton wrote:
>      mm-maps-read-proc-pid-maps-under-per-vma-lock.patch

>  static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
>  {
>  	if (*ppos == -2UL) {
> -		*ppos = -1UL;
> +		*ppos = -1UL; /* -1 indicates no more vmas */

What's going on here? loff_t is signed. Maybe it is OK.

"unsigned long a = -1;" I can understand. Give me some time to recall
casting rules.
