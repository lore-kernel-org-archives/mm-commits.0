Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6C7239BCB
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 11:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733915060; cv=none; b=HBH+EJXxZq3So5TjeL5kBICnWxxiypBhpRIqC3Lhb9PW5mJaI5LwtnrXVDAtQAh5tx05wxiU+afNhe4aCEmlmlZ2njALrT0VWFtdv4wtmpmMhQLKr3i4d8bCkH8cowuR4bW+FL2H2b9Dpjg5QMMECvgqVUGf3j+ch4GvcftA2ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733915060; c=relaxed/simple;
	bh=2BTPeEOU9uz8a4XnT7s4LYGYxs+ttGaFIxriJlodl1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mpj4IJ8C81S3JJwIDwc/HIBg61iAPmgaH4ZLk9cvN8rH4QESD0Uzmo3pq/dh1S7pOau5Dhmf3tausNWhrYOkzvGgHSXU0TsYeXc5LYRbSJejSnKPgD3cnKlGy95obcFWAVk/HKUCtGpKN1ShUyfjcM20PQSFIFVd4MNW4nlkRzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Jh1JD/LR; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Jh1JD/LR"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-728e729562fso1253124b3a.0
        for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 03:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1733915058; x=1734519858; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eywltzUnOzPwfstw05/MyaN9BrmL3L3nP8+yycM/qbM=;
        b=Jh1JD/LRPMMC9tSOOxPFXgpYzNJRX4nFch4D7o83U7M3RiZz+Z6b7OCarhz5fgUF1F
         pMqUp+AWyHWkcwi9XNB13IqFuvbIZtDResUoqbPBuecJvKTqLerbbaDclROqp2houtCU
         np7cvSmCSCFTQ/p4fO1HhFY6MOf+RpMhyjbkc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733915058; x=1734519858;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eywltzUnOzPwfstw05/MyaN9BrmL3L3nP8+yycM/qbM=;
        b=M+w5O9hHplZAFo2Dhk+QXAbWOEM/Sa9B0bFSeIhPtqDw9/2owkqsWgNu6nrCKUZxba
         MLFunbQhA6Q/kyEcAgJlHnCXg3jqnVMBxHL6IuZiQlYKuOvC4EQA9y5Rupvfo68eVvCC
         c88dAWUEnSsaTZO5/MzuI/s7lKsm2RqCRhiRStwTZ4zxhSs1d3klgGPtypPhTE/crrkq
         01uxurjC1uRvYqa9/u1KQp0Hmm6xh8C6tHOK3mO1juDdOaynKh5/U0BWn3Oh3abdPfyU
         a8Eg4nsSw/RolGMkPKC6ARfflVGFX41mn6AcFvDUvg+39ZROoQkAa1rdHmIc2vhNA/Ye
         NG/A==
X-Forwarded-Encrypted: i=1; AJvYcCX8p0miXvDP6rocDI8Tx+wiRk66fWZhF1ZNa0w5Pi/8+oR4byj3NBYlcunez4MUDLrf0AEhbe4sUHvd@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7eQPPedFzSThIR583l+OdHGFUAfqmaD4UYeNFgkbnJlwR77wr
	nSSuQJLkjntaVWS6puJWqbW9i3jlh3Ylo0TTpPtbGnS+uXlduJvvRag0166Huw==
X-Gm-Gg: ASbGncs++QG9OqzAVCfy2Tj1y9FH2aESZKectGi07NKp0I9EgvuMYo6fJoE14xlOZrF
	dfaKMeAXG5AQSl8ESnrD8fWrgc4jR6wY60nh1VGqyJDC3FZK85iJyMuR3h2xGu2aJCFQRkmQlcf
	Ckb43ALdptoyCHw5Yf0hM/TO0KInyDopwuJ3GkwWRFFXn85whOBMK89hE0/4VLvKiKsd5XzDhul
	AdIbEaPKLWnQ3AhpZsyuN/8Z/IuMP6iWlniRzUTI61To082GK98959BGw==
X-Google-Smtp-Source: AGHT+IEFTbWxKbUBljHzQVU300Tpa0Tc/WJ1J0H0f09QoJCPUEPJJ6xq2+6IrwuuQJyI0DCtI5jkMw==
X-Received: by 2002:a05:6a21:9990:b0:1d9:1a77:3875 with SMTP id adf61e73a8af0-1e1c1408120mr3429969637.42.1733915058534;
        Wed, 11 Dec 2024 03:04:18 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:d087:4c7f:6de6:41eb])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725c6f6d81dsm8578061b3a.24.2024.12.11.03.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 03:04:18 -0800 (PST)
Date: Wed, 11 Dec 2024 20:04:14 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: caiqingfu <baicaiaichibaicai@gmail.com>
Cc: akpm@linux-foundation.org, senozhatsky@chromium.org, minchan@kernel.org,
	mm-commits@vger.kernel.org, caiqingfu <caiqingfu@ruijie.com.cn>
Subject: Re: [PATCH] zram: panic when use ext4 over zram
Message-ID: <20241211110414.GF2091455@google.com>
References: <20241129115735.136033-1-baicaiaichibaicai@gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241129115735.136033-1-baicaiaichibaicai@gmail.com>

