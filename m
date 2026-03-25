Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B3B19B5A3
	for <mm-commits@vger.kernel.org>; Wed, 25 Mar 2026 01:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774403193; cv=none; b=AjZpF+YahHVYq4cfwvSTbag8ZeLtpZKs52dVM9+I5TIBZS9/cGaXPCK/g3K1zLdzwMs+6lRfP04szaObneS0ng9YA5Qtb5lCSg4Ypw3xhrToM+xpUOyzNfMAYmmpVBwnKwOC2a/EI5HlFJEBSrtIGry9/NeS0bcet4n3gM0iIXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774403193; c=relaxed/simple;
	bh=J05DKlmK+44ZtncLnTpEsjlOqflBQqjoy8CruuSFAdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mI3AnwvkkXItvqTPj/AN+f/PY5KIVIyc+bQu7/x369vrXHe3zriqCAPx2rSTDfK8bwSc+8snsUtxQV1rNr/3OJSFAXtX5huHqkhaKaGnMt+4HRTW9zhWdjOIDFt3zXZEX7cyDmseHSzeWCnnBtaG3+JWAkVOC2l8tn5oZAuESyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=JPqrEXjZ; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="JPqrEXjZ"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2b0603ee486so13526455ad.0
        for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 18:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1774403191; x=1775007991; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XAqwg4AZtsESsH97IIgmTxvMLL2sE46/gIAdnIuPc+o=;
        b=JPqrEXjZp25gpFGUSP9UPyNEimPuO5kDezLntBJaie7NmpgP5aOJfx7msCr7jMxfJC
         9yCDdvalRYJTzxgXk0xllsG5glyTCC2tTLJaT6e1I6VCvdgPLp/0WP+o3PIvq/00uCCJ
         r6VZpYboTCmYS8S7U8dCMTqew32nNi072OEk4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774403191; x=1775007991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAqwg4AZtsESsH97IIgmTxvMLL2sE46/gIAdnIuPc+o=;
        b=ZCZi2/HiihkRqUjZDBYjFHqDg4rx7xj+pRAEWnNPMuXiaNtMc0ByICBKY5RgeydRny
         rTx6SGSThxtZRX/aSapfbaWygHP9/CcdoVLo98HG6XAeUGSBwMWcMGZNqfNw+2uh8oLD
         gWBSZUmTefOzSLgbKvzmL/ox2Lz71sDeUjmIiV0TUNtfr5MYDlpTLEVMPHvjxMioduO5
         MIPXGU7mUYSoVv2rTUnO+w/oMkdT3vf0Oi1suA4lfWaCyzoQ1b9iqh7PAZ/R2PNRjRjT
         JjlS19vPGGU4qaQIaKuxZex0JkonJfumJiT6bTjtLHKNk5mGjOPjtaK9ZBU90GsdT8He
         ERYQ==
X-Gm-Message-State: AOJu0Yxk15AaEoC3y58PWmXpn+0blEwQ40tlN+f88KE1MqxvtrzgYq8l
	fF2Uy5ILGVnUpzQrAK+6HYDXiOhrSuh0xdSX/vNqD/y9V+9uslukwWIOTGyqLTnKZg==
X-Gm-Gg: ATEYQzzDXVHcCQO+A9qJib+677ZiFDI3CVANHH+hXchFQx1vfE7kTINxFfTrs9d3yxk
	wUrzAv7/zjNcnAQoB5Mlj+3xj6AALPeZzp+IbfAcYH7ur2n5EL7rP3tH7dkwXBciZFQ6mTuPGCu
	uuYzDrcZy0msuyEsCGlrbiNS4HOp0dzaegbcCZyy1E/xzedZ7RMi/6Ob6D0oSqiFcxK5aeGK0eU
	2xLBHuDGtcV71u2xIni0Bj4zz3GONTSNAT2/kj/h6koi9PR7SDz6bGy393FHotYnUpKlLPdN1jW
	zLV0lPi39gGEDCUYJdX2FFNHWx2k35U2wJlUCE6USCCfFsHVTYoeSZA3KwUWjhtHMjIxeQzoI9z
	RYh5kON0orv5VEkmDT7Rj8eMzpKzyW9qs8tva0uBx30Ei4cT9bXjsGwY7JbX1AJvVJF5J2Fe3Ih
	ddJy0fFTMaaAyCEqoUyaJ6gRBNaAPYBJ26FuRahKYBvYuLMhmyieKTV4i3GnwcvmX8eIiBRtYDj
	A==
X-Received: by 2002:a17:902:ebc2:b0:2aa:d5e5:b136 with SMTP id d9443c01a7336-2b0b0af3befmr20192675ad.38.1774403190926;
        Tue, 24 Mar 2026 18:46:30 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:b91b:3806:4771:9ab8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083527f84sm153641805ad.18.2026.03.24.18.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 18:46:29 -0700 (PDT)
Date: Wed, 25 Mar 2026 10:46:26 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org, 
	senozhatsky@chromium.org, minchan@kernel.org, mark-pk.tsai@mediatek.com, 
	syoshida@redhat.com
Subject: Re: + mm-zsmalloc-copy-kmsan-metadata-in-zs_page_migrate.patch added
 to mm-new branch
Message-ID: <acM-RcQ89TkxDhCo@google.com>
References: <20260321175018.5B0E7C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260321175018.5B0E7C19421@smtp.kernel.org>

On (26/03/21 10:50), Andrew Morton wrote:
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-copy-kmsan-metadata-in-zs_page_migrate.patch
> 
[..]
> ------------------------------------------------------
> From: Shigeru Yoshida <syoshida@redhat.com>
> Subject: mm/zsmalloc: copy KMSAN metadata in zs_page_migrate()
> Date: Sat, 21 Mar 2026 22:29:11 +0900
> 
> zs_page_migrate() uses copy_page() to copy the contents of a zspage page
> during migration.  However, copy_page() is not instrumented by KMSAN, so
> the shadow and origin metadata of the destination page are not updated.
> 
> As a result, subsequent accesses to the migrated page are reported as
> use-after-free by KMSAN, despite the data being correctly copied.
> 
> Add a kmsan_copy_page_meta() call after copy_page() to propagate the KMSAN
> metadata to the new page, matching what copy_highpage() does internally.
> 
> Link: https://lkml.kernel.org/r/20260321132912.93434-1-syoshida@redhat.com
> Fixes: afb2d666d025 ("zsmalloc: use copy_page for full page copy")
> Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
> Cc: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
