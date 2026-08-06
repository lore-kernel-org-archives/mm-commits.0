Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913321A9FBA
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 03:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785987716; cv=none; b=HsTytz6Di2OTbzgAvw82OCBZKC7El6nQ/Yx09OsvhyyfsHe29VUc/dfPFmmZ0gYOhRWiXzv7C5sgXQJM1MATCyH3RacPNyGEPSW4lM2b6R4RSlw8cW05ubWWfe1XfS/iDWAMNhrS7oR8tO2uW5h6ZfLxJ3L5eXKGVa/2WicTJKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785987716; c=relaxed/simple;
	bh=CwhYbikRvMaDHOlP8y3Uj/dg4iTaxackAEIaAerGW5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u1N+jzlwgo+VcxtLKP67ae6N5X4KnDzhMkpRnib2fE33qUhQJ+dNKwUywNZj5l4Th7yG03yi0LUJwO2+KSaWtoAUahlC0Ip6Wq7Ciz2rF0w7JkcTWMhe5Lh5DZKx9Ahjp9bs+WsafQQMEp/Ol4lVNzpH7uAN7+P+5fR6j4hTadE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Gf2/zKvZ; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Gf2/zKvZ"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-848479c9bd5so1592369b3a.3
        for <mm-commits@vger.kernel.org>; Wed, 05 Aug 2026 20:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1785987714; x=1786592514; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jFSf2V0NRaAWT2/+cpciF/RWo86JJIrKrftTaJppXow=;
        b=Gf2/zKvZNweFlgUSkOXrNiACcJRwz4zT4etEwFrC4wiUuf3BbA5uPcVMSmLXigIvQo
         +K5t//Y7LMwEWscV6CfxH0hd7UDr17m3/eTXcwX5bmbDRFFPkMmS0ONuyqexTOtpC87n
         2F+BadGKsL8nOyTB63QcXkMO6gC/kDOiaa3Xs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785987714; x=1786592514;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jFSf2V0NRaAWT2/+cpciF/RWo86JJIrKrftTaJppXow=;
        b=Q1NmD0VAASrOuv9fRCzIMXCf4euTs4Tj7WPWUUN/xDxAXt0EfD/7dMHKX3pw/9j93C
         JKceGdW4s+1j8gKmrpNqgDI2G6xErzQuAYjHLFvNSIKsklDouwfS/yq5T62ibDPGo5RA
         InvUs36U/hlgVkAp4+PyaAa/eRrVDgzOmURFd2Dg1yPWsdy3r6DkvFTsl4fIj8ezYg8V
         o8/6dPEZBjp7zEGp5Gzmi5aQFbL5hpgRGXCoVpMTjAtMf/wDa6NS5Vft3jx9nQLfkzQd
         J+eZonVTS/L+P0JX3LlHYgxsJGgGnQRUk2OVvT8FmkcxVF3NEqKiqyari3grYrE27h0P
         iVoQ==
X-Gm-Message-State: AOJu0Yz/2iFG7YDmF7PVGwcFhEKhwuqHfOrynnV7pASVULmJx4adsPu+
	9JdnnRzcmypheC6v4Nilt/9Ro5R/W5W67d5kBtnpojoQkH1jbhOACDaivRWleZk7Qg==
X-Gm-Gg: AR+sD119Mthaed+rKMBUhJlbv4Kr/CnuJdWMoxBL92W+/jY5V+BWgSauZaJnkZAYA8r
	dcKDE+kMbA01yq5B/29cDgAOQsQs7VsPiBRZOk/bRpa3IoIfbLL0hnnILjqiI7yfFrVHgRcEQJN
	y6ChSQyibLdtSv0v3C2L5W5AXDG5OmUTvvDIUzVLQiT/oLxQNAu2okD5Oy1VmOm1TjmIxYOYRpH
	bJzXG6tTYrHiXLr4gv7RmiUftjJcCCQuAcbYJ12adsM1YuWT0l8t/vQCk1J+h+kQQ9Lbrs7/r0R
	Rf1oNFrHoDc6/WrG1caeVL5hhRMFrdOsZxwXL/Pb+ya/gfMK6Y563ykOYDAbo9c0/TF8nxdPIox
	SU/R7hClJVAbk+nooGx7JkDQRdmaFQWgvJWTpIsryP1xKI4bwXCmmF+FqCyEHTR43tKfH2FM2zy
	bt0teh3CUl2pIP3X64Yk0uB2Qx6xzzBBhSfM3NEmB/imZ+yVrcg079dO1RsvmK6kooTZJDhS0v4
	RO3yRpDDpdFy8nQM+J7hN/iq6p/
X-Received: by 2002:a05:6a00:b806:b0:847:e2c7:59b6 with SMTP id d2e1a72fcca58-84f2e031181mr13517709b3a.11.1785987713953;
        Wed, 05 Aug 2026 20:41:53 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:8002:2a47:a704:5a58])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f453b0adfsm408354b3a.15.2026.08.05.20.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 20:41:53 -0700 (PDT)
Date: Thu, 6 Aug 2026 12:41:50 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org, 
	senozhatsky@chromium.org, xialonglong@kylinos.cn
Subject: Re: + zram-reject-disksizes-that-exceed-slot-index-range.patch added
 to mm-new branch
Message-ID: <anQCNYyJ4mI3l2a4@google.com>
References: <20260805184803.00F171F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805184803.00F171F00A3A@smtp.kernel.org>

On (26/08/05 11:48), Andrew Morton wrote:
> The patch titled
>      Subject: zram: reject disksizes that exceed slot index range
> has been added to the -mm mm-new branch.  Its filename is
>      zram-reject-disksizes-that-exceed-slot-index-range.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-reject-disksizes-that-exceed-slot-index-range.patch

This patch is superseded by
https://lore.kernel.org/linux-kernel/ 20260806031640.536615-1-senozhatsky@chromium.org
