Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B25223645D
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 13:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037874; cv=none; b=tvvg3aMsiUr+ssEE3G5zgac3DkKJ68Oe/03ghlEpw4uVRvrPPx1kMmzrCeEGWbXGrKwIsF2sTLAp8lDOhHwuDLsd4zbwjfYAmKyN8X0NKfO4NPBiAtOq2Agb6+SvEbT/s3gUAUvSSj3XHuyXgCfs+Wkh5yFr9Ghsi0UG2kXDdSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037874; c=relaxed/simple;
	bh=tUNIjgBvFInPbSXz/F00iO/St383mxPnsAQBMkip4qg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aKjpHgb2isz8sz+HnaJYeiy9/y/lfhiz/kHuVNAIURe8Uv0+CYFnAVYeKl5qbpGm/zhbc6BjF1gCCrnvNxP6XvGCny9/JDuh/BDeTj7c1B6r55A1jVxpyyYk1KeRKH04pydtUoAnHnQduJURdAn+Js0ntfASln4VZb4HkVHtF5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rkkmGyK6; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rkkmGyK6"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5a3fcb2c718so6712055e87.0
        for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 06:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777037872; x=1777642672; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X080B6TdiPMBkC7Kvzr0GCDeixr+j47svqB2B4ELQuw=;
        b=rkkmGyK6nhfKDwX9iu7kP/tkA4osXahJjsqBTrP8EIkmKH8ywWS0k1/PNoZIeWwKK2
         tp+kmvP4iZPbinfxs+5yLBXrd1esvSkcKJzxet102MxQX0/gouyxPLTgnDew4wrNOkkk
         qlXIHYcybbbQN9j7aXfDC+gpGH7OiGRuqmwXOgAuac3TA5PuatYQiZIcu9zBHX0PScsi
         Wt7dnSyo4zoUroLiwSsVAq3u/ABReiZxcbnk0UWvcvLZyNQa3Bn3q+b76GIYjZUo4X0K
         /b3fOiZhDrTE5j3hXRc8x+NI5cd2vfv8AjGXy/ny5zg3CTQpYGkxvrqgF2w5p1S1R/O+
         PH2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777037872; x=1777642672;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X080B6TdiPMBkC7Kvzr0GCDeixr+j47svqB2B4ELQuw=;
        b=Sn9ekc00qyGJuq2JmClcvb5ensZF7M+g0ljCdoZqf98l2Ric4dRd504MWWbssqAEqJ
         25bB1HzS/VssKX8RRQxF9YsN4KUCHqR3eSoYCme3N8unYH65vuypkSMZiy9IDlfA6nXf
         cTx8zENqnd9sZUFjwiWhItAetQLj7WcMuQjS6Qhc2P2tTQadj0V/EeOoqaLfUKQKsp1v
         sxRDWinm009VxSM6rG89Oe0S1B8wISAfjZ+xP8wOlp0xtlmWzxWTNVxccXtW/iFNdCVC
         ScXmdiGJnII/+dI3MPF2ZKbSKunALYGEg2SIbyB6Xtq/gZYPJCZQNlj4mTxhUqt9Wq5/
         Dtbw==
X-Forwarded-Encrypted: i=1; AFNElJ/Ux6idwTIUZEQkUrNaa4Dt3Wk8JmSzTYJJvvtSv/v1NqZdu5H8JyspRyT+0Tjq0KtQ2uVbqsojrDHN@vger.kernel.org
X-Gm-Message-State: AOJu0YxVH7nuRM8CpNV8CxoLlzltw012UL7agP12uAJ8AiGco8ts08Y0
	WcvoUSg1LsYw2Cn2myAoDsUE2Z8O3s+J6eISrmPimDeUOBk9YFDtHNk=
X-Gm-Gg: AeBDieuz0SS50zDp8xkEONFJcNcj6UccX5WeJ5VPK/2gGEkchBmmOYBO2bS0OnkFAI+
	2PceDSWRnhIEmqg/5r/mX6bc5ljcLMBVn4JHARbZssyA1X7qVISLegmJ27nkGAm5JLCNM6rNu67
	pU6sq5oSxjzwycEu+M3yzZr5gE3LL0N0uKyAvv3KejQr4HRHRf7rV2ZuT19n/FbvEup8IfV2X9N
	/+rbLTCZRk101hFquLVhf0sCJLUZeTWWqew7zLvBuzN/IfQeDaf1v5JpwTetl95bimdbRV/ZNjJ
	XNmJZ8g7l5GUJoT2QUN1+Di7Th7PEycwgWmqomZMYyew8PCn2yB5LODKVMtxg6fldXWvanH7xxY
	E2Z2Xz2guhUKg6XGDWSgGPvjfoDPoCLbBo3kXR7YC7SAmQmS0wRqLDnce6D9oGynhRg5dtDh6+g
	p7iILSLizzEsLSDHceqm6iOwY=
X-Received: by 2002:a05:6512:4142:b0:5a4:e6:8fce with SMTP id 2adb3069b0e04-5a4172f609dmr8075664e87.38.1777037871549;
        Fri, 24 Apr 2026 06:37:51 -0700 (PDT)
Received: from p183 ([178.172.147.205])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38ecb73aa8dsm48026421fa.35.2026.04.24.06.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 06:37:51 -0700 (PDT)
Date: Fri, 24 Apr 2026 16:40:02 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jstultz@google.com, me@cherr.cc,
	mm-commits@vger.kernel.org
Subject: Re: + proc-fix-comm_write-return-value-when-truncated-or-error.patch
 added to mm-nonmm-unstable branch
Message-ID: <ef2301c4-bbc5-496e-b9d2-9adcff8b8d42@p183>
References: <20260424105325.B0E0BC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260424105325.B0E0BC19425@smtp.kernel.org>

On Fri, Apr 24, 2026 at 03:53:25AM -0700, Andrew Morton wrote:
> From: "Shengzhuo Wei" <me@cherr.cc>
> Subject: proc: fix comm_write return value when truncated or error
> Date: Fri, 24 Apr 2026 04:06:21 +0800
> 
> When count exceeds TASK_COMM_LEN-1, comm_write() copies at most
> TASK_COMM_LEN-1 bytes but returns the original count.  This violates
> write(2) semantics, which require returning the number of bytes actually
> written.


This is sketchy for reasons:

1) not consuming whole buffer may (and will) break programs which write
   overlong string _and_ use "while (len > 0) { len -= write(); } "
   full write idiom.

2) adding filesystems semantics of writing into the middle of the file
   is counter productive here.

   If "comm" was regular API, there would be "read comm", "write comm"
   + some locking inside of the kernel. Partial update is kind of silly
   here because string is small.

   IIRC there was sysctl fixes banning partial update of modprobe path
   or something like that for security/predictability reasons.

> --- a/fs/proc/base.c~proc-fix-comm_write-return-value-when-truncated-or-error
> +++ a/fs/proc/base.c
> @@ -1727,8 +1727,10 @@ static ssize_t comm_write(struct file *f

> -	return count;
> +	return ret;
