Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A24B10F1
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 04:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706243595; cv=none; b=TSxwgc3WufLBG4LGMveliWmXiOsQ51dfNmiS6v0t/FsXbpzpEbio0FJM+TePbcLHo5TmQu5SltcJRD0jwuNpafiGpVenrIGZmlVJcdrldd4LEq5Iy+fUqCmf+8mFABpkhRxHa5pugjtZ9tKCcFe6EJh9uv2wSr3xSyhNkOYdiuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706243595; c=relaxed/simple;
	bh=4j4EQ2N08blnjHNxFuZlwOjB+HrCUNlfX8ov8ppS9z0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KSH1SzdU/K4yoldNkn5zpD30rr+9HKyktSz1/mPfNEJX0aWmngfp15SVXPvPZKaiJUzq/5oxuaYQNs+o3uO/e8cm89fb4Lag1zBcz9enVkZg25tBoBhIZi2INzFpl4PxIBz5UkJ65iJSiEz3m/YHKPlszyceWiiG4+n7PKqJQbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B1/8nWLA; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B1/8nWLA"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5100cb238bcso5520136e87.3
        for <mm-commits@vger.kernel.org>; Thu, 25 Jan 2024 20:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706243591; x=1706848391; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1KfJQNBMEmPoo2PEop22ArDZeFLX97BES6Yp7corSc4=;
        b=B1/8nWLA1OExOS1+QRhREm+6TdF3U9VmoxzlxZLvGt9Vjo3tKvs7GGfyEEEcWOEWgw
         0TL1D6oFS9H6yD0uaFFagZCsRbJap72SrQT3hXXIrRmqfo2+pTG5uS1AgwCSl4GNn/0O
         WpMvL+FqTTuEpUBsHktBNyW67NxhXHYvhJuaXsRZ7657HPFZ4pXMlN790WjRaSaq/TYy
         oDKLpexnaFQROJY0kJ0qtvc+eH4qsjCcfEpLlhNNIB2JiEsk+wc0zB6vhM39FbS5jQqI
         8JmjLLC9QocmxAw7l1blfj5bdb9hq231MazDsREFZ8a1s5cbeePEGFu/tNffbSPLRira
         m5pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706243591; x=1706848391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1KfJQNBMEmPoo2PEop22ArDZeFLX97BES6Yp7corSc4=;
        b=TKjOmL1vFV6ZiOjwk6QCs4J5+2i/r7dYUOeDPZYT7AEogG65hZgNxvsdKkeQGj7Jfz
         9qrOQIyuIuNaDv3WA1VAD6QmL1XWqW/rq3+pYRgfMUrKIG5c7Q99dDpyhSEtIc01q7xp
         TbukBY7+wX/L5mz49G2D7XS6AOCdTNSl1Aax/WNSW+Y9dVyX+Dvrod2nawASZ8aLDxO9
         6hIAVWKb7OVhE0jsKYGwNmsEDer7SBJnQmUPQBCAf6ARRtWDtcm6kkmmGrGCKJqVXOH/
         Ryd+RWDZqUGQuE5Tq71IQgKKYCI5tcgt7xVZf9s1oSsCExNcYT7ctlFUh6WXpcbipeDp
         GZBw==
X-Gm-Message-State: AOJu0YxDqaDw1TW5lgO7A41FQUm9CMmDfYkmAqUUiK384TZCQKk5w0dZ
	GeB5wmBAyzBP6pUOlba++AfHASaKBW/D1U46FtL8CFPcGtiW7zXfLc/7juFGakgTEenz942+Yfb
	oqVecwjnjIzNwXaS6znzFOnki4VUF6ERb/XKc
X-Google-Smtp-Source: AGHT+IEa9V/Ni8w28g9Ab/aaJDBYoCX+Sgu2mbMYjqeX76gf7JkekAd61muPUam9GiNx2k95iDl0Dc9FtDdcl971Vq8=
X-Received: by 2002:ac2:599d:0:b0:50e:a688:4a1f with SMTP id
 w29-20020ac2599d000000b0050ea6884a1fmr350712lfn.112.1706243591146; Thu, 25
 Jan 2024 20:33:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126021711.8F67CC433F1@smtp.kernel.org>
In-Reply-To: <20240126021711.8F67CC433F1@smtp.kernel.org>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Thu, 25 Jan 2024 20:32:33 -0800
Message-ID: <CAJD7tkYwn30+pahxyVKwWEM50O2rKdMQ33LkQRdpMTnJgOf0_g@mail.gmail.com>
Subject: Re: + mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated.patch
 added to mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, shakeelb@google.com, roman.gushchin@linux.dev, 
	oliver.sang@intel.com, muchun.song@linux.dev, mhocko@kernel.org, 
	hannes@cmpxchg.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 25, 2024 at 6:17=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The patch titled
>      Subject: mm: memcg: optimize parent iteration in memcg_rstat_updated=
()
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated.patch
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
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Yosry Ahmed <yosryahmed@google.com>
> Subject: mm: memcg: optimize parent iteration in memcg_rstat_updated()
> Date: Wed, 24 Jan 2024 10:00:22 +0000
>
> In memcg_rstat_updated(), we iterate the memcg being updated and its
> parents to update memcg->vmstats_percpu->stats_updates in the fast path
> (i.e. no atomic updates). According to my math, this is 3 memory loads
> (and potentially 3 cache misses) per memcg:
> - Load the address of memcg->vmstats_percpu.
> - Load vmstats_percpu->stats_updates (based on some percpu calculation).
> - Load the address of the parent memcg.
>
> Avoid most of the cache misses by caching a pointer from each struct
> memcg_vmstats_percpu to its parent on the corresponding CPU. In this
> case, for the first memcg we have 2 memory loads (same as above):
> - Load the address of memcg->vmstats_percpu.
> - Load vmstats_percpu->stats_updates (based on some percpu calculation).
>
> Then for each additional memcg, we need a single load to get the
> parent's stats_updates directly. This reduces the number of loads from
> O(3N) to O(2+N) -- where N is the number of memcgs we need to iterate.

Hey Andrew,

Do you mind correcting this in place: s/O(2+N)/O(1+N)/g? The first
memcg requires 2 loads, and other memcgs require 1 load, so that's 1+N
not 2+N.
