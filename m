Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6040D18B1A
	for <mm-commits@vger.kernel.org>; Thu, 29 Aug 2024 02:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724896916; cv=none; b=d8sTt5B2xfsnVmPE/zTTGaKngS4NBhUxmSHuTmcDdvOnR1xi1wxGVD3L10DJf4gKotIOaPqEqsee7KMSsTqEQa/jUjK7IQ816mf9fhVsFAE5SN85N89NOjr/wGbrducOXLQb12TvdytoSEzCORrIYPNDq9Hu3cz+hH7XdGg1GHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724896916; c=relaxed/simple;
	bh=TUyECRLtLo+TghTXmMN8V5Hn9Po5TB5Q5kHLL8xlrGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TklB1kZkvJpROEFBOjbkAZPrPQg7DIQrSTTNrdPgkVoFmMBRvSHyJQm1rV/r1Og1emlx5bn8psTpYxBhfV4HocfCJ0rJL6moaeaeoVlbu/G0Fj20WZjQOrV+vT6oWwxysD+902KHQ6/bVly3kHHNBT3b+xY85+nBhcOCVpOyOO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=J+F7vchz; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="J+F7vchz"
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-201fbd0d7c2so1300895ad.0
        for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 19:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724896914; x=1725501714; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GnzWPdswANA8qDaBEnblao+is+FN544TK7j/chFuL/0=;
        b=J+F7vchzxHdHclD+unAwBrGRbmlsyMwt/cpy/8UVK9SzJWUXaDPWerlEgQduAtQNJm
         1czXdZWDYobWy24D+4Nj2EuORB959ojqknLZd/PA7AmUDKvekVifJ3OdHwni+HrKFxWk
         kgt0yxLhOhAbu7lbEVNT7MDEsydXcd1wVXDt4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724896914; x=1725501714;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GnzWPdswANA8qDaBEnblao+is+FN544TK7j/chFuL/0=;
        b=c4PErwMjeYccyMBvRZP+7sUJOsC8mGmzmV2aqSoEAAWUzZJa8ohTIjnaPEwrwal/KD
         kiZOHEztAW8MiAWqfEZsEuPR+Dx1dLUieBwaG0CKaa984rDRD+fjT9+ceU8vbYK3SRTW
         StvDxKhwJcehGYamtXivMLYDvHKdk4JTiTsHkaDBRkb2UkkeZUlxoHTywqL1dHRg40y9
         /qG9WuCQGuHNenOp4k4sOWAyGeCWexVsRzMsU1DD1sBekgJiR2oDhIO2ozhYSAUPQ4+5
         4flPz0BC31zPdXnNQ8RUeJxd9YYXdx+OwE7qUTvWpBqg6h2pNnCv6JbWeldvuRP9P54c
         V+/Q==
X-Gm-Message-State: AOJu0YyY7Acl5zBpivpSgMHp42e5tiKpOdWP+SO5T5Pyj+1rLUWct96w
	l3wqqjYkw8E6wKImL+Vvy3af3gJahzCG2CroDKedgQ55cdqU7dfkcmeyBBe4tQ==
X-Google-Smtp-Source: AGHT+IH9UkyUgiv43FvWiuFKd3ChYbqTZj5T7CWHU/KiKSlUNk2RsKR11W2w6WAyo01/BO/L0uu7HA==
X-Received: by 2002:a17:903:2347:b0:1fb:8f72:d5ea with SMTP id d9443c01a7336-2050c42f00dmr15288315ad.50.1724896914501;
        Wed, 28 Aug 2024 19:01:54 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:b156:6761:b52:2576])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-205152b12d3sm1276245ad.41.2024.08.28.19.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 19:01:54 -0700 (PDT)
Date: Thu, 29 Aug 2024 11:01:50 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, terrelln@fb.com, nphamcs@gmail.com,
	ngupta@vflare.org, minchan@kernel.org, senozhatsky@chromium.org
Subject: Re: +
 documentation-zram-add-documentation-for-algorithm-parameters.patch added to
 mm-unstable branch
Message-ID: <20240829020150.GA9738@google.com>
References: <20240724192716.657C5C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240724192716.657C5C32781@smtp.kernel.org>

On (24/07/24 12:27), Andrew Morton wrote:
> The patch titled
>      Subject: Documentation/zram: add documentation for algorithm parameters
> has been added to the -mm mm-unstable branch.  Its filename is
>      documentation-zram-add-documentation-for-algorithm-parameters.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-zram-add-documentation-for-algorithm-parameters.patch
> 
> Document brief description of compression algorithms' parameters:
> compression level and pre-trained dictionary.
> 

Hello Andrew,

Sorry to bother you, can you please drop this entire series?  I will
send out a new version shortly.  There aren't any serious changes,
I just don't like zram-extend-comp_algorithm-attr-write-handling
patch anymore and instead of changing behavior of an existing
device attribute I'd rather introduce a new one: algorithm_params.
Other than that the series is exactly the same, so we should be
fine landing it this coming merge window.
