Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792142641EA
	for <mm-commits@vger.kernel.org>; Sun, 15 Jun 2025 09:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749978904; cv=none; b=XNi6snG+Ts+LAipSwS+F1koXid/Rs1xrbw5RFg1b4V/c1wPlkiflPVaxVGsEnWmsxT8Ws2KkaLAJI6K0CVngjepeg8evmvS7aDX/haxn+KPtkKAk7jVyA9xDyMIkT0DDZy33ZDq/2PWZC/kR5oML2K06AVtTwPUIyQ5s6DVPjtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749978904; c=relaxed/simple;
	bh=lEW92wYhuUIblKah0pzcPAHGPw/CxmF5q9Fh8/0hug0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CE9ndE/d5G6j7PQFXgrkYpVmF5WTWSlepcBdVjOTyPpf12u2KclkBrlE5eG21hDxu5CzVePyUlJ02Y3ldDBy8XYXe0+wU7qpFTqsNZa+moNzs8aZm1YPn/XGSEVdk8rPRn7Xobe22vu7p9EhqgbkCwplG+nB9ng8eljVMyR/VDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DwRWg9L1; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DwRWg9L1"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-553b5165cf5so1703358e87.0
        for <mm-commits@vger.kernel.org>; Sun, 15 Jun 2025 02:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749978900; x=1750583700; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tmg/p2kcDwYz24vXKEUTjDdH7xLktECYge3+JPIYdUs=;
        b=DwRWg9L1w4HrGCRsYJUycTXaFnwIQKuUbiy3symFHyVe0gh7HUpn8WuxdCRwsP7Q1B
         tBYF7519uH/lDPg7T2nDrzWVDUfpg52cdpOUsClnlfagA6V9zreoZ1BF56rVai2TLeUs
         hE1fzYXQj4RbcrbK/rJBgX9geFBJNO0EXw/mLSU1SO9zWHhKGGNRTglT5sInZxjNtLny
         uJOPU7QjZXVsGDxm6+USVD2qlOxxr81WbHsCNWJwha5BXRDx94hQxSn4JRjlyyDGGF6h
         zhVuwAIaAciXKSEgAXn+HqmHxy4tsdrUYyhbRaCEeY0Nf6CWAWZT/xzmxIqyTSceDHTk
         RACA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749978900; x=1750583700;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tmg/p2kcDwYz24vXKEUTjDdH7xLktECYge3+JPIYdUs=;
        b=xACkk303XvaQmBlYMtzwXWpLI8b5z54lm0Fsdag6OcbgcNf9qhwIfXGY8xiLx/G3Ew
         RL4r3JY9OdUaFznK7aYqLzxkkZYWU7LMArkG8q0evtA/jHiqeZqXddVG6vC4b/a7Ol29
         V+0hOsvDm7JOGJWVCIWJ7l+35/Jpd9mTTpyoigY03bD9bLQdK6fhyFAGRSxQT2rVFs6g
         0QSRKGb/6IajRbzT7U8Pbi4OaEdDTLKrG1dNah+n+DeUT+Te5pziblJJIxvKbDa8Pjnu
         qOZWLemkELcIjYbUPRODq8JfGORFbGF06NwaJSfFALMBt3HiGSJCWofOATkCnZPbeXXh
         l0pg==
X-Gm-Message-State: AOJu0YzCDr9PUnQhkNoZSzNiEwHSvx8c1XvXqhaY39iX7oGnWmj/TwbV
	xxOTTygrOr+Z3HbquC0dk9uUohhNsp4YvYGszIJ7vfbA5/6EWq7V/Sa1nBP9
X-Gm-Gg: ASbGnctiri5yv45yvDjfpRYdBDIQUOhqvdq/nkt0s+lLb4nKUBFIyo77U7+mW4Wx19I
	SxXeCugWlsnHJOCXLWZod34L0KmmBcMfvllJpT9/6ZciWHMfR9LNiUbw9dSVH0bSG6m0lyjmQ8r
	jgArDBGAecQxJBEitC3CJ6Bev5uNesjpv3nNPiOmOvYiiFMUKTpLPXYp+cGbrxdCu9DroTY6Vnz
	plrHpnGcsWYGhkwMvRJ2aiKaJUzcPhuwRjOBoxk2j8y7/buBRHFrbHdsn3XZ+8qhhCdguvTfpq8
	QioGF2+KYHVO2RLIwSLRupKatqvP9ekKBQtPtkKaZCC3tbaS
X-Google-Smtp-Source: AGHT+IFG4+ig2Ti4ux5z0SDNfGWJi2nl3sJT5LHKTiyX+x5SrDsFVGphepFVW82hufvT7IEtQmqDpw==
X-Received: by 2002:a05:6512:1188:b0:553:ac4c:2165 with SMTP id 2adb3069b0e04-553b6f1a0c9mr1007074e87.29.1749978900243;
        Sun, 15 Jun 2025 02:15:00 -0700 (PDT)
Received: from p183 ([46.53.249.82])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-553ac1aa036sm1107360e87.128.2025.06.15.02.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jun 2025 02:14:59 -0700 (PDT)
Date: Sun, 15 Jun 2025 12:14:57 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
	wangzijie1@honor.com
Subject: Re: +
 proc-use-the-same-treatment-to-check-proc_lseek-as-ones-for-proc_read_iter-etal.patch
 added to mm-new branch
Message-ID: <0a7acce2-311a-475b-a4d7-5f819f8b976b@p183>
References: <20250607221403.D7582C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250607221403.D7582C4CEE4@smtp.kernel.org>

On Sat, Jun 07, 2025 at 03:14:03PM -0700, Andrew Morton wrote:
>      proc-use-the-same-treatment-to-check-proc_lseek-as-ones-for-proc_read_iter-etal.patch

> Link: https://lkml.kernel.org/r/20250607021353.1127963-1-wangzijie1@honor.com
> Signed-off-by: wangzijie <wangzijie1@honor.com>

Fixes: 3f61631d47f1 ("take care to handle NULL ->proc_lseek()")
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
