Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13D72F3B
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 05:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732944775; cv=none; b=Yt+xrDnIsJo0EW7GNT8XnQUicTytdEDjgEjkpiOe895g2CogMbuq2ktAcg2jseMK6W31O5hmlKCaUM8B7Ni/FW5uCD5zKZ9SogewYxaBzPokLfGYwgqkQQPZbZP1s+h+Yl2GsBh/KkharPpctrzTi7aC+UYy/vh1MiYG6xHTzWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732944775; c=relaxed/simple;
	bh=9hH92oiRgyozaoRmxV8TYNxb7vexkrDr5Yt+iildYUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jPGHjuWeKxRSkPD8PBuckYXpnATE2pAmBrfNHiSsEf1UDU3UOnYFtg7zfU42fapHDnCMHSioKy00PH7Qf6Je0dfzs9kMAnyDeNE+RsfLdfUwjofsj2cQvtROKbeQv372cTnCqkxKq6sgizVYm1T7OG3QUn8zxMUxsT5hNE2HO8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=mE6L+Srm; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mE6L+Srm"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7ee7e87f6e4so1666026a12.2
        for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 21:32:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1732944772; x=1733549572; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gHK17CMUDUi1kmPKTSvIoyUfNW98U6T8YCMOBpnKCjs=;
        b=mE6L+SrmODMQxte9Sq60gZvQgPfIh4VHaOvqtqJB+1Mzfzbx0UsNM44kPNKVfWy9PV
         CJ1aZ/jp8+gqII1BLvid4JbRysuD6CZMCey1tLOgdxSeN8HK5Wgbk+kRzTg1SKDInNtQ
         EP3BU7rBJpt6k2ltaDFBr/ioBBS1VdgaU9kxk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732944772; x=1733549572;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gHK17CMUDUi1kmPKTSvIoyUfNW98U6T8YCMOBpnKCjs=;
        b=oHdlhuCuwSe5XZq4+Gzbb3LI1bJZHuBB/+Jm/W3GeTpjkK2ZaXOruBnTt8y/wRFPwe
         46gskt+Qp2Eyp+T73ftKh1kVQmSdiKElmreaWDMcJKMFMF8JRn3WS7gtIwdhgS5qEe+o
         jP0phUGmbLKULKl8tJvbGkpNUc+eW6Bh1f523izuRQzsSTUyjSjiSQ3tBsNli+n3eWTO
         +C76umxBXNcg1HrSe3g4aMkEK2QUgvW60BlUOgLBnZ/io6O8lNU3Vr2difBmvW+N8EMe
         T863QQBrM33FXyeCdTV+mxFpH+3OHtMJoGbvvMR6La6Z3FvDAvwAx04dczjn+VNwZ7Us
         /fog==
X-Forwarded-Encrypted: i=1; AJvYcCUcDqRVWQH5fK98rOOPyk9mr2bLEC9YtSqGQ01llVmyrwMuxJwTMfi5m5GM459YOiQbsismNlPLrL8z@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7r/MkxN+Id5VeypaH4raL7hGsyomjgkPBW4HTy/hP/zV4dfv8
	Eu84kBztDfIF0jJZV5vb6iSCgPbSnfcYuGMsx+mQUTe7CD9o/tQYG+3lBdk5ng==
X-Gm-Gg: ASbGncs1CBFrUMA9beuMYTRw44v6B1ohSG0+dsLDGX01L7kXR25lX0i7SHhyTh/4e+n
	eGOTgD3BpY0yc6Z1aHWMfChtdD7DZ02Qr1TQw1NFWA1doPCa3SRRqpQnQkO8YNa8YQzEsL0GAQh
	h+5lBsK2n3cPktz/N2mondwFR8VhV11PSIlOsKEFhGLJEON6dCDYrlf/viUZP4IcDTov6dQqaEI
	r28ph0d5ZrO+u8v2g/PH7tIB+G4DwXgve3+eOM6Vsw8rvDTu34i5w==
X-Google-Smtp-Source: AGHT+IG2pNidXFvtT191fvXtdKKdqX63g+4s6XLT0lfcEWk9jcT9aRhFXSs2LGqq6aSFmefGvXQu5Q==
X-Received: by 2002:a05:6a20:2583:b0:1e0:c8d9:3382 with SMTP id adf61e73a8af0-1e0e0b8c5d1mr20887964637.45.1732944772213;
        Fri, 29 Nov 2024 21:32:52 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:93be:3f9d:a36b:c095])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fc9c3b6ee3sm3904660a12.85.2024.11.29.21.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 21:32:51 -0800 (PST)
Date: Sat, 30 Nov 2024 14:32:47 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: caiqingfu <baicaiaichibaicai@gmail.com>
Cc: akpm@linux-foundation.org, senozhatsky@chromium.org, minchan@kernel.org,
	mm-commits@vger.kernel.org, caiqingfu <caiqingfu@ruijie.com.cn>
Subject: Re: [PATCH] zram: panic when use ext4 over zram
Message-ID: <20241130053247.GH10431@google.com>
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
> 
> When using ext4 on zram, the following panic occasionally occurs under
> high memory usage
> 
> The reason is that when the handle is obtained using the slow path, it
> will be re-compressed. If the data in the page changes, the compressed
> length may exceed the previous one. Overflow occurred when writing to
> zs_object, which then caused the panic.

I honestly don't know...

What is changing the page under write()?  If something is modifying
page's content in parallel with zram's write() then you can't really
use zram, if the content is changing concurrently with zram's compression
then I really don't see how it would be able to decompress it later
and what would it decompress to (some mix of stale and new data?).
