Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C641FECC3
	for <mm-commits@vger.kernel.org>; Tue, 15 Apr 2025 01:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744679976; cv=none; b=qHotfzD6QKQgYrbk71CSgryQKSGrI1pBh1PBNqe9sRkh5CbR3D/vZjbDGHQJAU+3skJvbZhBgvPB2uNfBAMiV6zweH6y8bRsirPLv0M+3S+T5OyH9FlfSxLRTrttDSAQ6/p3LqIPyqp2hrHvmJbUD7dn0h26krz/Q6Gs0vJ7LcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744679976; c=relaxed/simple;
	bh=HH+yemXMr73MsKFhqUzz5QVkr07dJ7OXdc6vrxkb9qM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jZHAqAHsd1/KiZ5WF6WibhSEPKt2A4qQ2eJvQkYrYQdm+xvhF7grNqlwGh/hDLWuLQM8Dkskg2KkYCjHBrOuyuDBvE1uhHT2ZwoBipNAHPNCygIlFK8CCC+TqwSi+WVT25lBl9p6uEyjGZ4tyJeSO7MyMZUM1AC6eS5LQNkjXa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cwrJ5+XO; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cwrJ5+XO"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2242ac37caeso49315ad.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Apr 2025 18:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744679974; x=1745284774; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KNGETWZNs4IcYjMvHwyU4mx+Pq0GDiIwvzNG0May4zo=;
        b=cwrJ5+XO2shv76yElgrQbaLEfMLBwzVfaprozEYKzgpyPiDiQedkB3g0XtbYw9AG42
         0iDpv5LAOb0ID9WkcgWEOMc0LoLFFqZsbftu/egmVRAty31UwQNwXbpEzFbQD6DU+Tw3
         cFh6WR45f2yXTSVG1oJqD9Tp2JeAiIVkjpbJOP8Cx59KxghQcDVLUK7XpLC5pW4VicMQ
         7r6DDFmJnncKxHdAEuLCYrm172HAEQBcTZ0krBUzrueuZC2ff5+l+abdQT7cD12CSsyS
         StanexzedCjfmyFX/xgpB+N/6u4u8nvE7zyTVg5OEgjZVQGI4xYtIihBFVOL2+Tm1mL6
         x0WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744679974; x=1745284774;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KNGETWZNs4IcYjMvHwyU4mx+Pq0GDiIwvzNG0May4zo=;
        b=vCB5DOeFJOEhF/YEydjWjn+yJ6iOpmYaCXic4IpA5CTZjWAITD6EkxLi8O12SJnL6u
         PZMh5DZS843lzHQpDtIUysNzI/N9hf/bRukYW//pYg095wAansOmmbw3EeqVFbBB5CBh
         FHBZQUFJriAGvD1L9Ym6RlQumvfUxSMk5IurDG0DjEBygO79pGXBa5s3af7aawlm+x4u
         tD9vvb82yMr62m7PUiP7dPPy1xHx7czNUpJvOW9vRnCaeuvcJoNACiwCkMJCEZjBBYpz
         kzKeSQcXtOwLWD1m9+GkRpwGHY8TqItPVcJDnRNv1gHxPQNDmdK81svFRmb/sL09GFhL
         fpqg==
X-Gm-Message-State: AOJu0YwKUDE5kTlX4H4XcrEX/SWzS40rizn25rtRiWhrYIwL2yksoUfo
	besi7GbXtQj6CGvGTe9swnJ31xVRb0TciJQ7BE0ur6GBmSiaIMHextAp/olJWg==
X-Gm-Gg: ASbGncsALAy/txdNb1Af7mtdv6n1zK/YiNxdWHTJn/maFLZTyV7db2Yvvbnq/RB9XTN
	AmoBADzOw9oU3jSxB1mlAt/Cv8YeIOZvnhig2eqtpMPSUeqmZiJ2GCCjwXSAXjbXM8UCiek8QzH
	0fM3mqbSMC6NZvUDcCzf6WW/Ye4E8+vOcitaSKPJ9iJcZrCy5LjkjjG0XvAqxgnljfx3FnXMvFk
	AiYp4lH/OxZBgZmzebUJxjDgHzNIv+kJF8xtFHTQKYsUXzT5MM2aAf1ttHC46Xdyj+Fg7B6TnM9
	tC45OkeALBFyjm22PGc66ijVRvLyTvARoX060FuksIGFUHxT3izhKrhqYKP0Ef2g6fFdXG08Ct2
	443vUAq2iYjqv78/BorR/2xAQVZyqEGZmHWI=
X-Google-Smtp-Source: AGHT+IF7IuKvgyzhaDqAqKede+CStzceNsk7CzjTSLU9+LFfmSs3OHUEdqyHJsKnaYmhGw2nVjqKAw==
X-Received: by 2002:a17:902:ccc1:b0:21f:2ded:bfa0 with SMTP id d9443c01a7336-22c26cfb67amr538265ad.25.1744679973496;
        Mon, 14 Apr 2025 18:19:33 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:73a2:27a9:213c:3f0d] ([2a00:79e0:2eb0:8:73a2:27a9:213c:3f0d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22ac7b8c3c1sm106064785ad.60.2025.04.14.18.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 18:19:33 -0700 (PDT)
Date: Mon, 14 Apr 2025 18:19:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: mm-commits@vger.kernel.org, yuzhao@google.com, surenb@google.com, 
    rppt@kernel.org, david@redhat.com, baohua@kernel.org, gaoxu2@honor.com
Subject: Re: + mm-add-nr_free_highatomic-in-show_free_areas.patch added to
 mm-new branch
In-Reply-To: <20250415010507.C17A3C4CEE2@smtp.kernel.org>
Message-ID: <c711233a-70d5-cc70-0d90-4d0ee6f2d50a@google.com>
References: <20250415010507.C17A3C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 14 Apr 2025, Andrew Morton wrote:

> 
> The patch titled
>      Subject: mm: add nr_free_highatomic in show_free_areas
> has been added to the -mm mm-new branch.  Its filename is
>      mm-add-nr_free_highatomic-in-show_free_areas.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-nr_free_highatomic-in-show_free_areas.patch
> 
> This patch will later appear in the mm-new branch at
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
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: gaoxu <gaoxu2@honor.com>
> Subject: mm: add nr_free_highatomic in show_free_areas
> Date: Sat, 12 Apr 2025 09:27:24 +0000
> 
> commit c928807f6f6b6("mm/page_alloc: keep track of free highatomic")
> adds a new variable nr_free_highatomic, which is useful for analyzing low
> mem issues. add nr_free_highatomic in show_free_areas.
> 
> Signed-off-by: gao xu <gaoxu2@honor.com>
> Link: https://lkml.kernel.org/r/d92eeff74f7a4578a14ac777cfe3603a@honor.com
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Yu Zhao <yuzhao@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: David Rientjes <rientjes@google.com>

This is especially helpful when looking into oom killer output.
