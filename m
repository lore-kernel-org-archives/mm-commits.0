Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCAC4C6C
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730695098; cv=none; b=eK6YygtNJsfp4RPPGbJLex4jA+urrf3zc5IMV+FmOarRHgilLyVdeixUTddUJ7WJXr68YXiElJRu+/G1Edh0rtyHHud51WoLf2+zjCpoJpz2ZOGZbpso3E82KAWI1A9cVW62lP35kMhZsQMa0OlPJMqUzeCZ4eiZw6hlFawDn4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730695098; c=relaxed/simple;
	bh=cXgVnxXsrmOtXCTy2ACRpEGv5wON117ltWMijZsHoQs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d39vStKJf1qCG0sObldLpbS5h7hzLTwoi9IbZ28yREQq08HDHdoYCqOUtm5SJr+p/XjkMssB8I4fbzLxbVRhOSZIxjLoRHQ4BtS2fgoVrC2I+07BhrYerO7Jdy2Wjgr1UcqFqBewsn1v5HCx/CucWaV5K4YqMiuX7zwhsF2DbKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lbWNA487; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lbWNA487"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-53c78ebe580so3868105e87.1
        for <mm-commits@vger.kernel.org>; Sun, 03 Nov 2024 20:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730695095; x=1731299895; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NICdImHC5fhEa16sdVJzsuFfScS+w3N6bksIT3LQ9qk=;
        b=lbWNA487ZCHIOzNFmJITMG7l3RDCNxtEbb/RaQBL+F7PbB9vtXHb5EqyaoAgsR4czP
         C41bclCzKJ2K2YnVNmoVISiibDo3roiLxe3mhEVVNUPSJqUSvsZ4Cn5VDROpiUC0y0aA
         6tpb/bQsotgDsCQNJzrqOplfIgfyjFepN7fq9eTlp1MTYOeh3iWc2L77vJZBrVWvkzDR
         zPp3Q+yN84NQE60UaEYAuuJgByifcDYxlpbIiNGsPgqntmJ+rgok3+DY8F5X+ghmi+bq
         k5Dw2Qf5yTRMxXgoN/7VtgCpKHyZdW95Y8xEtGkRtUY7zqU/CD/sQjePOMOOhXGj7ToD
         w57g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730695095; x=1731299895;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NICdImHC5fhEa16sdVJzsuFfScS+w3N6bksIT3LQ9qk=;
        b=dRUyc/qA9ojtDuOPrPE9oOWOLlD5Yus9jQN48PPTvVYfVSjh00trTe1/JGg6v69OpY
         muwV8ycbpghC4xU3vbL4dkVg81IAjUnxLO+eZi8DLHQ252nuAwycUhXJFzstqUP19+wq
         udxkJS3gLWIu5Q44Pw51nneU1xG9YQL8rVqRbBA73/jc+Ssp8O1QleYMBZDRdve/+8Dm
         SBAolf0ckf2hTeaTlG//IBS1LiaMciW7PdI1iqP6C0y0B4EwWavetjzNcyAJAJFWgII3
         1WIWyYIYAZDnnANBqNt0mQZQUKt0Rm8RTq/DbkDi8xbK7Zl/2ukpVjpltuzm7AmBx9Tj
         qxuw==
X-Gm-Message-State: AOJu0YxYQ33AC216LRYORgG7xh7aSBUtFNIgLFFIa58XA6crHbjOFUf8
	DSdv8d0oS/zHZx0EUY3CXi7sKwcYC+qE8oVnghpq017Bs2ZW2FdLdIVUCMfcb9mGu9XCLdkyVbo
	qTmejXg6B2QsI/TVK0sbg+wfmsF37XrSlzNc=
X-Google-Smtp-Source: AGHT+IEGnc1eigKcXJvHovbRv3kVRPZlYl62u+LbDnMc/UDmEdAlDbb6aC/eeUx97UuF6NTYbAmEycy/Iixya4WAAMc=
X-Received: by 2002:a05:651c:1988:b0:2fb:5014:f03c with SMTP id
 38308e7fff4ca-2fedb3c5d5bmr34161881fa.5.1730695094414; Sun, 03 Nov 2024
 20:38:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241104040639.A548BC4CECE@smtp.kernel.org>
