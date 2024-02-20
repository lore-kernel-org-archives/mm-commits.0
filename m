Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4076812B76
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708390410; cv=none; b=WnqDkYHuANtN4L8htVTfqxlWMBqsoLDucbeCnazoNVsGp4AcriD5U1mg+Tl2qMI40dBNwhpBVfrBtGbdhoRBR94buvP0QseKS9Epb5x4uqdm74vQAL3fOuTFU2oQjSdbG1YAC4h1bQG+qCD0prBajrstgLiOkDHpmrqxidBY/Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708390410; c=relaxed/simple;
	bh=MCanYBM1GatpKqd62JJxLs/JzFbsx+0P9SIqngYJicg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o49ykVuQUi8AHgz1rMUEV9X8qO+OtLuLK9tOt1FkW2XKC279C7974tXftbZdP12k+ykntI/oG58VHE/1z4K5cFvTJhnqPQWWfd/6455MSkR0lcO4vOTe7bOeuaxxtk5UI9UktIw4Qb9HyUTdNQwRj5DFod2TtWWNFUJwixnJHxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=AW8Qe9Eq; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="AW8Qe9Eq"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e46dcd8feaso653637b3a.2
        for <mm-commits@vger.kernel.org>; Mon, 19 Feb 2024 16:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708390408; x=1708995208; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bbNZgK8aQbcZBGe7NP/6o1O8hKHbJt5eJ9p+YMCFxE4=;
        b=AW8Qe9EqqdBI8dfCyM7vMUWn0a1DYeORO6fu2ffnSqqDdXLhIrpMv8VZ/scd3YFL0J
         ecuf7A/dm5+h2l23t2Yr3c+FGYPExFBVisxiEQTX3t335Tvk8bREl9hyqj4g8UxjkEVZ
         YPjb2C6dyG0YZ9l9EhRnHO9Gs/gY4BixvrzlQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708390408; x=1708995208;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bbNZgK8aQbcZBGe7NP/6o1O8hKHbJt5eJ9p+YMCFxE4=;
        b=DdjWnaW3MsrtY+Hb7mhAk8t9Rt+wm3b+DDmKp9mD/brYYFFj2kMwciQiolEmSwrja+
         ijDnQb2QdVr1LorWTAIsrWpN1JEYMxdrGgN/hkwFAnYLqmLNrJYYHxmLnTIUEKnk3u0a
         g7OHrAQwDUqYBuf4F65mmOSsmkIaLM6oRR3lJStkkG/TPoIkb91/qZEtSlfn9jhrUXys
         ln08u++2uDf+Jl0WoB5dGP23OVTMvrLdRf5Bg1p2i1JPgwCyg57X6ekWv5JG1uZzVZgm
         dMCn/VjzNjQ6bpV+5vQlpCXZYKVFBYxQ7p8UWmNkLVf74ASkkF8ZfDpOMvQcUsOYQBm8
         54NA==
X-Forwarded-Encrypted: i=1; AJvYcCWSQJN44HZaY7lHVbzZzB7Ljgud2HzQwu7WOp/leBE6bGXuQBX3y6nFqnD8uE8YzK05RFJM+1wtj9uyanhD/s/7jVTiWDCzNYfBcw==
X-Gm-Message-State: AOJu0Yye+bgeOPgpyfcRd7AANa/drd7gzTY4HlvFSZcb3/TPYvl4dIUf
	4ivEcBqxYRCTvH/D6hT84MySQWfg/b0IwhFzr9ygRb7/f0Wig8ySwABc5PAorA==
X-Google-Smtp-Source: AGHT+IHX0JmiYmeLCYFyazPD0AFFqVqe+4QZZIewF6IRHzlJPOihNqKw/i0uNwGXj4Ka7hzZLIG9Pg==
X-Received: by 2002:aa7:84d8:0:b0:6e2:497f:abb6 with SMTP id x24-20020aa784d8000000b006e2497fabb6mr5889593pfn.0.1708390408550;
        Mon, 19 Feb 2024 16:53:28 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:8998:e92c:64ca:f09f])
        by smtp.gmail.com with ESMTPSA id r6-20020aa78b86000000b006e2f9f007b0sm5156025pfd.92.2024.02.19.16.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 16:53:28 -0800 (PST)
Date: Tue, 20 Feb 2024 09:53:24 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	yosryahmed@google.com, nphamcs@gmail.com, minchan@kernel.org,
	hannes@cmpxchg.org, zhouchengming@bytedance.com
Subject: Re: + mm-zsmalloc-remove-unused-zspage-isolated.patch added to
 mm-unstable branch
Message-ID: <20240220005324.GC11472@google.com>
References: <20240220004051.3CB77C433F1@smtp.kernel.org>
 <20240220004939.GB11472@google.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220004939.GB11472@google.com>

On (24/02/20 09:49), Sergey Senozhatsky wrote:
> 
> Interesting, none of these 3 patches can be found in my inbox.

Okay, so the series is in the spam folder

```
Be careful with this message

The sender hasn't authenticated this message so Chromium Mail can't
verify that it actually came from them. Avoid clicking links, downloading
attachments, or replying with personal information.
```
