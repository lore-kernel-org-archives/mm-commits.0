Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE403202F97
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 08:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730189275; cv=none; b=MQGu0elP31gNppaTmbhKti9ssmcQ1zK893bVGNK6ARS9T9FZN2A/Tw0+VcQAqkdy2xT1G1uUkXz59zRPKb2q511pau1/ikKVwCtf49+QBwO+fAJmssTmTiWXZ2XaabcoRNTtrkKrRRnEpqppeH31f6ohfBw1/xtij1FwpcjG6iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730189275; c=relaxed/simple;
	bh=KJfJcAH7hKsecAAc4oM8/h/DsOBBS2oqIaz1Unqv6NE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eE0tie4251sc7c/oPOK82XGITAt90VweVtih/zTqKWSAQLlxLQyP/MWXzpoQRsneFmxp+dodlIkSHCiw89ohnoNQXpWDP4hUgLXdOKp6APS/d0qrVguCYYHuw+UB0jDxP1JdZOrD3lvF4+36RjH6dVQ1h+RmPlAqBHX6/0kZeF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=LH3v+DuI; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="LH3v+DuI"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5e98bfea0ceso2517721eaf.0
        for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 01:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1730189272; x=1730794072; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lx1hVVZrhruV9WzE8vP+JOdmDoa9T2aOUBZLwAYUlvw=;
        b=LH3v+DuI68lT7odBkb27CIXp1PlwvagFD4/kT+udekeX1VBt/qfcSP8YUEwOGWetz5
         r2JwEPEJmVrrkRE9HOsJ+TzmcATKvihxiQ1c8SK0QAklkj8cq1ba4OrKHD8T/SLGklRB
         lVJQs0FnpQIarkLUpTMmDg2mnBxjCZmjsyyvo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730189272; x=1730794072;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lx1hVVZrhruV9WzE8vP+JOdmDoa9T2aOUBZLwAYUlvw=;
        b=MykgqNsujOA3u0L7JT606hpBAuww4JBF7ZA6EsCrLoafZpPVm3SVzLW4joIQIRHdUx
         Qe+tmvEzbXgVszw0MdJwhK6NttL1uPVzHs8gGeJt3KxeYNzW9qn8G5vWdgqkZXi8U7bj
         y8JxAqWcZ6biK0dT9pZ24aA7yTT0VWOd/jXNiazEE+WRe5sdbXnoYuVSi+nXpn65H/nt
         CTYHJaPB2L8ZAUuvrkTauacIcPtqYaD3/6muq3xt2ZDIUcNiBEidlaodDNG1r/unXF1h
         yWVV4rcmWmYYHHRqaJg8faTFXyKmzIP4RL8Cnq6WmzQmjzcNBpkGZk1l5fWYwT6IdRtC
         /8vA==
X-Gm-Message-State: AOJu0YxPwo3a7sbSAbvIenEFpOMTikUNkXsnUlbVXER3N7jtpJf8+O3C
	2NIyRK9QepPtz8yYIlopip2+DaKAVP8evwK2whb94I4qfgy68RfhD487mLotnQ==
X-Google-Smtp-Source: AGHT+IFRET7hf5ANefmpxlqI1P9aMUPXxZkHdGKMUG4q3/U97FW2MrgBgE8zEHX4WDhpOmhEkVhxvA==
X-Received: by 2002:a05:6871:5825:b0:277:c3e6:7889 with SMTP id 586e51a60fabf-29051d8c2bcmr9423033fac.30.1730189272615;
        Tue, 29 Oct 2024 01:07:52 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:8438:faca:cde8:9e95])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7edc86965d3sm7050340a12.46.2024.10.29.01.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 01:07:51 -0700 (PDT)
Date: Tue, 29 Oct 2024 17:07:48 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, minchan@kernel.org, kawasin@google.com,
	senozhatsky@chromium.org
Subject: Re: + zram-clear-idle-flag-after-recompression.patch added to
 mm-unstable branch
Message-ID: <20241029080748.GV1279924@google.com>
References: <20241028221018.5481AC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028221018.5481AC4CEC3@smtp.kernel.org>

On (24/10/28 15:10), Andrew Morton wrote:
> Patch series "zram: IDLE flag handling fixes".
> 
> zram can wrongly preserve ZRAM_IDLE flag on its entries which can result
> in premature post-processing (writeback and recompression) of such
> entries.
> 
> 
> This patch (of 2):
> 
> Recompression should clear ZRAM_IDLE flag on the entires it has accessed,
> because otherwise some entries, specifically those for which recompression
> has failed, become immediate candidate entries for another post-processing
> (e.g.  writeback).
> 
> Consider the following case:
> - recompression marks entries IDLE every 4 hours and attempts
>   to recompress them
> - some entries are incompressible, so we keep them intact and
>   hence preserve IDLE flag
> - writeback marks entries IDLE every 8 hours and writebacks
>   IDLE entries, however we have IDLE entries left from
>   recompression, so writeback prematurely writebacks those
>   entries.
> 
> Link: https://lkml.kernel.org/r/20241028073529.1383980-1-senozhatsky@chromium.org
> Link: https://lkml.kernel.org/r/20241028073529.1383980-2-senozhatsky@chromium.org
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Reported-by: Shin Kawamura <kawasin@google.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Andrew, can I please ask you to replace these patches with v2 series?
v2 comes with styles and typos fixed.

https://lore.kernel.org/linux-kernel/20241028153629.1479791-1-senozhatsky@chromium.org
