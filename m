Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D2B18E77D
	for <mm-commits@vger.kernel.org>; Tue,  3 Sep 2024 20:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725394714; cv=none; b=ZVLmqtvCwtQjqcbkHzKhMsTHZ7eSTfmFVwZUA+lwy4Qn35Uwt9vbKV2bZDsaP7XbpVuC3FOglrPVk/UEfo0p3dCUtbTt7121a0Cm6hmUXv5pAbhO9X0ej3IPRCxZkbQRDWUl1lnq8jSKAmpx+TfmNmdF+nemPRhmyhQsdyrFeDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725394714; c=relaxed/simple;
	bh=hzAqGd3F7AgPkCeGGqromJaKIJXJKAOln3vKkvXFg18=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hxnBBo5nBT2uKKmYHWP988ceEXiG5f7Jkef82Vslgw+pL9udgxe+KSAEHhCPUyDOg6Z21JqKujZnOPJh0czIgmCHGbsDOdhBC17BZvlwKh1igL+gAa8VJLqbVCir0oWFtIND2cNGT7CIO/dvzg+4IjqL2tJQLSlKK9x+zfts+Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dKHr6GCS; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dKHr6GCS"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a8696e9bd24so686383566b.0
        for <mm-commits@vger.kernel.org>; Tue, 03 Sep 2024 13:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725394711; x=1725999511; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oWbMfvcljod0JpxC0uK+HPRl2MlFSfhObh8ySh6Wf0c=;
        b=dKHr6GCSu1E9dNajNUGM0Ptso8C9KH3okxYNy/PRq31DIH+W5xkRJcZtW9nWI8FMMa
         ac4vifZuqMFzxV5ZET2InYh3QHaDCKr/hU5apSu9kx3/G45ReIXLcznxCr8ITIh0XTtu
         bS+oskDCQeTyGGwrTrM8yY79wNftAuweWMeYyczawGnDfs/6W6PhMaJaBUDVLRQiXRzb
         GwQP1bKf2lsR9WTBOMorz5vWqZbV1uk4M8Ex44/aKBM+iuHj5pLeyllcbDPYYCHhAFhL
         MGROiuGJjF8iTDHsm+PtTZ2HOMGfnjH9iIU2Aj9Og3Gt9bNwYu6hvoRhAEboKtnauURN
         LvTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725394711; x=1725999511;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oWbMfvcljod0JpxC0uK+HPRl2MlFSfhObh8ySh6Wf0c=;
        b=ine2JHAwejIwWb9p8LsNCnzrCYyhgwH4lSqRBUvxCixapx2XLgcqmowFf7xc0kUSTq
         tAvMD5UDDK8Je7+BH4MtfkFj+JEag4PjrUHoDthJel/19criUKcyWBtqrveSvcWw+nUK
         ccl1xKUbt0npHsamzeVHxB9v+jodjTdTmkMCPLXA2TmFJpB4Fw3R/UQBEjKKe6LI6M9G
         ZIO9X177k/cgkPhEErXG6yAHFmOfuAO3FY1eLM34MaYdhU5hYmopPKUj92GtAnyTfPNB
         0SNMqQMIeE+zSMyhKvzQRu2mnQAYT4E5ItF8cDgqOBa5cGGMFKdmEOiVvkJdD8wZVEFu
         yVBQ==
X-Gm-Message-State: AOJu0YyZ4pRslVgq2hwsQ4cvvSPqAvMuiWc/qWVGU9Y6DWR7GfYDNdjb
	dDjqRinexhnrqNFida4ihWyLjZ551ib+U1xRfoU5ZYKggfXkJ3j012sb9sSn6RhkBDsaQmgxTFL
	qcZnm7UzqvYatUPg2xYVnhrOoxLO3QUY6l+E5aLjmgGl6BSytdw==
X-Google-Smtp-Source: AGHT+IFYUH/hVNuhhP40aPgAS7zEvNZTSTwvvuFNeAMEV+ZwBawVLkqTESoQZXwhziKheUUQ5XgC8wxLk0fxSFgcBAI=
X-Received: by 2002:a17:907:9485:b0:a86:a41c:29b with SMTP id
 a640c23a62f3a-a897f78cc4emr1417395766b.8.1725394710002; Tue, 03 Sep 2024
 13:18:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240902005945.34B0FC4CEC3@smtp.kernel.org> <CAJD7tkYtM8gQDX8RrT1cnkfDQ0dRv4woNY4jrwjc1oUuavbuTg@mail.gmail.com>
 <20240903125329.726489169d81399a954f7787@linux-foundation.org>
In-Reply-To: <20240903125329.726489169d81399a954f7787@linux-foundation.org>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Tue, 3 Sep 2024 13:17:52 -0700
Message-ID: <CAJD7tkZ9PQXKkt=74dGHZgfCLs+jRz8KPPv5UZ2z9NScwOdT1w@mail.gmail.com>
Subject: Re: [merged mm-hotfixes-stable] mm-memcontrol-respect-zswapwriteback-setting-from-parent-cg-too.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org, shakeel.butt@linux.dev, 
	roman.gushchin@linux.dev, nphamcs@gmail.com, muchun.song@linux.dev, 
	mkoutny@suse.com, mhocko@kernel.org, hannes@cmpxchg.org, me@yhndnzj.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 3, 2024 at 12:53=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 3 Sep 2024 10:53:21 -0700 Yosry Ahmed <yosryahmed@google.com> wro=
te:
>
> > > The inconsistency became more noticeable after I introduced the
> > > MemoryZSwapWriteback=3D systemd unit setting [2] for controlling the =
knob.
> > > The patch assumed that the kernel would enforce the value of parent
> > > cgroups.  It could probably be workarounded from systemd's side, by g=
oing
> > > up the slice unit tree and inheriting the value.  Yet I think it's mo=
re
> > > sensible to make it behave consistently with zswap.max and friends.
> > >
> > > [1] https://wiki.archlinux.org/title/Power_management/Suspend_and_hib=
ernate#Disable_zswap_writeback_to_use_the_swap_space_only_for_hibernation
> > > [2] https://github.com/systemd/systemd/pull/31734
> > >
> > > Link: https://lkml.kernel.org/r/20240823162506.12117-1-me@yhndnzj.com
> > > Fixes: 501a06fe8e4c ("zswap: memcontrol: implement zswap writeback di=
sabling")
> > > Signed-off-by: Mike Yuan <me@yhndnzj.com>
> > > Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> > > Acked-by: Yosry Ahmed <yosryahmed@google.com>
> >
> > We wanted to CC stable here, it's too late at this point, right?
>
> It has cc:stable?
>
> > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > Cc: Michal Hocko <mhocko@kernel.org>
> > > Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
> > > Cc: Muchun Song <muchun.song@linux.dev>
> > > Cc: Roman Gushchin <roman.gushchin@linux.dev>
> > > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > > Cc: <stable@vger.kernel.org>
>
> ^^ here

Sorry for the noise, I'll go find an eye doctor.
