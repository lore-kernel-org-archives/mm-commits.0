Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C5419CCF5
	for <mm-commits@vger.kernel.org>; Fri, 20 Mar 2026 02:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773974031; cv=none; b=LQ8OxfSaurywkkeiNbxUaXFjcXQTMnGfGhfvQPkHTcIIUG+tD/rHmY8TYOB6ByDY6lecljOJHWls2BYR0tqB/rqTg5RLT4mchRy52lV2DyjPle8mKK3rITwRAhHqyMqY1aw+/qKWLZrWS9w5WrOQ+aE1+xGtiJIAVqaXbXBB4HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773974031; c=relaxed/simple;
	bh=al3fogu+8oML75BIthbC+aR+QGQGekkQZUuy6YrgCj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQARYGMyCqMq8JnpFavPcx3y+Cb5t5Uis6/OcxjTdAuXanyUJGYjMiXlPNYRzeZ5RIlwSLEWUaSTVWe9tpCE4asH932txIV819hktK6CuHzU9DbPXGgVSeCwOLOiNPFeLydIl+6ax7z0nYkS31Mi8XyuP+8NSPAgur7smAIXkqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=FH4u3kRw; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FH4u3kRw"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-35a1cc6e478so1058386a91.0
        for <mm-commits@vger.kernel.org>; Thu, 19 Mar 2026 19:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773974029; x=1774578829; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S+2jipR+ofpTCeJN6fflI6Waqwz0II2MU/wU4uYVEEM=;
        b=FH4u3kRwqxOHFiFtaBRbkeDA58/CAVs9RIv44xyY2eOsfCTx8fvpdqXwsLhHH5GTM7
         rwJMJhdsGnGYlSTCyxkUxkxL5BQwZVmaGlH/bJ55YJo7S37adOK+Xewcjj2dpMtfAHE+
         roD1ojAjHaSadXc0lEqjs1e5Y+ggVmKS+1Yn4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773974029; x=1774578829;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S+2jipR+ofpTCeJN6fflI6Waqwz0II2MU/wU4uYVEEM=;
        b=QsmHFfZlnggsQ7zB2xi8CU7F/iGk8nouD3ZuWshq+EZ3OqyGj29sNjB2EYrYT1GvPb
         +htwzb0oPiaCt0Lujc8Ev5+EsZfWP4lVPfdlCFvCngUZeQYbDCo9Zc8Dq35sP7kPEx28
         ZC2LTktGPbFx7b0wjTMD7rs9TVgGrL5kxIDx+5rW/nCLTGfuNEubhi0kCXSUFSwIuwqN
         29hnQoHdOL2DMyXZNV9g8YHclkVsZsaHwBEimQdTsFDgxFI+yRjWbI4yfhbsC2CATNnY
         IDHvk7ZXYzd9PO6+lSdphq0DZ1CO67f7nHnEfx4coV5w5lkac6UUQVACBNn3kTqhSsRh
         TiPA==
X-Gm-Message-State: AOJu0Yxq6sI3aTl/nQGGshxvpBEBH3+f0nBL1qvfWswGdcH5oEMySNfz
	Z8+N0XWZdHH0qVtoRiiuFrQ5cwdASFmKP/591t4+0vtPjkOO6VCu7VRgnADmLOTv7A==
X-Gm-Gg: ATEYQzzaUCCVE/DS6FbRYmYP5yxkkhsdh+V36VkbMv4QmFULF98YJiUwo38oY16l+kr
	STLaqp22Qi1aGBrDy1EaHMGC+DoqCKn2LpAkYe2RhotMC5BET/aaE0D6jAUbVKAI19nIbjIqhOd
	ZGCWXSQRMsIKvcLyVgfn9krSLjcrMRbY9o79gXXGWu18SBEh6wJLhWnFLYrP7AVmnBkufX5Wphl
	T22F3re+dJlPuqtsjvjFAl9SBhnmyGQVDqdHmb2ateAqNZ4SAvA/3L+v46pTUgOKyseKuQvde9H
	3+YH1TMiVXmpHcsbCKr7dk9Bo+ClBRkne/4XXru1l+O3dGOuZ+zWZhuLF9nDg1641lu0pwXZs1L
	VEEw6JndMKxz1lMSMv00Rr/VyHYc5hI9HDuzh8CiHf2twMsBkR7euyv5K1pUAekRP0vmV2coE3Y
	HMMpjjGPdXQnXGSAI7GFb830Uai3wHrjIqikKz4sr9lnGDTg1AWOG18VGCLt0e3A==
X-Received: by 2002:a17:90b:1d47:b0:35b:a656:a60f with SMTP id 98e67ed59e1d1-35bd2d146e7mr978123a91.28.1773974029203;
        Thu, 19 Mar 2026 19:33:49 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:65ca:c086:eef:123e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd40e4bfdsm436032a91.9.2026.03.19.19.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 19:33:48 -0700 (PDT)
Date: Fri, 20 Mar 2026 11:33:46 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, richardycc@google.com, minchan@kernel.org, 
	bgeffon@google.com, senozhatsky@chromium.org
Subject: Re: + zram-do-not-slot_free-written-back-slots.patch added to
 mm-hotfixes-unstable branch
Message-ID: <abyxpYQNHD0sZLVd@google.com>
References: <20260319224457.488D2C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319224457.488D2C2BC9E@smtp.kernel.org>

On (26/03/19 15:44), Andrew Morton wrote:
> The patch titled
>      Subject: zram: do not slot_free() written-back slots
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      zram-do-not-slot_free-written-back-slots.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-slot_free-written-back-slots.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
> 
> ------------------------------------------------------
> From: Sergey Senozhatsky <senozhatsky@chromium.org>
> Subject: zram: do not slot_free() written-back slots
> Date: Thu, 19 Mar 2026 12:44:56 +0900
> 
> slot_free() basically completely resets the slots by clearing all of its
> flags and attributes.  While zram_writeback_complete() restores some of
> flags back (those that are necessary for async read decompression) we
> still lose a lot of slot's metadata.  For example, slot's ac-time, or
> ZRAM_INCOMPRESSIBLE.
> 
> Do not slot_free() on writeback, instead clear only those flags/attrs that
> we need to clear.

Hello Andrew,
I just sent a v2 with updated commit message [1]

[1] https://lore.kernel.org/linux-mm/20260320023143.2372879-1-senozhatsky@chromium.org