On (24/11/29 19:57), caiqingfu wrote:
> [   52.073080 ] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
> [   52.073511 ] Modules linked in:
> [   52.074094 ] CPU: 0 UID: 0 PID: 3825 Comm: a.out Not tainted 6.12.0-07749-g28eb75e178d3-dirty #3
> [   52.074672 ] Hardware name: linux,dummy-virt (DT)
> [   52.075128 ] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [   52.075619 ] pc : obj_malloc+0x5c/0x160
> [   52.076402 ] lr : zs_malloc+0x200/0x570
> [   52.076630 ] sp : ffff80008dd335f0
> [   52.076797 ] x29: ffff80008dd335f0 x28: ffff000004104a00 x27: ffff000004dfc400
> [   52.077319 ] x26: 000000000000ca18 x25: ffff00003fcaf0e0 x24: ffff000006925cf0
> [   52.077785 ] x23: 0000000000000c0a x22: ffff0000032ee780 x21: ffff000006925cf0
> [   52.078257 ] x20: 0000000000088000 x19: 0000000000000000 x18: 0000000000fffc18
> [   52.078701 ] x17: 00000000fffffffd x16: 0000000000000803 x15: 00000000fffffffe
> [   52.079203 ] x14: 000000001824429d x13: ffff000006e84000 x12: ffff000006e83fec
> [   52.079711 ] x11: ffff000006e83000 x10: 00000000000002a5 x9 : ffff000006e83ff3
> [   52.080269 ] x8 : 0000000000000001 x7 : 0000000017e80000 x6 : 0000000000017e80
> [   52.080724 ] x5 : 0000000000000003 x4 : ffff00000402a5e8 x3 : 0000000000000066
> [   52.081081 ] x2 : ffff000006925cf0 x1 : ffff00000402a5e8 x0 : ffff000004104a00
> [   52.081595 ] Call trace:
> [   52.081925 ]  obj_malloc+0x5c/0x160 (P)
> [   52.082220 ]  zs_malloc+0x200/0x570 (L)
> [   52.082504 ]  zs_malloc+0x200/0x570
> [   52.082716 ]  zram_submit_bio+0x788/0x9e8
> [   52.083017 ]  __submit_bio+0x1c4/0x338
> [   52.083343 ]  submit_bio_noacct_nocheck+0x128/0x2c0
> [   52.083518 ]  submit_bio_noacct+0x1c8/0x308
> [   52.083722 ]  submit_bio+0xa8/0x14c
> [   52.083942 ]  submit_bh_wbc+0x140/0x1bc
> [   52.084088 ]  __block_write_full_folio+0x23c/0x5f0
> [   52.084232 ]  block_write_full_folio+0x134/0x21c
> [   52.084524 ]  write_cache_pages+0x64/0xd4
> [   52.084778 ]  blkdev_writepages+0x50/0x8c
> [   52.085040 ]  do_writepages+0x80/0x2b0
> [   52.085292 ]  filemap_fdatawrite_wbc+0x6c/0x90
> [   52.085597 ]  __filemap_fdatawrite_range+0x64/0x94
> [   52.085900 ]  filemap_fdatawrite+0x1c/0x28
> [   52.086158 ]  sync_bdevs+0x170/0x17c
> [   52.086374 ]  ksys_sync+0x6c/0xb8
> [   52.086597 ]  __arm64_sys_sync+0x10/0x20
> [   52.086847 ]  invoke_syscall+0x44/0x100
> [   52.087230 ]  el0_svc_common.constprop.0+0x40/0xe0
> [   52.087550 ]  do_el0_svc+0x1c/0x28
> [   52.087690 ]  el0_svc+0x30/0xd0
> [   52.087818 ]  el0t_64_sync_handler+0xc8/0xcc
> [   52.088046 ]  el0t_64_sync+0x198/0x19c
> [   52.088500 ] Code: 110004a5 6b0500df f9401273 54000160 (f9401664)
> [   52.089097 ] ---[ end trace 0000000000000000  ]---
> 
> When using ext4 on zram, the following panic occasionally occurs under
> high memory usage
> 
> The reason is that when the handle is obtained using the slow path, it
> will be re-compressed. If the data in the page changes, the compressed
> length may exceed the previous one. Overflow occurred when writing to
> zs_object, which then caused the panic.
> 
> Comment the fast path and force the slow path. Adding a large number of
> read and write file systems can quickly reproduce it.
> 
> The solution is to re-obtain the handle after re-compression if the
> length is different from the previous one.

I see that somebody posted something similar on the bugzilla [1].  Is
that person you, by any chance?  If so, can you please post your
findings to linux kernel mailing list? E.g. linux-ext4@, Cc-ing
linux-fsdevevl@ and linux-mm@ would be a good start.  Bugzilla is
not used.

If this problem is in ext4 then I'd really prefer to address it there and
drop this patch from zram, simply because it covers an issue in the upper
layer.  And it's better to fix issues that to cover them.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=219548
