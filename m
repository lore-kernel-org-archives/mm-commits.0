Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C07F2F2C
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708390186; cv=none; b=ZF8NxPilc11s5G8tbFbfvy4qAeZZe4ZL5+wk5sqoH1dSOSaTSeW+qTrQdk3oAbKUoJMJeuwhwj94QAaGpKfzSrsyRAdRNyYKmOeAN+ArRo6n5X+smxGIbLqoefmPjZX0fHE59Cgtl0EGwWku2IjKae+i/xNN79ZYxSSmacCuz00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708390186; c=relaxed/simple;
	bh=cNmnMfMEYt093CQI8cSj8q3Kb8otnABNd1hY+g/ydNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jqie6T5Z0XVTz3hfCsXaLyfCb10yCMc5rnh2z7zzUyJi5YX4/K++Mu8E8avZgMG1ctvMCmCR6ih1GBW/9Y+4WM0QJu2Pt0Tj/dHDHYemCzXtA0yLKM0nKMcsIftMAQb0ED6Jqi/8ZNln8IU/9vMVptBVot0jjIocEXqHP3vWtn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=euiP37by; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="euiP37by"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e46db0cf82so773628b3a.0
        for <mm-commits@vger.kernel.org>; Mon, 19 Feb 2024 16:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708390184; x=1708994984; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OxcuUSUD8OXvmP8BkrCS+hHzqDuSpw2mIRoHf6rKClQ=;
        b=euiP37by4MB8Hb+dGnQQZnTA+p7A0hmxGmP4JWD8pZAVrBZn68Wn8i8ozYN/So0IQN
         2R6rmaUz1ujNzfsCqxcuVAzzcslCChLNKFkWsLarSJr88Sg1QKzSjihT1L9yEeewSCrV
         a85Jw+PFbu7H0RgUmyxS4RsDsQTy0ORA4lWmo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708390184; x=1708994984;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OxcuUSUD8OXvmP8BkrCS+hHzqDuSpw2mIRoHf6rKClQ=;
        b=qSIXTmtgap0vUHS+xRKj2YleGpMuSRYNhPZlXGSsKnxXXsdmHa/G3EYx43JfNY8GMU
         AEwK1Y+Rn8XDcTGd2N+GiS0KbI4N/5C/b+uDFG+mxGo/cvr3+CuXXcRv+PnETr7K6Po9
         z1PgJdqfpkmYubBVmjpOv2Q038gb3vjNPjxXrAm3IFdNpjpKiV+VR45b80A5AC+0/oMd
         mYP7iBvLCtfPir2TqcmJPhshAzJoFkyBwe+GnvmwWcuvjTrky7M/m8D4QOuR/wsd5boW
         a4jgu9DIk88Zk7t69ZY0w/O8FNdari8Nxq9OTFtt3M++fs04H0Qn6nJ0/RQm+/QcV3K3
         2fWA==
X-Gm-Message-State: AOJu0YxmMVsqybaVI/XgJrDM1YdEMvu/6CPODxZussw5DP4EPdyiyUwC
	J0djMGHSNMke0xSOH3T1q58VRbm+rVtXl7421bYawT1TiCPa1EHnMVqh2fDSAg==
X-Google-Smtp-Source: AGHT+IEELta0qVlf/yYJyPog9aklU/no+kwepNuMts0gVCamH62e4wz0BV8Ixe7MQnNPe3n+sv8+Fw==
X-Received: by 2002:a05:6a00:9294:b0:6e4:7a93:b626 with SMTP id jw20-20020a056a00929400b006e47a93b626mr516628pfb.20.1708390183681;
        Mon, 19 Feb 2024 16:49:43 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:8998:e92c:64ca:f09f])
        by smtp.gmail.com with ESMTPSA id z28-20020a637e1c000000b005dccf9e3b74sm5125910pgc.92.2024.02.19.16.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 16:49:43 -0800 (PST)
Date: Tue, 20 Feb 2024 09:49:39 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yosryahmed@google.com,
	senozhatsky@chromium.org, nphamcs@gmail.com, minchan@kernel.org,
	hannes@cmpxchg.org, zhouchengming@bytedance.com
Subject: Re: + mm-zsmalloc-remove-unused-zspage-isolated.patch added to
 mm-unstable branch
Message-ID: <20240220004939.GB11472@google.com>
References: <20240220004051.3CB77C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220004051.3CB77C433F1@smtp.kernel.org>

On (24/02/19 16:40), Andrew Morton wrote:
> From: Chengming Zhou <zhouchengming@bytedance.com>
> Subject: mm/zsmalloc: remove unused zspage->isolated
> Date: Mon, 19 Feb 2024 13:33:53 +0000
> 
> The zspage->isolated is not used anywhere, we don't need to maintain it,
> which needs to hold the heavy pool lock to update it, so just remove it.
> 
> Link: https://lkml.kernel.org/r/20240219-b4-szmalloc-migrate-v1-3-34cd49c6545b@bytedance.com
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Yosry Ahmed <yosryahmed@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Interesting, none of these 3 patches can be found in my inbox.

I'll take a look.
