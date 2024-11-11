Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005F41865E0
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 13:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731332604; cv=none; b=fV+azTLKe8VNd66nOHhKofxz9As2LlwSu3KRpjnZW+ta5gjm6F3Cm8ykHk9AG6vqK4osACUQCcnZozK/g4pDsSxOrxWH8ai+roXeLOsTpYYuKNwp/671lEODjZGllFJl80OLN7TBWnOLwktZCF1QY8i6/SB/191jQDCAhWeH9h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731332604; c=relaxed/simple;
	bh=VEzep2qfZfDQPm8vkc8zKCYLCd1rpaOALNslZLJk9hg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KH1rb2Oxr3UiHmunOd5emmiCtXvA7qDvkDvmchO4To4vMxA/GPQivXCI2RSr68gx5HZudIOJYWJDwcKXgvS+szEvWNGojc9US9AsFLBHFlp5ziPn19ccZ5ZpA3yYnnPpGNgCKaOp9Wyqk8okI4L9UW3XCXUyVHertNOG7phthpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T5tBB+DV; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T5tBB+DV"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-20ca4877690so246475ad.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 05:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731332602; x=1731937402; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gOravA2AiWFyxmdks4yuQshOzkG2LRoT+7GOiDZUH0k=;
        b=T5tBB+DVsv+tL47uo8Q42zscxjwcswenP/fVRJ/AiJ+5v2L1ZzG9uxsIjN/QggVC9B
         6BBjwLwSjUjrgh4gQNvCDGM6nstZb6L3fudbWw/f+gxdSKCyYIDQvZYHRzmorrYKrWe8
         IanAfJxb6S2+hnoKquvmKf4EkdhpCCQvY8kFdNgB3INm8fbg4h90tkZhR79Yi/veF0dU
         mI4l6S8bYZivky3h5nqK4GdAt75rWj4oZh2zIOcvOCe1VwbBzTg37QqSvU6zR4i/wDbm
         ZwOjAG+i1ActOX1XkFhRKcqX92fnTNBq9eiqT9+4KTco4ktVjj7FTJDHpw3h6Jndk9gu
         r6XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731332602; x=1731937402;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gOravA2AiWFyxmdks4yuQshOzkG2LRoT+7GOiDZUH0k=;
        b=Sgv3NUTAE29meVxyJPjJkxmmXJj3F3GBszhiJO0wnQ7N0vHLZHSkcEo7f7zpn+xg68
         H0DT6W2/Dz761swVIVEx2FajpIKHBPx2ouw2roLibTyUhNWm6IMo3J77uRs/CHyP8nCm
         SWIa66F6SjWkHRNI1GVdMPsRR1TRMDD9wktknoOyAgI00HWadV+yNu2AvxnzWjxyJJtf
         /y7K0isS+1AhYeOtobZm05pdJ4XG6pn9FFqbt4rWGDSobSy0e3ZB6aXimlcEapUB/uh7
         +/rGB+ca6fofDo8lnVUncopouFF9GNbkhwsDAZiKcqZKeKZAzNDnlLhylegVferYe2C4
         a2+A==
X-Gm-Message-State: AOJu0YwBiAekX9ZfL6Yw+NOLETrTBSVV3hpTQB9KGCJEVBdGl5QFuWl1
	qpho0KfB0phu40oHz2sSOWRo3m2xzZLICjug8pynnonfgEqqEOe4CbvmxFKvSBXmtY7s/z/yIh+
	HwFQzbI62rswA6wxw489etNO6Mv/y2pNYtG8M
X-Gm-Gg: ASbGnct3Nq1wM1mSOOV8AqhdrK82SAIp6J1EPA+0/yisC37yp45HzyJaosasYPRzffa
	5mu26UmO4A6tO2TICvYWbYBz+tsqMBA==
X-Google-Smtp-Source: AGHT+IGseGdAK4M2MkzOF++QSEMNMdBRNCsHmkDPW/rMziYjmYG8r7HRhclySmImUvu7e4Zb89MIuVt+7UFKjLLP3EM=
X-Received: by 2002:a17:903:244a:b0:20c:5fbe:4e66 with SMTP id
 d9443c01a7336-2118f1d3adcmr3118335ad.27.1731332601947; Mon, 11 Nov 2024
 05:43:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241111082832.CB6B3C4CED0@smtp.kernel.org>
In-Reply-To: <20241111082832.CB6B3C4CED0@smtp.kernel.org>
From: Brian Geffon <bgeffon@google.com>
Date: Mon, 11 Nov 2024 08:42:45 -0500
Message-ID: <CADyq12zz+Di3FDANsZo1F79EvSSvUZt6fdRMDqG0tqbWoHq+rg@mail.gmail.com>
Subject: Re: [merged mm-stable] zram-clear-idle-flag-after-recompression.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, minchan@kernel.org, kawasin@google.com, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11, 2024 at 3:28=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The quilt patch titled
>      Subject: zram: clear IDLE flag after recompression
> has been removed from the -mm tree.  Its filename was
>      zram-clear-idle-flag-after-recompression.patch
>
> This patch was dropped because it was merged into the mm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> ------------------------------------------------------
> From: Sergey Senozhatsky <senozhatsky@chromium.org>
> Subject: zram: clear IDLE flag after recompression
> Date: Tue, 29 Oct 2024 00:36:14 +0900
>
> Patch series "zram: IDLE flag handling fixes", v2.
>
> zram can wrongly preserve ZRAM_IDLE flag on its entries which can result
> in premature post-processing (writeback and recompression) of such
> entries.
>
>
> This patch (of 2)
>
> Recompression should clear ZRAM_IDLE flag on the entries it has accessed,
> because otherwise some entries, specifically those for which recompressio=
n
> has failed, become immediate candidate entries for another post-processin=
g
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
> The bug was reported by Shin Kawamura.
>
> Link: https://lkml.kernel.org/r/20241028153629.1479791-1-senozhatsky@chro=
mium.org
> Link: https://lkml.kernel.org/r/20241028153629.1479791-2-senozhatsky@chro=
mium.org
> Fixes: 84b33bf78889 ("zram: introduce recompress sysfs knob")
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Reported-by: Shin Kawamura <kawasin@google.com>
> Acked-by: Brian Geffon <bgeffon@google.com>
> Cc: Minchan Kim <minchan@kernel.org>
Cc: stable@vger.kernel.org
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  drivers/block/zram/zram_drv.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> --- a/drivers/block/zram/zram_drv.c~zram-clear-idle-flag-after-recompress=
ion
> +++ a/drivers/block/zram/zram_drv.c
> @@ -1864,6 +1864,13 @@ static int recompress_slot(struct zram *
>         if (ret)
>                 return ret;
>
> +       /*
> +        * We touched this entry so mark it as non-IDLE. This makes sure =
that
> +        * we don't preserve IDLE flag and don't incorrectly pick this en=
try
> +        * for different post-processing type (e.g. writeback).
> +        */
> +       zram_clear_flag(zram, index, ZRAM_IDLE);
> +
>         class_index_old =3D zs_lookup_class_index(zram->mem_pool, comp_le=
n_old);
>         /*
>          * Iterate the secondary comp algorithms list (in order of priori=
ty)
> _
>
> Patches currently in -mm which might be from senozhatsky@chromium.org are
>
>