In-Reply-To: <20241104040639.A548BC4CECE@smtp.kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 4 Nov 2024 12:37:57 +0800
Message-ID: <CAMgjq7AMm0vw3QWo50XgRa7QOZn-GA+v6EnM6TcmsHcCQWqxxg@mail.gmail.com>
Subject: Re: + mm-list_lru-split-the-lock-to-per-cgroup-scope-fix.patch added
 to mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zhouchengming@bytedance.com, 
	zhengqi.arch@bytedance.com, willy@infradead.org, usamaarif642@gmail.com, 
	shakeel.butt@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	mhocko@suse.com, longman@redhat.com, hannes@cmpxchg.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Mon, Nov 4, 2024 at 12:06=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
> The patch titled
>      Subject: mm-list_lru-split-the-lock-to-per-cgroup-scope-fix
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-list_lru-split-the-lock-to-per-cgroup-scope-fix.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/mm-list_lru-split-the-lock-to-per-cgroup-scope-fix.patch
>
> This patch will later appear in the mm-unstable branch at
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
> From: Kairui Song <ryncsn@gmail.com>
> Subject: mm-list_lru-split-the-lock-to-per-cgroup-scope-fix
> Date: Mon, 28 Oct 2024 01:26:30 +0800
>
> Thanks for the report. I converted list_lru_walk callback to keep the
> list unlocked when LRU_RETRY and LRU_REMOVED_RETRY is returned, but
> didn't notice shrink_memcg_cg in zswap.c could return LRU_STOP after
> it unlocked the list.
>
> Link: https://lkml.kernel.org/r/CAMgjq7D_OA=3DvYf5SnNnKXjppPFhDqsbYF--6=
=3DcOayKiadxuwrQ@mail.gmail.com
> Signed-off-by: Kairui Song <ryncsn@gmail.com>
> Reported-by: Usama Arif <usamaarif642@gmail.com>
> Closes: https://lkml.kernel.org/r/7334b158-8567-4c66-8176-57b879ff8882@gm=
ail.com
> Cc: Chengming Zhou <zhouchengming@bytedance.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Waiman Long <longman@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/list_lru.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> --- a/mm/list_lru.c~mm-list_lru-split-the-lock-to-per-cgroup-scope-fix
> +++ a/mm/list_lru.c
> @@ -298,9 +298,9 @@ restart:
>                 ret =3D isolate(item, l, &l->lock, cb_arg);
>                 switch (ret) {
>                 /*
> -                * LRU_RETRY and LRU_REMOVED_RETRY will drop the lru lock=
,
> -                * the list traversal will be invalid and have to restart=
 from
> -                * scratch.
> +                * LRU_RETRY, LRU_REMOVED_RETRY and LRU_STOP will drop th=
e lru
> +                * lock, the list traversal will be invalid and have to r=
estart
> +                * from scratch.
>                  */
>                 case LRU_RETRY:
>                         goto restart;
> @@ -318,14 +318,13 @@ restart:
>                 case LRU_SKIP:
>                         break;
>                 case LRU_STOP:
> -                       assert_spin_locked(&l->lock);
>                         goto out;
>                 default:
>                         BUG();
>                 }
>         }
> -out:
>         unlock_list_lru(l, irq_off);
> +out:
>         return isolated;
>  }
>
> _
>
> Patches currently in -mm which might be from ryncsn@gmail.com are
>
> mm-list_lru-split-the-lock-to-per-cgroup-scope-fix.patch
>

Thanks for taking care of this. I was just thinking about posting a V3.

Can you also help pick up this fix?
https://lore.kernel.org/linux-mm/62a65418-2393-40ec-b462-151605a5efcf@stanl=
ey.mountain/

It also applies to "mm/list_lru: split the lock to per-cgroup scope".
These are so far the only two problems founded for that series.
